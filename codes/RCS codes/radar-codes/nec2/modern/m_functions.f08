! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mFunctions

    use mPrecisionDefinitions, only : ip, rp
    use mParameters,           only : i, cmotp, cone, ctwo, czero, rrtwo, radToDeg, sp, tosp

    implicit none

contains

    function impedanceWire ( sigl, rolam ) result ( impedance )
        ! internal impedance of a circular wire
        complex ( rp ), intent ( in ) :: sigl, rolam
        complex ( rp )                :: impedance

        complex ( rp ) :: br1 = i, fj = i!, br2 = i, theta = i, phi = i, f = i, g = i, cn = i

            br1 = cmplx ( rrtwo, -rrtwo, rp)

            impedance = fj * br1 / rolam * sqrt( cmplx ( cmotp, 0.0_rp, rp ) / sigl )

        return
    end function impedanceWire

    function phaseAngle ( z ) result ( angle )
        ! theta in z = r exp ( i theta )
        complex ( rp ), intent ( in ) :: z
        real    ( rp )                :: angle

            angle = atan ( z % im, z % re )

        return
    end function phaseAngle

    function phaseAngleD ( z ) result ( angle )
        ! phase angle in degrees
        complex ( rp ), intent ( in ) :: z
        real    ( rp )                :: angle

            angle = phaseAngle ( z ) * radToDeg

        return
    end function phaseAngleD

    function db10 ( x ) result ( db )
        ! db10 ( 10 ) = 10
        real ( rp ), intent ( in ) :: x
        real ( rp )                :: db

            ! real argument in, real argument out
            if ( x < 0.0_rp ) then
                db = -huge ( 1.0_rp )
                return
            end if

            ! cutoff
            if ( x < tiny ( 1.0_rp ) ) then
                db = log10 ( tiny ( 1.0_rp ) )
                return
            end if

            db = 10.0_rp * log10 ( x )

        return
    end function db10

    function sommerfield ( p ) result ( fbar )
        ! sommerfield attenuation function for numerical distance p
        complex ( rp ), intent ( in ) :: p
        complex ( rp )                :: fbar

        ! internal variables
        complex ( rp ) :: z = czero, factor = czero

            z = i * sqrt ( p )
            if ( abs ( z ) <=  3.0_rp ) then
                fbar = sommerfieldSmallZ ( p )
                return
            endif

            if ( z % re <= 0.0_rp ) then
                ! series expansion
                factor = cone
            else
                ! asympotic expansion
                factor = cmplx ( 2.0_rp, kind = rp ) * sp * z * exp ( z * z )
            endif
            fbar = sommerfieldLargeZ ( p, factor )

        return
    end function sommerfield

    function sommerfieldSmallZ ( p ) result ( fbar )
        ! series expansion
        complex ( rp ), intent ( in ) :: p
        complex ( rp )                :: fbar

        ! internal variables
        real ( rp ), parameter :: accs = 1.0E-12_rp

        complex ( rp ) :: z = czero, pow = czero, sum = czero, term = czero, sms = czero, tms = czero
        integer ( ip ) :: k

            z = i * sqrt ( p )
            sum = z
            pow = z

            do k = 1, 100
                !kz = cmplx ( real ( k, rp ), rp )
                pow  = -pow * z * z / cmplx ( k, kind = rp )
                term =  pow / cmplx ( 2 * ( k ) + 1, kind = rp )
                sum = sum + term
                tms = conjg ( term ) * term
                sms = conjg ( sum  ) * sum
                ! convergence criteria
                if ( tms % re / sms % im < accs ) then
                    exit
                end if
            end do
            fbar = cone - sum * tosp
            fbar = cone - fbar * z * exp ( z ) * sp

        return
    end function sommerfieldSmallZ

    function sommerfieldLargeZ ( p, factor ) result ( fbar )
        ! asymptotic expansion
        complex ( rp ), intent ( in ) :: p, factor
        complex ( rp )                :: fbar

        ! internal variables
        complex ( rp ) :: z = czero, sum = czero, term = czero
        integer ( ip ) :: k

            z = i * sqrt ( p )

            sum  = czero
            term = cone
            do k = 1, 6
                term = -term * cmplx ( ( 2 * k - 1 ) / 2, kind = rp ) * z * z
                sum  = sum + term
            end do
            fbar = factor - sum

        return
    end function sommerfieldLargeZ

    function isegno ( itagi, mx ) result ( segno )
    ! return segment number of mth segment having tag number itagi
    ! when itagi = 0, segment number m is returned

        use mDataBlocks,        only : b_data
        use mFormatDescriptors, only : fmt_alpha, fmt_bravo

        integer ( ip ), intent ( in ) :: itagi, mx
        integer ( ip )                :: segno

        integer ( ip ) :: icnt = 0_ip, k = 0_ip

            if ( mx <= 0 ) then
                write ( 2, fmt_alpha )
                stop "Terminating in module m_functions.f08"
            end if

            icnt = 0_ip
            if ( itagi == 0 ) then
                segno = mx
            end if

            if ( b_data % n >= 1 ) then
                do k = 1, b_data % n
                    if ( b_data % itag ( k ) /= itagi ) cycle
                    icnt = icnt + 1
                    if ( icnt == mx ) then
                        segno = k
                        return
                    end if
                enddo
            end if

            write ( 2, fmt_bravo )
            stop "Terminating in module m_functions.f08"

    end function isegno

end module mFunctions

! 1115    FUNCTION ATGN2( X, Y)                ARCTANGENT FUNCTION MODIFIED TO RETURN 0. WHEN X=Y=0.
! 1250    FUNCTION CANG( Z)                    RETURNS THE PHASE ANGLE OF A COMPLEX NUMBER IN DEGREES.
! 2867    FUNCTION DB10( X)                    RETURNS DB FOR MAGNITUDE (FIELD) OR MAG**2 (POWER) I
! 3822    FUNCTION FBAR( P)                    SOMMERFELD ATTENUATION FUNCTION FOR NUMERICAL DISTANCE P
! 5597    FUNCTION ISEGNO( ITAGI, MX)          RETURNS THE SEGMENT NUMBER OF THE MTH SEGMENT HAVING THE TAG NUMBER ITAGI
! 9030    COMPLEX FUNCTION ZINT( SIGL, ROLAM)  COMPUTES THE INTERNAL IMPEDANCE OF A CIRCULAR WIRE
