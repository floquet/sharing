#! /usr/bin/python
# # Amanzi: The Multi-Process HPC Simulator
# #   https://github.com/amanzi/amanzi
# # David Moulton   DGL LANL/T-5  moulton@lanl.gov  505 665 4712
# # Daniel Topa     LANL/CCS-2    dantopa@lanl.gov  505 667 0817

# # Debug tools
#   xl_numbered_lines( thisWorkbook, theseLines )
#   xl_dramatis_personae( thisWorkbook, thisBook )

# # imports
import tools_xl             # spreadsheet authoring tools

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

def xl_print_elements( thisWorkbook, col_elements ):
    # create sheet
    s = tools_xl.xl_sheet_generate( thisWorkbook, "elements" )

    # address worksheet in row, col form
    row = 0;
    col = 0;

    for e in col_elements:
        s.write( row, col, "name" )
        s.write( row, col + 1, e.name ); row += 1

        s.write( row, col, "flavor" )
        s.write( row, col + 1, e.flavor ); row += 1

        s.write( row, col, "status" )
        s.write( row, col + 1, e.status ); row += 1

        s.write( row, col, "index" )
        s.write( row, col + 1, e.k_index ); row += 1

        #s.write( row, col, "uuid" )
        #s.write( row, col + 1, e.uuid ); row += 1

        s.write( row, col, "source line" )
        s.write( row, col + 1, e.k_line ); row += 1

        s.write( row, col, "key: head" )
        s.write( row, col + 1, e.key_head ); row += 1

        s.write( row, col, "key: tail" )
        s.write( row, col + 1, e.key_tail ); row += 1

        s.write( row, col, "chapter" )
        s.write( row, col + 1, e.k_chapter ); row += 1

        row += 1

    return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

def xl_chapter_attributes( thisWorkbook, col_chapters ):
    # create sheet
    s = tools_xl.xl_sheet_generate( thisWorkbook, "chapters" )

    # address worksheet in row, col form
    row = 0;
    col = 0;

    for c in col_chapters:
        s.write( row, col, c.k_index )
        s.write( row, col + 1, c.title ); row += 1

        s.write( row, col + 1, "range of lines:" )
        s.write( row, col + 2, c.k_start )
        s.write( row, col + 3, c.k_stop ); row += 1

        s.write( row, col + 1, "key:" )
        s.write( row, col + 2, c.key ); row += 2

    return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

def xl_numbered_lines( thisWorkbook, theseLines ):
    s = tools_xl.xl_sheet_generate( thisWorkbook, "text lines" )

    # address worksheet in row, col form
    row = 0;
    col = 0;
    counter = 0;
    # Excel treats === and --- as operations, not text
    # To circumvent, use the TEXT function
    # which chokes on strings containing double quotes
    myText = thisWorkbook.add_format({'num_format': '@'})
    # restablish (?) formats
    format_title = thisWorkbook.add_format( )
    format_title.set_bold( )
    format_title.set_font_color( "blue" )

    s.write( row, col,     "index",  format_title )
    s.write( row, col + 1, "length", format_title )
    s.write( row, col + 2, "text",   format_title ); row += 1

    for line in theseLines:
        s.write( row, col, counter )
        myString = '= TEXT( "' + line + '", "=" )'
        s.write( row, col + 1, len( line ) )
        s.write( row, col + 2, "boo:", myText )
        s.write( row, col + 2, line, myText ); row += 1
        counter += 1;
    return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

def xl_dramatis_personae( thisWorkbook, thisBook ):

    s = tools_xl.xl_sheet_generate( thisWorkbook, "dramatis personae" )
    # widen first column
    s.set_column( "A:A", 10 )

    # restablish (?) formats
    format_title = thisWorkbook.add_format( )
    format_title.set_bold( )
    format_title.set_font_color( "blue" )

    # address worksheet in row, col form
    row = 0;
    col = 0;

    # source
    s.write( row, col, "Source file", format_title ); row += 1

    s.write( row, col, "Title" )
    s.write( row, col + 1, thisBook.source.title ); row += 1

    s.write( row, col, "Data file" )
    s.write( row, col + 1, thisBook.source.input_rst ); row += 1

    s.write( row, col, "Data path" )
    s.write( row, col + 1, thisBook.source.path_rst ); row += 1

    s.write( row, col, "Lines read" )
    s.write( row, col + 1, thisBook.source.numLines ); row += 1

    # sink
    row += 1
    s.write( row, col, "Output file", format_title ); row += 1

    s.write( row, col, "Output file" )
    s.write( row, col + 1, thisBook.source.output_xl ); row += 1

    s.write( row, col, "Output path" )
    s.write( row, col + 1, thisBook.source.path_xl ); row += 1

    return;

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

# l127914@pn1249300.lanl.gov:darboux $ py tools_debug.py

# l127914@pn1249300.lanl.gov:darboux $ date
# Wed Dec 19 13:13:39 MST 2018

# l127914@pn1249300.lanl.gov:darboux $ pwd
# /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/amanzi/darboux
