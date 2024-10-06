! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mAssetProperties

    use mAllocations,                   only : allocationToolKit, allocationToolKit0
    use mFileHandling,                  only : safeopen_writereplace
    use mFormatDescriptors,             only : fmt_stat, fmt_iomsg
    use mLibraryOfConstants,            only : tab, msgl, rl
    use mPrecisionDefinitions,          only : ip, rp
    use mRCS,                           only : rcs

    implicit none

    integer ( ip ) :: io_json = 0, io_stat = 0

    character ( len = msgl ) :: io_msg = ""
    character ( len = * ), parameter :: crashModule = "Program crashed in module 'assetProperties',"

    type ( allocationToolKit ) :: myKit = allocationToolKit0

    type :: asset
        ! rank 1
        integer ( ip ), allocatable :: rcsCases ( : )
        ! rank 0
        integer ( ip ) :: numCases     = 0
        integer ( ip ) :: nominalSpeed = 0
        integer ( ip ) :: CIT          = 0
        integer ( ip ) :: stride       = 0
        character ( len = rl ) :: Label          = ""
        character ( len = rl ) :: ICONImage      = ""
        character ( len = rl ) :: description    = ""
        character ( len = rl ) :: jsonFileName   = ""
        character ( len = rl ) :: binaryFileName = ""
        character ( len = rl ) :: rcsPrefix      = ""
        character ( len = rl ) :: rcsSuffix      = ""
    contains
        procedure, public :: printAssetProperties => printAssetProperties_sub
        procedure, public :: writeJSON            => writeJSON_sub
        procedure, public :: writeBinary          => writeBinary_sub
    end type asset

    private :: printAssetProperties_sub
    private :: writeBinary_sub, writeFooter_sub, writeHeader_sub, writeJSON_sub

