#!/usr/bin/python3

# # Daniel Topa

# imports
import math                 # pi
import os                   # opeating system
import uuid                 # Universal Unique IDentifier
#from pathlib import Path   # rename file

class TestObject( object ):
    def __init__( self ):

        self._descriptor      = None    # sphere
        self._elevation       = None    # 15
        self._mastersheet     = None    # PTW default
        self._stemName        = None    # PTW-default
        self._sourceFile      = None    # *.dat
        self._sourcePath      = None    # absolute path to *.dat
        self._sourcePathFile  = None    # path + source file name
        self._outputFile      = None    # *.xlsx
        self._outputPath      = None    # absolute path to *.xlsx
        self._outputPathFile  = None    # path + *.xlsx
        self._uuid            = uuid.uuid4( ) # de facto time stamp

#   P R O P E R T I E S   #

    @property
    def descriptor( self ):
        """Descriptor (sphere, cube, etc.)"""
        return self._descriptor

    @property
    def masterSheet( self ):
        """Name of master sheet"""
        return self._masterSheet

    @property
    def sourcePath( self ):
        """Path (absolute) to source file"""
        return self._sourcePath

    @property
    def stemName( self ):
        """Identifies object and elevation"""
        return self._stemName

    @property
    def sourceFile( self ):
        """Path + Name for input file"""
        return self._sourceFile

    @property
    def outputFile( self ):
        """Name of output file"""
        return self._outputFile

    @property
    def outputPath( self ):
        """Path (absolute) to output file"""
        return self._outputPath

    @property
    def outputPathFile( self ):
        """Path + Name for output file"""
        return self._outputPathFile

    @property
    def uuid( self ):
        """Universal unique identifier: connects requirements to source document"""
        return self._uuid

#   S E T T E R S   #

    @descriptor.setter
    def descriptor( self, value ):
        self._descriptor = value

    @masterSheet.setter
    def masterSheet( self, value ):
        self._masterSheet = value

    @sourcePath.setter
    def sourcePath( self, value ):
        self._sourcePath = value

    @stemName.setter
    def stemName( self, value ):
        self._stemName = value

    @sourceFile.setter
    def sourceFile( self, value ):
        self._sourceFile = value

    @outputFile.setter
    def outputFile( self, value ):
        self._outputFile = value

    @outputPath.setter
    def outputPath( self, value ):
        self._outputPath = value

    @outputPathFile.setter
    def outputPathFile( self, value ):
        self._outputPathFile = value

#   D E L E T E R S   #

    @descriptor.deleter
    def descriptor( self ):
        del self._descriptor

    @masterSheet.deleter
    def masterSheet( self ):
        del self._masterSheet

    @sourcePath.deleter
    def sourcePath( self ):
        del self._sourcePath

    @stemName.deleter
    def stemName( self ):
        del self._stemName

    @sourceFile.deleter
    def sourceFile( self ):
        del self._sourceFile

    @outputFile.deleter
    def outputFile( self ):
        del self._outputFile

    @outputPath.deleter
    def outputPath( self ):
        del self._outputPath

    @outputPathFile.deleter
    def outputPathFile( self ):
        del self._outputPathFile

    @uuid.deleter
    def uuid( self ):
        del self._uuid

#   M E T H O D S   #

    def print_attributes( self ):
        print('\nObject attributes:')
        print( 'descriptor     = %s' % self.descriptor )
        print( 'elevation      = %s' % self.elevation )
        print( 'sourcePath     = %s' % self.sourcePath )
        print( 'stemName       = %s' % self.stemName )
        print( 'sourceFile     = %s' % self.sourceFile )
        print( 'sourcePathFile = %s' % self.sourcePathFile )
        print( 'outputFile     = %s' % self.outputFile )
        print( 'outputPath     = %s' % self.outputPath )
        print( 'outputPathFile = %s' % self.outputPathFile )
        print( 'uuid           = %s' % self.uuid )
        print( )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def read_MoM_file( self ):
        ## ## read source file
        print ( "reading source file %s" % self.sourceFile )
        # https://stackoverflow.com/questions/3277503/in-python-how-do-i-read-a-file-line-by-line-into-a-list
        with open( self.sourceFile ) as f:
            self.col_lines = f.read( ).splitlines( )
            self.numLines = len( self.col_lines )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def setup_io( self ):
        # combine path and file name
        self.sourceFile     = self.stemName   + '-' + self.elevation
        self.outputFile     = self.stemName   + '-' + self.elevation + '.xlsx'
        self.sourcePathFile = self.sourcePath + self.sourceFile
        self.outputPathFile = self.outputPath + self.outputFile
        self.masterSheet    = self.descriptor + ' elevation ' + ( 90 - self.elevation )
        if not os.path.exists( self.sourcePath ):
            os.mkdir( self.sourcePath )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #
