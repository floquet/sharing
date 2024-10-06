! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module PECsphereRCS

    use mLibraryOfConstants,            only : machineEpsilon, cZero, cReOne, cImOne
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

contains

    subroutine sphere ( escat, fka )
        complex ( rp ), intent ( out ) :: escat
        real ( rp ),    intent ( in )  :: fka

        complex ( rp ) :: total = cZero, delta = cZero, f1  = cZero, f2 = cZero
        integer ( ip ) :: l = 0, m = 0, n = 0

            ! initialize running sum, first term, and recursive indices
            total = cZero
            f1    = cImOne
            f2    = cReOne

            m =  1
            n =  0
            l = -1

            do
                l = -l
                n = n + 1
                m = m + 2
                !delta = complex ( 2 * n - 1, rp ) * f2 / complex ( fka, rp ) - f1
                delta = complex ( 2 * n - 1, rp ) * f2
                delta = delta / complex ( fka, rp )
                delta = delta - f1
                f1 = f2
                f2 = delta
                ! build denominator
                !delta = complex ( fka, rp ) * f1 - complex ( n, rp ) * f2
                delta = complex ( fka, rp ) * f1
                delta = delta - complex ( n, rp ) * f2
                delta = f2 * delta
                delta = complex ( l * m, rp ) / delta
                total = total + delta
                if ( abs ( delta ) < 100 * machineEpsilon  ) then
                    exit
                end if
            end do

            escat = total

        return
    end subroutine sphere

end module PECsphereRCS
