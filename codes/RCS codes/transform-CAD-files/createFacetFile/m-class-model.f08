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
    use mHarvestCommandLine,            only : harvest_single_command_line_argument
    use mLibraryOfConstants,            only : fileNameLength, messageLength
    use mParametersSimulation,          only : dim, zero, one, zero_vector_r
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength
    character ( len = * ), parameter :: moduleCrash = "Program crashed in module 'mClassModel', "

    integer ( ip ) :: io_stat = 0, io_obj = 0, io_facet = 0
    character ( len = msgl ) :: io_msg = ""

    type :: model
        type ( vertex ), allocatable :: myVertex ( : )
        type ( face ),   allocatable :: myFace   ( : )
        type ( census )              :: myCensus = census0

        integer ( ip )  :: numParts = 0, numSubParts = 0, mirror = 0

        character ( len = fnl ) :: nameOBJ = "", nameFacet = "", nameData = "", nameCheck = ""
        character ( len =  20 ) :: partName = "partName", subPartName = "subPartName"
    contains
        procedure, public :: compute_triangle   => compute_triangle_area, &
                             create_file_names  => create_file_names_sub, &
                             memory_allocations => memory_allocations_sub, &
                             perform_census     => perform_census_sub, &
                             read_input_file    => read_input_file_sub, &
                             writeFacetFile     => write_facet_file
    end type model

    private :: compute_triangle_area, create_file_names_sub, file_closer_sub, memory_allocations_sub, perform_census_sub!, print_files_sub
    ! I/O
    private :: read_input_file_sub, write_facet_file

