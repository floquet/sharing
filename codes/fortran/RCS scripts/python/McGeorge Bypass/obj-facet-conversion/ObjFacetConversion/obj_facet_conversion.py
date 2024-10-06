from datetime          import datetime
from facet_converter   import FacetConverter
from facet_file_reader import FacetFileReader
from facet_file_writer import FacetFileWriter
from facet_model       import FacetModel
from obj_converter     import ObjConverter
from obj_file_reader   import ObjFileReader
from obj_file_writer   import ObjFileWriter
from obj_model         import ObjModel
from part              import Part
from subpart           import Subpart
from typing            import Any

import os
import sys

FILE_EXTENSION_OBJ   = ".obj"
FILE_EXTENSION_FACET = ".facet"

def _process_command_line_arguments() -> Any:
    argument_count  : int = len(sys.argv)
    input_file_name : str = ""
    output_file_name: str = ""

    if argument_count == 2:
        input_file_name  = sys.argv[1]
        output_file_name = ""
    elif argument_count == 3:
        input_file_name  = sys.argv[1]
        output_file_name = sys.argv[2]

    return input_file_name, output_file_name

if __name__ == '__main__':

    input_file_name, output_file_name = _process_command_line_arguments()
    if len(input_file_name) == 0:
        sys.stderr.write(f"Usage: python {os.path.basename(sys.argv[0])} <input-file-name> [<output-file-name>]\n")
        exit(-1)
    input_file_extension: str = os.path.splitext(input_file_name)[1]
    if input_file_extension.lower() == FILE_EXTENSION_OBJ.lower():
        if len(output_file_name) == 0:
            output_file_name = os.path.splitext(input_file_name)[0] + FILE_EXTENSION_FACET
    elif input_file_extension.lower() == FILE_EXTENSION_FACET.lower():
        if len(output_file_name) == 0:
            output_file_name = os.path.splitext(input_file_name)[0] + FILE_EXTENSION_OBJ
    else:
        raise Exception(f"The input file \"{input_file_name}\" has an invalid extension \"{input_file_extension}\".")

    output_file_extension: str = os.path.splitext(output_file_name)[1]
    if output_file_extension.lower() != FILE_EXTENSION_OBJ.lower() and \
       output_file_extension.lower() != FILE_EXTENSION_FACET.lower():
        raise Exception(f"The input file \"{output_file_name}\" has an invalid extension \"{output_file_extension}\".")

    if os.path.exists(output_file_name):
        os.remove(output_file_name)

    try:
        if input_file_extension.lower() == FILE_EXTENSION_OBJ.lower():
            obj_file_reader : ObjFileReader = ObjFileReader()
            obj_model       : ObjModel      = obj_file_reader.read(input_file_name)
            if output_file_extension.lower() == FILE_EXTENSION_OBJ.lower():
                obj_file_writer: ObjFileWriter = ObjFileWriter()
                obj_file_writer.write(output_file_name, obj_model)
            elif output_file_extension.lower() == FILE_EXTENSION_FACET.lower():
                facet_converter  : FacetConverter  = FacetConverter()
                facet_model      : FacetModel = facet_converter.from_obj_model(obj_model)
                facet_file_writer: FacetFileWriter = FacetFileWriter()
                facet_file_writer.write(output_file_name, facet_model)
        elif input_file_extension.lower() == FILE_EXTENSION_FACET.lower():
            facet_file_reader : FacetFileReader = FacetFileReader()
            facet_model       : FacetModel      = facet_file_reader.read(input_file_name)
            if output_file_extension.lower() == FILE_EXTENSION_FACET.lower():
                facet_file_writer: FacetFileWriter = FacetFileWriter()
                facet_file_writer.write(output_file_name, facet_model)
            elif output_file_extension.lower() == FILE_EXTENSION_OBJ.lower():
                obj_converter  : ObjConverter  = ObjConverter()
                obj_model      : ObjModel = obj_converter.from_facet_model(facet_model)
                obj_file_writer: ObjFileWriter = ObjFileWriter()
                obj_file_writer.write(output_file_name, obj_model)

    except Exception as e:
        if hasattr(e, 'message'):
            sys.stderr.write(e.message + os.linesep)
        else:
            sys.stderr.write(str(e) + os.linesep)
