#!/usr/bin/python

# # Amanzi: The Multi-Process HPC Simulator
# #   https://github.com/amanzi/amanzi

# # David Moulton DGL LANL/T-5 moulton@lanl.gov 505 665 4712
# # Daniel Topa   LANL/CCS-2   dantopa@lanl.gov 505 667 0817

# imports
import re                  # substitution
import uuid                # Universal Unique IDentifier
from pathlib import Path   # rename file
# home brew
# classes
import cls_Chapter         # chapter (constains sections)
import cls_Element         # elements (required, optional)

# Source class
#  source:  Amanzi manual to be parsed
#  sink:    Excel file with test matrix

class Source( object ):
    def __init__( self ):

        self._title           = None    # from *.rst, line 2
        self._col_lines       = list( ) # text as a collection of lines, EOL removed
        self._numLines        = None    # census
        self._uuid            = uuid.uuid4( ) # de facto time stamp
        self._input_rst       = None    # AmanziInputSpec-v2.3.2-draft.rst
        self._path_rst        = None    # absolute path
        self._full_rst        = None    # path + file name
        self._input_xl        = None    # AmanziInputSpec-v2.3.2-draft.xlsx
        self._path_xl         = None    # absolute path
        self._full_xl         = None    # path + file name

#   P R O P E R T I E S   #

    @property
    def title( self ):
        """Title from source file"""
        return self._title

    @property
    def col_lines( self ):
        """text as a collection of lines, EOL removed"""
        return self._col_lines

    @property
    def numLines( self ):
        """Number of lines read in source file"""
        return self._numLines

    @property
    def uuid( self ):
        """Universal unique identifier: connects requirements to source document"""
        return self._uuid

    @property
    def input_rst( self ):
        """Name of source file"""
        return self._input_rst

    @property
    def path_rst( self ):
        """Path (absolute) to source file"""
        return self._path_rst

    @property
    def full_rst( self ):
        """Path + Name for input file"""
        return self._full_rst

    @property
    def input_xl( self ):
        """Name of output file"""
        return self._input_xl

    @property
    def path_xl( self ):
        """Path (absolute) to output file"""
        return self._path_xl

    @property
    def full_xl( self ):
        """Path + Name for output file"""
        return self._full_xl

#   S E T T E R S   #

    @title.setter
    def title( self, value ):
        self._title = value

    @col_lines.setter
    def col_lines( self, value ):
        self._col_lines = value

    @numLines.setter
    def numLines( self, value ):
        self._numLines = value

    @input_rst.setter
    def input_rst( self, value ):
        self._input_rst = value

    @path_rst.setter
    def path_rst( self, value ):
        self._path_rst = value

    @full_rst.setter
    def full_rst( self, value ):
        self._full_rst = value

    @input_xl.setter
    def input_xl( self, value ):
        self._input_xl = value

    @path_xl.setter
    def path_xl( self, value ):
        self._path_xl = value

    @full_xl.setter
    def full_xl( self, value ):
        self._full_xl = value

#   D E L E T E R S   #

    @title.deleter
    def title( self ):
        del self._title

    @col_lines.deleter
    def col_lines( self ):
        del self._col_lines

    @numLines.deleter
    def numLines( self ):
        del self._numLines

    @uuid.deleter
    def uuid( self ):
        del self._uuid

    @input_rst.deleter
    def input_rst( self ):
        del self._input_rst

    @path_rst.deleter
    def path_rst( self ):
        del self._path_rst

    @full_rst.deleter
    def full_rst( self ):
        del self._full_rst

    @input_xl.deleter
    def input_xl( self ):
        del self._input_xl

    @path_xl.deleter
    def path_xl( self ):
        del self._path_xl

    @full_xl.deleter
    def full_xl( self ):
        del self._full_xl

