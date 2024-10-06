! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassDataFile

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    ! classes
    use mClassAverages,                 only : average, average0
    use mClassElectricFields,           only : electricFields, electricFields0
    use mClassMesh,                     only : meshReal
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    ! utilities
    use mLibraryOfConstants,            only : fileNameLength, messageLength, MoMlineLength
    ! use mBulkRCS,                       only : BulkRCS, BulkRCS0
    use mFileHandling,                  only : safeopen_readonly, safeopen_writereplace
    use mFormatDescriptors,             only : fmt_one, fmt_stat, fmt_iomsg, fmt_shape2
    use mPrecisionDefinitions,          only : ip, rp
    use mTextFileUtilities,             only : read_text_lines_sub

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength, mll = MoMlineLength

    character ( len = msgl ) :: io_msg = ""
    integer :: io_stat = 0

    type :: dataFile4112
        ! rank 2
        real ( ip ),             allocatable :: rcs_table_rank_2 ( : , : ) ! angle mesh length x nu mesh length
        ! ! rank 1
        type ( average ),        allocatable :: perFrequencyAverage ( : )  ! nu mesh length
        character ( len = mll ), allocatable :: lines4112Text ( : )        ! length numlines4112Text
        ! rank 0
        type ( electricFields ) :: eFields = electricFields0
        integer ( ip )          :: io_unit = 0, numlines4112Text = 0
        character ( len = fnl ) :: sourceFileName = "", RCSoutputFileName = ""
        ! allocation tools
        type ( allocationToolKit ) :: myKit = allocationToolKit0
    contains
        procedure, public :: extract_rcs_from_4112_file => extract_rcs_from_4112_file_sub
        procedure, public :: load_rcs_table_3           => load_rcs_table_3_sub
        procedure, public :: write_rcs_data_file        => write_rcs_data_file_sub
    end type dataFile4112

    private :: extract_rcs_from_4112_file_sub, load_rcs_table_3_sub, write_rcs_data_file_sub

contains

    subroutine load_rcs_table_3_sub ( me, rcs_table_rank_3, fixedAngleIndex, numFrequencies, numFreeAngles )
        class ( dataFile4112 ),    target :: me
        real    ( rp ),  intent ( inout ) :: rcs_table_rank_3 ( : , : , : )
        integer ( ip ),  intent ( in )    :: fixedAngleIndex
        integer ( ip ),  intent ( in )    :: numFrequencies, numFreeAngles
        integer ( ip ) :: kFrequency = 0, kFreeAngle = 0
            sweep_free_angles: do kFreeAngle = 1, numFreeAngles
                sweep_frequencies: do kFrequency = 1, numFrequencies
                    rcs_table_rank_3 ( kFreeAngle, kFrequency, fixedAngleIndex ) = me % rcs_table_rank_2 ( kFreeAngle, kFrequency )
                end do sweep_frequencies
            end do sweep_free_angles
        return
    end subroutine load_rcs_table_3_sub

    subroutine extract_rcs_from_4112_file_sub ( me, fullFileName, numFrequencies, numFreeAngles, lineNumbersFrequency, one )
        class ( dataFile4112 ),         target :: me
        real    ( rp )                         :: one ( : )
        integer ( ip ),          intent ( in ) :: lineNumbersFrequency ( : )
        integer ( ip ),          intent ( in ) :: numFrequencies, numFreeAngles
        character ( len = fnl ), intent ( in ) :: fullFileName
        ! locals
        type ( average ), pointer :: p => null ( )
        real    ( rp )            :: rcsMax = - huge ( 1.0_rp ), rcsMin = huge ( 1.0_rp ), sigma = 0.0_rp
        integer ( ip )            :: kFrequency = 0, kFreeAngle = 0, linePosition = 0
        character ( len = mll )   :: textLine

            ! open *.4112.txt file, read text lines into memory
            call read_text_lines_sub ( fileName = fullFileName, linesText = me % lines4112Text )
            ! sweep and harvest RCS value
            sweep_frequencies: do kFrequency = 1, numFrequencies
                linePosition = lineNumbersFrequency ( kFrequency ) + 8

                rcsMax = - huge ( 1.0_rp )
                rcsMin =   huge ( 1.0_rp )
                sweep_free_angles: do kFreeAngle = 1, numFreeAngles
                    textLine = me % lines4112Text ( linePosition )
                    call me % eFields % gather_mean_total_rcs ( textLine = textLine )
                        sigma = me % eFields % meanTotalRCS
                        me % rcs_table_rank_2 ( kFreeAngle, kFrequency ) = sigma
                        if ( sigma > rcsMax ) then
                            rcsMax = sigma
                            else if ( sigma < rcsMin ) then
                                rcsMin = sigma
                            end if
                    linePosition = linePosition + 1
                end do sweep_free_angles
            p => me % perFrequencyAverage ( kFrequency )
                call p % compute_mean_and_variance ( vector = me % rcs_table_rank_2 ( 1 : numFrequencies, kFrequency ), one = one )
                p % maxValue = rcsMax
                p % minValue = rcsMin
            p => null ( )
            end do sweep_frequencies

        return
    end subroutine extract_rcs_from_4112_file_sub

    subroutine write_rcs_data_file_sub ( me, MoM4112File, frequencyMesh, angleFreeMesh )
        class ( dataFile4112 ),        target  :: me
        type  ( meshReal ),      intent ( in ) :: frequencyMesh, angleFreeMesh
        character ( len = fnl ), intent ( in ) :: MoM4112File
        character ( len = fnl ) :: RCSoutputFileName = ""
        integer ( ip ) :: kFrequency = 0, kAngle = 0
        integer ( ip ) :: nameLength = 0, io_out = 0

            nameLength = len ( trim ( MoM4112File ) )
            me % RCSoutputFileName = trim ( MoM4112File ( 1 : nameLength - 4 ) ) // ".dat"
            io_out = safeopen_writereplace ( me % RCSoutputFileName )
            ! write RCS values one row at a time
            sweep_frequencies: do kFrequency = 1, frequencyMesh % numMeshElements
                write ( io_out, fmt = angleFreeMesh % valuesFormatDescriptor ) &
                    ( me % rcs_table_rank_2 ( kAngle , kFrequency ), kAngle = 1, angleFreeMesh % numMeshElements )
                    if ( io_stat /= 0 ) then
                        write ( * , fmt = '( 3g0 )' ) "Failure to WRITE line ", kFrequency, " in file ", &
                                                        trim ( RCSoutputFileName ), "'"
                        write ( * , fmt_stat  ) io_stat
                        write ( * , fmt_iomsg ) io_msg
                        stop "Program crashed in module 'mClassDataFile', subroutine 'write_rcs_data_file_sub'..."
                    end if
            end do sweep_frequencies

            ! close io handle
            close ( unit = io_out, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure on CLOSE for me % io_unit = ", me % io_unit
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in module 'mClassDataFile', subroutine 'write_rcs_data_file_sub'..."
            end if

        return
    end subroutine write_rcs_data_file_sub

end module mClassDataFile
