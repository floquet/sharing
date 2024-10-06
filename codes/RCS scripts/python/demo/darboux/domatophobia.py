#! /usr/bin/python
# # Amanzi: The Multi-Process HPC Simulator
# #   https://github.com/amanzi/amanzi

# # David Moulton   DGL LANL/T-5  moulton@lanl.gov  505 665 4712
# # Daniel Topa     LANL/CCS-2    dantopa@lanl.gov  505 667 0817

# # imports
import datetime             # timestamps
import os                   # opeating system
import sys                  # python version
from pathlib import Path    # rename file
import xlsxwriter           # API for Excel
# home brew
# classes
import cls_Book             # Book (constains chapters, contains requirements)
import cls_Chapter          # chapter (constains sections)
import cls_Element          # elements (required, optional)
import cls_Source           # e.q. Amanzi XML Input Specification (Version 2.3-draft)
# tools
import tools_debug
import tools_xl             # spreadsheet authoring tools

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

if __name__ == "__main__":

    # fundamental object: a book
    book = cls_Book.Book( ) # instantiate book
    book.source = cls_Source.Source( ) # instantiate source
    mySource = book.source

    # # source data
    mySource.input_rst = "short.rst"    # setter called
    mySource.path_rst  = "/Users/dantopa/Documents/repos/GitHub/topa-development/data/"
    # mySource.path_rst = "/Volumes/Tethys/repos/GitHub/topa-development/data/"
    # mySource.path_rst  = "/Volumes/Tlaltecuhtli/repos/GitHub/topa-development/data/"    # setter called

    # read source file
    mySource.setup_io( )
    mySource.read_file( )
    print( "length col_lines = %s" % len( mySource.col_lines ) )
    # mark candidate elements
    ( l_reqd, l_optl ) = mySource.search_elements_crude( )
    # harvest optional elements
    myflavor = "optional";
    Qreqd = "OPTL"
    all_elements = mySource.search_elements_refine( l_optl, myflavor, book )
    #print( "elements = {}".format( elements ) )
    # count = 0
    # for elist in all_elements:
    #     for t in elist:
    #         e = cls_Element.Element( )
    #         count += 1
    #         e.name = t
    #         e.flavor = Qreqd
    #         e.status = "NULL"
    #         e.k_index = count
    #         book.col_elements.append( e )
    for k in range( 0, len( book.col_elements ) ):
        book.col_elements[ k ].print_element( )


    # # # start the book
    # myBook = cls_Book.Book( ) # instantiate
    # myBook.source_object = mySource
    #
    # # open Excel file for results and intermediate data
    # myWorkbook = tools_xl.xl_new_workbook( mySource.full_xl )
    #
    # # compile lists of target locations
    # myBook.source_object.read_file( )
    # myBook.mark_chapters( )
    # # worksheets for debugging
    # tools_debug.xl_dramatis_personae( myWorkbook, myBook )
    # tools_debug.xl_numbered_lines( myWorkbook, mySource.col_lines )
    #
    # # write workbook
    # myWorkbook.close( )

    print( "\n", datetime.datetime.now( ) )
    print( "source: %s/%s" % ( os.getcwd( ), os.path.basename( __file__ ) ) )
    print( "python version %s" % sys.version )

