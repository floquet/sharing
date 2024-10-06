! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mTestRoutines

    use, intrinsic :: iso_fortran_env,  only : stdout => output_unit
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mBuildAFourier,                 only : linearSystem
    use mFormatDescriptors,             only : fmt_ten, fmt_tenD
    use mLibraryConstants,              only : deg
    use mMatrixReader,                  only : read_matrix_file
    use mMatrixWriter,                  only : print_matrix
    use mPrecisionDefinitions,          only : ip, rp, kindA
    !use mRCSProfile,                    only : meanRCS
    use mSolutionSVD,                   only : solutionSVD

    implicit none

contains

    subroutine test_svd_sub ( )
        integer ( kind = ip ) :: m = 0, n = 0
        character ( kind = kindA, len = 128 ) :: header = ""
        type ( allocationToolKit ) :: myKit = allocationToolKit0
        type ( linearSystem ) :: myLinearSystem
        type ( solutionSVD )  :: mySolution
            call myKit % allocate_rank_two_reals ( real_array = myLinearSystem % A, numRows = 3, numColumns = 2 )
            call read_matrix_file ( "../data/sample_matrix.txt", A = myLinearSystem % A, rows = m, cols = n, header = header )
            call print_matrix ( A = myLinearSystem % A, myFormat = 'E20.13', spaces = 3, dims = [ m, n ], my_io_unit = stdout )
            myLinearSystem % rows = 3
            myLinearSystem % cols = 2
            call mySolution % svd_pseudoinverse_solve ( myLinearSystem = myLinearSystem )
        return
    end subroutine test_svd_sub

    ! subroutine sciacca_fourier ( )
    !     ! classes
    !     type ( meanRCS )      :: sigma
    !     type ( linearSystem ) :: myA
    !     type ( solutionSVD )  :: mySoln
    !     ! allocation tools
    !     type ( allocationToolKit ) :: myKit = allocationToolKit0
    !     ! rank 1
    !     real ( kind = rp ), allocatable :: nu_mesh  ( : )
    !     real ( kind = rp ), allocatable :: yaw_mesh ( : )
    !     ! rank 0 parameters
    !     integer ( kind = ip ), parameter :: rowSciacca = 28, colSciacca = 361, degree_of_fit = 7, nu = 3
    !     integer ( kind = ip ) :: k = 0
    !
    !         myA % rows = rowSciacca
    !         myA % cols = colSciacca
    !
    !         ! allocations
    !         call myKit % rank_two_reals_sub ( real_array = nu_mesh,  numRows = rowSciacca )
    !         call rank_one_reals_sub ( real_array = yaw_mesh, numRows = colSciacca )
    !
    !         nu_mesh  ( : ) = [ ( real ( k, rp ),             k = 3,  30 ) ]
    !         yaw_mesh ( : ) = [ ( real ( k - 181, rp ) * deg, k = 1, 361 ) ]
    !         write ( * , fmt_tenD ) "yaw_mesh"
    !         write ( * , fmt_ten  ) ( yaw_mesh ( k ), k = 1, 10 )
    !
    !         call myA % build_A_Fourier ( mesh = yaw_mesh, degree_of_fit = degree_of_fit )
    !         call sigma % read_profile ( file_name = "../data/rcs-values-sciacca.dat", quarry = "Sciacca Airframe", &
    !                                          numRows = rowSciacca, numColumns = colSciacca )
    !         call rank_one_reals_sub ( real_array = myA % b, numRows = colSciacca )
    !         myA % b = [ ( sigma % profile ( nu, k ), k = 1, colSciacca ) ]
    !         write ( * , fmt_tenD ) "data vector"
    !         write ( * , fmt_ten  ) ( myA % b ( k ), k = 1, 10 )
    !         call mySoln % normal_equations_create ( myA )
    !         call print_matrix ( A = mySoln % W, myFormat = "F8.2", spaces = 1, moniker = "W matrix", dims = [ 8, 8 ], &
    !                             my_io_unit = 6 )
    !         call mySoln % normal_equations_solve ( myA )
    !         call print_matrix ( A = mySoln % Winv, myFormat = "F8.2", spaces = 1, moniker = "Winv matrix", dims = [ 8, 8 ], &
    !                             my_io_unit = 6 )
    !     return
    ! end subroutine sciacca_fourier

end module mTestRoutines
