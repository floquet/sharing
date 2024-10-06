! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassDataFile

    ! classes
    use mClassAverages,                 only : average
    use mClassElectricFields,           only : electricFields, electricFields0
    use mClassMesh,                     only : meshReal
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mAllocationsSpecial,            only : allocate_rank_one_averages_sub
    ! utilities
    use mLibraryOfConstants,            only : fileNameLength, messageLength, MoMlineLength
    use mFileHandling,                  only : safeopen_writereplace
    use mPrecisionDefinitions,          only : ip, rp
    use mTextFileUtilities,             only : count_lines_sub, mark_frequencies_sub, read_text_lines_sub, file_closer_sub, &
                                               iostat_check_sub
    implicit none

    ! parameters
    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength, mll = MoMlineLength
    character ( len = 9 ), parameter :: strAzimuth   = "azimuth  "
    character ( len = 9 ), parameter :: strElevation = "elevation"
    character ( len = * ), parameter :: moduleCrash = "Program crashed in module 'mClassDataFile', "

    integer :: io_stat = 0
    character ( len = msgl ) :: io_msg = ""

    type :: dataFile4112
        ! rank 2
        real ( ip ),             allocatable :: rcs_table ( : , : ) ! angle mesh length x nu mesh length
        ! ! rank 1
        integer ( ip ),          allocatable :: lineNumbersFrequency ( : ), &
                                                lineNumbersFinished  ( : )
        type ( average ),        allocatable :: perFrequencyAverage ( : )  ! nu mesh length
        character ( len = mll ), allocatable :: lines4112Text ( : )        ! length numlines4112Text
        ! rank 0
        type ( electricFields ) :: eFields = electricFields0
        type ( meshReal ) :: meshFrequency, &
                             meshFreeAngle
        integer ( ip ) :: numFrequencies   = 0, &
                          numFixedAngles   = 0, &
                          numFreeAngles    = 0, &
                          numMeasurements  = 0, &
                          numLines4112Text = 0
        integer ( ip ) :: io_unit = 0
        character ( len =   9 ) :: angleFixedType  = "", angleFreeType = ""
        character ( len = fnl ) :: file4112Name = "", fileRCStxtName = "", fileRCSbinaryName = ""
        ! allocation tools
        type ( allocationToolKit ) :: myKit = allocationToolKit0
    contains
        procedure, public :: allocate_rcs_tables           => allocate_rcs_tables_sub, &
                             allocate_rcsAverages          => allocate_rcsAverages_sub, &
                             characterize_rcs_by_frequency => characterize_rcs_by_frequency_sub, &
                             check_rcs_table_structure     => check_rcs_table_structure_sub, &
                             establish_free_angle_mesh     => establish_free_angle_mesh_sub, &
                             establish_frequency_mesh      => establish_frequency_mesh_sub, &
                             extract_rcs_from_4112_file    => extract_rcs_from_4112_file_sub, &
                             harvest_Finished_lines        => harvest_Finished_lines_sub, &
                             harvest_frequencies           => harvest_frequencies_sub, &
                             set_file_names                => set_file_names_sub, &
                             set_free_angle_azimuth        => set_free_angle_azimuth_sub, &
                             set_free_angle_elevation      => set_free_angle_elevation_sub, &
                             write_rcs_file_set            => write_rcs_file_set_sub, &
                             write_rcs_binary              => write_rcs_binary_sub, &
                             write_rcs_csv                 => write_rcs_csv_sub, &
                             write_summary_by_frequency    => write_summary_by_frequency_sub
    end type dataFile4112

    private :: allocate_rcs_tables_sub, allocate_rcsAverages_sub, &
               establish_free_angle_mesh_sub, establish_frequency_mesh_sub, extract_rcs_from_4112_file_sub, &
               harvest_Finished_lines_sub, harvest_frequencies_sub, &
               set_file_names_sub, set_free_angle_azimuth_sub, set_free_angle_elevation_sub, write_summary_by_frequency_sub

