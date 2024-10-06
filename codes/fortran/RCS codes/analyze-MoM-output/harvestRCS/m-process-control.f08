! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mProcessControl

    use mClassDataFile,                 only : dataFile4112
    use mLibraryOfConstants,            only : fileNameLength
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength

contains

    subroutine main_process_sub ( MoMdata, file4112Name )
        type ( dataFile4112 ) :: MoMdata
        character ( len = fnl ), intent ( in ) :: file4112Name

            write ( * , fmt = '( 3g0 )' ) "looking for file = '", trim ( file4112Name ), "'"
            call MoMdata % set_file_names ( file4112Name = file4112Name )
            call MoMdata % set_free_angle_azimuth ( )
            ! set up frequency mesh by reading frequency values
            call MoMdata % establish_frequency_mesh ( )
            call MoMdata % meshFrequency % print_real_mesh_summary ( dataType = "frequency" )
            ! set up angle mesh by counting measurements and then setting a data range
            call MoMdata % establish_free_angle_mesh ( angle_min = -180.0_rp, angle_max = 179.0_rp )
            call MoMdata % meshFreeAngle % create_valuesFormatDescriptor ( )
            ! check angle mesh
            call MoMdata % meshFreeAngle % print_real_mesh_summary ( dataType = MoMdata % angleFreeType )
            ! allocate RCS container for single MoM file, and the aggregate container
            call MoMdata % allocate_rcs_tables ( )
            call MoMdata % allocate_rcsAverages ( )
            call MoMdata % check_rcs_table_structure ( )
            ! read electric field values, compute rcs
            call MoMdata % extract_rcs_from_4112_file ( )
            call MoMdata % characterize_rcs_by_frequency ( )
            ! output results to file and summary to screen
            call MoMdata % write_rcs_file_set ( )
            call MoMdata % write_summary_by_frequency ( )
            call MoMdata % write_debug_file ( )
        return
    end subroutine main_process_sub

end module mProcessControl
