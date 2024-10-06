! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mMoMoutput

    use, intrinsic :: iso_fortran_env,  only : iostat_end

    use mArrayBounds,                   only : nu_lo, nu_hi, azimuth_lo, azimuth_hi, elevation_lo, elevation_hi, numElements
    use mMoMeFields,                    only : eFields
    use mAllocations,                   only : rank_one_integers_sub, rank_one_reals_sub, rank_two_eFields_azimuth_sub
    use mFileHandling,                  only : safeopen_readonly, safeopen_readwrite
    use mFormatDescriptors,             only : fmt_one, fmt_two, fmt_iomsg, fmt_stat
    use mIOutilities,                   only : rewinder_sub
    use mPrecisionDefinitions,          only : ip, rp, sp

    implicit none

    character ( len = 512 ) :: io_msg = ""
    integer :: io_stat = 0

    type :: output
        type ( eFields ), allocatable :: eFieldTable ( : , : )
        ! length ( frequency list )
        real    ( rp ), allocatable :: nu ( : )
        integer ( ip ), allocatable :: alpha ( : ), omega ( : )
        ! length ( angle list )
        real ( rp ), allocatable :: yaw ( : )
        real ( rp ), allocatable :: pitch ( : )
        ! accounting
        integer ( ip ) :: numFrequencies = nu_hi - nu_lo + 1
        integer ( ip ) :: numAngles      = azimuth_hi - azimuth_lo + 1
        integer ( ip ) :: numLines = 0
        integer ( ip ) :: currentLine = 0
        ! IO
        character ( len =   3 ) :: frequency_units = ""
        character ( len = 512 ) :: fullFileName = ""
        integer ( ip ) :: io_handle = 0
        ! strays
        character ( len = 3 ) :: frequencyUnits = ""
    contains
        procedure, public :: sweep_data_file => sweep_data_file_sub
    end type output

    private :: allocate_size_frequency_sub, count_lines_sub, rank_two_eFields_azimuth_sub, record_frequencies_sub, &
                sweep_data_file_sub, read_data_block_sub!, write_rcs_ascii_sub

