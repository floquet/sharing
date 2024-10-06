! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassCensus

    use mPrecisionDefinitions, only : ip

    implicit none

    ! line number of first OBJ entry, last entry, total entries
    type :: lines
        integer ( ip ) :: first = 0
        integer ( ip ) :: last  = 0
        integer ( ip ) :: count = 0
    end type lines
    ! constructor
    type ( lines ), parameter :: lines0 = lines ( first = 0, last = 0, count = 0 )

    type :: census
        type ( lines ) :: vertices = lines0
        type ( lines ) :: normals  = lines0
        type ( lines ) :: faces    = lines0
    end type census
    ! constructor
    type ( census ), parameter :: census0 = census ( vertices = lines0, normals = lines0, faces = lines0 )

end module mClassCensus
