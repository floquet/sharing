! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mOBJreader

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    ! class structures
    use mClassFace,                     only : face
    use mClassVertex,                   only : vertex
    ! utilities
    use mClassCensus,                   only : census, lines
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_one, fmt_two, fmt_three, fmt_four, fmt_stat, fmt_iomsg
    use mLibraryOfConstants,            only : messageLength
    use mPrecisionDefinitions,          only : ip, rp
    use mParametersSimulation,          only : dim

    implicit none
    ! parameters
    character ( len = * ), parameter :: moduleCrash = "Program crashed in module 'mOBJreader', "

    integer ( ip ) :: io_stat = 0, io_obj = 0
    character ( len = messageLength ) :: io_msg = ""
    character ( len =   2 ) :: trash  = ""

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

    subroutine getVertices ( io_obj, array, locators )
        ! tourists
        type ( vertex ), intent ( out ) :: array ( : )
        type ( lines ),  intent ( in )  :: locators
        integer ( ip ),  intent ( in )  :: io_obj
        ! locals
        integer ( ip ) :: j = 0, k = 0
        character ( len = * ), parameter :: subroutineCrash = "subroutine 'getVertices'"

            ! position line pointer
            rewind ( unit = io_obj, iostat = io_stat, iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Error rewinding *.obj file to gather vertex data"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop moduleCrash // subroutineCrash
            endif

            do k = 1, locators % first - 1
                read ( unit = io_obj, fmt = *, iostat = io_stat,  iomsg = io_msg )
                if ( io_stat /= 0 ) then
                    write ( * , fmt_one ) "Error while positioning read pointers"
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop moduleCrash // subroutineCrash
                endif
            end do

            ! read data
            do k = 1, locators % count
                read ( unit = io_obj, fmt = *, iostat = io_stat, iomsg = io_msg ) &
                    trash, ( array ( k ) % position ( j ), j = 1, dim )
                if ( io_stat /= 0 ) then
                    write ( * , fmt_two ) "Read error at vertex element ", k
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop moduleCrash // subroutineCrash
                endif
            end do

        return
    end subroutine getVertices

    ! https://stackoverflow.com/questions/61024072/how-to-use-fortran-to-read-the-face-information-from-a-obj-file
    subroutine getFaces ( io_obj, array, locators )
        ! tourists
        type ( face ),  intent ( out ) :: array ( : )
        type ( lines ), intent ( in )  :: locators
        integer ( ip ), intent ( in )  :: io_obj
        ! locals
        integer ( ip ) :: indices ( 1 : 6 )
        integer ( ip ) :: j = 0, k = 0
        character ( len = 128 ) :: buffer = ""
        character ( len = * ), parameter :: subroutineCrash = "subroutine 'getFaces'"

            ! position line pointer
            rewind ( unit = io_obj, iostat = io_stat, iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Error rewinding *.obj file to gather face data"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop moduleCrash // subroutineCrash
            endif

            do k = 1, locators % first - 1
                read ( unit = io_obj, fmt = *, iostat = io_stat,  iomsg = io_msg )
                if ( io_stat /= 0 ) then
                    write ( * , fmt_one ) "Error while positioning read pointer to gather face data"
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop moduleCrash // subroutineCrash
                endif
            end do

            ! read data
            do k = 1, locators % count
                ! f 1//1 2//2 3//3 ==> [ 1, 2, 3 ]
                ! read line as text buffer
                read ( unit = io_obj, fmt = '( A )', iostat = io_stat, iomsg = io_msg ) buffer
                if ( io_stat /= 0 ) then
                    write ( * , fmt_two ) "Read error at face element ", k
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop moduleCrash // subroutineCrash
                endif
                ! remove offending forward slashes
                do j = 1, len( buffer )
                    ! "/" ==> " "
                    if ( buffer ( j : j ) == "/" ) then
                        buffer ( j : j ) = " "
                    end if
                end do
                ! read buffer as integer list
                read ( unit = buffer ( 2 : ), fmt = *, iostat = io_stat, iomsg = io_msg ) indices ( 1 : 6 )
                if ( io_stat /= 0 ) then
                    write ( * , fmt_four ) "Read error at face element ", k, ": buffer = ", trim ( buffer )
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop moduleCrash // subroutineCrash
                endif
                ! harvest lead elements as vertex indices
                array ( k ) % indexVertex ( : ) = indices ( 1 : 6 : 2 )
            end do

        return
    end subroutine getFaces

end module mOBJreader