# l127914@pn1249300.lanl.gov:darboux $ python domatophobia.py
# reading source file /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/data/short.rst
# length col_lines = 231
# looking for optional elements
# line 42 = comment, author, created, modified, model_id, description, purpose, units
# line 60 = length_unit, time_unit, mass_unit, conc_unit
# line 105 = constants, macros
# line 117 = constant, time_constant, numerical_constant, area_mass_flux_constant
# line 153 = time_macro, cycle_macro, variable_macro
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f470>
# flavor = OPTL
# status = NULL
# k_index = 1
# uuid = 9f149fc0-0bf6-4ac7-9fd8-f2d517ff8c4c
# k_line = 42
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f4a8>
# flavor = OPTL
# status = NULL
# k_index = 2
# uuid = 73601091-7d57-45a3-847b-ed22b4ed5fc4
# k_line = 42
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f518>
# flavor = OPTL
# status = NULL
# k_index = 3
# uuid = d113bed2-f9c4-41c1-814a-4741ebef5a58
# k_line = 42
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f588>
# flavor = OPTL
# status = NULL
# k_index = 4
# uuid = b3d2194c-f0ba-4cc3-bc55-e149191b7c69
# k_line = 42
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f5f8>
# flavor = OPTL
# status = NULL
# k_index = 5
# uuid = 6304c284-9e3f-4861-89c7-3d721b6e077e
# k_line = 42
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f668>
# flavor = OPTL
# status = NULL
# k_index = 6
# uuid = 3600fa1e-71ab-42db-8352-33dc2dbbeef6
# k_line = 42
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f6d8>
# flavor = OPTL
# status = NULL
# k_index = 7
# uuid = 7a503ad8-64fd-44e9-bc50-abdf5a241493
# k_line = 42
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f748>
# flavor = OPTL
# status = NULL
# k_index = 8
# uuid = bcd4fe0f-2781-4fa8-b13c-a30a9e714b6f
# k_line = 42
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f27d68>
# flavor = OPTL
# status = NULL
# k_index = 9
# uuid = 13e0bb3b-473c-48d4-a82d-0ad2f9ec7dae
# k_line = 60
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f390>
# flavor = OPTL
# status = NULL
# k_index = 10
# uuid = 52d19abe-7f99-4049-ac63-7f5e089166a0
# k_line = 60
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f438>
# flavor = OPTL
# status = NULL
# k_index = 11
# uuid = bd261391-9d28-4b9b-a220-97ac0c9afc80
# k_line = 60
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f7b8>
# flavor = OPTL
# status = NULL
# k_index = 12
# uuid = 10b72850-dfca-4b61-abdb-75f5553b21df
# k_line = 60
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f8d0>
# flavor = OPTL
# status = NULL
# k_index = 13
# uuid = 85888891-0c17-44e3-bded-ba80baec7468
# k_line = 105
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f908>
# flavor = OPTL
# status = NULL
# k_index = 14
# uuid = 5d105773-a84c-4a7d-bd28-998a55c3a10e
# k_line = 105
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f860>
# flavor = OPTL
# status = NULL
# k_index = 15
# uuid = 6e54c4f2-b980-4c09-9384-35164e5e8e7a
# k_line = 117
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2f978>
# flavor = OPTL
# status = NULL
# k_index = 16
# uuid = 72090504-b2f2-4b45-a286-e431bc114147
# k_line = 117
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2fa20>
# flavor = OPTL
# status = NULL
# k_index = 17
# uuid = c5fa0c9c-3dbb-4626-ab8d-22a23466f35b
# k_line = 117
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2fa90>
# flavor = OPTL
# status = NULL
# k_index = 18
# uuid = d30ce5c2-d840-4ec2-a725-d22a5cba8b58
# k_line = 117
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2fb00>
# flavor = OPTL
# status = NULL
# k_index = 19
# uuid = f14bd718-dda8-45a3-ab28-b11d8d0c644d
# k_line = 153
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2fb70>
# flavor = OPTL
# status = NULL
# k_index = 20
# uuid = dab70fe4-1937-4bae-a5e4-0f43ea5e125a
# k_line = 153
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
# Element attributes:
# name = <cls_Element.Element object at 0x103f2fbe0>
# flavor = OPTL
# status = NULL
# k_index = 21
# uuid = 233b0cb8-8bf1-4597-817b-05ab6b30464e
# k_line = 153
# key_head = None
# key_tail = None
# k_chapter = None
# k_section = None
# k_subsection = None
# xl_row = None
# xl_col = None
#
#  2018-12-18 12:14:57.182633
# source: /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/amanzi/darboux/domatophobia.py
# python version 3.7.0 (default, Jun 28 2018, 07:39:16)
# [Clang 4.0.1 (tags/RELEASE_401/final)]


# Domatophobia	Fear of houses