contains

    subroutine compute_triangle_area ( me )
        class ( model ), target :: me
        character ( len = msgl ), parameter :: subroutineCrash = moduleCrash // "subroutine 'compute_triangle_area'"
        ! locals
        real ( rp ) :: area = zero, rcount = zero, difference = zero
        real ( rp ) :: sumArea = zero, sumAreaSq = zero, meanArea = zero, meanAreaSq = zero, standardDeviationArea = zero
        real ( rp ) :: max = -1.0_rp, min = huge ( one )
        real ( rp ) :: x ( 1 : dim ) = zero_vector_r, y ( 1 : dim ) = zero_vector_r, z ( 1 : dim ) = zero_vector_r
        real ( rp ) :: a = zero, b = zero, c = zero, s = zero, spectralRadius = zero
        integer ( ip ) :: count = 0, io_data
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
            io_data = safeopen_readwrite ( filename = me % nameData )

                write ( io_data , fmt_two ) trim ( me % nameFacet )
                write ( io_data , 200 ) count
                write ( io_data , 210 ) meanArea, standardDeviationArea
                write ( io_data , 220 ) "Maximum", max, indexMax
                write ( io_data , 220 ) "Minimum", min, indexMin
                write ( io_data , 230 ) spectralRadius
                write ( io_data , 240 ) me % myCensus % vertices % count

            call file_closer_sub ( io_unit = io_data, fileName = me % nameData, crashChain = subroutineCrash )

        return
        200 format ( /, "Characterization of ", g0, " triangle areas:" )
        210 format ( "Mean = ", E9.2, " +/- ", E9.2 )
        220 format ( g0, " value = ", E9.2, " occured at ", g0 )
        230 format ( "Spectral radius = ", F5.1 )
        240 format ( /, "vertex count = ", g0 )
    end subroutine compute_triangle_area

    subroutine write_facet_file ( me )
        class ( model ), target :: me
        character ( len = msgl ), parameter :: subroutineCrash = moduleCrash // "subroutine 'write_facet_file'"

            ! open file
            write ( * , * )
            write ( * , fmt_three ) "Opening ", trim ( me % nameFacet ), " for writing."
            io_facet = safeopen_readwrite ( filename = me % nameFacet )

            ! write headers and data
            call writeHeaderVertex ( io_facet = io_facet, numParts = me % numParts, partName = me % partName, mirror = me % mirror )
            call writeVertices     ( io_facet = io_facet, vertices = me % myVertex )
            call writeHeaderFace   ( io_facet = io_facet, numSubParts = me % numParts, subPartName = me % partName, &
                                                             numFaces = me % myCensus % faces % count )
            call writeFaces        ( io_facet = io_facet, faces = me % myFace )

            call file_closer_sub   ( io_unit  = io_facet, fileName = me % nameFacet, crashChain = moduleCrash // subroutineCrash )
        return
    end subroutine write_facet_file

    subroutine read_input_file_sub ( me )
        class ( model ), target :: me
        character ( len = msgl ), parameter :: subroutineCrash = moduleCrash // "subroutine 'read_input_file_sub'"

            ! open file
            write ( * , * )
            write ( * , fmt_three ) "Opening ", trim ( me % nameOBJ ), " to read data lists."
            io_obj = safeopen_readonly ( filename = me % nameOBJ )

            ! gather data
            call getVertices ( io_obj = io_obj, array = me % myVertex, locators = me % myCensus % vertices )
            call getFaces    ( io_obj = io_obj, array = me % myFace,   locators = me % myCensus % faces )

            call file_closer_sub ( io_unit = io_obj, fileName = me % nameOBJ, crashChain = subroutineCrash )

        return
    end subroutine read_input_file_sub

    subroutine memory_allocations_sub ( me )
        class ( model ), target :: me

            ! allocate memory for structures
            call rank_one_vertices_sub ( vertex_array = me % myVertex, nElements = me % myCensus % vertices % count )
            call rank_one_faces_sub    ( face_array   = me % myFace,   nElements = me % myCensus % faces    % count )

        return
    end subroutine memory_allocations_sub

    ! subroutine count_species_sub ( me, counter, id_tag, io_obj )
    !     class ( model ), target :: me
    subroutine count_species_sub (  counter, id_tag, io_obj )
        ! tourists
        integer ( ip ),        intent ( out ) :: counter
        integer ( ip ),        intent ( in )  :: io_obj
        character ( len = * ), intent ( in )  :: id_tag
        ! locals
        character ( len = 2 ) :: tag = ""
        character ( len = msgl ) :: myOptionalMessage = ""
        character ( len = * ), parameter :: subroutineCrash = moduleCrash // "subroutine 'count_species_sub'"

            ! sweep looking for all instances
            ! possible problem: non-sequential data
            counter = 0
            do
                read  ( unit = io_obj, fmt = *, iostat = io_stat,  iomsg = io_msg ) tag
                if ( io_stat == iostat_end ) then
                    return
                endif

                write ( myOptionalMessage, fmt = fmt_three ) "Error after reading ", counter, " elements"
                call io_exception_sub ( actionDescriptor = "Census for species " // trim ( id_tag ), &
                        optionalMessage = myOptionalMessage, subroutineCrash = subroutineCrash )

                ! check id
                if ( trim ( tag ) == id_tag ) then
                    counter = counter + 1
                else
                    if ( counter == 0 ) then
                        write ( * , fmt_two ) "No entries found for species ", trim ( id_tag )
                        stop subroutineCrash
                    end if
                    return
                end if
            end do

        return
    end subroutine count_species_sub

    subroutine perform_census_sub ( me )
        ! assumed structure: dummy line, vertices, normals, faces
        class ( model ), target :: me

        character ( len = fnl ) :: firstLine = ""
        character ( len = msgl ), parameter :: subroutineCrash = moduleCrash // "subroutine 'perform_census_sub'"
        integer ( ip ) :: counter = 0, io_data = 0

            ! open file
            io_obj = safeopen_readonly ( filename = me % nameOBJ )

            ! read text string in first line
            read  ( unit = io_obj, fmt = '( A80 )', iostat = io_stat, iomsg = io_msg ) firstLine
            if ( io_stat == iostat_end ) then
                write ( * , fmt_three ) "File ", trim ( me % nameOBJ ), " is empty."
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop subroutineCrash
            end if

            call io_exception_sub ( actionDescriptor = "Read error on first line ", subroutineCrash = subroutineCrash )

            me % myCensus % vertices % first = 2

            ! read vertices
            call count_species_sub ( counter = counter, id_tag = "v", io_obj = io_obj )
            me % myCensus % vertices % count = counter
            me % myCensus % vertices % last  = me % myCensus % vertices % first + counter - 1
            me % myCensus % normals  % first = me % myCensus % vertices % first + counter

            ! read normals
            backspace ( unit = io_obj, iostat = io_stat, iomsg = io_msg )
            call io_exception_sub ( actionDescriptor = "Backspace error trying to read normals", subroutineCrash = subroutineCrash )

            call count_species_sub ( counter = counter, id_tag = "vn", io_obj = io_obj )
            me % myCensus % normals % count = counter
            me % myCensus % normals % last  = me % myCensus % normals % first + counter - 1
            me % myCensus % faces   % first = me % myCensus % normals % first + counter

            ! read faces
            backspace ( unit = io_obj, iostat = io_stat, iomsg = io_msg )
            call io_exception_sub ( actionDescriptor = "Backspace error trying to read faces", subroutineCrash = subroutineCrash )

            call count_species_sub ( counter = counter, id_tag = "f", io_obj = io_obj )
            me % myCensus % faces % count = counter
            me % myCensus % faces % last  = me % myCensus % faces % first + counter - 1

            call file_closer_sub ( io_unit = io_obj, fileName = me % nameOBJ, crashChain = subroutineCrash )

            ! characterization of triangle areas
            io_data = safeopen_readwrite ( filename = me % nameCheck )

                write ( io_data , fmt_two ) trim ( me % nameFacet )
                write ( io_data , fmt_two ) "first line in *.obj: ", trim ( firstLine )
                write ( io_data , * )
                write ( io_data , fmt_two ) "Total vertices found = ",         me % myCensus % vertices % count
                write ( io_data , fmt_two ) "Line number for first vertex = ", me % myCensus % vertices % first
                write ( io_data , fmt_two ) "Line number for last vertex  = ", me % myCensus % vertices % last
                write ( io_data , fmt_two ) "Line number for first normal = ", me % myCensus % normals  % first

                write ( io_data , * )
                write ( io_data , fmt_two ) "Total normals found = ",          me % myCensus % normals % count
                write ( io_data , fmt_two ) "Line number for first normal = ", me % myCensus % normals % first
                write ( io_data , fmt_two ) "Line number for last normal  = ", me % myCensus % normals % last
                write ( io_data , fmt_two ) "Line number for first face   = ", me % myCensus % faces   % first

                write ( io_data , * )
                write ( io_data , fmt_two ) "Total faces found = ",            me % myCensus % faces % count
                write ( io_data , fmt_two ) "Line number for first face = ",   me % myCensus % faces % first
                write ( io_data , fmt_two ) "Line number for last face  = ",   me % myCensus % faces % last

            call file_closer_sub ( io_unit = io_data, fileName = me % nameCheck, crashChain = moduleCrash // subroutineCrash )

        return
    end subroutine perform_census_sub

    subroutine create_file_names_sub ( me )
        class ( model ), target :: me
        integer ( ip ) :: nameLength = 0
        character ( len = fnl ) :: nameOBJ = "", nameStem = ""
            call harvest_single_command_line_argument ( index = 1, theArgument = nameOBJ )
            me % nameOBJ = trim ( nameOBJ )
            nameLength = len ( trim ( nameOBJ ) )
            nameStem = trim ( me % nameOBJ ( 1 : nameLength - 4 ) )
            ! swap *.obj for *.facet, etc.
            me % nameFacet = trim ( nameStem ) // ".facet"
            me % nameData  = trim ( nameStem ) // ".data"
            me % nameCheck = trim ( nameStem ) // ".check"
        return
    end subroutine create_file_names_sub

    subroutine io_exception_sub ( actionDescriptor, subroutineCrash, optionalMessage )
        character ( len = * ),              intent ( in ) :: actionDescriptor, subroutineCrash
        character ( len = msgl ), optional, intent ( in ) :: optionalMessage

            if ( io_stat /= 0 ) then
                write ( * , fmt = '( g0 )' ) trim ( actionDescriptor )
                if ( present ( optionalMessage ) ) then
                    write ( * , fmt = '( g0 )' ) trim ( optionalMessage )
                end if
                write ( * , fmt = fmt_stat  ) io_stat
                write ( * , fmt = fmt_iomsg ) io_msg
                stop trim ( subroutineCrash )
            end if

        return
    end subroutine io_exception_sub

    subroutine file_closer_sub ( io_unit, fileName, crashChain, optionalMessage )
        integer ( ip ),                     intent ( in ) :: io_unit
        character ( len = fnl ),            intent ( in ) :: fileName
        character ( len = msgl ),           intent ( in ) :: crashChain
        character ( len = msgl ), optional, intent ( in ) :: optionalMessage

            close ( unit = io_unit, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure to CLOSE for io_unit = ", io_unit
                write ( * , fmt = '( 2g0 )' ) "File name = '", trim ( fileName ), "'"
                if ( present ( optionalMessage ) ) then
                    write ( * , fmt = '( g0 )' ) trim ( optionalMessage )
                end if
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg )      trim ( io_msg )
                write ( * , fmt = '( g0 )' ) trim ( crashChain )
                stop
            end if

        return
    end subroutine file_closer_sub

end module mClassModel