#   M E T H O D S   #

    def print_attributes( self ):
        print('\nSource attributes:')
        print( 'title = %s' % self.title )
        print( 'col_lines = %s' % self.col_lines )
        print( 'numLines = %s' % self.numLines )
        print( 'uuid = %s' % self.uuid )
        print( 'input_rst = %s' % self.input_rst )
        print( 'path_rst = %s' % self.path_rst )
        print( 'full_rst = %s' % self.full_rst )
        print( 'input_xl = %s' % self.input_xl )
        print( 'path_xl = %s' % self.path_xl )
        print( 'full_xl = %s' % self.full_xl )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def read_source( self ):
        self.setup_io( ) # establish outut file
        self.read_file( )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def read_file( self ):
        ## ## read source file
        print ( "reading source file %s" % self.full_rst )
        # https://stackoverflow.com/questions/3277503/in-python-how-do-i-read-a-file-line-by-line-into-a-list
        with open( self.full_rst ) as f:
            self.col_lines = f.read( ).splitlines( )
            self.numLines = len( self.col_lines )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def setup_io( self ):
        # combine path and file name
        self.full_rst  = self.path_rst + self.input_rst
        # # output file: same directory
        # https://stackoverflow.com/questions/2900035/changing-file-extension-in-python
        self.output_xl = Path( self.input_rst ).stem + ".xlsx"
        self.path_xl   = self.path_rst
        self.full_xl   = self.path_xl + self.output_xl
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def search_elements_refine( self, list_search, flavor, myBook, chapter_number ):
        all_elements = list( ); # empty container
        # REQD or OPTL
        Qreqd = "REQD"
        if flavor == "optional":
           Qreqd = "OPTL"
        # adjust counter to track both reqd and optl elements
        count = len( myBook.col_elements )
        # remove first 25 characters
        for k in list_search: # sweep line numbers
            # drop first 25 characters: "      Optional Elements:"
            line = self.col_lines[ k ][25:]
            # purge arguments inside parentheses, braces
            # https://stackoverflow.com/questions/14596884/remove-text-between-and-in-python
            line = re.sub( "[\(\[].*?[\)\]]", "", line )
            # clean up spaces, '
            # https://stackoverflow.com/questions/3939361/remove-specific-characters-from-a-string-in-python
            #for char in "' ":
                #line = line.replace( char, "" ) # constants, macros
            # separate elements into list
            elements = line.split( "," )
            for myElement in elements:
                e           = cls_Element.Element( )
                count      += 1
                e.name      = myElement
                e.flavor    = Qreqd
                e.status    = "NULL"
                e.k_chapter = chapter_number
                e.k_index   = count
                e.k_line    = k
                myBook.col_elements.append( e )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def search_elements_crude( self, alpha, omega ):
        # containers for line numbers
        l_reqd = list( )
        l_optl = list( )

        # required elements
        k_line = alpha
        for line in self.col_lines[ alpha : omega ]:
            # required
            if line.find( "Required Elements:" ) != -1:
                if line.find( "NONE" ) != -1:
                    continue
                l_reqd.append( k_line )
            k_line += 1

        # optional elements
        k_line = alpha
        for line in self.col_lines[ alpha : omega ]:
            # optional
            if line.find( "Optional Elements:" ) != -1:
                if line.find( "NONE" ) != -1:
                    continue
                l_optl.append( k_line )
            k_line += 1

        # return list of lines numbers which may have elements
        return ( l_reqd, l_optl )

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def parse_alpha( self, search_string, alpha, omega ):

        ptr_locations = list( ) # list of line numbers
        for lineNum in range( alpha, omega ):
            line = self.col_lines[ lineNum ]
            if line.find( search_string ) != -1:
                if line.find( "+" ) != -1:
                    continue
                ptr_locations.append( lineNum )
        return ptr_locations

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def parse_match_lengths( self, ptr_locations ): # vet candidates
        loc = list( )  # location
        txt = list( )  # text
        for lineNum in ptr_locations:
            lineLengthA = len( self.col_lines[ lineNum ] )
            lineLengthB = len( self.col_lines[ lineNum - 1 ] )
            if lineLengthA == lineLengthB:
                loc.append( lineNum - 1 ) # title line number
                txt.append( self.col_lines[ lineNum - 1 ] ) # title string
        return ( loc, txt );

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

# user: l127914, CPU: pn1249300, MM v. 11.3.0 for Mac OS X x86
# date: Dec 19, 2018, time: 10:59:16
# nb: /Users/l127914/Mathematica_files/nb/lanl/python/author/class-structures-06.nb

# l127914@pn1249300.lanl.gov:darboux $ py cls_Source.py

# l127914@pn1249300.lanl.gov:darboux $ date
# Wed Dec 19 13:07:28 MST 2018

# l127914@pn1249300.lanl.gov:darboux $ pwd
# /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/amanzi/darboux
