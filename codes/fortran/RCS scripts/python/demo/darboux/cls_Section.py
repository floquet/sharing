#!/usr/bin/python

# # Amanzi: The Multi-Process HPC Simulator
# #   https://github.com/amanzi/amanzi

# # David Moulton DGL LANL/T-5 moulton@lanl.gov 505 665 4712
# # Daniel Topa   LANL/CCS-2   dantopa@lanl.gov 505 667 0817

# Section class
#  composed of sections (Constants, Macros, etc)

class Section( object ):
    def __init__( self ):

        self._title           = None    # Model Description
        self._k_index         = None    # section number
        self._key             = None    # S-03
        self._k_start         = None    # 5
        self._k_stop          = None    # 231
        self._col_sections    = list( ) # collection of subsections

#   P R O P E R T I E S   #

    @property
    def title( self ):
        """Section title"""
        return self._title

    @property
    def k_index( self ):
        """Section number"""
        return self._k_index

    @property
    def key( self ):
        """Unique key to tag section"""
        return self._key

    @property
    def k_start( self ):
        """First line number of searchable text"""
        return self._k_start

    @property
    def k_stop( self ):
        """Last line number of searchable text"""
        return self._k_stop

    @property
    def col_sections( self ):
        """Collection of subsection objects"""
        return self._col_sections

#   S E T T E R S   #

    @title.setter
    def title( self, value ):
        self._title = value

    @k_index.setter
    def k_index( self, value ):
        self._k_index = value

    @key.setter
    def key( self, value ):
        self._key = value

    @k_start.setter
    def k_start( self, value ):
        self._k_start = value

    @k_stop.setter
    def k_stop( self, value ):
        self._k_stop = value

    @col_sections.setter
    def col_sections( self, value ):
        self._col_sections = value

#   D E L E T E R S   #

    @title.deleter
    def title( self ):
        del self._title

    @k_index.deleter
    def k_index( self ):
        del self._k_index

    @key.deleter
    def key( self ):
        del self._key

    @k_start.deleter
    def k_start( self ):
        del self._k_start

    @k_stop.deleter
    def k_stop( self ):
        del self._k_stop

    @col_sections.deleter
    def col_sections( self ):
        del self._col_sections

#   M E T H O D S   #

    def print_attributes( self ):
        print('\nSection attributes:')
        print( 'title = %s' % self.title )
        print( 'k_index = %s' % self.k_index )
        print( 'key = %s' % self.key )
        print( 'k_start = %s' % self.k_start )
        print( 'k_stop = %s' % self.k_stop )
        print( 'col_sections contains %s objects' % len( self.col_sections ) )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

# user: l127914, CPU: pn1249300, MM v. 11.3.0 for Mac OS X x86
# date: Dec 19, 2018, time: 14:56:36
# nb: /Users/l127914/Mathematica_files/nb/lanl/python/author/class-structures-06.nb

# l127914@pn1249300.lanl.gov:darboux $ py cls_Section.py

# l127914@pn1249300.lanl.gov:darboux $ date
# Wed Dec 19 15:01:14 MST 2018

# l127914@pn1249300.lanl.gov:darboux $ pwd
# /Volumes/Tlaltecuhtli/repos/GitHub/topa-development/amanzi/darboux
