! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
program shaeffer

    use, intrinsic :: iso_fortran_env,  only : compiler_options, compiler_version

    use mFormatDescriptors,             only : fmt_cpu_time, fmt_datecom
    use mLibraryOfConstants,            only : cZero, rZero
    use PECsphereRCS,                   only : sphere
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    complex ( rp ) :: escat = cZero

    real ( rp ) :: fka = rZero, rcs = rZero
    real ( rp ) :: start = 0.0_rp, finish = 0.0_rp

    integer ( ip ) :: kLoop = 0, kMax = 0
    ! containers for date and time
    integer ( ip ) :: dt_values ( 1 : 8 ) = 0_ip

        call cpu_time ( start )

            kMax = 50
            do kLoop = 1, kMax
                fka = real ( kLoop, rp ) / 2.0_rp
                call sphere ( escat = escat, fka = fka )
                rcs = 20.0_rp * log ( abs ( escat ) )
                write ( * , 100 ) kLoop, fka, escat, abs ( escat )
            end do

        call cpu_time ( finish )
        ! execution complete - tag output
        write ( * , fmt = fmt_cpu_time ) finish - start
        call date_and_time ( VALUES = dt_values )
            write ( * , fmt = fmt_datecom ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

        write ( * , '(    "compiler version: ", g0, "."    )' ) compiler_version ( )
        write ( * , '( /, "compiler options: ", g0, ".", / )' ) compiler_options ( )

    stop 'Successful run for "shaeffer.f08."'
    100 format ( g0, ". fka = ", g0, ", escat = ", g0, ", ", g0, ", mag = ", g0 )

end program shaeffer
