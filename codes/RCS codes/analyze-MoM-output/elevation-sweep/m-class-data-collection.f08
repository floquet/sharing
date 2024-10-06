! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassDataCollection

    ! classes
    use mAllocationsSpecial,            only : allocate_rank_two_averages_sub, allocate_rank_one_averages_sub
    use mClassAverages,                 only : average
    use mClassDataFile,                 only : dataFile4112
    use mClassMesh,                     only : meshReal
    ! objects
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    ! values
    use mLibraryOfConstants,            only : fileNameLength, messageLength, MoMlineLength
    ! use mBulkRCS,                       only : BulkRCS
    use mFormatDescriptors,             only : fmt_stat, fmt_iomsg, fmt_shape2
    use mPrecisionDefinitions,          only : ip, rp
    ! procedures
    use mTextFileUtilities,             only : count_lines_sub, mark_frequencies_sub, parse_name_sub, read_text_lines_sub

    implicit none

    ! parameters
    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength, mll = MoMlineLength

    ! variables
    integer :: io_stat = 0
    character ( len = msgl ) :: io_msg = ""

    character ( len = 9 ), parameter :: strAzimuth   = "azimuth  "
    character ( len = 9 ), parameter :: strElevation = "elevation"

    type :: collection
        ! rank 3
        ! ( free angle, fixed angle, frequency )
        real ( rp ),      allocatable :: rcs_table_rank_3 ( : , : , : )
        ! rank 2
        ! ( frequency, fixed angle )
        type ( average ), allocatable :: rcsAverages ( : , : )
        ! rank 1
        integer ( ip ),   allocatable :: lineNumbersFrequency ( : ), &
                                         lineNumbersFinished  ( : )
        ! rank 0
        type ( dataFile4112 )      :: MoMdataFile
        type ( meshReal )          :: meshFrequency, &
                                      meshFreeAngle, &
                                      meshFixedAngle
        type ( allocationToolKit ) :: myKit = allocationToolKit0
        ! census variables
        integer ( ip ) :: numFrequencies   = 0, &
                          numFixedAngles   = 0, &
                          numFreeAngles    = 0, &
                          numLines4112Text = 0
        ! identification
        character ( len = mll ) :: quarry          = "", &
                                   descriptor      = "", &
                                   directory4112   = "", &
                                   directoryRCSdat = "", &
                                   listOfDataFiles = ""
        character ( len =   9 ) :: angleFixedType  = "", angleFreeType = ""
    contains
        procedure, public :: allocate_rcsAverages           => allocate_rcsAverages_sub
        procedure, public :: allocate_rcs_tables            => allocate_rcs_tables_sub
        procedure, public :: check_rcs_table_structure      => check_rcs_table_structure_sub
        procedure, public :: establish_fixed_angle_mesh     => establish_fixed_angle_mesh_sub
        procedure, public :: establish_free_angle_mesh      => establish_free_angle_mesh_sub
        procedure, public :: establish_frequency_mesh       => establish_frequency_mesh_sub
        procedure, public :: harvest_Finished_lines         => harvest_Finished_lines_sub
        procedure, public :: harvest_frequencies            => harvest_frequencies_sub
        procedure, public :: set_free_angle_azimuth         => set_free_angle_azimuth_sub
        procedure, public :: set_free_angle_elevation       => set_free_angle_elevation_sub
        procedure, public :: sweep_data_set                 => sweep_data_set_sub
        procedure, public :: write_local_averages           => write_local_averages_sub
    end type collection

    private :: allocate_rcsAverages_sub, allocate_rcs_tables_sub, &
               check_rcs_table_structure_sub, &
               establish_fixed_angle_mesh_sub, establish_free_angle_mesh_sub, establish_frequency_mesh_sub, &
               harvest_Finished_lines_sub, harvest_frequencies_sub, &
               set_free_angle_azimuth_sub, set_free_angle_elevation_sub, sweep_data_set_sub, &
               write_local_averages_sub
