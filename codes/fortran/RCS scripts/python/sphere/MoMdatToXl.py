#! /usr/bin/python3

# # Daniel Topa

# Gather RCS in dBsm from the *.dat files into XL format

# # imports
import datetime             # timestamps
import os                   # opeating system
import sys                  # python version
from pathlib import Path    # rename file
import xlsxwriter           # API for Excel
# home brew
# classes
import cls_TestObject       # defines scenario
import tools_xl             # spreadsheet authoring tools

#  ==   ==   == ==   ==   == ==   ==   == ==   ==   ==  #

if __name__ == "__main__":
    # print("PYTHONPATH:", os.environ.get('PYTHONPATH'))
    # print("PATH:", os.environ.get('PATH'))
    for res in range( 1, 8 ):
        object = cls_TestObject.TestObject( )     # instantiate TestObject
        # populate object properties
        object.descriptor = "sphere"
        object.sizeName   = "diameter"
        object.sizeValue  = 100
        object.dValue     = "050"
        object.sizeUnits  = "m"
        object.areaUnits  = "m^2"
        object.resolution = str( res ).zfill( 2 )
        object.stemName   = object.descriptor + '-d' + object.dValue
        object.sourcePath = "/Tlaloc/Mercury-MoM/library/sphere/" + object.dValue + "m/MoM/resolution-" + object.resolution + "/"
        object.outputPath = "/Tlaloc/Mercury-MoM/library/sphere/" + object.dValue + "m/xls/"
        object.setup_io( )
        object.area_circular( )

        object.print_attributes( )

        # container for MoM data and results
        MoMresults = tools_xl.xl_new_workbook( object )

        # close MoMresults
        MoMresults.close( )

    print( "\n", datetime.datetime.now( ) )
    print( "source: %s/%s" % ( os.getcwd( ), os.path.basename( __file__ ) ) )
    print( "python version %s" % sys.version )

# $ python MoM.py

