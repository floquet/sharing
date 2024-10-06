! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassEdge

    use mClassVertex,                   only : vertex
    use mLibraryOfConstants,            only : dim, messageLength, zero, zero_vector_r
    use mPrecisionDefinitions,          only : ip, rp, kindA

    implicit none

    character ( kind = kindA, len = * ), parameter :: moduleCrash = "Program crashed in module 'mClassEdge', "

    type :: edge
        ! rank 1: triangles
        integer ( kind = ip ) :: indexVertexLo = 0, indexVertexHi = 0, &
                                 indexFaceA    = 0, indexFaceB    = 0
        real    ( kind = rp ) :: length = zero
    contains
        procedure, public :: add_new_edge  => add_new_edge_sub
    end type edge

    private :: add_new_edge_sub, compute_edge_length_sub

    ! edge constructor
    type ( edge ), parameter :: edge0 = edge ( indexVertexLo = 0, indexVertexHi = 0, indexFaceA = 0, indexFaceB = 0, &
                                                length = 0.0_rp )
contains

    subroutine add_new_edge_sub ( me, myVertices, indexFace, indexVertexA, indexVertexB, indexVertexLo, indexVertexHi )
        class ( edge ), target :: me
        type ( vertex ),       intent ( in ) :: myVertices ( : )
        integer ( kind = ip ), intent ( in ) :: indexFace
        integer ( kind = ip ), optional, intent ( in ) :: indexVertexA, indexVertexB
        integer ( kind = ip ), optional, intent ( in ) :: indexVertexLo, indexVertexHi
        character ( kind = kindA, len = messageLength ) :: crashChain = moduleCrash // trim ( "subroutine 'add_new_edge_sub'." )
            ! define edge as line from vertex lo to vertex high
            if ( present ( indexVertexA ) ) then
                ! order indices
                if ( indexVertexA == indexVertexB ) then
                    write ( * , fmt = '( 3g0 )' ) "Trying to define edge: both endpoints have the same index of ", indexVertexA, "."
                    stop crashChain
                end if
                if ( indexVertexA < indexVertexB ) then
                    me % indexVertexLo = indexVertexA
                    me % indexVertexHi = indexVertexB
                else
                    me % indexVertexLo = indexVertexB
                    me % indexVertexHi = indexVertexA
                end if
            else ! indices are already ordered
                me % indexVertexLo = indexVertexLo
                me % indexVertexHi = indexVertexHi
            end if
            call compute_edge_length_sub ( me, myVertices )
        return
    end subroutine add_new_edge_sub

    subroutine compute_edge_length_sub ( me, myVertices )
        class ( edge ),          target :: me
        type ( vertex ), intent ( in )  :: myVertices ( : )
        real ( kind = rp ) :: x ( 1 : dim ) = zero_vector_r, &
                              y ( 1 : dim ) = zero_vector_r
            x = myVertices ( me % indexVertexLo ) % position ( : )
            y = myVertices ( me % indexVertexHi ) % position ( : )
            me % length = norm2 ( x - y )
        return
    end subroutine compute_edge_length_sub

end module mClassEdge

! dantopa:test-evaluate/facet-edge % make                                                                                                                                    (master)ftn
! gfortran -g -c -Og -pedantic -Wall -Warray-temporaries -Wextra -Waliasing -Wsurprising -Wimplicit-procedure -Wintrinsics-std -Wfunction-elimination -Wc-binding-type -Wrealloc-lhs-all -Wuse-without-only -Wconversion-extra -fno-realloc-lhs -ffpe-trap=denormal,invalid,zero -fbacktrace -fmax-errors=5 -fcheck=all -fcheck=do -fcheck=pointer -fno-protect-parens -faggressive-function-elimination -fdiagnostics-color=auto -finit-derived -o m-class-edge.o m-class-edge.f08
! m-class-edge.f08:17:17:
!
!    17 |         procedure, public :: compute_edge_length  => compute_edge_length_fcn
!       |                 1
! Error: Non-polymorphic passed-object dummy argument of 'compute_edge_length_fcn' at (1)
! m-class-edge.f08:28:73:
!
!    28 |     function compute_edge_length_fcn ( me, myVertices ) result ( length )
!       |                                                                         1
! Error: Symbol at (1) is not a DUMMY variable
! m-class-edge.f08:33:12:
!
!    33 |             a = myVertices ( me % indexVertexLo ) % position ( : )
!       |            1
! Error: Incompatible ranks 0 and 1 in assignment at (1)
! m-class-edge.f08:34:12:
!
!    34 |             b = myVertices ( me % indexVertexHi ) % position ( : )
!       |            1
! Error: Incompatible ranks 0 and 1 in assignment at (1)
! m-class-edge.f08:35:29:
!
!    35 |             length = norm2 ( a - b )
!       |                             1
! Error: Unexpected derived-type entities in binary intrinsic numeric operator '-' at (1)
! make: *** [m-class-edge.o] Error 1
