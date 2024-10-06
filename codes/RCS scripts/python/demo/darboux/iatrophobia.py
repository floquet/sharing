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
    book        = cls_Book.Book( )     # instantiate book
    book.source = cls_Source.Source( ) # instantiate source

    # # source data file and path
    book.source.input_rst = "short.rst"    # setter called
    # source.path_rst  = "/Users/dantopa/Documents/repos/GitHub/topa-development/data/"
    # source.path_rst = "/Volumes/Tethys/repos/GitHub/topa-development/data/"
    book.source.path_rst  = "/Volumes/Tlaltecuhtli/repos/GitHub/topa-development/data/"

    # read source file
    book.source.read_source( )

    # create xl notebook for results
    workbook = tools_xl.xl_new_workbook( book.source.full_xl )
    # worksheets for debugging
    tools_debug.xl_dramatis_personae( workbook, book )
    tools_debug.xl_numbered_lines( workbook, book.source.col_lines )

    # delineate chapters
    book.mark_chapters( )
    tools_debug.xl_chapter_attributes( workbook, book.col_chapters )

    for c in book.col_chapters:
        book.mark_sections( c )
        print( "... searching chapter %s for elements" % c.title )
        # mark candidate elements: return lists of candidate lines
        ( l_reqd, l_optl ) = book.source.search_elements_crude( c.k_start, c.k_stop )
        # harvest optional elements
        all_elements = book.source.search_elements_refine( l_optl, "optional", book, c.k_index )
        all_elements = book.source.search_elements_refine( l_reqd, "required", book, c.k_index )

    tools_debug.xl_print_elements( workbook, book.col_elements )

    # write workbook
    workbook.close( )
    print( "\n", datetime.datetime.now( ) )
    print( "source: %s/%s" % ( os.getcwd( ), os.path.basename( __file__ ) ) )
    print( "python version %s" % sys.version )

# l127914@pn1249300.lanl.gov:darboux $ py hypochonria.py
# reading source file /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/data/short.rst
# ... searching chapter Amanzi Input for elements
# ... searching chapter Model Description for elements
# ... searching chapter Definitions for elements

#  2018-12-19 13:17:31.011657
# source: /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/amanzi/darboux/hypochonria.py
# python version 3.6.6 (default, Jun 28 2018, 05:53:46)
# [GCC 4.2.1 Compatible Apple LLVM 9.0.0 (clang-900.0.39.2)]

# Iatrophobia: Fear of doctors
