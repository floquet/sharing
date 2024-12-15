! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassModel

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    ! class structures
    use mClassCensus,                   only : census, census0
    use mClassVertex,                   only : vertex, vertex0
    use mClassFace,                     only : face,   face0
    ! reader routines
    use mOBJreader,                     only : getVertices, getFaces
    ! writer routines
    use mFacetWriter,                   only : writeVertices, writeHeaderVertex, writeFaces, writeHeaderFace
    ! memory allocation
    use mAllocations,                   only : rank_one_vertices_sub, rank_one_faces_sub
    ! utilities
    use mFileHandling,                  only : safeopen_readonly, safeopen_readwrite
    use mFormatDescriptors,             only : fmt_one, fmt_two, fmt_three, fmt_four, fmt_stat, fmt_iomsg
    use mHarvestCommandLine,            only : harvest_command_line_argument
    use mParametersSimulation,          only : dim, zero, one, zero_vector_r
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ) :: io_stat = 0, u_obj = 0, u_facet = 0
    character ( len = 512 ) :: io_msg = ""

    type :: model
        type ( vertex ), allocatable :: myVertex ( : )
        type ( face ),   allocatable :: myFace   ( : )
        type ( census )              :: myCensus

        integer ( ip )  :: numParts = 0, numSubParts = 0, mirror = 0

        character ( len = 512 ) :: namePath = "./", nameStem = "", nameOBJ = "", nameFacet = "", nameData = "", nameCheck = ""
        character ( len =  20 ) :: partName = "partName", subPartName = "subPartName"
    contains
!        procedure, public :: count_species        =>    count_species_sub
        procedure, public :: compute_triangle     =>    compute_triangle_area
        procedure, public :: create_file_names    =>    create_file_names_sub
        procedure, public :: memory_allocations   =>    memory_allocations_sub
        procedure, public :: perform_census       =>    perform_census_sub
        procedure, public :: print_files          =>    print_files_sub
        procedure, public :: read_input_file      =>    read_input_file_sub
        procedure, public :: writeFacetFile       =>    write_facet_file
    end type model

    private :: compute_triangle_area, create_file_names_sub, memory_allocations_sub, perform_census_sub, print_files_sub
    ! I/O
    private :: read_input_file_sub, write_facet_file

