! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
module mProcessControl

    use mClassDataFile,                 only : dataFile4112
    use mLibraryOfConstants,            only : fileNameLength, messageLength
    use mPrecisionDefinitions,          only : ip, rp

    implicit none

    integer ( ip ), parameter :: fnl = fileNameLength

contains

    subroutine main_process_sub ( MoMdata, file4112Name )
        type ( dataFile4112 ) :: MoMdata
        character ( len = fnl ), intent ( in ) :: file4112Name

        return
    end subroutine main_process_sub

end module mProcessControl
