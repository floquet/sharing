#!/usr/bin/python

# # Amanzi: The Multi-Process HPC Simulator
# #   https://github.com/amanzi/amanzi

# # David Moulton DGL LANL/T-5 moulton@lanl.gov 505 665 4712
# # Daniel Topa   LANL/CCS-2   dantopa@lanl.gov 505 667 0817

# home brew
# classes
import        cls_Chapter # chapter (constains sections)

# Book class
#  Contains source and chapters

class Book( object ):
    def __init__( self ):

        self._title           = None    # Amanzi XML Input Specification (Version 2.3-draft)
        self._k_index         = None    # chapter number
        self._k_start         = None    # 5
        self._k_stop          = None    # 231
        self._source          = None    # input source
        self._xl_file         = None    # output
        self._col_chapters    = list( ) # collection of chapters
        self._col_elements    = list( ) # collection of elements


#   P R O P E R T I E S   #

    @property
    def title( self ):
        """Title of book"""
        return self._title

    @property
    def k_index( self ):
        """Chapter number"""
        return self._k_index

    @property
    def k_start( self ):
        """First line number of searchable text"""
        return self._k_start

    @property
    def k_stop( self ):
        """Last line number of searchable text"""
        return self._k_stop

    @property
    def source( self ):
        """Source file"""
        return self._source

    @property
    def xl_file( self ):
        """Excel spreadsheet"""
        return self._xl_file

    @property
    def col_chapters( self ):
        """Collection of chapter objects"""
        return self._col_chapters

    @property
    def col_elements( self ):
        """Collection of element objects"""
        return self._col_elements

#   S E T T E R S   #

    @title.setter
    def title( self, value ):
        self._title = value

    @k_index.setter
    def k_index( self, value ):
        self._k_index = value

    @k_start.setter
    def k_start( self, value ):
        self._k_start = value

    @k_stop.setter
    def k_stop( self, value ):
        self._k_stop = value

    @source.setter
    def source( self, value ):
        self._source = value

    @xl_file.setter
    def xl_file( self, value ):
        self._xl_file = value

    @col_chapters.setter
    def col_chapters( self, value ):
        self._col_chapters = value

    @col_elements.setter
    def col_elements( self, value ):
        self._col_elements = value

#   D E L E T E R S   #

    @title.deleter
    def title( self ):
        del self._title

    @k_index.deleter
    def k_index( self ):
        del self._k_index

    @k_start.deleter
    def k_start( self ):
        del self._k_start

    @k_stop.deleter
    def k_stop( self ):
        del self._k_stop

    @source.deleter
    def source( self ):
        del self._source

    @xl_file.deleter
    def xl_file( self ):
        del self._xl_file

    @col_chapters.deleter
    def col_chapters( self ):
        del self._col_chapters

    @col_elements.deleter
    def col_elements( self ):
        del self._col_elements

#   M E T H O D S   #

    def print_attributes( self ):
        print('\nBook attributes:')
        print( 'title = %s' % self.title )
        print( 'k_index = %s' % self.k_index )
        print( 'k_start = %s' % self.k_start )
        print( 'k_stop = %s' % self.k_stop )
        print( 'source = %s' % self.source )
        print( 'xl_file = %s' % self.xl_file )
        print( 'col_chapters = %s' % self.col_chapters )
        print( 'col_elements = %s' % self.col_elements )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def mark_sections( self, chapter ):
        ptr_locations = self.mark_sections_start( chapter )
        self.mark_sections_stop( chapter, ptr_locations )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def mark_sections_start( self, chapter ):
        print( "& & & chapter.mark_sections" )
        ptr_locations = self.source.parse_alpha( "---", chapter.k_start, chapter.k_stop )
        ( loc, txt )  = self.source.parse_match_lengths( ptr_locations )
        if len( ptr_locations ) == 0:
            return
        count = 0 # count sections
        for myLoc, myTxt in zip( loc, txt ): # ( myLoc, myTxt ) = 32, Model Description
            s           = cls_Section.Section( )
            count      += 1
            s.title     = myTxt # section title
            s.k_start   = myLoc # title line of chapter
            s.k_index   = count # section number
            s.key       = "S-" + str( count ).zfill( 2 )
            self.col_sections.append( s )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def mark_sections_stop( self, chapter, ptr_locations ):
        if len( ptr_locations ) == 0:
            return
        ptr_locations.append( chapter.k_stop )
        ptr_locations = ptr_locations[ 1: ]
        for ( s, l ) in zip( chapter.col_sections, ptr_locations ):
            s.k_stop = l

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def mark_chapters( self ):
        ptr_locations = self.mark_chapters_start( )
        self.mark_chapters_stop( ptr_locations )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def mark_chapters_start( self ):
        ptr_locations = self.source.parse_alpha( "===", 0, self.source.numLines )
        # remove Overview pointer
        ptr_locations = ptr_locations[ 3: ]
        ( loc, txt )  = self.source.parse_match_lengths( ptr_locations )
        count = 0
        for myLoc, myTxt in zip( loc, txt ): # ( myLoc, myTxt ) = 32, Model Description
            c           = cls_Chapter.Chapter( )
            count      += 1
            c.title     = myTxt # chapter title
            c.k_start   = myLoc # title line of chapter
            c.k_index   = count # chapter number
            c.key       = str( count ).zfill( 2 ) + "-"
            self.col_chapters.append( c )
        return loc

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def mark_chapters_stop( self, ptr_locations ):

        #del start_locations[ 0 ] # remove first element
        # skip 2 lines: title line, =====
        # https://stackoverflow.com/questions/9304408/how-to-add-an-integer-to-each-element-in-a-list
        # https://nedbatchelder.com/text/names1.html
        # https://stackoverflow.com/questions/4426663/how-to-remove-the-first-item-from-a-list
        ptr_locations.append( self.source.numLines + 1 )
        ptr_locations = ptr_locations[ 1: ]
        for ( c, l ) in zip( self.col_chapters, ptr_locations ):
            c.k_stop = l - 1

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

# user: l127914, CPU: pn1249300, MM v. 11.3.0 for Mac OS X x86
# date: Dec 19, 2018, time: 13:10:34
# nb: /Users/l127914/Mathematica_files/nb/lanl/python/author/class-structures-06.nb


# l127914@pn1249300.lanl.gov:darboux $ py cls_Chapter.py

# l127914@pn1249300.lanl.gov:darboux $ date
# Wed Dec 19 13:08:50 MST 2018

# l127914@pn1249300.lanl.gov:darboux $ pwd
# /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/amanzi/darboux
