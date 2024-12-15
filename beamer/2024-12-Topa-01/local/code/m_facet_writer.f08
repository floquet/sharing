! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mFacetWriter

    use, intrinsic :: iso_fortran_env,  only : iostat_end
    ! ! class structures
    use mClassFace,                     only : face
    use mClassVertex,                   only : vertex
    ! utilities
    use mFormatDescriptors,             only : fmt_one, fmt_two, fmt_three, fmt_four, fmt_datecom, fmt_stat, fmt_iomsg
    use mPrecisionDefinitions,          only : ip

    implicit none

    integer ( ip ) :: io_stat = 0
    character ( len = 512 ) :: io_msg = ""

! NASA/LDTM—201502
! Mercury Method of Moments and MMViz
! User's Guide
! Facet File Format and Sample File
! p. 121

contains

    subroutine writeFaces ( u_facet, faces )

        type ( face ),  intent ( in ) :: faces ( : )
        integer ( ip ), intent ( in ) :: u_facet

        integer ( ip ) :: k = 0, nf = 0

            nf = size ( faces, 1 )

            ! Line N: V1 V2 V3 M [M1 M2] FORMAT (3(I7,1X),I7 [,2(1X,I7)])
            do k = 1, nf
                write ( unit = u_facet, fmt = 100, iostat = io_stat, iomsg = io_msg ) faces ( k ) % indexVertex, 0
                if ( io_stat /= 0 ) then
                    write ( * , fmt_one  ) "Write error on N line of facet"
                    write ( * , fmt_four ) "At element ", k, " of ", nf
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop "Program crashed in subroutine writeFaces..."
                end if
            end do

        return
        100 format ( 4 ( I7 ) )
    end subroutine writeFaces

    subroutine writeHeaderFace ( u_facet, numSubParts, subPartName, numFaces )

        integer ( ip ),        intent ( in ) :: u_facet, numSubParts, numFaces
        character ( len = * ), intent ( in ) :: subPartName

            ! Line G: NSP FORMAT (I5)
            ! number of subparts
            write ( unit = u_facet , fmt = '( I5 )', iostat = io_stat, iomsg = io_msg ) numSubParts
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Write error on G line, number of subparts"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine writeHeaderFace..."
            endif

            ! Line H: SUBPARTNAME FORMAT (A20)
            write ( unit = u_facet , fmt = '( A20 )', iostat = io_stat, iomsg = io_msg ) subPartName
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Write error on H line, subpart name"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine writeHeaderFace..."
            endif

            ! No Line I in document (p. 123)

            ! Line J: ET NSE NSV EM2 VP VN EC R0 R1 BC FORMAT (10I7)
            !   ET  Type of element (Edge=2, Triangle=3, MIXED=15, etc)
            !   NSE Number of elements in current subpart - always non-zero
            !   NSV Number of vertices in the current subpart - non-0 if VP=1 or VN=1
            !   EM2 Parameter set to 1 if two-sided material fields have been defined, and 0 otherwise
            write ( unit = u_facet , fmt = '( 10I7 )', iostat = io_stat, iomsg = io_msg ) 3, numFaces, 0, 0, 0, 0, 0
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Write error on J line of facet (partname)"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine writeHeaderFace..."
            endif

            ! Line K: U V VID FORMAT (10(F10.7,1X),I7)
            !   ( U V ) 2-D coordinates in the parameter space of the original surface
            !   VID     Index of part vertex in range [1, NV]
            !   * There will be NSV copies of this line if VP = 1
            ! or line N?

        return
    end subroutine writeHeaderFace

    subroutine writeVertices ( u_facet, vertices )

        type ( vertex ), intent ( in ) :: vertices ( : )
        integer ( ip ),  intent ( in ) :: u_facet

        integer ( ip ) :: k = 0, nv = 0

            nv = size ( vertices, 1 )

            ! Line E: NV FORMAT (I7)
            ! number of vertices
            write ( unit = u_facet , fmt = '( I7 )', iostat = io_stat, iomsg = io_msg ) nv
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Write error on E line of facet (number of vertices)"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine writeVertices..."
            endif

            ! Line F: X Y Z FORMAT (2(F14.6,1X),F14.6)
            do k = 1, nv
                write ( unit = u_facet, fmt = 100, iostat = io_stat, iomsg = io_msg ) vertices ( k ) % position
                !write ( unit = u_facet, fmt = 100, iostat = io_stat, iomsg = io_msg ) vertices ( k ) % position, &
                !                                                                      vertices ( k ) % area
                if ( io_stat /= 0 ) then
                    write ( * , fmt_one  ) "Write error on F line of facet (number of vertices)"
                    write ( * , fmt_four ) "At element ", k, " of ", nv
                    write ( * , fmt_stat )  io_stat
                    write ( * , fmt_iomsg ) io_msg
                    stop "Program crashed in subroutine writeVertices..."
                end if
            end do

        return
        100 format ( 2 ( F14.6, 1X ), F14.6 )
        !100 format ( 2 ( F14.6, 1X ), F14.6, ", area = ", g0 )
    end subroutine writeVertices

    subroutine writeHeaderVertex ( u_facet, numParts, partName, mirror )

        integer ( ip ),        intent ( in ) :: u_facet, numParts, mirror
        character ( len = * ), intent ( in ) :: partName
        ! containers for date and time
        integer ( ip ) :: dt_values ( 1 : 8 ) = 0
        character ( len =  80 ) :: string = ""

            call date_and_time ( VALUES = dt_values )
            write ( unit = string , fmt = '( I5, 2 ( "-", I2.2 ), I3, 2 ( ":", I2.2 ) )' ) dt_values ( 1 : 3 ), dt_values ( 5 : 7 )

            ! Line A: Revision Date/Time Machine FORMAT (A80)
            write ( unit = u_facet , fmt = fmt_two, iostat = io_stat, iomsg = io_msg ) "facet-maker.f08 ", trim ( string )
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Write error on A, first line of facet"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine writeHeaderVertex..."
            endif

            ! Line B: NP FORMAT (I5)
            ! number of parts
            write ( unit = u_facet , fmt = '( I5 )', iostat = io_stat, iomsg = io_msg ) numParts
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Write error on B line of facet (number of parts)"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine writeHeaderVertex..."
            endif

            ! Line C: PARTNAME FORMAT (A)
            write ( unit = u_facet , fmt = fmt_one, iostat = io_stat, iomsg = io_msg ) trim ( partName )
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Write error on C line of facet (partname)"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine writeHeaderVertex..."
            endif

            ! Line D: MIRROR [A B C D] FORMAT (I1 [,4(1X,F8.6)])
            ! MIRROR - If 0, part is not mirrored and A, B, C, and D are not present
            ! - If 1, only half of the part is defined and the implicit half
            ! is produced by reflecting the defined half about the plane: Ax + By + Cz = D
            write ( unit = u_facet , fmt = '( I1 )', iostat = io_stat, iomsg = io_msg ) mirror
            if ( io_stat /= 0 ) then
                write ( * , fmt_one ) "Write error on D line of facet (mirror)"
                write ( * , fmt_stat )  io_stat
                write ( * , fmt_iomsg ) io_msg
                stop "Program crashed in subroutine writeHeaderVertex..."
            endif

        return
    end subroutine writeHeaderVertex

end module mFacetWriter
