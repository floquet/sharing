! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mProcessControl

    use mClassModel,                    only : model

    implicit none

contains

    subroutine main_process_sub ( )
        type ( model ) :: myModel

            ! initialize model details
            myModel % mirror      = 0
            myModel % numParts    = 1
            myModel % numSubParts = 1

            ! *.facet, *.data, *.check
            call myModel % get_vertex_and_face_data ( )
            call myModel % write_facet_file ( )
            call myModel % computeFaceStatistics ( )
            call myModel % write_face_areas ( )
            call myModel % analyze_lengths ( )
            call myModel % compute_centroid ( )
            call myModel % nearest_neighbors ( )
            call myModel % write_vertex_statistics ( )
            call myModel % analyze_nearest ( )
            call myModel % write_nearest_neighbors ( )

        return
    end subroutine main_process_sub

end module mProcessControl
