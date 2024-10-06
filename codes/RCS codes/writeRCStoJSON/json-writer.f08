! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program json_writer

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version

    use mAssetProperties,               only : asset
    use mFormatDescriptors,             only : fmt_cpu_time, fmt_datecom
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    type ( asset ) :: testAsset

    real ( rp ) :: start = 0.0_rp, finish = 0.0_rp
    integer ( ip ) :: stride = 5 ! average five azimuth values

    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip

        call cpu_time ( start )
        ! #  #  #  begin execution  #  #  #

            ! define asset properties and point to data source
            testAsset % jsonFileName = "./data/b-1bbomber.json"
            testAsset % Label        = "B-1B bomber"
            testAsset % ICONImage    = "B-1B.png"
            testAsset % description  = "Aircraft"
            testAsset % nominalSpeed = 400
            testAsset % CIT          = 2
            testAsset % stride       = stride
            testAsset % rcsPrefix = "data/PTW-"
            testAsset % rcsSuffix = ".4112.rcs.r32"
            call testAsset % printAssetProperties ( )

            ! write JSON file
            call testAsset % writeJSON   ( rcsCases  = [ 0, 90 ] )
            call testAsset % writeBinary ( rcsCases  = [ 0, 90 ] )

            ! call profile % readBinaryFile ( binaryDataFileName = "data/PTW-000.4112.rcs.r32" )
            ! write ( * , fmt = '( 2g0 )' ) "profile % values ( 1 , 1 ) = ", profile % values ( 1 , 1 )
            ! write ( * , fmt = '( 2g0 )' ) "profile % values ( 1 , 2 ) = ", profile % values ( 1 , 2 )
            ! write ( * , fmt = '( 2g0 )' ) "profile % values ( 2 , 1 ) = ", profile % values ( 2 , 1 )
            ! write ( * , fmt = '( 2g0 )' ) "profile % values ( 2 , 2 ) = ", profile % values ( 2 , 2 )


        ! #  #  #  execution complete  #  #  #
        call cpu_time ( finish )
        ! execution complete - tag output
        write ( * , fmt = fmt_cpu_time ) finish - start
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt = fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , fmt = 100 ) compiler_version ( )
        write ( * , fmt = 110 ) compiler_options ( )

    stop 'Successful run for "json_writer.f08."'

    100 format (    "compiler version: ", g0, "."    )
    110 format ( /, "compiler options: ", g0, ".", / )

end program json_writer
