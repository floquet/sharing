! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mIOtools

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    ! class structures
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_stat, fmt_iomsg
    use mLibraryOfConstants,            only : objFmt, fileNameLength, messageLength, objLineLength
    use mPrecisionDefinitions,          only : ip, rp, kindA

    implicit none
    ! parameters
    integer ( kind = ip ),        parameter :: fnl = fileNameLength, msgl = messageLength, oll = objLineLength
    character ( kind = kindA, len = * ), parameter :: moduleCrash = "Program crashed in module 'mIOtools', "

    integer ( kind = ip ) :: io_stat = 0, io_obj = 0
    character ( len = msgl ) :: io_msg = ""

    type :: textLines
        ! rank 1
        character ( len = oll ), allocatable :: textLine ( : )
        integer ( kind = ip ),          allocatable :: linesVertex ( : ), linesFace ( : )
        ! rank 0
        integer ( kind = ip ) :: numLines = 0
        ! allocation tools
        type ( allocationToolKit ) :: myKit = allocationToolKit0
    contains
        procedure, public :: allocate_text_containers => allocate_text_containers_sub, &
                             classify_vertex_or_face  => classify_vertex_or_face_sub, &
                             count_lines              => count_lines_sub, &
                             read_textLines           => read_textLines_sub
    end type textLines

    private :: allocate_text_containers_sub, classify_vertex_or_face_sub, count_lines_sub, &
               read_textLines_sub
! http://paulbourke.net/dataformats/obj/
! Object Files (.obj)

