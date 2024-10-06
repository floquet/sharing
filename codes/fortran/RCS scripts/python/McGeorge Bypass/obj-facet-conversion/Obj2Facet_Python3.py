from datetime import datetime
from Facet import Facet
from Vertex import Vertex

import io
import os
import sys

DEFAULT_ELEMENT_DESCRIPTION   = '3 {} 0 0 0 0 0'
DEFAULT_FILE_EXTENSION_OUTPUT = '.facet'
DEFAULT_PART_COUNT            = '1'
DEFAULT_PART_MIRROR           = '0'
DEFAULT_PART_NAME             = '<PTW MeshModel>'
DEFAULT_SUBPART_COUNT         = '1'
DEFAULT_SUBPART_NAME          = '<PTW MeshSheet>'

argumentCount = len(sys.argv)

# output argument-wise
if argumentCount == 2:
    objectFileName = sys.argv[1]
    outputFileName = os.path.splitext(objectFileName)[0] + DEFAULT_FILE_EXTENSION_OUTPUT
elif argumentCount == 3:
    objectFileName = sys.argv[1]
    outputFileName = sys.argv[2]
else:
    sys.stderr.write('Usage: python Obj2Facet.py <input-obj-file-name> [<output-facet-file-name>]\n')
    sys.exit()

facetCount  = 0
facetLines  = ""
vertexCount = 0
vertexLines = ""
with io.open(objectFileName, 'r', encoding='utf-8') as objectFile:
    line = objectFile.readline()
    lineNumber = 1
    while line:
        tokens = line.strip().split(' ')
        if len(tokens) == 4:
            type = tokens[0]

            if type.lower() == 'f':
                facetLines += ' '.join(tokens[1:4])
                facetLines += ' 0'
                facetLines += '\n'
                facetCount += 1

            elif type.lower() == 'v':
                vertexLines += ' '.join(tokens[1:4])
                vertexLines += '\n'
                vertexCount += 1

        line        = objectFile.readline()
        lineNumber += 1

    objectFile.close()

with io.open(outputFileName, 'w', encoding='utf-8') as outputFile:
    outputFile.write('FACET FILE V3.4 ')
    outputFile.write(datetime.today().strftime('%d-%b-%Y %H:%M:%S'))
    outputFile.write('\n')

    outputFile.write(DEFAULT_PART_COUNT)
    outputFile.write('\n')
    outputFile.write(DEFAULT_PART_NAME)
    outputFile.write('\n')
    outputFile.write(DEFAULT_PART_MIRROR)
    outputFile.write('\n')

    outputFile.write(str(vertexCount))
    outputFile.write('\n')
    outputFile.write(vertexLines)

    outputFile.write(DEFAULT_SUBPART_COUNT)
    outputFile.write('\n')
    outputFile.write(DEFAULT_SUBPART_NAME)
    outputFile.write('\n')

    outputFile.write(DEFAULT_ELEMENT_DESCRIPTION.format(facetCount))
    outputFile.write('\n')
    outputFile.write(facetLines)

    outputFile.close()
