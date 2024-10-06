! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassFace

    use mClassVertex,           only : vertex
    use mIOtools,               only : iostat_check_sub
    use mLibraryOfConstants,    only : dim, zero, zero_vector_i, zero_vector_r, messageLength, objLineLength
    use mPrecisionDefinitions,  only : ip, rp

    implicit none

    character ( len = * ), parameter :: moduleCrash = "Program crashed in module 'mClassFace', "

    integer ( ip ) :: io_stat = 0
    character ( len = messageLength ) :: io_msg = ""

    type :: face
        ! rank 1: triangles
        integer ( ip ) :: indexVertex ( 1 : dim ) = zero_vector_i
        ! rank 0
        real ( rp ) :: area = zero
    contains
        procedure, public :: computeFaceArea => computeFaceArea_sub, &
                             getFaces        => getFaces_sub, &
                             writeFace       => writeFace_sub
    end type face

    ! vertex constructor
    type ( face ), parameter :: face0 = face ( indexVertex = zero_vector_i, area = zero )

    private :: computeFaceArea_sub, getFaces_sub

contains

    subroutine getFaces_sub ( me, textLine )
        class ( face ), target :: me
        character ( len = * ), intent ( in ) :: textLine
        integer ( ip ) :: indices ( 1 : 6 )
        integer ( ip ) :: j = 0
        character ( len = objLineLength ) :: buffer = ""
        character ( len = messageLength ) :: crashChain = moduleCrash // trim ( "subroutine 'getFaces_sub'." )

            buffer = trim ( textLine )
            do j = 1, len ( trim ( buffer ) )
                ! "/" ==> " "
                if ( buffer ( j : j ) == "/" .or. buffer ( j : j ) == "f" .or. buffer ( j : j ) == "F" ) then
                     buffer ( j : j ) = " "
                end if
            end do
            read ( unit = buffer, fmt = *, iostat = io_stat, iomsg = io_msg ) indices ( 1 : 6 )
            call iostat_check_sub ( action = "unformatted READ", fileName = "string variable 'textLine'", &
                                    iostat = io_stat, iomsg = io_msg, crashChain = crashChain )
            ! harvest lead elements as vertex indices
            me % indexVertex ( : ) = indices ( 1 : 6 : 2 )

        return
    end subroutine getFaces_sub

    subroutine computeFaceArea_sub ( me, myVertices )
        class ( face ),         target :: me
        type ( vertex ), intent ( in ) :: myVertices ( : )
        ! rank 1
        real ( rp ) :: x ( 1 : dim ) = zero_vector_r, y ( 1 : dim ) = zero_vector_r, z ( 1 : dim ) = zero_vector_r
        ! rank 0
        real ( rp ) :: s = zero, a = zero, b = zero, c = zero

            write ( * , fmt = '( g0, 2( ", ", g0 ), g0 )' ) "inside computeFaceArea_sub: me % indexVertex = ", me % indexVertex
            x = myVertices ( me % indexVertex ( 1 ) ) % position ( : )
            y = myVertices ( me % indexVertex ( 2 ) ) % position ( : )
            z = myVertices ( me % indexVertex ( 3 ) ) % position ( : )
            ! x1 y2 z3 + x2 y3 z1 + x3 y1 z2 - x1 y3 z2 - x2 y1 z3 - x3 y2 z1
            ! area = x ( 1 ) * y ( 2 ) * z ( 3 ) + x ( 2 ) * y ( 3 ) * z ( 1 ) + x ( 3 ) * y ( 1 ) * z ( 2 ) &
            !      - x ( 1 ) * y ( 3 ) * z ( 2 ) - x ( 2 ) * y ( 1 ) * z ( 3 ) - x ( 3 ) * y ( 2 ) * z ( 1 )
            ! Herron's formula
            a = norm2 ( x - y )
            b = norm2 ( x - z )
            c = norm2 ( y - z )
            s = ( a + b + c ) / 2.0_rp
            me % area = sqrt ( s * ( s - a ) * ( s - b ) * ( s - c ) )

        return
    end subroutine computeFaceArea_sub

    subroutine writeFace_sub ( me )
        class ( face ), target :: me
        integer :: kDim = 0
            sweep_spatial_dimensions: do kDim = 1, kDim
                write ( * , fmt = '( 4g0 )' ) "indexVertex ( ", kDim, " ) = ", me % indexVertex ( kDim )
            end do sweep_spatial_dimensions
            write ( * , fmt = '( 2g0 )' ) "face area = ", me % area
        return
    end subroutine writeFace_sub

end module mClassFace