contains

    subroutine compute_triangle_area ( me )
        class ( model ), target :: me
        ! locals
        real ( rp ) :: area = zero, rcount = zero, difference = zero
        real ( rp ) :: sumArea = zero, sumAreaSq = zero, meanArea = zero, meanAreaSq = zero, standardDeviationArea = zero
        real ( rp ) :: max = -1.0_rp, min = huge ( one )
        real ( rp ) :: x ( 1 : dim ) = zero_vector_r, y ( 1 : dim ) = zero_vector_r, z ( 1 : dim ) = zero_vector_r
        real ( rp ) :: a = zero, b = zero, c = zero, s = zero, spectralRadius = zero
        integer ( ip ) :: count = 0, u_data
        integer ( ip ) :: k = 0
        integer ( ip ) :: indexMin = 0, indexMax = 0

            count  = me % myCensus % faces % count
            rcount = real ( count, rp )
            sweep_triangles: do k = 1, count
                x = me % myVertex ( me % myFace ( k ) % indexVertex ( 1 ) ) % position ( : )
                y = me % myVertex ( me % myFace ( k ) % indexVertex ( 2 ) ) % position ( : )
                z = me % myVertex ( me % myFace ( k ) % indexVertex ( 3 ) ) % position ( : )
                ! x1 y2 z3 + x2 y3 z1 + x3 y1 z2 - x1 y3 z2 - x2 y1 z3 - x3 y2 z1
                ! area = x ( 1 ) * y ( 2 ) * z ( 3 ) + x ( 2 ) * y ( 3 ) * z ( 1 ) + x ( 3 ) * y ( 1 ) * z ( 2 ) &
                !      - x ( 1 ) * y ( 3 ) * z ( 2 ) - x ( 2 ) * y ( 1 ) * z ( 3 ) - x ( 3 ) * y ( 2 ) * z ( 1 )
                ! Herron's formula
                ! write ( * , '( "k = ", I4, "; area = ", E10.2 )' ) k, area
                a = norm2 ( x - y )
                b = norm2 ( x - z )
                c = norm2 ( y - z )
                s = ( a + b + c ) / 2.0_rp
                area = sqrt ( s * ( s - a ) * ( s - b ) * ( s - c ) )
                sumArea   = sumArea   + area
                sumAreaSq = sumAreaSq + area ** 2
                if ( area > max ) then
                     max  = area
                     indexMax = k
                end if
                if ( area < min ) then
                     min  = area
                     indexMin = k
                end if
            end do sweep_triangles
            spectralRadius = log10 ( max ) - log10 ( min )
            ! character triangle areas
            meanArea   = sumArea   / rcount
            meanAreaSq = sumAreaSq / rcount
            difference = meanAreaSq - meanArea ** 2
            ! difference of large numbers may be -epsilon
            if ( difference < zero ) then
                 difference = zero
            end if
            standardDeviationArea = sqrt ( difference )

            ! characterization of triangle areas
            u_data = safeopen_readwrite ( filename = me % nameData )

                write ( u_data , fmt_two ) trim ( me % nameFacet )
                write ( u_data , 200 ) count
                write ( u_data , 210 ) meanArea, standardDeviationArea
                write ( u_data , 220 ) "Maximum", max, indexMax
                write ( u_data , 220 ) "Minimum", min, indexMin
                write ( u_data , 230 ) spectralRadius
                write ( u_data , 240 ) me % myCensus % vertices % count

            close ( unit = u_data, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt_two   ) "Failure on CLOSE for data file ", trim ( me % nameData )
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine compute_triangle_area..."
            end if

        return
        200 format ( /, "Characterization of ", g0, " triangle areas:" )
        210 format ( "Mean = ", E9.2, " +/- ", E9.2 )
        220 format ( g0, " value = ", E9.2, " occured at ", g0 )
        230 format ( "Spectral radius = ", F5.1 )
        240 format ( /, "vertex count = ", g0 )
    end subroutine compute_triangle_area

    subroutine write_facet_file ( me )
        class ( model ), target :: me

            ! open file
            write ( * , * )
            write ( * , fmt_three ) "Opening ", trim ( me % nameFacet ), " for writing."
            u_facet = safeopen_readwrite ( filename = me % nameFacet )

            ! write headers and data
            call writeHeaderVertex ( u_facet = u_facet, numParts = me % numParts, partName = me % partName, mirror = me % mirror  )
            call writeVertices     ( u_facet = u_facet, vertices = me % myVertex )
            call writeHeaderFace   ( u_facet = u_facet, numSubParts = me % numParts, subPartName = me % partName, &
                                                        numFaces = me % myCensus % faces % count )
            call writeFaces        ( u_facet = u_facet, faces = me % myFace )

            close ( unit = u_facet, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt_two   ) "Failure on CLOSE for facet file ", trim ( me % nameFacet )
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine write_facet_file..."
            end if
        return
    end subroutine write_facet_file

    subroutine read_input_file_sub ( me )
        class ( model ), target :: me

            ! open file
            write ( * , * )
            write ( * , fmt_three ) "Opening ", trim ( me % nameOBJ ), " to read data lists."
            u_obj = safeopen_readonly ( filename = me % nameOBJ )

            ! gather data
            call getVertices ( u_obj = u_obj, array = me % myVertex, locators = me % myCensus % vertices )
            call getFaces    ( u_obj = u_obj, array = me % myFace,   locators = me % myCensus % faces )

            close ( unit = u_obj, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt_two   ) "Failure on CLOSE for OBJ file ", trim ( me % nameOBJ )
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine read_input_file_sub..."
            end if

        return
    end subroutine read_input_file_sub

    subroutine memory_allocations_sub ( me )
        class ( model ), target :: me

            ! allocate memory for structures
            call rank_one_vertices_sub ( vertex_array = me % myVertex, nElements = me % myCensus % vertices % count )
            call rank_one_faces_sub    ( face_array   = me % myFace,   nElements = me % myCensus % faces    % count )

        return
    end subroutine memory_allocations_sub

    ! subroutine count_species_sub ( me, counter, id_tag, u_obj )
    !     class ( model ), target :: me
    subroutine count_species_sub (  counter, id_tag, u_obj )
        ! tourists
        integer ( ip ),        intent ( out ) :: counter
        integer ( ip ),        intent ( in )  :: u_obj
        character ( len = * ), intent ( in )  :: id_tag
        ! locals
        character ( len = 2   ) :: tag = ""

            ! sweep looking for all instances
            ! possible problem: non-sequential data
            counter = 0_ip
            do
                read  ( unit = u_obj, fmt = *, iostat = io_stat,  iomsg = io_msg ) tag
                if ( io_stat == iostat_end ) then
                    return
                endif

                if ( io_stat /= 0 ) then
                    write ( * , fmt_two   ) "Census for species ", trim ( id_tag )
                    write ( * , fmt_three ) "Error after reading ", counter, " elements"
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop "Program crashed in subroutine count_species_sub..."
                end if

                ! check id
                if ( trim ( tag ) == id_tag ) then
                    counter = counter + 1
                else
                    if ( counter == 0 ) then
                        write ( * , fmt_two ) "No entries found for species ", trim ( id_tag )
                        stop "Program crashed in subroutine count_species_sub..."
                    end if
                    return
                end if
            end do

        return
    end subroutine count_species_sub

    subroutine perform_census_sub ( me )
        ! assumed structure: dummy line, vertices, normals, faces
        class ( model ), target :: me

        character ( len = 512 ) :: firstLine = ""

        integer ( ip ) :: counter = 0, u_data = 0

            ! open file
            u_obj = safeopen_readonly ( filename = me % nameOBJ )

            ! read text string in first line
            read  ( unit = u_obj, fmt = '( A80 )', iostat = io_stat,  iomsg = io_msg ) firstLine
            if ( io_stat == iostat_end ) then
                write ( * , fmt_three ) "File ", trim ( me % nameOBJ ), " is empty."
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine perform_census_sub..."
            end if

            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Read error on first line "
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine perform_census_sub..."
            end if

            me % myCensus % vertices % first = 2

            ! read vertices
            call count_species_sub ( counter = counter, id_tag = "v", u_obj = u_obj )
            me % myCensus % vertices % count = counter
            me % myCensus % vertices % last  = me % myCensus % vertices % first + counter - 1
            me % myCensus % normals  % first = me % myCensus % vertices % first + counter

            ! read normals
            backspace ( unit = u_obj, iostat = io_stat )
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Backspace error trying to read normals"
                write ( * , fmt_stat )  io_stat
                stop "Program crashed in subroutine perform_census_sub..."
            end if

            call count_species_sub ( counter = counter, id_tag = "vn", u_obj = u_obj )
            me % myCensus % normals % count = counter
            me % myCensus % normals % last  = me % myCensus % normals % first + counter - 1
            me % myCensus % faces   % first = me % myCensus % normals % first + counter

            ! read faces
            backspace ( unit = u_obj, iostat = io_stat )
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Backspace error trying to read faces"
                write ( * , fmt_stat )  io_stat
                stop "Program crashed in subroutine perform_census_sub..."
            end if

            call count_species_sub ( counter = counter, id_tag = "f", u_obj = u_obj )
            me % myCensus % faces % count = counter
            me % myCensus % faces % last  = me % myCensus % faces % first + counter - 1

            close ( unit = u_obj, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt_two   ) "Failure on CLOSE for OBJ file ", trim ( me % nameOBJ )
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine perform_census_sub..."
            end if

            ! characterization of triangle areas
            u_data = safeopen_readwrite ( filename = me % nameCheck )

                write ( u_data , fmt_two ) trim ( me % nameFacet )
                write ( u_data , fmt_two ) "first line in *.obj: ", trim ( firstLine )
                write ( u_data , * )
                write ( u_data , fmt_two ) "Total vertices found = ",         me % myCensus % vertices % count
                write ( u_data , fmt_two ) "Line number for first vertex = ", me % myCensus % vertices % first
                write ( u_data , fmt_two ) "Line number for last vertex  = ", me % myCensus % vertices % last
                write ( u_data , fmt_two ) "Line number for first normal = ", me % myCensus % normals  % first

                write ( u_data , * )
                write ( u_data , fmt_two ) "Total normals found = ",          me % myCensus % normals % count
                write ( u_data , fmt_two ) "Line number for first normal = ", me % myCensus % normals % first
                write ( u_data , fmt_two ) "Line number for last normal  = ", me % myCensus % normals % last
                write ( u_data , fmt_two ) "Line number for first face   = ", me % myCensus % faces   % first

                write ( u_data , * )
                write ( u_data , fmt_two ) "Total faces found = ",            me % myCensus % faces % count
                write ( u_data , fmt_two ) "Line number for first face = ",   me % myCensus % faces % first
                write ( u_data , fmt_two ) "Line number for last face  = ",   me % myCensus % faces % last

            close ( unit = u_data, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt_two   ) "Failure on CLOSE for data file ", trim ( me % nameCheck )
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine perform_census_sub..."
            end if

        return
    end subroutine perform_census_sub

    subroutine create_file_names_sub ( me, namePath )
        class ( model ), target :: me
        character ( len = * ), intent ( in ) :: namePath
        character ( len = 128 ) :: nameStem
            call harvest_command_line_argument ( index = 1, theArgument = nameStem )
            me % namePath  = trim ( namePath )
            me % nameOBJ   = trim ( namePath ) // trim ( nameStem ) // ".obj"
            me % nameFacet = trim ( namePath ) // trim ( nameStem ) // ".facet"
            me % nameData  = trim ( namePath ) // trim ( nameStem ) // ".data"
            me % nameCheck = trim ( namePath ) // trim ( nameStem ) // ".check"
            call print_files_sub ( me )
        return
    end subroutine create_file_names_sub

    subroutine print_files_sub ( me )
        class ( model ), target :: me
            write ( * , * )
            write ( * , fmt_two ) "target directory: ", trim ( me % namePath )
            write ( * , fmt_two ) "input  file: ",      trim ( me % nameOBJ )
            write ( * , fmt_two ) "output file: ",      trim ( me % nameFacet )
        return
    end subroutine print_files_sub

end module mClassModel
