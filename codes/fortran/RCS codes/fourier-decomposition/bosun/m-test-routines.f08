! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mTestRoutines

    use mAllocations,                   only : rank_one_reals_sub
    use mBuildAFourier,                 only : systemMatrix
    use mFormatDescriptors,             only : fmt_datecom, fmt_two, fmt_ten, fmt_tenD
    use mMatrixWriter,                  only : print_matrix
    use mRCSProfile,                    only : meanRCS
    use mParametersSimulation,          only : deg
    use mPrecisionDefinitions,          only : ip, rp
    use mSolutionNormal,                only : solutionNormal

    implicit none

contains

    subroutine sciacca_fourier ( )
        ! classes
        type ( meanRCS )        :: sigma
        type ( systemMatrix )   :: myA
        type ( solutionNormal ) :: mySoln
        ! rank 1
        real ( rp ), allocatable :: nu_mesh  ( : )
        real ( rp ), allocatable :: yaw_mesh ( : )
        ! rank 0 parameters
        integer ( ip ), parameter :: rowSciacca = 28, colSciacca = 361, degree_of_fit = 7, nu = 3
        integer ( ip ) :: k = 0

            myA % rows = rowSciacca
            myA % cols = colSciacca

            ! allocations
            call rank_one_reals_sub ( real_array = nu_mesh,  numRows = rowSciacca )
            call rank_one_reals_sub ( real_array = yaw_mesh, numRows = colSciacca )

            nu_mesh  ( : ) = [ ( real ( k, rp ),       k = 3,  30 ) ]
            yaw_mesh ( : ) = [ ( real ( k - 181, rp ) * deg, k = 1, 361 ) ]
            write ( * , fmt_tenD ) "yaw_mesh"
            write ( * , fmt_ten  ) ( yaw_mesh ( k ), k = 1, 10 )

            call myA % build_A_Fourier ( mesh = yaw_mesh, degree_of_fit = degree_of_fit )
            call sigma % read_profile ( file_name = "../data/rcs-values-sciacca.dat", quarry = "Sciacca Airframe", &
                                             numRows = rowSciacca, numColumns = colSciacca )
            call rank_one_reals_sub ( real_array = myA % b, numRows = colSciacca )
            myA % b = [ ( sigma % profile ( nu, k ), k = 1, colSciacca ) ]
            write ( * , fmt_tenD ) "data vector"
            write ( * , fmt_ten  ) ( myA % b ( k ), k = 1, 10 )
            call mySoln % normal_equations_create ( myA )
            call print_matrix ( A = mySoln % W, myFormat = "F8.2", spaces = 1, moniker = "W matrix", dims = [ 8, 8 ], &
                                my_io_unit = 6 )
            call mySoln % normal_equations_solve ( myA )
            call print_matrix ( A = mySoln % Winv, myFormat = "F8.2", spaces = 1, moniker = "Winv matrix", dims = [ 8, 8 ], &
                                my_io_unit = 6 )
        return
    end subroutine sciacca_fourier

end module mTestRoutines