# Object attributes:
# descriptor     = sphere
# sizeName       = diameter
# sizeValue      = 10
# sizeUnits      = m
# resolution     = 01
# sourcePath     = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-01/
# stemName       = sphere-d005
# sourceFile     = sphere-d005-01
# sourcePathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-01/sphere-d005-01
# outputFile     = sphere-d005-01.xlsx
# outputPath     = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/
# outputPathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-01.xlsx
# uuid           = 49bfb71a-1ea9-45be-957d-db91092ec460
#
# creating /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-01.xlsx
# adding sheet 3 MHz
# adding sheet 4 MHz
# adding sheet 5 MHz
# adding sheet 6 MHz
# adding sheet 7 MHz
# adding sheet 8 MHz
# adding sheet 9 MHz
# adding sheet 10 MHz
# adding sheet 11 MHz
# adding sheet 12 MHz
# adding sheet 13 MHz
# adding sheet 14 MHz
# adding sheet 15 MHz
# adding sheet 16 MHz
# adding sheet 17 MHz
# adding sheet 18 MHz
# adding sheet 19 MHz
# adding sheet 20 MHz
# adding sheet 21 MHz
# adding sheet 22 MHz
# adding sheet 23 MHz
# adding sheet 24 MHz
# adding sheet 25 MHz
# adding sheet 26 MHz
# adding sheet 27 MHz
# adding sheet 28 MHz
# adding sheet 29 MHz
# adding sheet 30 MHz
#
# Object attributes:
# descriptor     = sphere
# sizeName       = diameter
# sizeValue      = 10
# sizeUnits      = m
# resolution     = 02
# sourcePath     = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-02/
# stemName       = sphere-d005
# sourceFile     = sphere-d005-02
# sourcePathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-02/sphere-d005-02
# outputFile     = sphere-d005-02.xlsx
# outputPath     = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/
# outputPathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-02.xlsx
# uuid           = b0fd6ca5-20ff-4354-87d5-e21c649aa59c
#
# creating /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-02.xlsx
# adding sheet 3 MHz
# adding sheet 4 MHz
# adding sheet 5 MHz
# adding sheet 6 MHz
# adding sheet 7 MHz
# adding sheet 8 MHz
# adding sheet 9 MHz
# adding sheet 10 MHz
# adding sheet 11 MHz
# adding sheet 12 MHz
# adding sheet 13 MHz
# adding sheet 14 MHz
# adding sheet 15 MHz
# adding sheet 16 MHz
# adding sheet 17 MHz
# adding sheet 18 MHz
# adding sheet 19 MHz
# adding sheet 20 MHz
# adding sheet 21 MHz
# adding sheet 22 MHz
# adding sheet 23 MHz
# adding sheet 24 MHz
# adding sheet 25 MHz
# adding sheet 26 MHz
# adding sheet 27 MHz
# adding sheet 28 MHz
# adding sheet 29 MHz
# adding sheet 30 MHz
#
# Object attributes:
# descriptor     = sphere
# sizeName       = diameter
# sizeValue      = 10
# sizeUnits      = m
# resolution     = 03
# sourcePath     = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-03/
# stemName       = sphere-d005
# sourceFile     = sphere-d005-03
# sourcePathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-03/sphere-d005-03
# outputFile     = sphere-d005-03.xlsx
# outputPath     = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/
# outputPathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-03.xlsx
# uuid           = 0c3da6b2-54c5-4a83-bafd-f2b5a5bd2dc9
#
# creating /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-03.xlsx
# adding sheet 3 MHz
# adding sheet 4 MHz
# adding sheet 5 MHz
# adding sheet 6 MHz
# adding sheet 7 MHz
# adding sheet 8 MHz
# adding sheet 9 MHz
# adding sheet 10 MHz
# adding sheet 11 MHz
# adding sheet 12 MHz
# adding sheet 13 MHz
# adding sheet 14 MHz
# adding sheet 15 MHz
# adding sheet 16 MHz
# adding sheet 17 MHz
# adding sheet 18 MHz
# adding sheet 19 MHz
# adding sheet 20 MHz
# adding sheet 21 MHz
# adding sheet 22 MHz
# adding sheet 23 MHz
# adding sheet 24 MHz
# adding sheet 25 MHz
# adding sheet 26 MHz
# adding sheet 27 MHz
# adding sheet 28 MHz
# adding sheet 29 MHz
# adding sheet 30 MHz
#
# Object attributes:
# descriptor     = sphere
# sizeName       = diameter
# sizeValue      = 10
# sizeUnits      = m
# resolution     = 04
# sourcePath     = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-04/
# stemName       = sphere-d005
# sourceFile     = sphere-d005-04
# sourcePathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-04/sphere-d005-04
# outputFile     = sphere-d005-04.xlsx
# outputPath     = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/
# outputPathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-04.xlsx
# uuid           = 5b4a3772-63ab-4862-b830-66a22a4f70d8
#
# creating /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-04.xlsx
# adding sheet 3 MHz
# adding sheet 4 MHz
# adding sheet 5 MHz
# adding sheet 6 MHz
# adding sheet 7 MHz
# adding sheet 8 MHz
# adding sheet 9 MHz
# adding sheet 10 MHz
# adding sheet 11 MHz
# adding sheet 12 MHz
# adding sheet 13 MHz
# adding sheet 14 MHz
# adding sheet 15 MHz
# adding sheet 16 MHz
# adding sheet 17 MHz
# adding sheet 18 MHz
# adding sheet 19 MHz
# adding sheet 20 MHz
# adding sheet 21 MHz
# adding sheet 22 MHz
# adding sheet 23 MHz
# adding sheet 24 MHz
# adding sheet 25 MHz
# adding sheet 26 MHz
# adding sheet 27 MHz
# adding sheet 28 MHz
# adding sheet 29 MHz
# adding sheet 30 MHz
#
# Object attributes:
# descriptor     = sphere
# sizeName       = diameter
# sizeValue      = 10
# sizeUnits      = m
# resolution     = 05
# sourcePath     = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-05/
# stemName       = sphere-d005
# sourceFile     = sphere-d005-05
# sourcePathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-05/sphere-d005-05
# outputFile     = sphere-d005-05.xlsx
# outputPath     = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/
# outputPathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-05.xlsx
# uuid           = d0b9f6dc-ab64-4340-a454-36a1252f3112
#
# creating /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-05.xlsx
# adding sheet 3 MHz
# adding sheet 4 MHz
# adding sheet 5 MHz
# adding sheet 6 MHz
# adding sheet 7 MHz
# adding sheet 8 MHz
# adding sheet 9 MHz
# adding sheet 10 MHz
# adding sheet 11 MHz
# adding sheet 12 MHz
# adding sheet 13 MHz
# adding sheet 14 MHz
# adding sheet 15 MHz
# adding sheet 16 MHz
# adding sheet 17 MHz
# adding sheet 18 MHz
# adding sheet 19 MHz
# adding sheet 20 MHz
# adding sheet 21 MHz
# adding sheet 22 MHz
# adding sheet 23 MHz
# adding sheet 24 MHz
# adding sheet 25 MHz
# adding sheet 26 MHz
# adding sheet 27 MHz
# adding sheet 28 MHz
# adding sheet 29 MHz
# adding sheet 30 MHz
#
# Object attributes:
# descriptor     = sphere
# sizeName       = diameter
# sizeValue      = 10
# sizeUnits      = m
# resolution     = 06
# sourcePath     = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-06/
# stemName       = sphere-d005
# sourceFile     = sphere-d005-06
# sourcePathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/MoM/resolution-06/sphere-d005-06
# outputFile     = sphere-d005-06.xlsx
# outputPath     = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/
# outputPathFile = /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-06.xlsx
# uuid           = 1592d999-e2d6-4840-bac1-a12ec0efd2ca
#
# creating /Tlaloc/Mercury-MoM/library/sphere/005m/xls/sphere-d005-06.xlsx
# adding sheet 3 MHz

#  2020-06-26 20:27:04.384031
# source: /Tlaloc/python/sphere/MoM.py
# python version 3.7.7 (default, Jun 26 2020, 09:53:42)
# [GCC 10.1.0]

# $ lsb_release -a
# No LSB modules are available.
# Distributor ID:	Ubuntu
# Description:	Ubuntu 20.04 LTS
# Release:	20.04
# Codename:	focal
