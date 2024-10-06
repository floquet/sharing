! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mListOfMoMfiles

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mFileHandling,                  only : safeopen_readonly
    use mFormatDescriptors,             only : fmt_one, fmt_stat, fmt_iomsg
    use mLibraryOfConstants,            only : fileNameLength, messageLength
    use mPrecisionDefinitions,          only : ip, rp
    use mTextFileUtilities,             only : count_lines_sub

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength

    integer :: io_stat = 0, io_unit = 0
    character ( len = msgl ) :: io_msg = ""

    type :: sourceFileNames
        character ( len = fnl ), allocatable :: listFileNames ( : )
        character ( len = fnl )    :: sourceFileName = ""
        integer ( ip )             :: numFileNames = 0
        ! allocation tools
        type ( allocationToolKit ) :: myKit = allocationToolKit0
    contains
        procedure, public :: ingest_file_names     => ingest_file_names_sub
        procedure, public :: print_list_file_names => print_list_file_names_sub
        procedure, public :: read_file_list        => read_file_list_sub
    end type sourceFileNames

    private :: ingest_file_names_sub, print_list_file_names_sub, read_file_list_sub

contains

    subroutine read_file_list_sub ( me, fullFileName )
        class ( sourceFileNames ), target :: me
        character ( len = * ), intent ( in ) :: fullFileName
            me % sourceFileName = trim ( fullFileName )
            call count_lines_sub ( fullFileName = me % sourceFileName, numLines = me % numFileNames )
            call me % myKit % allocate_rank_one_characters ( character_array = me % listFileNames, &
                                                              index_min = 1, index_max = me % numFileNames )
            call ingest_file_names_sub ( me )
            call print_list_file_names_sub ( me )
        return
    end subroutine read_file_list_sub

    subroutine print_list_file_names_sub ( me )
        class ( sourceFileNames ), target :: me
        integer ( ip ) :: kLines = 0
            write ( * , fmt = '( 5g0 )' ) "List of ", me % numFileNames, " input files in ", trim ( me % sourceFileName ), ":"
            loop_file_names: do kLines = 1, me % numFileNames
                write ( * , fmt = '( I2, 3g0 )' ) kLines, ". ", trim ( me % listFileNames ( kLines ) ), "."
            end do loop_file_names
            write ( * , * )
        return
    end subroutine print_list_file_names_sub

    subroutine ingest_file_names_sub ( me )
        class ( sourceFileNames ), target :: me
        integer ( ip ) :: kLines = 0
            io_unit = safeopen_readonly ( trim ( me % sourceFileName ) )

            do kLines = 1, me % numFileNames
                read ( unit = io_unit, fmt = *, iostat = io_stat, iomsg = io_msg ) me % listFileNames ( kLines )
                if ( io_stat /= 0 ) then
                    write ( * , fmt = '( 5g0 )' ) "Failure to READ file name number ", kLines, " from " , &
                                                    trim ( me % sourceFileName ), "."
                    write ( * , fmt = fmt_stat  ) io_stat
                    write ( * , fmt = fmt_iomsg ) io_msg
                    stop "Error occured in module 'mListOfMoMfiles', subroutine 'ingest_file_names_sub'."
                end if
            end do

            close ( unit = io_unit, iostat = io_stat, iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure on CLOSE for io_unit = ", io_unit, " for file ", &
                                                trim ( me % sourceFileName ), "."
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in module 'mListOfMoMfiles', subroutine 'ingest_file_names_sub'..."
            end if

        return
    end subroutine ingest_file_names_sub


end module mListOfMoMfiles