contains

    subroutine characterize_rcs_by_frequency_sub ( me )
        class ( dataFile4112 ),         target :: me
        type ( average ), pointer :: p => null ( )
        integer ( ip ) :: kFrequency = 0

            sweep_frequencies: do kFrequency = 1, me % numFrequencies
                p => me % perFrequencyAverage ( kFrequency )
                    call p % find_max_and_min          ( vector = me % rcs_table ( 1 : me % numFrequencies, kFrequency ) )
                    call p % compute_mean_and_variance ( vector = me % rcs_table ( 1 : me % numFrequencies, kFrequency ), &
                                                         one = me % meshFrequency % one )
                p => null ( )
            end do sweep_frequencies

        return
    end subroutine characterize_rcs_by_frequency_sub

    module subroutine write_summary_by_frequency_sub ( me )
        class ( dataFile4112 ), target :: me
        integer ( ip ) :: kFrequency = 0
            write ( * , * )
            sweep_frequencies: do kFrequency = 1,   me % meshFrequency % numMeshElements
                write ( * , fmt = 100 ) kFrequency, me % meshFrequency % meshValues ( kFrequency ), &
                                                    me % perFrequencyAverage ( kFrequency ) % mean, &
                                                    me % perFrequencyAverage ( kFrequency ) % standardDeviation, &
                                                    me % perFrequencyAverage ( kFrequency ) % extrema % minValue, &
                                                    me % perFrequencyAverage ( kFrequency ) % extrema % maxValue
            end do sweep_frequencies
        return
        100 format ( I3.3, ". nu = ", g0, ", mean RCS = ", g0, " +/- ", g0, ", min = ", g0, ", max = ", g0 )
    end subroutine write_summary_by_frequency_sub

    module subroutine write_rcs_file_set_sub ( me )
        class ( dataFile4112 ), target :: me
            call me % write_rcs_csv    ( )
            call me % write_rcs_binary ( )
        return
    end subroutine write_rcs_file_set_sub

    module subroutine write_rcs_binary_sub ( me )
        class ( dataFile4112 ), target :: me
        integer ( ip )           :: io_rcs = 0
        character ( len = msgl ) :: crashChain = ""

            crashChain = moduleCrash // "subroutine 'write_rcs_binary_sub'."

            open ( newunit = io_rcs, file = me % fileRCSbinaryName, action = 'WRITE', status = 'REPLACE', form = 'UNFORMATTED', &
                                    iostat = io_stat, iomsg = io_msg )
            call iostat_check_sub ( action = "UNFORMATTED OPENING", fileName = me % fileRCSbinaryName, crashChain = crashChain, &
                                    iostat = io_stat, iomsg = io_msg )

            write ( io_rcs, iostat = io_stat,  iomsg = io_msg ) me % rcs_table ( 1 : me % meshFreeAngle  % numMeshElements, &
                                                                                 1 : me % meshFrequency  % numMeshElements )
            call iostat_check_sub ( action = "UNFORMATTED WRITE to", fileName = me % fileRCSbinaryName, crashChain = crashChain, &
                                    iostat = io_stat, iomsg = io_msg )
            call file_closer_sub ( io_unit = io_rcs, fileName = me % fileRCSbinaryName, crashChain = crashChain )

        return
    end subroutine write_rcs_binary_sub

    module subroutine write_rcs_csv_sub ( me )
        class ( dataFile4112 ),         target :: me
        integer ( ip ) :: kFrequency = 0, kFreeAngle = 0, &
                          io_out = 0
        character ( len = msgl ) :: crashChain = ""

            crashChain = moduleCrash // "subroutine 'write_rcs_csv_sub'."
            io_out = safeopen_writereplace ( me % fileRCStxtName )
            ! write RCS values one row (frequency) at a time
            sweep_frequencies: do kFrequency = 1, me % meshFrequency % numMeshElements
                write ( io_out, fmt = me % meshFreeAngle % valuesFormatDescriptor ) ( me % rcs_table ( kFreeAngle, kFrequency ), &
                        kFreeAngle = 1, me % meshFreeAngle % numMeshElements )
                call iostat_check_sub ( action = "WRITE to", fileName = me % fileRCStxtName, crashChain = crashChain, &
                                            iostat = io_stat, iomsg = io_msg )
            end do sweep_frequencies
            ! close io handle
            call file_closer_sub ( io_unit = io_out, fileName =  me % fileRCStxtName, crashChain = crashChain )

        return
    end subroutine write_rcs_csv_sub

    subroutine set_file_names_sub ( me, file4112Name )
        class ( dataFile4112 ),         target :: me
        character ( len = fnl ), intent ( in ) :: file4112Name
        integer ( ip ) :: nameLength = 0

            nameLength =       len ( trim ( file4112Name ) )
            me % file4112Name      = trim ( file4112Name )
            me % fileRCStxtName    = trim ( file4112Name ( 1 : nameLength - 4 ) ) // ".rcs.txt"
            me % fileRCSbinaryName = trim ( file4112Name ( 1 : nameLength - 4 ) ) // ".rcs.r32"

        return
    end subroutine set_file_names_sub

    subroutine allocate_rcsAverages_sub ( me )
        class ( dataFile4112 ), target :: me
            call allocate_rank_one_averages_sub ( rank_1_average = me % perFrequencyAverage, &
                                                       index_min = 1, index_max = me % numFrequencies )
        return
    end subroutine allocate_rcsAverages_sub

    subroutine allocate_rcs_tables_sub ( me )
        class ( dataFile4112 ), target :: me
            call me % myKit % allocate_rank_two_reals (  rank_2_real_array = me % rcs_table,           &
                                                            dim1_index_min = 1, dim1_index_max = me % numFreeAngles, &
                                                            dim2_index_min = 1, dim2_index_max = me % numFrequencies )
        return
    end subroutine allocate_rcs_tables_sub

    subroutine establish_frequency_mesh_sub ( me )
        class ( dataFile4112 ), target :: me
            ! count lines in MoM file (e.q. 14844)
            call count_lines_sub ( fullFileName = me % file4112Name, numLines = me % numLines4112Text )
            ! allocate object to hold text of MoM file as a collection of text lines
            call me % myKit % allocate_rank_one_characters ( character_array = me % lines4112Text, &
                                                             index_min = 1, index_max = me % numLines4112Text )
            ! load MoM text into memory to count frequencies and angles
            call read_text_lines_sub ( fileName = me % file4112Name, linesText = me % Lines4112Text )
            ! sift through text lines for " Freq ="
            call me % harvest_frequencies ( )
            ! sift through text lines for "...Finished"
            call me % harvest_Finished_lines ( )
            ! compute number of angle measurements
            me % numFreeAngles = me % lineNumbersFinished  ( 1 ) - me % lineNumbersFrequency ( 1 ) - 8
        return
    end subroutine establish_frequency_mesh_sub

    ! sweep through character array looking for "  Freq"
    ! store these values in a temporary array until nuMesh is allocated
    subroutine harvest_frequencies_sub ( me )
        class ( dataFile4112 ), target :: me
        ! pointers
        !character ( len =  mll ),   pointer :: p => null ( )
        type ( meshReal ),          pointer :: q => null ( )
        type ( allocationToolKit ), pointer :: s => null ( )
        ! temp arrays
        real    ( ip ) :: tempFrequencyValues   ( 1 : 500 )
        integer ( ip ) :: tempLineNumsFrequency ( 1 : 500 )
        ! scalars
        integer ( ip ) :: numfrequencies = 0, kFrequency = 0

            ! find lines containing " Freq ="
            call mark_frequencies_sub ( lines4112Text = me % lines4112Text,    &
                                     numLines4112Text = me % numLines4112Text, &
                                  tempFrequencyValues = tempFrequencyValues,   &
                                tempLineNumsFrequency = tempLineNumsFrequency, &
                                       numfrequencies = numfrequencies )

            ! record what we have learned about the mesh
            q => me % meshFrequency
                q % numMeshElements = numfrequencies
                ! allocate data objects
                call q % allocate_mesh_real (  )
                s => me % myKit
                    ! call s % allocate_rank_one_reals    (    real_array = q  % meshValues,           index_min = 1, &
                    !                                           index_max = q  % numMeshElements )
                    call s % allocate_rank_one_integers ( integer_array = me % lineNumbersFrequency, index_min = 1, &
                                                              index_max = q  % numMeshElements )
                    call s % allocate_rank_one_integers ( integer_array = me % lineNumbersFinished,  index_min = 1, &
                                                              index_max = q  % numMeshElements )
                s => null ( )
                ! move temporary array data into data object
                do kFrequency = 1, q % numMeshElements
                     q % meshValues           ( kFrequency ) = tempFrequencyValues   ( kFrequency )
                    me % lineNumbersFrequency ( kFrequency ) = tempLineNumsFrequency ( kFrequency )
                end do
                me % numFrequencies = q % numMeshElements
                call q % analyze_mesh_values ( )
            q => null ( )
        return
    end subroutine harvest_frequencies_sub

    ! sweep through character array looking for "...Finished"
    subroutine harvest_Finished_lines_sub ( me )
        class ( dataFile4112 ), target :: me
        ! pointers
        character ( len =  mll ), pointer :: p => null ( )
        ! scalars
        integer ( ip ) :: kLines = 0, location = 0, numFinished = 0

            numFinished = 0
            sweep_lines: do kLines = 1, me % numLines4112Text
                p => me % lines4112Text ( kLines )
                ! does this line list a frequency?
                    location = index ( p, "subroutine Solve_SetUp(  Surface, bk, pSys, pD, Nodes )  : ...Finished", kind = ip )
                    if ( location > 0 ) then
                        ! data line found
                        numFinished = numFinished + 1
                        ! write ( * , fmt = '( 2g0 )' ) "numfrequencies = ", numfrequencies
                        me % lineNumbersFinished ( numFinished ) = kLines
                    end  if
                p => null ( )
            end do sweep_lines
        return
    end subroutine harvest_Finished_lines_sub

    subroutine extract_rcs_from_4112_file_sub ( me )
        class ( dataFile4112 ),         target :: me
        ! locals
        real    ( rp )            :: sigma = 0.0_rp
        integer ( ip )            :: kFrequency = 0, kFreeAngle = 0, linePosition = 0
        character ( len = mll )   :: textLine

            ! open *.4112.txt file, read text lines into memory
            call read_text_lines_sub ( fileName = me % file4112Name, linesText = me % lines4112Text )
            ! sweep and harvest RCS value
            sweep_frequencies: do kFrequency = 1, me % numFrequencies
                linePosition = me % lineNumbersFrequency ( kFrequency ) + 8
                sweep_free_angles: do kFreeAngle = 1, me % numFreeAngles
                    textLine = me % lines4112Text ( linePosition )
                    call me % eFields % gather_mean_total_rcs ( textLine = textLine )
                        sigma = me % eFields % meanTotalRCS
                        me % rcs_table ( kFreeAngle, kFrequency ) = sigma
                    linePosition = linePosition + 1
                end do sweep_free_angles
            end do sweep_frequencies

        return
    end subroutine extract_rcs_from_4112_file_sub

    subroutine set_free_angle_elevation_sub ( me )
        class ( dataFile4112 ), target :: me
            me % angleFreeType  = strElevation
            me % angleFixedType = strAzimuth
        return
    end subroutine set_free_angle_elevation_sub

    subroutine set_free_angle_azimuth_sub ( me )
        class ( dataFile4112 ), target :: me
            me % angleFreeType  = strAzimuth
            me % angleFixedType = strElevation
        return
    end subroutine set_free_angle_azimuth_sub

    subroutine establish_free_angle_mesh_sub ( me, angle_min, angle_max )
        class ( dataFile4112 ), target :: me
        real ( rp ), intent ( in ) :: angle_min, angle_max

            me % meshFreeAngle % meshAverage % extrema % minValue = angle_min
            me % meshFreeAngle % meshAverage % extrema % maxValue = angle_max
            me % meshFreeAngle % numMeshElements = me % numFreeAngles

            call me % meshFreeAngle % allocate_mesh_real (  )
            call me % meshFreeAngle % compute_real_mesh_length ( )
            call me % meshFreeAngle % compute_real_mesh_interval ( )
            call me % meshFreeAngle % populate_real_mesh ( )
            call me % meshFreeAngle % populate_integer_mesh ( )

        return
    end subroutine establish_free_angle_mesh_sub

    subroutine check_rcs_table_structure_sub ( me )
        class ( dataFile4112 ), target :: me
            write ( * , * )
            write ( * , fmt = '(  g0 )' ) "#  #  Dimensions for RCS data container  #  #"
            write ( * , * )
            write ( * , fmt = '(  g0 )' ) "# Expected dimensions:"
            write ( * , fmt = '( 2g0 )' ) "# Number of radar frequencies scanned by MoM:   ",                me % numFrequencies
            write ( * , fmt = '( 4g0 )' ) "# Number of ", me % angleFreeType, " angles scanned by MoM:  ",   me % numFreeAngles
            write ( * , * )
            write ( * , fmt = '( 2g0 )' ) "# Container MoM 4112.txt file: rcs_table"
            write ( * , fmt = '( 6g0 )' ) "# Free angle dimension = ",  size   ( me % rcs_table, 1 ), &
                                                  " indices run from ", lbound ( me % rcs_table, 1 ), &
                                                  " to ",               ubound ( me % rcs_table, 1 )
            write ( * , fmt = '( 6g0 )' ) "# Frequency dimension  = ",  size   ( me % rcs_table, 2 ), &
                                                  " indices run from ", lbound ( me % rcs_table, 2 ), &
                                                  " to ",               ubound ( me % rcs_table, 2 )
            write ( * , * )
        return
    end subroutine check_rcs_table_structure_sub

end module mClassDataFile