contains

    subroutine writeBinary_sub ( me, rcsCases )
        class ( asset ), target :: me
        integer ( ip ), intent ( in ) :: rcsCases ( : )
        real( rp ),  allocatable :: one ( : )
        real( rp )               :: sumRCS = rZero, meanRCS = rZero
        type     ( rcs )         :: rcsProfile
        integer   ( ip )         :: kCases = 0, kNu = 0, kAzimuth = 0
        character ( len = msgl ) :: crash = ""

            crash = trim ( crashModule ) // " subroutine 'writeBinary_sub'."

            ! allocate according to number of elevation angles
            me % numCases = size ( rcsCases, 1 )
            call myKit % allocate_rank_one_integers ( integer_array = me % rcsCases, index_min = 1,  index_max = me % numCases )
            me % rcsCases ( : ) = rcsCases ( : )
            ! generate file name
            write ( me % binaryFileName, 100 ) trim ( me % rcsPrefix ), me % rcsCases ( kCases ), trim ( ".r32" )
            write ( * , fmt = '( 2g0 )' ) "me % binaryFileName = ", trim ( me % binaryFileName )
            ! open file for unformatted WRITE
            open ( newunit = io_rcs, file = me % binaryFileName, action = 'WRITE', form = 'UNFORMATTED', &
                                 iostat = io_stat, iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) "Failure to OPEN file '", trim ( me % binaryFileName ), &
                                              "' for UNFORMATTED writing."
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop crash
            end if

            ! vectors rule; do loops suck
            call myKit % allocate_rank_one_reals ( real_array = 1.0_rp, index_min = 1, index_max = 6 )
            one ( : ) = 1.0_rp
            sweep_elevation_angles: do kCases = 1, me % numCases
                sweep_frequency: do kNu = 1, numNu
                    sweep_azimuth: do kAzimuth = 1, numAngles, stride
                        sumRCS = dot_product ( [ ( me % values ( kAzimuth + jStride, kNu ), jStride = 0, stride - 1 ) ], one )
                        meanRCS = sumRCS / dot_product ( one, one )
                        write ( io_rcs, iostat = io_stat,  iomsg = io_msg ) meanRCS
                        if ( io_stat /= 0 ) then
                            write ( * , fmt = '( 2g0 )' ) "Failure on UNFORMATTED WRITE from io_rcs = ", io_rcs
                            write ( * , fmt = '( 3g0 )' ) "WRITING average RCS values to '", trim ( me % binaryFileName ), "'"
                            write ( * , fmt_stat  ) io_stat
                            write ( * , fmt_iomsg ) trim ( io_msg )
                            stop crash
                        end if
                    end do sweep_azimuth
                end do sweep_frequency
            enddo sweep_elevation_angles

            close ( unit = io_rcs, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure on CLOSE for io_rcs = ", io_rcs
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop crash
            end if

        return
        100 format ( g0, I3.3, g0 )
    end subroutine writeBinary_sub

    subroutine writeJSON_sub ( me, rcsCases )
        class ( asset ), target :: me
        integer ( ip ), intent ( in ) :: rcsCases ( : )
        type ( rcs ) :: rcsProfile
        integer ( ip ) :: kCases = 0
        character ( len = rl ) :: rcsDataFileName
            ! allocate according to number of elevation angles
            me % numCases = size ( rcsCases, 1 )
            call myKit % allocate_rank_one_integers ( integer_array = me % rcsCases, index_min = 1,  index_max = me % numCases )
            me % rcsCases ( : ) = rcsCases ( : )
            ! JSON file header
            call writeHeader_sub ( me )
            sweep_elevation_angles: do kCases = 1, me % numCases
                write ( rcsDataFileName, 100 ) trim ( me % rcsPrefix ), me % rcsCases ( kCases ), trim ( me % rcsSuffix )
                write ( * , fmt = '( 2g0 )' ) "rcsDataFileName = ", trim ( rcsDataFileName )
                rcsProfile % binaryDataFileName = trim ( rcsDataFileName )
                rcsProfile % tag = rcsCases ( kCases )
                call rcsProfile % writeRCSdata ( io_json = io_json, stride = me % stride )
            enddo sweep_elevation_angles
            call writeFooter_sub ( me, io_json = io_json )
        return
        100 format ( g0, I3.3, g0 )
    end subroutine writeJSON_sub

    subroutine writeHeader_sub ( me )
        class ( asset ), target :: me

            io_json = safeopen_writereplace ( me % jsonFileName )

            write ( io_json, fmt = '(  g0 )' ) "{"
            write ( io_json, fmt = '( 4g0 )' ) tab, '"Label":"',       trim ( me % Label ), '",'
            write ( io_json, fmt = '( 4g0 )' ) tab, '"ICONImage":"',   trim ( me % ICONImage ), '",'
            write ( io_json, fmt = '( 4g0 )' ) tab, '"description":"', trim ( me % description ), '",'
            write ( io_json, fmt = '( 4g0 )' ) tab, '"nominalSpeed":', me % nominalSpeed, ','
            write ( io_json, fmt = '( 4g0 )' ) tab, '"CIT":',          me % CIT, ','
            write ( io_json, fmt = '( 2g0 )' ) tab, '"crossSection":['

        return
    end subroutine writeHeader_sub

    subroutine writeFooter_sub ( me, io_json )
        class ( asset ), target :: me
        integer ( ip ), intent ( in ) :: io_json
        character ( len = msgl ) :: crash = ""

            crash = trim ( crashModule ) // " subroutine 'writeFooter_sub'."

            write ( io_json, fmt = '( 2g0 )' ) tab, "]"
            write ( io_json, fmt = '(  g0 )' ) "}"

            ! close io handle
            call fileCloser_sub ( io_unit = io_json, fileName = me % jsonFileName, crashChain = crash )

            write ( * , fmt = '( 2g0 )' ) "JSON data written to ", me % jsonFileName

        return
    end subroutine writeFooter_sub

    subroutine printAssetProperties_sub ( me )
        class ( asset ), target :: me

            write ( * , fmt = '(  g0 )' ) "Asset properties:"
            write ( * , fmt = '( 2g0 )' ) "Label        = ", trim ( me % Label )
            write ( * , fmt = '( 2g0 )' ) "ICONImage    = ", trim ( me % ICONImage )
            write ( * , fmt = '( 2g0 )' ) "description  = ", trim ( me % description )
            write ( * , fmt = '( 2g0 )' ) "nominalSpeed = ", me % nominalSpeed
            write ( * , fmt = '( 2g0 )' ) "CIT          = ", me % CIT

        return
    end subroutine printAssetProperties_sub

    subroutine fileCloser_sub ( io_unit, fileName, crashChain, optionalMessage )
        integer ( ip ),                  intent ( in ) :: io_unit
        character ( len = * ),           intent ( in ) :: fileName, &
                                                          crashChain
        character ( len = * ), optional, intent ( in ) :: optionalMessage

            close ( unit = io_unit, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure to CLOSE for me % io_unit = ", io_unit
                write ( * , fmt = '( 2g0 )' ) "File name = '", trim ( fileName ), "'"
                if ( present ( optionalMessage ) ) then
                    write ( * , fmt = '( g0 )' ) trim ( optionalMessage )
                end if
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop trim ( crashChain )
            end if

        return
    end subroutine fileCloser_sub

end module mAssetProperties
