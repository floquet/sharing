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
#import cls_Element          # elements (required, optional)
import cls_Source           # e.q. Amanzi XML Input Specification (Version 2.3-draft)
# tools
import tools_debug
import tools_xl             # spreadsheet authoring tools

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

if __name__ == "__main__":

    # fundamental object: a book
    book        = cls_Book.Book( )     # instantiate book
    book.source = cls_Source.Source( ) # instantiate source
    source = book.source

    # # source data
    source.input_rst = "short.rst"    # setter called
    # source.path_rst  = "/Users/dantopa/Documents/repos/GitHub/topa-development/data/"
    # source.path_rst = "/Volumes/Tethys/repos/GitHub/topa-development/data/"
    source.path_rst  = "/Volumes/Tlaltecuhtli/repos/GitHub/topa-development/data/"

    # read source file
    source.setup_io( )
    source.read_file( )
    print( "length col_lines = %s" % len( source.col_lines ) )

    # create xl notebook
    workbook = tools_xl.xl_new_workbook( source.full_xl )
    # worksheets for debugging
    tools_debug.xl_dramatis_personae( workbook, book )
    tools_debug.xl_numbered_lines( workbook, book.source.col_lines )
    # delineate chapters
    book.mark_chapters( )

    # delineate sections
    #for c in book.col_chapters:
        # mark sections
        #c.mark_sections( )
    tools_debug.xl_chapter_attributes( workbook, book.col_chapters )

    print( "* * * searching chapters for elements" )
    for c in book.col_chapters:
        # mark candidate elements
        ( l_reqd, l_optl ) = source.search_elements_crude( c.k_start, c.k_stop )
        c.print_attributes( )

    # harvest optional elements
    # all_elements = mySource.search_elements_refine( l_optl, "optional", book )
    # all_elements = mySource.search_elements_refine( l_reqd, "required", book )
    # for e in book.col_elements:
    #     e.print_attributes( )

    # write workbook
    workbook.close( )
    print( "\n", datetime.datetime.now( ) )
    print( "source: %s/%s" % ( os.getcwd( ), os.path.basename( __file__ ) ) )
    print( "python version %s" % sys.version )

# l127914@pn1249300.lanl.gov:darboux $ py genuphobia.py
# reading source file /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/data/short.rst
# length col_lines = 231
# =  =  = xl_sheet_generate: provenance
# =  =  = xl_sheet_generate: dramatis personae
# =  =  = xl_numbered_lines:
# =  =  = xl_sheet_generate: text lines
# @ @ @ book.mark_chapters_start:
# ! ! ! source.parse_alpha: search_string, alpha, omega - === 0 231
# ptr_locations = [0, 2, 8, 17, 33, 96]
# after del: ptr_locations = [17, 33, 96]
# $ $ $ source.parse_match_lengths locations = [17, 33, 96]
#
# 16 B = Amanzi Input
# 17 A = ============
#
# 32 B = Model Description
# 33 A = =================
#
# 95 B = Definitions
# 96 A = ===========
# out: locations, text = [16, 32, 95], ['Amanzi Input', 'Model Description', 'Definitions']
# ( loc, txt ) [16, 32, 95] - ['Amanzi Input', 'Model Description', 'Definitions']
#
# chapter title lines found: [16, 32, 95]
# # # # book.mark_chapters_stop:
# ptr_locations: [16, 32, 95]
# 2. ptr_locations = [32, 95, 232]
# chapter 1: Amanzi Input 16 to 31
# chapter 2: Model Description 32 to 94
# chapter 3: Definitions 95 to 231
# =  =  = xl_sheet_generate: chapters
# * * * searching chapters for elements
#
# Chapter attributes:
# title              = Amanzi Input
# key                = 01-
# k_start            = 16
# k_stop             = 31
# number of sections = 0
#
# Chapter attributes:
# title              = Model Description
# key                = 02-
# k_start            = 32
# k_stop             = 94
# number of sections = 0
#
# Chapter attributes:
# title              = Definitions
# key                = 03-
# k_start            = 95
# k_stop             = 231
# number of sections = 0
#
#  2018-12-19 12:13:39.412764
# source: /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/amanzi/darboux/genuphobia.py
# python version 3.6.6 (default, Jun 28 2018, 05:53:46)
# [GCC 4.2.1 Compatible Apple LLVM 9.0.0 (clang-900.0.39.2)]


# Hypochonria 
