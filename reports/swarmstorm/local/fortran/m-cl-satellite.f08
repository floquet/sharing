! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! ======================================================================================
! Module: mClassSatellite
! Purpose:
!   Defines the `satellite` type and its operations, including creation, parameter 
!   modification, listing, class summaries, and memory allocation management.
!
! Public Routines:
! - set_satellite_parameters_sub: Modifies satellite parameters.
! - list_satellite_parameters_sub: Lists parameters of a single satellite.
! - print_satellite_class_summary: Summarizes a class of satellites.
!! ======================================================================================
module mClassSatellite

    use, intrinsic :: iso_fortran_env,  only : stdin  => input_unit, &
                                               stdout => output_unit, &
                                               stderr => error_unit
    use mFormatDescriptorsAllocations,  only : fmt_allocerror, fmt_allocstat, fmt_allocmsg, fmt_allocsize
    use mFormatDescriptorsBasics,       only : fmt_one, fmt_two, fmt_three
    use mLibConstants,                  only : UUID_SIZE, empty_uuid, alpha_upper_case, fnl, one, zero, COLOR_BLUE, COLOR_BLACK
    use mUtilities,                     only : generateUUID
    use mPrecisionDefinitions,          only : rp, ip, kindA

    implicit none
    ! Declare Loop Index Variables Locally:  Always declare loop index variables inside the 
    ! subroutine or function where they are used. Global dummies violate loop index integrity.
    integer ( kind = ip ) :: io = stdout, allocStatus = 0_ip
    character ( kind = kindA, len = 15 ), parameter :: nameModule = "mClassSatellite"
    character ( kind = kindA, len = fnl ) :: allocMessage = "", myKind = ""


    ! Fortran achieves a clean separation between declaration and visibility adjustment, 
    ! ensuring code remains readable and maintainable.
    type :: satellite
        ! rank 2
        integer ( kind = ip ), dimension ( 1 : UUID_SIZE ) :: uuid
        character ( kind = kindA, len = 36 ) :: moniker, model
        ! rank 1
        real ( kind = rp ) :: mass_metal   = 0.0_rp, mass_fuel      = 0.0_rp, fuel_burn_rate = 0.0_rp
        real ( kind = rp ) :: radius_orbit = 0.0_rp, energy_kinetic = 0.0_rp
        real ( kind = rp ) :: time_born    = 0.0_rp, time_end       = 0.0_rp, time_attack    = 0.0_rp
        integer ( kind = ip ) :: index, color
 
    contains

        ! Type-bound procedures
        ! PROCEDURE inside a type defines how the type behaves and ties methods directly to it.
        procedure, public :: list_satellite_parameters    => list_satellite_parameters_sub, &
                             set_satellite_parameters     => set_satellite_parameters_sub                            
    end type satellite

    type ( satellite ), parameter :: baseSatellite = satellite ( &
        uuid           = empty_uuid,                        &           ! Default or uninitialized UUID
        model          = "null",                            &           ! Name of the satellite model
        moniker        = "null",                            &           ! Satellite moniker
        mass_metal     = zero,                              &           ! Metal mass in appropriate units
        mass_fuel      = zero,                              &           ! Fuel mass in appropriate units
        fuel_burn_rate = zero,                              &           ! Fuel consumption rate
        radius_orbit   = zero,                              &           ! Orbital radius in kilometers
        energy_kinetic = zero,                              &           ! Initial kinetic energy
        time_born      = zero,                              &           ! Time of creation
        time_end       = zero,                              &           ! Time when the satellite will be decommissioned
        time_attack    = zero,                              &           ! Time for any specific mission or attack
        index          = 0_ip,                              &           ! Unique identifier within its type
        color          = COLOR_BLACK )                                  ! Wheeler convention

    ! accessibility declarations: which entities are accessible outside the module or type
    ! control module-level visibility without redefining or duplicating entity declarations

    public :: manage_satellite_allocation_sub, print_satellite_class_summary_sub

