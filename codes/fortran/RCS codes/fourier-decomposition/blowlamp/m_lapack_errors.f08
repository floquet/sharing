! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mLapackErrors

    use mFormatDescriptors,             only : fmt_one, fmt_three, fmt_five
    use mPrecisionDefinitions,          only : ip

    implicit none

contains

    ! http://www.netlib.org/lapack/explore-html/dd/d9a/group__double_g_ecomputational_ga56d9c860ce4ce42ded7f914fdb0683ff.html#ga56d9c860ce4ce42ded7f914fdb0683ff
    subroutine lapackErrorsDGETRI ( info )
        integer ( ip ), intent ( in ) :: info

            write ( * , fmt_one ) "Error in LAPACK routine DGETRI"
            write ( * , fmt_one ) "DGETRI computes the inverse of a matrix using the LU factorization computed by DGETRF"
            write ( * , fmt_one ) "inverts U and then computes inv(A) by solving the system inv(A)*L = inv(U) for inv(A)"
            write ( * , * )

            if ( info < 0 ) then
                call illegalArgument ( info )
                return
            end if

            call zeroPivot ( info )

        return
    end subroutine lapackErrorsDGETRI

    ! http://www.netlib.org/lapack/explore-html/dd/d9a/group__double_g_ecomputational_ga0019443faea08275ca60a734d0593e60.html#ga0019443faea08275ca60a734d0593e60
    subroutine lapackErrorsDGETRF ( info )
        integer ( ip ), intent ( in ) :: info

            write ( * , fmt_one ) "Error in LAPACK routine DGETRF"
            write ( * , fmt_one ) "DGETRF computes an LU factorization of a general M-by-N matrix A"
            write ( * , fmt_one ) "using partial pivoting with row interchanges."
            write ( * , * )

            if ( info < 0 ) then
                call illegalArgument ( info )
                return
            end if

            call zeroPivot ( info )

        return
    end subroutine lapackErrorsDGETRF

    subroutine zeroPivot ( info )
        integer ( ip ), intent ( in ) :: info
        write ( * , fmt_five ) "pivot element U(", info, ",", info, ") = 0"
        write ( * , fmt_one  ) "The factorization has been completed, but the factor U is exactly singular,"
        write ( * , fmt_one  ) "and division by zero will occur if it is used to solve a system of equations."
    end subroutine zeroPivot

    subroutine illegalArgument ( info )
        integer ( ip ), intent ( in ) :: info
            write ( * , fmt_three ) "argument in position ", abs ( info ), " has an illegal value"
    end subroutine illegalArgument


end module mLapackErrors
