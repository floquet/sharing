! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mBuildAFourier

    use mAllocations,                   only : rank_two_reals_sub
    use mFormatDescriptors,             only : fmt_one, fmt_three, fmt_five
    use mMatrixWriter,                  only : print_matrix, open_file_print_matrix
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    type :: systemMatrix
        ! rank 2: system matrix - encodes mesh
        real ( rp ), allocatable :: A ( : , : )
        real ( rp ), allocatable :: b ( : )
        ! scalar
        integer ( ip ) :: rows = 0, cols = 0
        character ( len =  64 ) :: descriptorA = "", descriptorB = ""
    contains
        procedure, public :: build_A_Fourier => build_A_Fourier_sub
    end type systemMatrix

    private :: build_A_Fourier_sub

contains

    subroutine build_A_Fourier_sub ( me, mesh, degree_of_fit )

        class ( systemMatrix ), target :: me
        ! tourists
        real ( rp ),    intent ( in ) :: mesh ( : )
        integer ( ip ), intent ( in ) :: degree_of_fit
        ! locals
        integer ( ip ) :: rows = 0
        integer ( ip ) :: cols = 0
        integer ( ip ) :: k = 0

            me % descriptorA = "Fourier"
            me % cols = degree_of_fit + 1
            me % rows = size ( mesh )
            write ( * , * ) "build_A_Fourier_sub rows = ", me % rows, ", cols = ", me % cols
            call rank_two_reals_sub ( real_array = me % A, numRows = me % rows, numColumns = me % cols )
            ! populate A
            me % A ( : , 1 ) = 1.0_rp
            ! A =
            ! | 1 cos(a1) cos(2a1) ... cos(da1) |
            ! | .    .       .             .    |
            ! | .    .       .             .    |
            ! | 1 cos(am) cos(2am) ... cos(dam) |
            do k = 1, degree_of_fit
                me % A ( : , k + 1 ) = cos ( real ( k, rp ) * mesh )
            end do
            write ( * , fmt_three ) "shape( A ) = ", shape ( me % A )
            call open_file_print_matrix ( A = me % A, myFormat = "F11 .5", spaces = 1, moniker = "A matrix", dims = [ 361, 8 ], &
                                myFile = "A.txt" )

    end subroutine build_A_Fourier_sub

end module mBuildAFourier
