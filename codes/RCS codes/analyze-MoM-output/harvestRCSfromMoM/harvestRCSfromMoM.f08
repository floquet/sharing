! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! Daniel Topa
! ERT Corp.
program harvestRCSfromMoM_00
! harvest the electric field values from the ASCII file *.4112.txt mixed text and numeric lines
! compute the mean total RCS and write these values

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version
    use mClassDataFile,                 only : dataFile4112
    use mFormatDescriptors,             only : fmt_datecom
    use mGetCommandLineArguments,       only : get_single_command_line_argument
    use mLibraryOfConstants,            only : fileNameLength
    use mPrecisionDefinitions,          only : ip
    use mProcessControl,                only : main_process_sub

    implicit none

    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip
    type ( dataFile4112 ) :: MoMdata
    character ( len = fileNameLength ) :: fileName = ""

        ! harvest name from command line: one and only argument
        call get_single_command_line_argument ( index = 1, theArgument = fileName )
        call main_process_sub ( MoMdata = MoMdata, file4112Name = fileName )

        ! execution complete - tag output
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '( "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( "compiler options: ", g0, ".", / )' ) compiler_options ( )

        stop 'Successful run for "harvestRCSfromMoM_00.f08."'

end program harvestRCSfromMoM_00