contains

    ! type or class?

    ! Criterion         Type                Class
    ! polymorphism      not supported       support
    ! type saftey       compile time only   run-time checks for extension
    ! dynamic dispatch  not supported       supported
    ! performance       slightly faster     slight overhead
    ! flexibility       rigid               extensible

    ! dispatch: static or dynamic
    ! Criterion            Static Dispatch          Dynamic Dispatch
    ! resolution time      compile-time             runtime
    ! procedure selection  based on declared type   based on actual type
    ! polymorphism         not supported            supported
    ! flexibility          limited                  highly extensible
    ! performance          faster (no runtime cost) slight overhead (vtable lookup)
    ! use case             simple, fixed behavior   polymorphic, extensible designs

    ! The price for immutability: ensure key attributes are intent(in) or private within the type

    ! Dynamic dispatch is a mechanism in object-oriented programming that determines which implementation 
    ! of a polymorphic procedure to invoke at runtime based on the dynamic (actual) type of the object, 
    ! rather than its static (declared) type.

!   =================================================================================================                         update

    subroutine set_satellite_parameters_sub ( self, mass_metal, mass_fuel, radius_orbit, fuel_burn_rate, energy_kinetic, &
            time_born, time_end, time_attack, moniker, model, index, color, uuid )

        ! external arguments
        ! class is used to allow polymorphism for derived types
        class ( satellite ), intent ( inout ) :: self
        ! rank 2
        integer    ( kind = ip ), dimension ( 1 : UUID_SIZE ), intent ( in ), optional :: uuid! Array representation of UUID
        ! rank 1
        integer    ( kind = ip ),    intent ( in ), optional :: index, color
        real       ( kind = rp ),    intent ( in ), optional :: mass_metal, mass_fuel, fuel_burn_rate, energy_kinetic, &
                    radius_orbit, time_born, time_end, time_attack
         character ( kind = kindA, len = * ), intent ( in ), optional :: moniker, model
            if ( present ( mass_metal ) )     self % mass_metal     = mass_metal
            if ( present ( mass_fuel ) )      self % mass_fuel      = mass_fuel
            if ( present ( fuel_burn_rate ) ) self % fuel_burn_rate = fuel_burn_rate
            if ( present ( energy_kinetic ) ) self % energy_kinetic = energy_kinetic
            if ( present ( radius_orbit ) )   self % radius_orbit   = radius_orbit
            if ( present ( time_born ) )      self % time_born      = time_born
            if ( present ( time_end ) )       self % time_end       = time_end
            if ( present ( time_attack ) )    self % time_attack    = time_attack
            if ( present ( moniker ) )        self % moniker        = trim ( moniker )
            if ( present ( model ) )          self % model          = trim ( model )
            if ( present ( index ) )          self % index          = index
            if ( present ( color ) )          self % color          = color
            if ( present ( uuid ) )           self % uuid           = uuid
        return
    end subroutine set_satellite_parameters_sub

!   =================================================================================================

    ! This subroutine uses `class` to allow polymorphism and dynamic dispatch.
    ! It is read-only (`intent(in)`), ensuring safety and encapsulation.
    ! The design choice reflects the need to handle derived types of `satellite`
    ! without modifying the original object.
    subroutine list_satellite_parameters_sub ( self, io_unit )
        ! This routine was written with guidance and collaboration from Achates (ChatGPT by OpenAI).
        ! Generates a detailed list of satellite parameters with an optional I/O handle.

        ! external arguments
        ! class is used to allow polymorphism for derived types
        class ( satellite ), intent ( in ) :: self
        integer,             intent ( in ), optional :: io_unit  ! Optional I/O unit

        ! internal variables
        integer ( kind = ip ) :: k

        ! Determine which I/O unit to use
        if ( present ( io_unit ) ) then
            io = io_unit
        else
            io = stdout  ! Default to standard output (stdout)
        endif

        ! Print the satellite parameters
        write ( io, fmt = fmt_one ) "Satellite Parameters:"
        write ( io, fmt = fmt_two ) "Mass (Metal):       ", self % mass_metal
        write ( io, fmt = fmt_two ) "Mass (Fuel):        ", self % mass_fuel
        write ( io, fmt = fmt_two ) "Radius (Orbit):     ", self % radius_orbit
        write ( io, fmt = fmt_two ) "Energy (Kinetic):   ", self % energy_kinetic
        write ( io, fmt = fmt_two ) "Time Born:          ", self % time_born
        write ( io, fmt = fmt_two ) "Time End:           ", self % time_end
        write ( io, fmt = fmt_two ) "Time Attack:        ", self % time_attack
        write ( io, fmt = fmt_two ) "Moniker:               " // trim ( self % moniker )

        ! Print UUID as hexadecimal with colons
        write ( unit = io, fmt = fmt_one, advance = "no" ) "UUID:                  "
        do k = 1, UUID_SIZE - 1
            write ( io, "( Z2.2, g0 )", advance = "no" ) self % uuid ( k ), ":"
        end do
        write ( io, "( Z2.2 )" ) self % uuid ( UUID_SIZE )

        return
    end subroutine list_satellite_parameters_sub

