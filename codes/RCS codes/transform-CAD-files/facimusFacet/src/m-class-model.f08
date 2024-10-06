! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mClassModel

    use, intrinsic :: iso_fortran_env,  only : iostat_end, output_unit, error_unit
    ! class structures
    use mClassFace,                     only : face
    use mClassVertex,                   only : vertex
    ! memory allocation
    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mAllocationsSpecial,            only : allocate_rank_one_faces_sub, allocate_rank_one_vertices_sub
    use mClassAverage,                  only : average, average0
    use mFacetWriter,                   only : writeVertices, writeHeaderVertex, writeFaces, writeHeaderFace
    use mFileHandling,                  only : safeopen_readwrite
    use mFormatDescriptors,             only : fmt_two, fmt_three, fmt_stat, fmt_iomsg
    use mHarvestCommandLine,            only : harvest_single_command_line_argument_sub
    use mIOtools,                       only : textLines, file_closer_sub, iostat_check_sub
    use mLibraryOfConstants,            only : dim, fileNameLength, zero_vector_r, messageLength, zero
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength, msgl = messageLength
    character ( len = * ), parameter :: moduleCrash = "Program crashed in module 'mClassModel', "

    integer ( ip ) :: io_stat = 0
    character ( len = msgl ) :: io_msg = ""

    type :: model
        type ( vertex ), allocatable :: myVertex ( : )
        type ( face ),   allocatable :: myFace   ( : )
        real ( rp ),     allocatable :: closest  ( : ), furthest ( : )
        integer ( ip ),  allocatable :: indexClose ( : ), indexFar ( : )
        type ( textLines )           :: objFileContent

        ! structures
        type ( average ) :: faceAverage    = average0
        type ( average ) :: vertexAverage  = average0
        type ( average ) :: nearestAverage = average0
        type ( allocationToolKit ) :: myKit = allocationToolKit0

        real    ( rp ) :: centroid ( 1 : dim ) = zero_vector_r

        integer ( ip ) :: numFaces = 0, numVertices = 0, &
                          numParts = 0, numSubParts = 0, mirror = 0

        character ( len = fnl ) :: nameOBJ = "", nameAreas = "", nameClose = "", nameData = "", nameFacet = "", nameVertices = ""
        character ( len =  20 ) :: partName = "partName", subPartName = "subPartName"
    contains
        procedure, public :: analyze_lengths          => analyze_lengths_sub, &
                             analyze_nearest          => analyze_nearest_sub, &
                             compute_centroid         => compute_centroid_sub, &
                             computeFaceStatistics    => computeFaceStatistics_sub, &
                             get_vertex_and_face_data => get_vertex_and_face_data_sub, &
                             nearest_neighbors        => nearest_neighbors_sub, &
                             set_file_names           => set_file_names_sub, &
                             write_face_areas         => write_face_areas_sub, &
                             write_facet_file         => write_facet_file_sub, &
                             write_nearest_neighbors  => write_nearest_neighbors_sub, &
                             write_vertex_statistics  => write_vertex_statistics_sub
    end type model

    private :: allocate_data_structures_sub, analyze_lengths_sub, analyze_nearest_sub, &
               compute_centroid_sub, computeFaceStatistics_sub, &
               create_file_names_sub, get_vertex_and_face_data_sub, nearest_neighbors_sub, set_file_names_sub, &
               write_face_areas_sub, write_facet_file_sub, write_nearest_neighbors_sub, write_vertex_statistics_sub
