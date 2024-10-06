! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mScenarios

    ! classes
    use mClassDataCollection,           only : collection
    ! objects
    use mListOfMoMfiles,                only : sourceFileNames
    ! values
    use mLibraryOfConstants,            only : fileNameLength
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength

contains

    subroutine scenario_A ( filePathRCSoutput, filePathListOfNames, fileNameListOfNames )
        character ( len = * ), intent ( in ) :: filePathRCSoutput, filePathListOfNames, fileNameListOfNames
        type ( collection ),      target  :: SweepElevationCollection
        type ( collection ),      pointer :: p => null ( )
        type ( sourceFileNames ), target  :: elevationFileList
        character ( len = fnl )           :: fileName = ""

            p => SweepElevationCollection
                p % quarry          = "PTW"
                p % descriptor      = "Sciacca airframe"
                p % directoryRCSdat = trim ( filePathRCSoutput )
                p % directory4112   = trim ( filePathListOfNames )
                p % listOfDataFiles = trim ( fileNameListOfNames )
                ! file with list of elevation *.4112.txt files
                fileName = trim ( p % directory4112 ) // trim ( p % listOfDataFiles )
                ! count data sets
                call elevationFileList % read_file_list ( fileName )
                p % numFixedAngles = elevationFileList % numFileNames
                call p % establish_fixed_angle_mesh ( numElements = p % numFixedAngles )
                ! scenario A describes data where MoM scans azimuth angle
                call p % set_free_angle_azimuth ( )
                fileName = trim ( p % directory4112 ) // trim ( elevationFileList % listFileNames ( 1 ) )
                ! set up frequency mesh by reading frequency values
                call p % establish_frequency_mesh ( fileName )
                ! set up angle mesh by counting measurements and then setting a data range
                call p % establish_free_angle_mesh ( angle_min = -180.0_rp, angle_max = 179.0_rp )
                call p % meshFreeAngle % create_valuesFormatDescriptor ( )
                ! check angle mesh
                call p % meshFreeAngle % print_real_mesh_summary ( angleType = p % angleFreeType )
                ! allocate RCS container for single MoM file, and the aggregate container
                call p % allocate_rcs_tables ( )
                call p % allocate_rcsAverages ( )
                !call p % allocate_average_value_arrays ( )
                ! print dimensions of RCS tables
                call p % check_rcs_table_structure ( )
                ! action!
                call p % sweep_data_set ( listofMoMfiles = elevationFileList % listFileNames )
                ! scorecards
                !call p % write_local_averages ( )
            p => null ( )

        return
    end subroutine scenario_A

end module mScenarios