!   =================================================================================================

    subroutine print_satellite_class_summary_sub ( satellite_class_name, satellites, io_unit )
        ! external arguments
        ! class is used to allow polymorphism for derived types
        class ( satellite ), dimension ( : ), intent ( in ) :: satellites ( : )

        character ( kind = kindA, len = * ), intent ( in ) :: satellite_class_name
        integer ( kind = ip ), optional,     intent ( in ) :: io_unit  ! Optional I/O unit for printing

        ! internal variables
        integer ( kind = ip ) :: num_satellites = 0, k

        ! Determine the output unit
        if ( present ( io_unit ) ) then
            io = io_unit
        else
            io = stdout  ! Default to standard output (stdout)
        end if

        ! Calculate the number of satellites
        num_satellites = size ( satellites )

        ! Output the summary
        write ( io, fmt = fmt_three ) "There are ", num_satellites, " satellites in this class with properties:"
        write ( io, fmt = fmt_one )   "Class Name: " // trim(satellite_class_name)
        write ( io, fmt = fmt_one )   "-----------------------------------"

        ! Loop over satellites and use the list_satellite_parameters_sub routine
        do k = 1, num_satellites
            write ( io, fmt = fmt_two ) "Satellite ", k
            ! satellite type encapsulates its structure and logic, exposing only a clean, well-defined interface
            call satellites ( k ) % list_satellite_parameters ( io_unit = io )
            write ( io, fmt = fmt_one ) "-----------------------------------"
        end do

        return
    end subroutine print_satellite_class_summary_sub

!   =================================================================================================

    subroutine manage_satellite_allocation_sub ( satelliteArray, count )
        ! external arguments
        ! class is used to allow polymorphism for derived types
        type ( satellite ), dimension ( : ), allocatable, intent ( inout ) :: satelliteArray
        integer   ( kind = ip ),                           intent ( in )    :: count
        character ( kind = kindA, len = 31 ), parameter                     :: nameRoutine = "manage_satellite_allocation_sub"
        ! internal variables
        character ( kind = kindA, len = 256 )                               :: contextError

        contextError = "Error occured in module " // trim ( nameModule ) // ", routine " // trim ( nameRoutine ) // "."
 
        ! Deallocate if already allocated
        if ( allocated ( satelliteArray ) ) then
            deallocate ( satelliteArray, stat = allocStatus, errmsg = allocMessage )
            call post_error_message_composite_sub ( count = count, actionName = "Deallocating", &
                    errorDetail = "Unexpected deallocation", contextError = contextError )
        end if

        ! Allocate the array
        allocate ( satelliteArray ( count ), stat = allocStatus, errmsg = allocMessage )
        call post_error_message_composite_sub ( count = count, actionName = "Allocating  satellites.", &
                errorDetail = "Failed to allocate array", contextError = contextError )
        return
    end subroutine manage_satellite_allocation_sub

    subroutine post_error_message_composite_sub ( count, actionName, errorDetail, contextError )
        ! external arguments
        integer   ( kind = ip ),             intent ( in )           :: count
        character ( kind = kindA, len = * ), intent ( in )           :: actionName
        character ( kind = kindA, len = * ), intent ( in ), optional :: errorDetail, contextError

        if ( allocStatus == 0 ) return
        write ( *, fmt = fmt_allocerror ) actionName, count
        write ( *, fmt = fmt_allocstat  ) allocStatus
        write ( *, fmt = fmt_allocmsg   ) trim ( allocMessage )
        if ( present ( errorDetail )  ) write ( *, fmt = fmt_one ) trim ( errorDetail )
        if ( present ( contextError ) ) write ( *, fmt = fmt_one ) trim ( contextError )

        stop "# # #  Failed memory allocation  # # #"

        return
    end subroutine post_error_message_composite_sub

end module mClassSatellite
