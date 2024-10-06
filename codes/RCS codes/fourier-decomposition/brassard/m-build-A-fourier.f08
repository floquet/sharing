! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mBuildAFourier

    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mFormatDescriptors,             only : fmt_one, fmt_three, fmt_five
    use mMatrixWriter,                  only : print_matrix, open_file_print_matrix
    use mPrecisionDefinitions,          only : ip, rp, kindA

    implicit none

    type :: linearSystem
        ! rank 2: system matrix - encodes mesh
        real ( kind = rp ), allocatable :: A ( : , : )
        real ( kind = rp ), allocatable :: b ( : )
        ! scalar
        integer ( kind = ip ) :: rows = 0, cols = 0
        character ( kind = kindA, len =  64 ) :: descriptorA = "", descriptorB = ""
        ! types
        type ( allocationToolKit ) :: myKit = allocationToolKit0
    contains
        procedure, public :: build_A_Fourier => build_A_Fourier_sub
    end type linearSystem

    private :: build_A_Fourier_sub

contains

    subroutine build_A_Fourier_sub ( me, mesh, degree_of_fit )
        class ( linearSystem ), target :: me

        ! tourists
        real ( kind = rp ),    intent ( in ) :: mesh ( : )
        integer ( kind = ip ), intent ( in ) :: degree_of_fit
        ! locals
        integer ( kind = ip ) :: kFrequency = 0

            me % descriptorA = "Fourier"
            me % cols = degree_of_fit + 1
            me % rows = size ( mesh )
            write ( * , * ) "build_A_Fourier_sub rows = ", me % rows, ", cols = ", me % cols
            call me % myKit % allocate_rank_two_reals ( real_array = me % A, numRows = me % rows, numColumns = me % cols )
            ! populate A
            me % A ( : , 1 ) = 1.0_rp
            ! A =
            ! | 1 cos(a1) cos(2a1) ... cos(da1) |
            ! | .    .       .             .    |
            ! | .    .       .             .    |
            ! | 1 cos(am) cos(2am) ... cos(dam) |
            sweep_degree_of_fit: do kFrequency = 1, degree_of_fit
                me % A ( : , kFrequency + 1 ) = cos ( real ( kFrequency, rp ) * mesh )
            end do sweep_degree_of_fit
            write ( * , fmt_three ) "shape( A ) = ", shape ( me % A )
            call open_file_print_matrix ( A = me % A, myFormat = "F11 .5", spaces = 1, moniker = "A matrix", dims = [ 361, 8 ], &
                                myFile = "A.txt" )

    end subroutine build_A_Fourier_sub

end module mBuildAFourier
