! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mRCS

    use mFileHandling,                  only : safeopen_writereplace
    use mFormatDescriptors,             only : fmt_stat, fmt_iomsg
    use mLibraryOfConstants,            only : tab, msgl, rl
    use mPrecisionDefinitions,          only : ip, sp, rp

    implicit none

    integer :: io_rcs = 0, io_stat = 0
    character ( len = 1024 ) :: io_msg = ""

    integer ( ip ), parameter :: numAngles = 360, numNu = 28, numElements = numAngles * numNu
    character ( len = * ), parameter :: crashModule = "Program crashed in module 'mRCS',"

    type :: rcs
        real ( sp ) :: values ( 1 : numAngles, 1 : numNu )
        character ( len = rl ) :: binaryDataFileName = ""
        integer ( ip ) :: tag = 0
    contains
        procedure, public :: readBinaryFile => readBinaryFile_sub
        procedure, public :: writeRCSdata   => writeRCSdata_sub
    end type rcs

    type ( rcs ), parameter :: rcs0 = rcs ( values = 0.0, binaryDataFileName = "", tag = 0 )

    private :: readBinaryFile_sub, writeRCSdata_sub

contains

    subroutine writeRCSdata_sub ( me, io_json, stride )
        ! hint for stride lengths:
        ! 360 = 2^3 3^2 5
        class ( rcs ),         target :: me
        integer ( ip ), intent ( in ) :: io_json, stride
        real ( sp ) :: meanRCS = 0.0
        character ( len = msgl ) :: crash = ""
        character ( len =   64 ) :: strFreq = "", strElev = "", strAzmth = "", strRCS = "", strStart = "", strEnd = "", strAll = ""
        character ( len =    6 ) :: firstSixDigits = ""
        integer ( ip ) :: jStride = 0, kNu = 0, kAzimuth = 0
            crash = trim ( crashModule ) // " subroutine 'writeRCSdata_sub'."
            call readBinaryFile_sub ( me )
            ! build output line by crafting str... variables
            write ( strStart, fmt = '(  g0 )' ) trim ( "{" )
            write ( strEnd,   fmt = '(  g0 )' ) trim ( '},' )
            write ( strElev,  fmt = '( 3g0 )' ) trim ( '"Elev":' ), me % tag, ','
            sweep_frequency: do kNu = 1, numNu
                write ( strFreq, fmt = '( 3g0 )' ) trim ( '"Freq":' ), kNu + 2, ','
                sweep_azimuth: do kAzimuth = 1, numAngles, stride
                    write ( strAzmth, fmt = '( 3g0 )' ) trim ( '"Azmth":' ), kAzimuth, ','
                    ! average STRIDE elements
                    meanRCS = sum ( [ ( me % values ( kAzimuth + jStride, kNu ), jStride = 0, stride - 1 ) ] ) / real ( stride, sp )
                    write ( strAll, fmt = '(  g0 )' ) meanRCS
                    ! truncate RFS value at six digits
                    firstSixDigits = strAll ( 1 : 6 )
                    write ( strRCS, fmt = '( 3g0 )' ) '"RCS":', firstSixDigits
                    ! assemble pieces to form complete line
                    write ( io_json, fmt = '( 8X, 6g0 )' ) trim ( strStart ), trim ( strFreq ), trim ( strElev ), &
                                                           trim ( strAzmth ), trim ( strRCS ),  trim ( strEnd )
                end do sweep_azimuth
            end do sweep_frequency
        return
    end subroutine writeRCSdata_sub

    subroutine readBinaryFile_sub ( me )
        class ( rcs ), target :: me
        character ( len = msgl ) :: crash = ""
        integer ( ip ) :: sizeInBytes = 0, elementsFound = 0

            crash = trim ( crashModule ) // " subroutine 'readBinaryFile_sub'."

            ! measure the size of the file
            inquire ( file = me % binaryDataFileName, size = sizeInBytes, iomsg = io_msg, iostat = io_stat )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) "Failure on INQUIRE for file '", trim ( me % binaryDataFileName ), "."
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop crash
            end if

            ! first and last element are file size
            elementsFound = ( sizeInBytes - 8 ) / 4
            if ( elementsFound - numAngles * numNu /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Error: trying to read binary data file ", trim ( me % binaryDataFileName )
                write ( * , fmt = '( 7g0 )' ) "Expected size of data file: ", numAngles, " rows * ", numNu, " columns = ", &
                                                numElements, " elements"
                write ( * , fmt = '( 3g0 )' ) "Measured size of data file = ", sizeInBytes, " bytes"
                write ( * , fmt = '( 3g0 )' ) "At 4 bytes per element, this is ", elementsFound, " elements"
                write ( * , fmt = '( 3g0 )' ) "Discrepancy = ", elementsFound - numAngles * numNu, " elements"
                stop crash
            end if

            open ( newunit = io_rcs, file = me % binaryDataFileName, action = 'READ', form = 'UNFORMATTED', &
                                 iostat = io_stat, iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 3g0 )' ) "Failure to OPEN file '", trim ( me % binaryDataFileName ), &
                                              "' for UNFORMATTED reading."
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop crash
            end if

            read ( io_rcs, iostat = io_stat,  iomsg = io_msg ) me % values
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure on UNFORMATTED READ from io_rcs = ", io_rcs
                write ( * , fmt = '( 3g0 )' ) "Trying to read list of RCS values '", trim ( me % binaryDataFileName ), "'"
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop crash
            end if

            close ( unit = io_rcs, iostat = io_stat,  iomsg = io_msg )
            if ( io_stat /= 0 ) then
                write ( * , fmt = '( 2g0 )' ) "Failure on CLOSE for io_rcs = ", io_rcs
                write ( * , fmt_stat  ) io_stat
                write ( * , fmt_iomsg ) trim ( io_msg )
                stop crash
            end if

        return
    end subroutine readBinaryFile_sub

end module mRCS