contains

    subroutine sweep_data_set_sub ( me, listofMoMfiles )
        class ( collection ),           target :: me
        character ( len = fnl ), intent ( in ) :: listofMoMfiles ( : )
        ! locals
        type ( allocationToolKit ), pointer :: p => null ( )
        integer ( ip )           :: kFile = 0, angleValue = 0, angleLocal = 0
        character ( len = fnl )  :: fileName = "", myFile = ""
        real ( rp ), allocatable :: one ( : )

            ! clone a vector
            p => me % myKit
                allocate ( one, source = me % meshFrequency % meshValues, stat = p % alloc_status, errmsg = p % alloc_message )
                if ( p % alloc_status /= 0 ) then
                    call p % post_error_message_intrinsic ( action = 'allocating' )
                end if
                one ( : ) = one ( : ) - one ( : ) + 1
            p => null ( )
            ! analyze each MoM *.4112.txt
            ! parse file name for fixed angle
            ! extract RCS values into rank 2 table
            ! output rank 2 table
            ! load rank 3 table
            sweep_data_files: do kFile = 1, me % numFixedAngles
                myFile = trim ( listofMoMfiles ( kFile ) )
                call parse_name_sub ( fileName = myFile, angleValue = angleValue )
                me % meshFixedAngle % meshValues ( kFile ) = real ( angleValue, kind = rp )
                ! MoM measures from North Pole to equator. We measure equator to North Pole.
                angleLocal = 90 - angleValue
                write ( * , fmt = '( g0, I3.3, g0, I3.3, 7g0 )' ) "Analyzing file ", kFile, "/", me % numFixedAngles, ": '", &
                                                        trim ( myFile ), "', ", me % angleFixedType, " = ", angleLocal, "."
                fileName = trim ( me % directory4112 ) // trim ( myFile )
                call me % MoMdataFile % extract_rcs_from_4112_file ( fullFileName = fileName , &
                                                                   numFrequencies = me % numFrequencies, &
                                                                    numFreeAngles = me % numFreeAngles, &
                                                             lineNumbersFrequency = me % lineNumbersFrequency, &
                                                                              one = one )
                fileName = trim ( me % directoryRCSdat ) // trim ( listofMoMfiles ( kFile ) )
                call me % MoMdataFile % write_rcs_data_file ( MoM4112File = fileName, &
                                                            frequencyMesh = me % meshFrequency, angleFreeMesh = me % meshFreeAngle )
                call me % MoMdataFile % load_rcs_table_3 ( rcs_table_rank_3 = me % rcs_table_rank_3, fixedAngleIndex = kFile, &
                                                             numFrequencies = me % numFrequencies, &
                                                              numFreeAngles = me % numFreeAngles )
            end do sweep_data_files

        return
    end subroutine sweep_data_set_sub

    subroutine check_rcs_table_structure_sub ( me )
        class ( collection ), target :: me
            write ( * , * )
            write ( * , fmt = '(  g0 )' ) "#  #  Dimensions for RCS data containers  #  #"
            write ( * , * )
            write ( * , fmt = '(  g0 )' ) "# Expected dimensions:"
            write ( * , fmt = '( 2g0 )' ) "# Number of radar frequencies scanned by MoM:   ",                me % numFrequencies
            write ( * , fmt = '( 4g0 )' ) "# Number of ", me % angleFreeType, " angles scanned by MoM:  ",   me % numFreeAngles
            write ( * , fmt = '( 4g0 )' ) "# Number of ", me % angleFixedType, " angles scanned manually: ", me % numFixedAngles
            write ( * , * )
            write ( * , fmt = '( 2g0 )' ) "# Container for each MoM 4112.txt file: rcs_table_rank_2"
            write ( * , fmt = '( 6g0 )' ) "# Free angle dimension = ",  size   ( me % MoMdataFile % rcs_table_rank_2, 1 ), &
                                                  " indices run from ", lbound ( me % MoMdataFile % rcs_table_rank_2, 1 ), &
                                                  " to ",               ubound ( me % MoMdataFile % rcs_table_rank_2, 1 )
            write ( * , fmt = '( 6g0 )' ) "# Frequency dimension  = ",  size   ( me % MoMdataFile % rcs_table_rank_2, 2 ), &
                                                  " indices run from ", lbound ( me % MoMdataFile % rcs_table_rank_2, 2 ), &
                                                  " to ",               ubound ( me % MoMdataFile % rcs_table_rank_2, 2 )
            write ( * , * )
            write ( * , fmt = '( 2g0 )' ) "# Container for all MoM 4112.txt files: rcs_table_rank_3"
            write ( * , fmt = '( 6g0 )' ) "# Free angle dimension  = ", size   ( me % rcs_table_rank_3, 1 ), &
                                                  " indices run from ", lbound ( me % rcs_table_rank_3, 1 ), &
                                                  " to ",               ubound ( me % rcs_table_rank_3, 1 )
            write ( * , fmt = '( 6g0 )' ) "# Frequency dimension   = ", size   ( me % rcs_table_rank_3, 2 ), &
                                                  " indices run from ", lbound ( me % rcs_table_rank_3, 2 ), &
                                                  " to ",               ubound ( me % rcs_table_rank_3, 2 )
            write ( * , fmt = '( 6g0 )' ) "# Fixed angle dimension = ", size   ( me % rcs_table_rank_3, 3 ), &
                                                  " indices run from ", lbound ( me % rcs_table_rank_3, 3 ), &
                                                  " to ",               ubound ( me % rcs_table_rank_3, 3 )
            write ( * , * )
        return
    end subroutine check_rcs_table_structure_sub

    subroutine allocate_rcsAverages_sub ( me )
        class ( collection ), target :: me
            call allocate_rank_two_averages_sub ( rank_2_average = me % rcsAverages, &
                                                  dim1_index_min = 1, dim1_index_max = me % numFixedAngles, &
                                                  dim2_index_min = 1, dim2_index_max = me % numFrequencies )
            call allocate_rank_one_averages_sub ( rank_1_average = me % MoMdataFile % perFrequencyAverage, &
                                                       index_min = 1,      index_max = me % numFrequencies )
        return
    end subroutine allocate_rcsAverages_sub

    subroutine allocate_rcs_tables_sub ( me )
        class ( collection ), target :: me
            call me % MoMdataFile % myKit % allocate_rank_two_reals (  rank_2_real_array = me % MoMdataFile % rcs_table_rank_2,    &
                                                                          dim1_index_min = 1, dim1_index_max = me % numFreeAngles, &
                                                                          dim2_index_min = 1, dim2_index_max = me % numFrequencies )
            call me %               myKit % allocate_rank_three_reals( rank_3_real_array = me % rcs_table_rank_3,                  &
                                                                          dim1_index_min = 1, dim1_index_max = me % numFreeAngles, &
                                                                          dim2_index_min = 1, dim2_index_max = me % numFrequencies,&
                                                                          dim3_index_min = 1, dim3_index_max = me % numFixedAngles )
        return
    end subroutine allocate_rcs_tables_sub

    subroutine allocate_table_of_rcs_averages_sub ( me )
        class ( collection ), target :: me
            call me % MoMdataFile % myKit % allocate_rank_two_reals (  rank_2_real_array = me % MoMdataFile % rcs_table_rank_2,    &
                                                                          dim1_index_min = 1, dim1_index_max = me % numFreeAngles, &
                                                                          dim2_index_min = 1, dim2_index_max = me % numFrequencies )
            call me %               myKit % allocate_rank_three_reals( rank_3_real_array = me % rcs_table_rank_3,                  &
                                                                          dim1_index_min = 1, dim1_index_max = me % numFreeAngles, &
                                                                          dim2_index_min = 1, dim2_index_max = me % numFrequencies,&
                                                                          dim3_index_min = 1, dim3_index_max = me % numFixedAngles )
        return
    end subroutine allocate_table_of_rcs_averages_sub

    subroutine establish_frequency_mesh_sub ( me, fileName )
        class ( collection ),           target :: me
        character ( len = fnl ), intent ( in ) :: fileName
            !write ( * , fmt = '( 2g0 )' ) "hello from establish_frequency_mesh_sub"
            ! count lines in MoM file (e.q. 14844)
            call count_lines_sub ( fullFileName = fileName, numLines = me % numLines4112Text )
            ! allocate object to hold text of MoM file as a collection of text lines
            call me % myKit % allocate_rank_one_characters ( character_array = me % MoMdataFile % lines4112Text, &
                                                             index_min = 1, index_max = me % numLines4112Text )
            ! load MoM text into memory to count frequencies and angles
            call read_text_lines_sub ( fileName = fileName, linesText = me % MoMdataFile % Lines4112Text )
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
        class ( collection ), target :: me
        real ( ip ),     allocatable :: one ( : )
        ! pointers
        !character ( len =  mll ),   pointer :: p => null ( )
        type ( meshReal ),          pointer :: q => null ( )
        type ( allocationToolKit ), pointer :: s => null ( )
        ! temp arrays
        real    ( ip ) :: tempFrequencyValues   ( 1 : 500 )
        integer ( ip ) :: tempLineNumsFrequency ( 1 : 500 )
        ! scalars
        real    ( rp ) :: maxFrequency = - huge( 1.0_rp ), minFrequency = huge( 1.0_rp )
        real    ( rp ) :: meanOfSquares = 0.0_rp
        integer ( ip ) :: numfrequencies = 0, kFrequency = 0

            ! find lines containing " Freq ="
            call mark_frequencies_sub ( lines4112Text = me % MoMdataFile % lines4112Text,    &
                                     numLines4112Text = me % numLines4112Text,               &
                                  tempFrequencyValues = tempFrequencyValues,                 &
                                tempLineNumsFrequency = tempLineNumsFrequency,               &
                                       numfrequencies = numfrequencies )

            ! record what we have learned about the mesh
            q => me % meshFrequency
                q % numMeshElements = numfrequencies
                ! allocate data objects
                s => me % myKit
                    call s % allocate_rank_one_reals    (    real_array = one,                       index_min = 1, &
                                                              index_max = q  % numMeshElements )
                    call s % allocate_rank_one_reals    (    real_array = q  % meshValues,           index_min = 1, &
                                                              index_max = q  % numMeshElements )
                    call s % allocate_rank_one_integers ( integer_array = me % lineNumbersFrequency, index_min = 1, &
                                                              index_max = q  % numMeshElements )
                    call s % allocate_rank_one_integers ( integer_array = me % lineNumbersFinished,  index_min = 1, &
                                                              index_max = q  % numMeshElements )
                s => null ( )
                ! populate data object
                one ( : ) = 1.0_rp
                ! move temporary array data into data object
                do kFrequency = 1, q % numMeshElements
                     q % meshValues ( kFrequency )           = tempFrequencyValues   ( kFrequency )
                    me % lineNumbersFrequency ( kFrequency ) = tempLineNumsFrequency ( kFrequency )
                end do
                ! mesh properties
                q % value_max = maxFrequency
                q % value_min = minFrequency
                q % meshMean  = dot_product ( one,            q % meshValues ) / dot_product ( one, one )
                meanOfSquares = dot_product ( q % meshValues, q % meshValues ) / dot_product ( one, one )
                q % meshSD    = sqrt ( meanOfSquares - ( q % meshMean ) ** 2 )
                me % numFrequencies = q % numMeshElements
            q => null ( )
        return
    end subroutine harvest_frequencies_sub

    ! sweep through character array looking for "...Finished"
    subroutine harvest_Finished_lines_sub ( me )
        class ( collection ), target :: me
        ! pointers
        character ( len =  mll ), pointer :: p => null ( )
        ! scalars
        integer ( ip ) :: kLines = 0, location = 0, numFinished = 0

            numFinished = 0
            sweep_lines: do kLines = 1, me % numLines4112Text
                p => me % MoMdataFile % lines4112Text ( kLines )
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

    subroutine set_free_angle_elevation_sub ( me )
        class ( collection ), target :: me
            me % angleFreeType  = strElevation
            me % angleFixedType = strAzimuth
        return
    end subroutine set_free_angle_elevation_sub

    subroutine set_free_angle_azimuth_sub ( me )
        class ( collection ), target :: me
            me % angleFreeType  = strAzimuth
            me % angleFixedType = strElevation
        return
    end subroutine set_free_angle_azimuth_sub

    subroutine establish_free_angle_mesh_sub ( me, angle_min, angle_max )
        class ( collection ), target :: me
        real ( rp ), intent ( in ) :: angle_min, angle_max

            me % meshFreeAngle % value_min = angle_min
            me % meshFreeAngle % value_max = angle_max
            me % meshFreeAngle % numMeshElements = me % numFreeAngles

            call me % meshFreeAngle % allocate_mesh_real (  )
            call me % meshFreeAngle % compute_real_mesh_length ( )
            call me % meshFreeAngle % compute_real_mesh_interval ( )
            call me % meshFreeAngle % populate_real_mesh ( )
            call me % meshFreeAngle % populate_integer_mesh ( )

        return
    end subroutine establish_free_angle_mesh_sub

    subroutine establish_fixed_angle_mesh_sub ( me, numElements )
        class ( collection ),  target :: me
        integer ( ip ), intent ( in ) :: numElements
            me % meshFixedAngle % numMeshElements = numElements
            call me % meshFixedAngle % allocate_mesh_real (  )
            call me % meshFixedAngle % populate_integer_mesh ( )
        return
    end subroutine establish_fixed_angle_mesh_sub

    subroutine write_local_averages_sub ( me )
        class ( collection ), target :: me
        type ( average ), pointer :: p => null ( )
        integer ( ip ) :: kFrequency = 0
            write ( * , * )
            write ( * , fmt = '(  g0 )' ) "Local RCS averages"
            sweep_frequencies: do kFrequency = 1, me % numFrequencies
                p => me % MoMdataFile % perFrequencyAverage ( kFrequency )
                write ( * , fmt = 100 ) kFrequency, me % meshFrequency % meshValues ( kFrequency ), &
                                        p % mean, p % standardDeviation, p % minValue, p % maxValue
            end do sweep_frequencies
            p => null ( )
        return
        100 format ( I2.2, ". nu = ", f4.1, " MHz: mean = ", f5.2, " +/- ", f5.2, ", min = ", f6.1, ", max = ", f6.1 )
    end subroutine write_local_averages_sub

end module mClassDataCollection