contains

    subroutine sweep_data_file_sub ( me, fullFileName )
        class ( output ), target :: me
        character ( len = * ), intent ( in ) :: fullFileName
        !integer ( ip ) :: k = 0
            me % fullFileName      = trim ( fullFileName )

            call count_lines_sub ( me )
            call allocate_size_frequency_sub ( me )
            call record_frequencies_sub ( me )
            call rank_two_eFields_azimuth_sub ( me % eFieldTable, index_azimuth_lo = azimuth_lo, index_azimuth_hi = azimuth_hi, &
                                                index_nu_lo = nu_lo, index_nu_hi = nu_hi )
            !write ( * , fmt = '( 3g0 )' ) "shape ( me % eFieldTable ( : , : ) ) = ", shape ( me % eFieldTable ( : , : ) )
            call read_data_block_sub ( me )
        return
    end subroutine sweep_data_file_sub

    subroutine read_data_block_sub ( me )
        class ( output ), target :: me
        integer ( ip ) :: kAngles = 0, kFrequencies = 0, kline = 0!, pos = 0, next_rec
        character ( len = 161 ) :: data_line = ""

            me % currentLine = 1
            sweep_frequencies: do kFrequencies = nu_lo, nu_hi
                ! how far until the next data block?
                !inquire ( unit = me % io_handle, pos = pos, nextrec = next_rec )
                !write ( * , * )
                ! write ( * , fmt = '( 2g0 )' ) "currently at line = ", pos, "; nextrec = ", next_rec
                ! write ( * , fmt = '( 2g0 )' ) "kFrequencies = ", kFrequencies
                ! write ( * , fmt = '( 2g0 )' ) "next data block starts at = ", me % alpha ( kFrequencies )
                ! write ( * , fmt = '( 2g0 )' ) "lines to next data block = ", me % alpha ( kFrequencies ) - pos
                do kline = 1, me % alpha ( kFrequencies ) - me % currentLine
                    read ( unit = me % io_handle, fmt = * )
                    me % currentLine = me % currentLine + 1
                end do
                sweep_angles: do kAngles = azimuth_lo, azimuth_hi
                    !write ( * , fmt = '( 2g0)' ) "kAngles = ", kAngles
                    read ( unit = me % io_handle, fmt = '( A161 )', iostat = io_stat,  iomsg = io_msg ) data_line
                    me % currentLine = me % currentLine + 1
                    if ( io_stat /= 0 ) then
                        write ( * , fmt_one ) "Error while harvesting electric field values"
                        write ( * , fmt_stat )  io_stat
                        write ( * , fmt_iomsg ) io_msg
                        !inquire ( unit = me % io_handle, pos = pos )
                        !write ( * , fmt_two ) "Line position = ", pos
                        stop "Program crashed in module 'mMoMoutput', subroutine 'read_data_block_sub'..."

                    endif
                    call me % eFieldTable ( kAngles, kFrequencies ) % harvest_e_fields ( data_line = data_line )
                end do sweep_angles
            end do sweep_frequencies

        return
    end subroutine read_data_block_sub

    subroutine record_frequencies_sub ( me )
        class ( output ), target :: me
        integer ( ip ) :: knu = 2, location = -1, line_number = 0
        character ( len = 256 ) :: number = ""
        character ( len = 161 ) :: data_line = ""

        counting_lines: do
            read ( unit = me % io_handle, fmt = '( A161 )', iostat = io_stat,  iomsg = io_msg ) data_line
                if ( io_stat /= 0 ) then

                    ! check EOF
                    if ( io_stat == iostat_end ) then
                        me % numLines = knu - 1
                        exit counting_lines
                    end if

                    write ( * , fmt_one ) "Error while sweeping data file"
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop "Program crashed in module 'mMoMoutput', subroutine 'record_frequencies_sub'..."

                endif

            line_number = line_number + 1

            location = index ( data_line, "  Freq ", kind = ip )
            if ( location > 0 ) then
                knu = knu + 1
                if ( knu == 3 ) then
                    me % frequencyUnits = data_line ( 25 : 27 )
                endif
                me % alpha ( knu ) = line_number + 8
                write ( number, fmt = '( g0 )' ) data_line ( 11 : 24 )
                write ( *, fmt = '( 2g0 )' ) "slice = ", data_line ( 11 : 24 )
                read  ( number, fmt = '( e13.2 )' ) me % nu ( knu )
                write ( *, fmt = '( g0 )' ) me % nu ( knu )
            end if

            location = index ( data_line, "subroutine Solve_SetUp(  Surface, bk, pSys, pD, Nodes )  : ...Finished", kind = ip )
            if ( location > 0 ) then
                me % omega ( knu ) = line_number - 1
            end if

        end do counting_lines
        me % numAngles = me % omega ( knu ) - me % alpha ( knu ) + 1
        write ( * , fmt = '( 9g0 )' ) " me % numAngles = ", me % numAngles, ", me % omega ( ", knu, " ) ", me % omega ( knu ), &
         " - ", me % alpha ( knu ), " + 1"

        ! rewind file to sweep e fields
        call rewinder_sub ( me % io_handle )

        return
    end subroutine record_frequencies_sub

    subroutine allocate_size_frequency_sub ( me )
        class ( output ), target :: me

            call rank_one_reals_sub    ( real_array    = me % nu,    index_lo = nu_lo, index_hi = nu_hi )
            call rank_one_integers_sub ( integer_array = me % alpha, index_lo = nu_lo, index_hi = nu_hi )
            call rank_one_integers_sub ( integer_array = me % omega, index_lo = nu_lo, index_hi = nu_hi )

        return
    end subroutine allocate_size_frequency_sub

    subroutine count_lines_sub ( me )
        class ( output ), target :: me
        integer ( ip ) :: k = 1, location = -1
        character ( len = 161 ) :: data_line

        me % io_handle = safeopen_readonly ( trim ( me % fullFileName ) )

        me % numFrequencies = 0
        counting_lines: do
            read ( unit = me % io_handle, fmt = '( A161 )', iostat = io_stat,  iomsg = io_msg ) data_line
                if ( io_stat /= 0 ) then

                    ! check EOF
                    if ( io_stat == iostat_end ) then
                        me % numLines = k - 1
                        write ( *, '( 4g0 )' ) trim ( me % fullFileName ), " has ", me % numLines, " lines"
                        exit counting_lines
                    end if

                    write ( * , fmt_one ) "Error while sweeping data file"
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop "Program crashed in module 'mMoMoutput', subroutine 'count_lines'..."

                endif
            k = k + 1

            location = index ( data_line, "  Freq ", kind = ip )
            if ( location > 0 ) then
                me % numFrequencies = me % numFrequencies + 1
            end if

        end do counting_lines
        !write ( *, '( 4g0 )' ) trim ( me % fileName ), " has ", me % numFrequencies, " frequencies."

        ! rewind file to sweep frequency log
        call rewinder_sub ( me % io_handle )

        return
    end subroutine count_lines_sub


end module mMoMoutput
