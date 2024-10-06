! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassMesh

    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mClassAverages,                 only : average, average0
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    type :: meshReal
        ! rank 1
        real    ( rp ), allocatable :: meshValues  ( : ), one ( : )
        integer ( ip ), allocatable :: meshIndices ( : )
        ! rank 0
        type ( average )       :: meshAverage = average0
        real ( rp )            :: meshLength = 0.0_rp, meshInterval = 0.0_rp
        integer ( ip )         :: numMeshElements = 0
        character ( len = 18 ) :: valuesFormatDescriptor = ""
        ! allocation tools
        type ( allocationToolKit ) :: myKit = allocationToolKit0
    contains
        procedure, public :: allocate_mesh_real            => allocate_mesh_real_sub, &
                             analyze_mesh_values           => analyze_mesh_values_sub, &
                             compute_real_mesh_interval    => compute_real_mesh_interval_sub, &
                             compute_real_mesh_length      => compute_real_mesh_length_sub, &
                             create_valuesFormatDescriptor => create_valuesFormatDescriptor_sub, &
                             populate_integer_mesh         => populate_integer_mesh_sub, &
                             print_real_mesh_summary       => print_real_mesh_summary_sub, &
                             print_real_mesh_values        => print_real_mesh_values_sub
    end type meshReal

    private :: allocate_mesh_real_sub, analyze_mesh_values_sub, &
               compute_real_mesh_interval_sub, compute_real_mesh_length_sub, create_valuesFormatDescriptor_sub, &
               populate_integer_mesh_sub, print_real_mesh_summary_sub, print_real_mesh_values_sub

contains

    subroutine analyze_mesh_values_sub ( me )
        class ( meshReal ), target :: me
        type ( allocationToolKit ), pointer :: p => null ( )
        real ( rp ), allocatable :: one ( : )

            ! clone a vector
            p => me % myKit
                allocate ( one, source = me % meshValues, stat = p % alloc_status, errmsg = p % alloc_message )
                if ( p % alloc_status /= 0 ) then
                    call p % post_error_message_intrinsic ( action = 'allocating' )
                end if
                one ( : ) = one ( : ) - one ( : ) + 1.0_rp
            p => null ( )
            call me % meshAverage % compute_mean_and_variance ( vector = me % meshValues, one = one )
            call me % meshAverage % find_max_and_min          ( vector = me % meshValues )
            call me % compute_real_mesh_length ( )
            call me % compute_real_mesh_interval ( )

        return
    end subroutine analyze_mesh_values_sub

    subroutine create_valuesFormatDescriptor_sub ( me )
        class ( meshReal ), target :: me
            write ( me % valuesFormatDescriptor, fmt = 100 ) me % numMeshElements
        return
        100 format ( "( ", g0, "( g0, 2X) )" )
    end subroutine create_valuesFormatDescriptor_sub

    subroutine populate_integer_mesh_sub ( me )
        class ( meshReal ), target :: me
        integer ( ip ) :: kElement = 0
            do kElement = 1, me % numMeshElements
                me % meshIndices ( : ) = kElement
            end do
        return
    end subroutine populate_integer_mesh_sub

    subroutine compute_real_mesh_length_sub ( me )
        class ( meshReal ), target :: me
            me % meshLength = me % meshAverage % extrema % maxValue - me % meshAverage % extrema % minValue
        return
    end subroutine compute_real_mesh_length_sub

    subroutine compute_real_mesh_interval_sub ( me )
        class ( meshReal ), target :: me
            me % meshInterval = me % meshLength / real ( me % numMeshElements - 1, kind = rp )
        return
    end subroutine compute_real_mesh_interval_sub

    subroutine print_real_mesh_summary_sub ( me, dataType )
        class ( meshReal ),           target :: me
        character ( len = 9 ), intent ( in ) :: dataType
            write ( * , * )
            write ( * , fmt = '(  3g0 )' ) "* Properties of ", dataType, " mesh:"
            write ( * , fmt = 100 ) me % meshAverage % extrema % minValue, me % meshAverage % extrema % maxValue, me % meshLength
            write ( * , fmt = 110 ) me % numMeshElements, me % meshInterval
        return
        100 format ( "* minimum value = ", g0, ", maximum value = ", g0, ", length = ", g0 )
        110 format ( "* number of samples = ", g0, ", interval size = ", g0 )
    end subroutine print_real_mesh_summary_sub

    subroutine print_real_mesh_values_sub ( me )
        class ( meshReal ), target :: me
        integer :: kMesh = 0
            do kMesh = 1, me % numMeshElements
                write ( * , fmt = 100 ) kMesh, me % meshValues ( kMesh )
            end do
        return
        100 format ( g0, ". value = ", g0 )
    end subroutine print_real_mesh_values_sub

    subroutine allocate_mesh_real_sub ( me )
        class ( meshReal ), target :: me
            call me % myKit % allocate_rank_one_reals    ( real_array    = me % meshValues,  index_min = 1, &
                                                                                             index_max = me % numMeshElements )
            call me % myKit % allocate_rank_one_reals    ( real_array    = me % one,         index_min = 1, &
                                                                                             index_max = me % numMeshElements )
            call me % myKit % allocate_rank_one_integers ( integer_array = me % meshIndices, index_min = 1, &
                                                                                             index_max = me % numMeshElements )
            me % one ( : ) = 1.0_rp
        return
    end subroutine allocate_mesh_real_sub

end module mClassMesh
