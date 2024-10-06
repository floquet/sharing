#! /usr/bin/python
# # Amanzi - David Moulton T-5
# # Daniel Topa  LANL/CCS-2  dantopa@lanl.gov  505 667 0817

# # Excel tools

# # imports
import os           # probe, change directories
import sys          # python version
import datetime     # https://stackoverflow.com/questions/415511/how-to-get-the-current-time-in-python
import xlsxwriter   # API for Excel

# # modules
def xl_new_workbook( workbook_title ):

    my_workbook = xlsxwriter.Workbook( workbook_title )

    xl_sheet_provenance( my_workbook ) # provenance sheet
    xl_sheet_requirements( my_workbook ) # summarize requirements by type

    return my_workbook;

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

def xl_sheet_requirements( this_workbook ):

    col = 0 # starting column
    row = 0 # starting row

    # header format
    format_title = this_workbook.add_format( )
    format_title.set_bold( )
    format_title.set_font_color( "blue" )

    # PASS
    sheet_requirements_pass = this_workbook.add_worksheet( "requirements - PASS" )
    xl_sheet_header_footer( sheet_requirements_pass )
    sheet_requirements_pass.write( row, col, "Summary or requirements PASSED", format_title )

    # FAIL
    sheet_requirements_fail = this_workbook.add_worksheet( "requirements - FAIL" )
    xl_sheet_header_footer( sheet_requirements_fail )
    sheet_requirements_fail.write( row, col, "Summary or requirements FAIL", format_title )

    # NULL
    sheet_requirements_null = this_workbook.add_worksheet( "requirements - NULL" )
    xl_sheet_header_footer( sheet_requirements_null )
    sheet_requirements_null.write( row, col, "Summary or requirements NULL", format_title )

    return;

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

def xl_sheet_generate( this_workbook, title_sheet ):

    # insure every worksheet has a header and footer
    mySheet = this_workbook.add_worksheet( title_sheet )
    xl_sheet_header_footer( mySheet )

    return mySheet;

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

def xl_sheet_provenance( this_workbook ):

    # forensic info
    sheet_provenance = xl_sheet_generate( this_workbook, "provenance" )

    #  # special formats
    # https://xlsxwriter.readthedocs.io/format.html?highlight=bold

    # method 1
    # setting the property as a dictionary of key/value pairs in the constructor
    format_title = this_workbook.add_format( )
    format_title.set_bold( )
    format_title.set_font_color( "blue" )

    # method 2
    # passing a dictionary of properties to the add_format() constructor
    format_time = this_workbook.add_format( {'num_format': 'yy/mm/dd hh:mm'} ) # https://xlsxwriter.readthedocs.io/working_with_dates_and_time.html

    # widen first columns
    sheet_provenance.set_column( "A:A", 15 )
    sheet_provenance.set_column( "B:B", 13 )

    # https://xlsxwriter.readthedocs.io/worksheet.html
    sheet_provenance.write_url( "A1", "https://github.com/amanzi/amanzi", string = "AMANZI: The Multi-Process HPC Simulator" )

    #  #  provencance
    sheet_provenance.write( "A3", "Workbook created by", format_title )
    #sheet_provenance.write( "A1", tip, "boo" )

    # python notebook which creates workbook
    sheet_provenance.write( "A4", "python source" )
    sheet_provenance.write( "B4", os.path.basename( __file__ ) ) # charlie.py

    # current working directory
    sheet_provenance.write( "A5", "directory" )
    sheet_provenance.write( "B5", os.getcwd( ) ) # /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/python/xlsx

    # python version
    sheet_provenance.write( "A6", "python version" )
    sheet_provenance.write( "B6", sys.version ) # "3.7.0 (default, Jun 28 2018, 07:39:16) [Clang 4.0.1 (tags/RELEASE_401/final)]"

    #  #  environment variables
    # practise row, col notation
    col = 0 # starting column
    row = 7 # starting row
    sheet_provenance.write( row, col, "Environment variables", format_title ); row += 1

    sheet_provenance.write( row, col, "$USER" ) # l127914
    sheet_provenance.write( row, col + 1, os.environ[ "USER" ] ); row += 1

    sheet_provenance.write( row, col, "$HOSTNAME" ) # Cauchy.Schwarz
    sheet_provenance.write( row, col + 1, os.environ[ "HOSTNAME" ] ); row += 1

    sheet_provenance.write( row, col, "$HOME" ) # /Users/l127914
    sheet_provenance.write( row, col + 1, os.environ[ "HOME" ] ); row += 1

    sheet_provenance.write( row, col, "timestamp" ) # 11/21/18 16:18
    sheet_provenance.write( row, col + 1, datetime.datetime.now( ), format_time ); row += 1

    #  #  Excel info routines
    # https://xlsxwriter.readthedocs.io/working_with_formulas.html

    row += 1 # jump
    sheet_provenance.write( row, col, "XL info function", format_title ); row += 1

    sheet_provenance.write( row, col, "platform" ) # mac
    sheet_provenance.write_formula( row, col + 1, '= INFO( "system" )' ); row += 1

    sheet_provenance.write( row, col, "recalculation mode" ) # Automatic
    sheet_provenance.write_formula( row, col + 1, '= INFO( "recalc" )' ); row += 1

    sheet_provenance.write( row, col, "active sheets" ) # 1
    sheet_provenance.write_formula( row, col + 1, '= INFO( "numfile" )' ); row += 1

    sheet_provenance.write( row, col, "cursor" ) # $A:$A$1
    sheet_provenance.write_formula( row, col + 1, '= INFO( "origin" )' ); row += 1

    sheet_provenance.write( row, col, "XL release" ) # 16.16
    sheet_provenance.write_formula( row, col + 1, '= INFO( "release" )' ); row += 1

    sheet_provenance.write( row, col, "application directory" ) # /Users/dantopa/Library/Containers/com.microsoft.Excel/Data/Documents/
    sheet_provenance.write_formula( row, col + 1, '= INFO( "directory" )' ); row += 1

    sheet_provenance.write( row, col, "operating systems" ) # Macintosh (Intel) Version 10.13.3 (Build 17D47)
    sheet_provenance.write_formula( row, col + 1, '= INFO( "osversion" )' ); row += 1

    return;

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

def xl_sheet_header_footer( this_worksheet ):

    # header: sheet name (center)
    # footer: date/time, page number, path/file

    myheader = "&C&12&A" # fontsize 12
    myfooter = "&L&8&T\n&8&D" + "&C &P / &N" + "&R&8&Z\n&8&F" # fontsize 8

    this_worksheet.set_header( myheader )
    this_worksheet.set_footer( myfooter )

    return;
