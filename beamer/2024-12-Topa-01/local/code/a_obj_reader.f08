! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mOBJreader

    use, intrinsic :: iso_fortran_env, only : iostat_end
    ! class structures
    use mClassFace,                    only : face
    use mClassVertex,                  only : vertex
    ! utilities
    use mClassCensus,                  only : census, lines
    use mFileHandling,                 only : safeopen_readonly
    use mFormatDescriptors,            only : fmt_one, fmt_two, fmt_three, fmt_four, fmt_stat, fmt_iomsg
    use mPrecisionDefinitions,         only : ip, rp
    use mParametersSimulation,         only : dim

    implicit none

    integer ( ip ) :: io_stat = 0, u_obj = 0
    character ( len = 512 ) :: io_msg = ""
    character ( len =   2 ) :: trash  = ""

! http://paulbourke.net/dataformats/obj/
! Object Files (.obj)

! https://www.cs.utah.edu/~boulos/cs3505/obj_spec.pdf
! B1. Object Files (.obj)
! If there are only vertices and vertex normals for a face element (no
! texture vertices), you would enter two slashes (//). For example, to
! specify only the vertex and vertex normal reference numbers, you
! would enter:
! f 1//1 2//2 3//3 4//4

contains

    subroutine getVertices ( u_obj, array, locators )
        ! tourists
        type ( vertex ), intent ( out ) :: array ( : )
        type ( lines ),  intent ( in )  :: locators
        integer ( ip ),  intent ( in )  :: u_obj
        ! locals
        integer ( ip ) :: j = 0, k = 0

        ! position line pointer
        rewind ( unit = u_obj, iostat = io_stat, iomsg = io_msg )
        call handleIOError ( "Error rewinding *.obj file to gather vertex data", io_stat, io_msg )

        ! Position pointer
        do k = 1, locators % first - 1
            read ( unit = u_obj, fmt = *, iostat = io_stat, iomsg = io_msg )
            call handleIOError ( "Error positioning read pointer", io_stat, io_msg )
        end do

        ! Read data
        do k = 1, locators % count
            read ( unit = u_obj, fmt = *, iostat = io_stat, iomsg = io_msg ) &
            trash, ( array ( k ) % position ( j ), j = 1, dim )
            call handleIOError ( "Read error at vertex element", io_stat, io_msg, "Element: " // trim ( adjustl ( k ) ) )
        end do

        return
    end subroutine getVertices

    ! https://stackoverflow.com/questions/61024072/how-to-use-fortran-to-read-the-face-information-from-a-obj-file
    subroutine getFaces ( u_obj, array, locators )
        ! tourists
        type ( face ),         intent ( out ) :: array ( : )
        type ( lines ),        intent ( in )  :: locators
        integer ( kind = ip ), intent ( in )  :: u_obj
        ! locals
        integer ( kind = ip ), dimension ( 1 : 6 ) :: indices
        integer ( kind = ip ) :: j = 0, k = 0
        character (  kind = kindA, len = 128 ) :: buffer = ""

        ! Rewind
        rewind ( unit = u_obj, iostat = io_stat, iomsg = io_msg )
        call handleIOError ( "Error rewinding *.obj file to gather face data", io_stat, io_msg )

        ! Position pointer
        do k = 1, locators % first - 1
            read ( unit = u_obj, fmt = *, iostat = io_stat, iomsg = io_msg )
            call handleIOError ( "Error positioning read pointer for face data", io_stat, io_msg )
        end do

        ! Read data
        do k = 1, locators % count
            read ( unit = u_obj, fmt = '( A )', iostat = io_stat, iomsg = io_msg ) buffer
            call handleIOError ( "Read error at face element", io_stat, io_msg, "Element: " // trim ( adjustl ( k ) ) )

            ! Remove slashes
            do j = 1, len ( buffer )
                if ( buffer ( j : j ) == "/" ) buffer ( j : j ) = " "
            end do

            ! Parse buffer
            read ( unit = buffer ( 2 : ), fmt = *, iostat = io_stat, iomsg = io_msg ) indices ( 1 : 6 )
            call handleIOError ( "Read error parsing face indices", io_stat, io_msg, "Buffer: " // trim ( buffer ) )

            ! Harvest indices
            array ( k ) % indexVertex ( : ) = indices ( 1 : 6 : 2 )
        end do

        return
    end subroutine getFaces

    subroutine handleIOError ( context, io_stat, io_msg, additional )
        ! Consolidated IO error handler
        use mFormatDescriptors, only : fmt_one, fmt_stat, fmt_iomsg
        implicit none
        ! Inputs
        character ( len = * ), intent ( in ) :: context       ! Description of the operation
        integer ( kind =ip ),  intent ( in ) :: io_stat       ! I/O status code
        character ( len = * ), intent ( in ) :: io_msg       ! I/O message
        character ( len = * ), intent ( in ), optional :: additional ! Additional information

        if ( io_stat /= 0 ) then
            write ( * , fmt_one ) trim ( context )
            if ( present ( additional ) ) write ( * , fmt_two ) trim ( additional )
            write ( * , fmt_stat ) io_stat
            write ( * , fmt_iomsg ) io_msg
            stop "Program crashed due to I/O error."
        end if
    end subroutine handleIOError


end module mOBJreader