! https://www.cs.utah.edu/~boulos/cs3505/obj_spec.pdf
! B1. Object Files (.obj)
! If there are only vertices and vertex normals for a face element (no
! texture vertices), you would enter two slashes (//). For example, to
! specify only the vertex and vertex normal reference numbers, you
! would enter:
! f 1//1 2//2 3//3 4//4

contains

    subroutine read_textLines_sub ( me, fullFileName )
        class ( textLines ),          target :: me
        character ( kind = kindA, len = * ), intent ( in ) :: fullFileName
        integer ( kind = ip )           :: io_unit = 0, kLines = 0
        character ( len = msgl ) :: crashChain

            crashChain = trim ( moduleCrash ) // "subroutine 'read_textLines_sub'"
            io_unit = safeopen_readonly ( fullFileName )
            ! slurp up data
            sweep_text_lines: do kLines = 1, me % numLines
                read ( unit = io_unit, fmt = objFmt, iostat = io_stat, iomsg = io_msg ) me % textLine ( kLines )
                if ( io_stat /= 0 ) then
                    if ( io_stat == iostat_end ) then
                        write ( * , fmt = '( 3g0 )' ) "Premature end-of-file for ", trim ( fullFileName ), "."
                        write ( * , fmt = '( 3g0 )' ) "Expected", me % numLines, " lines."
                        write ( * , fmt = '( 3g0 )' ) "Reached EOF at ", kLines, " lines."
                        write ( * , fmt = '( 3g0 )' ) "Difference = ", me % numLines - kLines +  1, " lines."
                        stop crashChain
                    end if
                    call iostat_check_sub ( action =  "READ", fileName = fullFileName, iostat = io_stat, iomsg = io_msg, &
                                            crashChain = crashChain )
                end if
            end do sweep_text_lines
            call file_closer_sub ( io_unit = io_obj, fileName = fullFileName, crashChain = crashChain )

        return
    end subroutine read_textLines_sub

    subroutine classify_vertex_or_face_sub ( me, numFaces, numVertices )
        class ( textLines ), target    :: me
        integer ( kind = ip ), intent ( out ) :: numVertices, numFaces
        integer ( kind = ip ) :: kLines = 0
        character ( len = 2 ) :: stub = "!!"
        character ( len = msgl ) :: crashChain = ""

            numFaces    = 0
            numVertices = 0
            crashChain = trim ( moduleCrash ) // "subroutine 'classify_vertex_or_face_sub'"
            sweep_text_lines: do kLines = 1, me % numLines
                stub = me % textLine ( kLines )( 1 : 2 )
                if ( stub == "v " .or. stub == "V " ) then
                    numVertices = numVertices + 1
                    me % linesVertex ( numVertices ) = kLines
                    cycle sweep_text_lines
                else if ( stub == "f " .or. stub == "F " ) then
                    numFaces = numFaces + 1
                    me % linesFace ( numFaces ) = kLines
                    cycle sweep_text_lines
                end if
            end do sweep_text_lines
            write ( * , fmt = '( 5g0 )' ) "There are ", numVertices, " vertices and ", numFaces, " faces."

        return
    end subroutine classify_vertex_or_face_sub

    subroutine allocate_text_containers_sub ( me )
        class ( textLines ), target :: me
            call me % myKit % allocate_rank_one_characters ( character_array = me % textLine, &
                                                                                        index_min = 1, index_max = me % numLines )
            call me % myKit % allocate_rank_one_integers   ( integer_array   = me % linesVertex, &
                                                                                        index_min = 1, index_max = me % numLines )
            call me % myKit % allocate_rank_one_integers   ( integer_array   = me % linesFace, &
                                                                                        index_min = 1, index_max = me % numLines )
        return
    end subroutine allocate_text_containers_sub

    subroutine count_lines_sub ( me, fullFileName )
        class ( textLines ),          target :: me
        character ( kind = kindA, len = * ), intent ( in ) :: fullFileName
        integer ( kind = ip )           :: io_unit = 0
        character ( len = oll )  :: data_line = ""
        character ( len = msgl ) :: crashChain

            crashChain = trim ( moduleCrash ) // " subroutine 'count_lines_sub'"
            io_unit = safeopen_readonly ( trim ( fullFileName ) )
            me % numLines = 0
            counting_lines: do
                read ( unit = io_unit, fmt = objFmt, iostat = io_stat,  iomsg = io_msg ) data_line
                if ( io_stat /= 0 ) then
                    ! check EOF
                    if ( io_stat == iostat_end ) then
                        exit counting_lines
                    end if
                    call iostat_check_sub ( action = "READ", fileName = fullFileName, iostat = io_stat, iomsg = io_msg, &
                                            crashChain = crashChain )
                endif
                me % numLines = me % numLines + 1
            end do counting_lines

            call file_closer_sub ( io_unit = io_unit, fileName = fullFileName, crashChain = crashChain )

        return
    end subroutine count_lines_sub

    subroutine iostat_check_sub ( action, fileName, iostat, iomsg, crashChain, optionalMessage )
        integer   ( kind = ip ),                intent ( in ) :: iostat
        character ( kind = kindA, len = * ),           intent ( in ) :: action, &
                                                          fileName, &
                                                          iomsg, &
                                                          crashChain
        character ( kind = kindA, len = * ), optional, intent ( in ) :: optionalMessage
        character ( len = msgl ) :: subroutineCrash

            subroutineCrash = trim ( crashChain ) // trim ( " subroutine 'iostat_check_sub'." )
            if ( io_stat /= 0 ) then
                write ( * , fmt = 100 ) action, trim ( fileName )
                if ( present ( optionalMessage ) ) then
                    write ( * , fmt = '( g0 )' ) trim ( optionalMessage )
                end if
                write ( * , fmt = fmt_stat  ) iostat
                write ( * , fmt = fmt_iomsg ) trim ( iomsg )
                write ( * , fmt = '( g0 )' )  trim ( subroutineCrash )
                stop
            end if

        return
        100 format ( "I/O failure during ", g0, " in file '", g0, "'" )
    end subroutine iostat_check_sub

    subroutine file_closer_sub ( io_unit, fileName, crashChain, optionalMessage )
        integer ( kind = ip ),                  intent ( in ) :: io_unit
        character ( kind = kindA, len = * ),           intent ( in ) :: fileName
        character ( kind = kindA, len = * ),           intent ( in ) :: crashChain
        character ( kind = kindA, len = * ), optional, intent ( in ) :: optionalMessage
        character ( len = msgl ) :: subroutineCrash

            subroutineCrash = trim ( crashChain ) // " " // trim ( "subroutine 'file_closer_sub'." )
            close ( unit = io_unit, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure to CLOSE for me % io_unit = ", io_unit
                write ( * , fmt = '( 2g0 )' ) "File name = '", trim ( fileName ), "'"
                if ( present ( optionalMessage ) ) then
                    write ( * , fmt = '( g0 )' ) trim ( optionalMessage )
                end if
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg )      trim ( io_msg )
                write ( * , fmt = '( g0 )' ) trim ( subroutineCrash )
                stop
            end if

        return
    end subroutine file_closer_sub

end module mIOtools
