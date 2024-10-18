#!/usr/bin/python3

# # Daniel Topa

# imports
import math                 # pi
import uuid                 # Universal Unique IDentifier
#from pathlib import Path   # rename file

class TestObject( object ):
    def __init__( self ):

        self._descriptor      = None    # sphere
        self._sizeName        = None    # diameter
        self._sizeValue       = None    # 10
        self._sizeUnits       = None    # m
        self._areaValue       = None    # pi r^2
        self._areaUnits       = None    # m^2
        self._resolution      = None    # 04
        self._mastersheet     = None    # sphere, d = 10 m
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
    def sizeName( self ):
        """Name of size parameter (edge, radius, etc.)"""
        return self._sizeName

    @property
    def sizeValue( self ):
        """Length parameter"""
        return self._sizeValue

    @property
    def sizeUnits( self ):
        """Units (m, mm, etc.)"""
        return self._sizeUnits

    @property
    def areaValue( self ):
        """Area"""
        return self._areaValue

    @property
    def areaUnits( self ):
        """Area units (m^2, mm, etc.)"""
        return self._areaUnits

    @property
    def masterSheet( self ):
        """Name of master sheet"""
        return self._masterSheet

    @property
    def sourcePath( self ):
        """Path (absolute) to source file"""
        return self._sourcePath

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

    @sizeName.setter
    def sizeName( self, value ):
        self._sizeName = value

    @sizeValue.setter
    def sizeValue( self, value ):
        self._sizeValue = value

    @sizeUnits.setter
    def sizeUnits( self, value ):
        self._sizeUnits = value

    @areaValue.setter
    def areaValue( self, value ):
        self._areaValue = value

    @areaUnits.setter
    def areaUnits( self, value ):
        self._areaUnits = value

    @masterSheet.setter
    def masterSheet( self, value ):
        self._masterSheet = value

    @sourcePath.setter
    def sourcePath( self, value ):
        self._sourcePath = value

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

    @sizeName.deleter
    def sizeName( self ):
        del self._sizeName

    @sizeValue.deleter
    def sizeValue( self ):
        del self._sizeValue

    @sizeUnits.deleter
    def sizeUnits( self ):
        del self._sizeUnits

    @areaValue.deleter
    def areaValue( self ):
        del self._areaValue

    @areaUnits.deleter
    def areaUnits( self ):
        del self._areaUnits

    @masterSheet.deleter
    def masterSheet( self ):
        del self._masterSheet

    @sourcePath.deleter
    def sourcePath( self ):
        del self._sourcePath

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
        print('\nSource attributes:')
        print( 'descriptor     = %s' % self.descriptor )
        print( 'sizeName       = %s' % self.sizeName )
        print( 'sizeValue      = %s' % self.sizeValue )
        print( 'sizeUnits      = %s' % self.sizeUnits )
        print( 'sourcePath     = %s' % self.sourcePath )
        print( 'sourceFile     = %s' % self.sourceFile )
        print( 'sourcePathFile = %s' % self.sourcePathFile )
        print( 'outputFile     = %s' % self.outputFile )
        print( 'outputPath     = %s' % self.outputPath )
        print( 'outputPathFile = %s' % self.outputPathFile )
        print( 'uuid           = %s' % self.uuid )
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def scenario( self ):
        self.setup_io( ) # establish outut file
        #self.read_MoM_file( )
        self.area_circular( ) # compute area for given geometry
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
        self.sourcePathFile  = self.sourcePath + self.sourceFile
        self.outputPathFile  = self.outputPath + self.outputFile
        self.masterSheet     = self.descriptor + ', ' + self.sizeName[0] + ' = ' + str( self.sizeValue ) + ' ' + self.sizeUnits
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

    def area_circular( self ):
        # combine path and file name
        self.areaValue = math.pi * ( self.sizeValue / 2 )**2
        return

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #
