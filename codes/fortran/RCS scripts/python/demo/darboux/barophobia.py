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
#import cls_Chapter          # chapter (constains sections, contains requirements)
import cls_Source            # e.q. Amanzi XML Input Specification (Version 2.3-draft)
# tools
import tools_debug
import tools_xl             # spreadsheet authoring tools

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

if __name__ == "__main__":

    # fundamental object: a book
    book = cls_Book.Book( )

    # # source data
    book.source = cls_Source.Source( ) # instantiate
    book.source.input_rst = "short.rst"    # setter called
    book.source.path_rst  = "/Users/dantopa/Documents/repos/GitHub/topa-development/data/"
        # source.path_rst = "/Volumes/Tethys/repos/GitHub/topa-development/data/"
    # source.path_rst  = "/Volumes/Tlaltecuhtli/repos/GitHub/topa-development/data/"    # setter called

    # read source file
    book.source.setup_io( )
    book.source.read_file( )
    print( "length col_lines = %s" % len( book.source.col_lines ) )
    ( l_reqd, l_optl ) = book.source.search_elements_crude( )
    book.source.search_elements_refine( l_optl, "optional" )


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
    # tools_debug.xl_numbered_lines( myWorkbook, mySource.myLines )
    #
    # # write workbook
    # myWorkbook.close( )

    print( "\n", datetime.datetime.now( ) )
    print( "source: %s/%s" % ( os.getcwd( ), os.path.basename( __file__ ) ) )
    print( "python version %s" % sys.version )

# dantopa@Lax-Millgram:darboux $ py barophobia.py
# reading source file /Users/dantopa/Documents/repos/GitHub/topa-development/data/short.rst
# length col_lines = 231
# looking for optional elements
# line 42 = comment, author, created, modified, model_id, description, purpose, units
# elements = ['comment', 'author', 'created', 'modified', 'model_id', 'description', 'purpose', 'units']
# line 60 = length_unit, time_unit, mass_unit, conc_unit
# elements = ['length_unit', 'time_unit', 'mass_unit', 'conc_unit']
# line 105 = constants, macros
# elements = ['constants', 'macros']
# line 117 = constant, time_constant, numerical_constant, area_mass_flux_constant
# elements = ['constant', 'time_constant', 'numerical_constant', 'area_mass_flux_constant']
# line 153 = time_macro, cycle_macro, variable_macro
# elements = ['time_macro', 'cycle_macro', 'variable_macro']

#  2018-12-12 17:00:03.776078
# source: /Users/dantopa/Documents/repos/GitHub/topa-development/amanzi/darboux/barophobia.py
# python version 3.6.7 (default, Oct 21 2018, 09:26:25)
# [GCC 4.2.1 Compatible Apple LLVM 9.1.0 (clang-902.0.39.2)]

# Barophobia	Fear of gravity