contains

    subroutine analyze_nearest_sub ( me )
        class ( model ),  target :: me
        real ( rp ), allocatable :: one ( : )
            ! clone
            call me % myKit % clone_rank_one_reals ( target_array = one, mold_array = me % closest )
            one ( : ) = 1.0_rp
            ! compute statistics
            call me % nearestAverage % compute_mean_and_variance ( vector = me % closest, one = one )
            call me % nearestAverage % find_max_and_min          ( vector = me % closest )
        return
    end subroutine analyze_nearest_sub

    subroutine write_nearest_neighbors_sub ( me )
        class ( model ), target :: me
        integer ( ip ) :: io_near = 0, kNieghbor = 0
        character ( len = * ), parameter :: subroutineCrash = "subroutine 'write_nearest_neighbors_sub'"

            ! open file
            write ( * , * )
            write ( * , fmt_three ) "Opening ", trim ( me % nameClose ), " for writing."
            io_near = safeopen_readwrite ( filename = me % nameClose )

            call me % nearestAverage % write_statistics ( io_unit = io_near, propertyName = "nearest neighbors", &
                                                            census = me % numVertices - 1 )

            sweep_neighbors: do kNieghbor = 1, me % numVertices - 1
                write ( io_near, fmt = 100 ) kNieghbor, me % indexClose ( kNieghbor ),  me % closest ( kNieghbor )
            end do sweep_neighbors

            call file_closer_sub ( io_unit = io_near, fileName = me % nameClose, crashChain = subroutineCrash )
        return
        100 format ( "The point closest to vertex (", g0,") is vertex (", g0,"): separation = ", g0 )
    end subroutine write_nearest_neighbors_sub

    subroutine nearest_neighbors_sub ( me )
        class ( model ),  target :: me
        real ( rp )    :: distance = zero, near = zero, far = zero
        integer ( ip ) :: kVertex = 0, k = 0, m = 0
            m = me % numVertices - 1
            ! allocate
            call me % myKit % allocate_rank_one_reals    ( real_array    = me % closest,    index_min = 1, index_max = m )
            call me % myKit % allocate_rank_one_reals    ( real_array    = me % furthest,   index_min = 1, index_max = m )
            call me % myKit % allocate_rank_one_integers ( integer_array = me % indexClose, index_min = 1, index_max = m )
            call me % myKit % allocate_rank_one_integers ( integer_array = me % indexFar,   index_min = 1, index_max = m )
            ! id nearest and farthest neightbors
            sweep_vertices: do kVertex = 1, me % numVertices - 1
                near =  huge ( 1.0_rp )
                far  = -huge ( 1.0_rp )
                sweep_above: do k = 1, kVertex - 1
                        distance = norm2 ( me % myVertex ( kVertex ) % position - me % myVertex ( k ) % position )
                        if ( distance < near ) then
                            near = distance
                            me % indexClose ( kVertex ) = k
                        end if
                        if ( distance > far ) then
                            far = distance
                            me % indexFar ( kVertex ) = k
                        end if
                    end do sweep_above
                sweep_below: do k = kVertex + 1, me % numVertices
                        distance = norm2 ( me % myVertex ( kVertex ) % position - me % myVertex ( k ) % position )
                        if ( distance < near ) then
                            near = distance
                            me % indexClose ( kVertex ) = k
                        end if
                        if ( distance > far ) then
                            far = distance
                            me % indexFar ( kVertex ) = k
                        end if
                    end do sweep_below
                    me % closest  ( kVertex ) = near
                    me % furthest ( kVertex ) = far
            end do sweep_vertices
        return
    end subroutine nearest_neighbors_sub

    subroutine compute_centroid_sub ( me )
        class ( model ),  target :: me
        integer ( ip ) :: kVertex = 0, kDim = 0
            sweep_spatial_dimensions: do kDim = 1, dim
                me % centroid ( kDim ) = sum ( [ ( me % myVertex ( kVertex ) % position ( kDim ), &
                                                kVertex = 1, me % numVertices ) ] )
            end do sweep_spatial_dimensions
        return
    end subroutine compute_centroid_sub

    subroutine write_vertex_statistics_sub ( me )
        class ( model ), target :: me
        integer ( ip ) :: io_areas = 0, kVertex = 0
        character ( len = * ), parameter :: subroutineCrash = moduleCrash // trim ( "subroutine 'write_vertex_statistics_sub'" )

            ! open file
            write ( * , * )
            write ( * , fmt_three ) "Opening ", trim ( me % nameVertices ), " for writing."
            io_areas = safeopen_readwrite ( filename = me % nameVertices )

            ! write headers and data
            call me % vertexAverage % write_statistics ( io_unit = io_areas, propertyName = "vertex lengths", &
                                                        census = me % numVertices )
            sweep_faces: do kVertex = 1, me % numVertices
                write ( io_areas , fmt = 100, iostat = io_stat, iomsg = io_msg ) kVertex, me % myVertex ( kVertex ) % length
                call iostat_check_sub ( action = "write", fileName = me % nameVertices, &
                                        iostat = io_stat, iomsg = io_msg, crashChain = subroutineCrash )
            end do sweep_faces

            call file_closer_sub ( io_unit = io_areas, fileName = me % nameVertices, crashChain = subroutineCrash )

        return
        100 format ( "Vertex ( ", g0, " ) length = ", g0 )
    end subroutine write_vertex_statistics_sub

    subroutine analyze_lengths_sub ( me )
        class ( model ),  target :: me
        real ( rp ), allocatable :: vertexLength ( : ), one ( : )
        integer ( ip ) :: kVertex = 0
            ! allocate
            call me % myKit % allocate_rank_one_reals ( real_array = vertexLength, index_min = 1, index_max = me % numVertices )
            ! clone
            call me % myKit % clone_rank_one_reals    ( target_array = one, mold_array = vertexLength )
            ! load vectors
            sweep_verticies: do kVertex = 1, me % numVertices
                vertexLength ( kVertex ) = me % myVertex ( kVertex ) % length
            end do sweep_verticies
            one ( : ) = 1.0_rp
            ! compute statistics
            call me % vertexAverage % compute_mean_and_variance ( vector = vertexLength, one = one )
            call me % vertexAverage % find_max_and_min          ( vector = vertexLength )
        return
    end subroutine analyze_lengths_sub

    subroutine computeFaceStatistics_sub ( me )
        class ( model ), target :: me
        real    ( rp ), allocatable :: faceAreas ( : ), one ( : )
        integer ( ip )              :: kFace = 0
            ! allocate
            call me % myKit % allocate_rank_one_reals ( real_array = faceAreas, index_min = 1, index_max = me % numFaces )
            ! clone
            call me % myKit % clone_rank_one_reals    ( target_array = one, mold_array = faceAreas )
            ! load vectors
            sweep_faces: do kFace = 1, me % numFaces
                faceAreas ( kFace ) = me % myFace ( kFace ) % area
            end do sweep_faces
            one ( : ) = 1.0_rp
            ! compute statistics
            call me % faceAverage % compute_mean_and_variance ( vector = faceAreas, one = one )
            call me % faceAverage % find_max_and_min          ( vector = faceAreas )
        return
    end subroutine computeFaceStatistics_sub

    subroutine write_face_areas_sub ( me )
        class ( model ), target :: me
        integer ( ip ) :: io_areas = 0, kFace = 0
        character ( len = * ), parameter :: subroutineCrash = moduleCrash // trim ( "subroutine 'write_face_areas_sub'" )

            ! open file
            write ( * , * )
            write ( * , fmt_three ) "Opening ", trim ( me % nameAreas ), " for writing."
            io_areas = safeopen_readwrite ( filename = me % nameAreas )

            ! write headers and data
            call me % faceAverage % write_statistics ( io_unit = io_areas, propertyName = "face areas", census = me % numFaces )
            sweep_faces: do kFace = 1, me % numFaces
                write ( io_areas , fmt = 100, iostat = io_stat, iomsg = io_msg ) kFace, me % myFace ( kFace ) % area
                call iostat_check_sub ( action = "write", fileName = me % nameAreas, &
                                        iostat = io_stat, iomsg = io_msg, crashChain = subroutineCrash )
            end do sweep_faces

            call file_closer_sub ( io_unit = io_areas, fileName = me % nameAreas, crashChain = subroutineCrash )

        return
        100 format ( "Face ( ", g0, " ) area = ", g0 )
    end subroutine write_face_areas_sub

    subroutine write_facet_file_sub ( me )
        class ( model ), target :: me
        integer ( ip ) :: io_facet = 0
        character ( len = * ), parameter :: subroutineCrash = "subroutine 'write_facet_file'"

            ! open file
            write ( * , * )
            write ( * , fmt_three ) "Opening ", trim ( me % nameFacet ), " for writing."
            io_facet = safeopen_readwrite ( filename = me % nameFacet )

            ! write headers and data
            call writeHeaderVertex ( io_facet = io_facet, numParts = me % numParts, partName = me % partName, mirror = me % mirror )
            call writeVertices     ( io_facet = io_facet, vertices = me % myVertex )
            call writeHeaderFace   ( io_facet = io_facet, numSubParts = me % numParts, subPartName = me % partName, &
                                                             numFaces = me % numFaces )
            call writeFaces        ( io_facet = io_facet, faces = me % myFace )

            call file_closer_sub ( io_unit = io_facet, fileName = me % nameFacet, crashChain = subroutineCrash )
        return
    end subroutine write_facet_file_sub

    subroutine set_file_names_sub ( me )
        class ( model ), target :: me
        character ( len = fnl ) :: objFileName = ""
            ! extract file name from command line
            call harvest_single_command_line_argument_sub ( index = 1, theArgument = objFileName )
            me % nameOBJ = trim ( objFileName )
            call create_file_names_sub ( me )
        return
    end subroutine set_file_names_sub

    subroutine get_vertex_and_face_data_sub ( me )
        class ( model ), target :: me
        integer ( ip ) :: k = 0, lineNum = 0
            call set_file_names_sub ( me )
            call me % objFileContent % count_lines ( fullFileName = me % nameOBJ )
            ! allocate container to hold entire file
            call me % objFileContent % allocate_text_containers ( )
            ! read  file into memory
            call me % objFileContent % read_textLines ( fullFileName = me % nameOBJ )
            ! scan through data lines and mark lines with "v" or "f"
            call me % objFileContent % classify_vertex_or_face ( numFaces = me % numFaces, numVertices = me % numVertices )
            ! allocate faces and vertices
            call allocate_data_structures_sub ( me )
            sweep_vertices: do k = 1, me % numVertices
                lineNum = me % objFileContent % linesVertex ( k )
                call me % myVertex ( k ) % getVertices ( textLine = me % objFileContent % textLine ( lineNum ) )
            end do sweep_vertices
            sweep_faces: do k = 1, me % numFaces
                lineNum = me % objFileContent % linesFace ( k )
                call me % myFace ( k ) % getFaces ( textLine = me % objFileContent % textLine ( lineNum ) )
                write ( * , fmt = '( 2g0 )' ) "calling computeFaceArea_sub: k = ", k
                call me % myFace ( k ) % computeFaceArea ( myVertices = me % myVertex )
                call me % myFace ( k ) % writeFace ( )
            end do sweep_faces
        return
    end subroutine get_vertex_and_face_data_sub

    subroutine allocate_data_structures_sub ( me )
        class ( model ), target :: me
            ! allocate faces
            call allocate_rank_one_faces_sub    ( rank_1_face   = me % myFace,   index_min = 1, index_max = me % numFaces )
            call allocate_rank_one_vertices_sub ( rank_1_vertex = me % myVertex, index_min = 1, index_max = me % numVertices )
        return
    end subroutine allocate_data_structures_sub

    subroutine create_file_names_sub ( me )
        class ( model ), target :: me
        character ( len = fnl ) :: nameStem = ""
        integer ( ip )          :: nameLength = 0

            nameLength = len ( trim ( me % nameOBJ ) )
            nameStem   =       trim ( me % nameOBJ ( 1 : nameLength - 4_ip ) )
            ! swap *.obj for *.facet, etc.
            me % nameAreas    = trim ( nameStem ) // ".areas"
            me % nameClose    = trim ( nameStem ) // ".close"
            me % nameData     = trim ( nameStem ) // ".data"
            me % nameFacet    = trim ( nameStem ) // ".facet"
            me % nameVertices = trim ( nameStem ) // ".verts"

        return
    end subroutine create_file_names_sub

end module mClassModel
