from datetime            import datetime
from face                import Face
from file_reader         import FileReader
from file_read_exception import FileReadException
from facet_model         import FacetModel
from part                import Part
from subpart             import ElementType, Subpart
from typing              import Any
from vertex              import Vertex

import io

class FacetFileReader(FileReader):

#region Constants

    __FORMAT_DATE_TIME : str = "%d-%b-%Y %H:%M:%S"

#endregion

#region Constructors

    def __init__(self) -> None:
        pass

#endregion

#region Public Methods

    def read(self, file_name: str) -> FacetModel:
        try:
            facetModel: FacetModel = FacetModel()
            with io.open(file_name, 'r') as file:
                facetModel.format       , \
                facetModel.creation_time, \
                facetModel.platform       = self.__parse_format_line(self.__read_next_non_blank_line(file))
                partCount: int = int(self.__read_next_non_blank_line(file))
                for partIndex in range(0, partCount):
                    part: Part      = Part()
                    part.name       = self.__read_next_non_blank_line(file)
                    part.mirrored   = True if self.__read_next_non_blank_line(file) == "1" else False
                    vertexCount: int = int(self.__read_next_non_blank_line(file))
                    for vertexIndex in range(0, vertexCount):
                        tokens: [str]  = self.__read_next_non_blank_line(file).split()
                        vertex: Vertex = Vertex(float(tokens[0]),
                                                float(tokens[1]),
                                                float(tokens[2]))
                        part.vertices.append(vertex)
                    subpartCount: int = int(self.__read_next_non_blank_line(file))
                    for subpartIndex in range(0, subpartCount):
                        subpart: Subpart = Subpart()
                        subpart.name = self.__read_next_non_blank_line(file)
                        subpart.element_type             , \
                        subpart.element_count            , \
                        subpart.vertex_count             , \
                        subpart.material_field_two_sided , \
                        subpart.vertex_parameter_present , \
                        subpart.vertex_normal_present    , \
                        subpart.element_curvature_present, \
                        subpart.outer_region_id          , \
                        subpart.inner_region_id          , \
                        subpart.boundary_condition         = self.__parse_element_line(self.__read_next_non_blank_line(file))
                        for elementCount in range(0, subpart.element_count):
                            tokens: [str ] = self.__read_next_non_blank_line(file).split()
                            face  : [Face] = Face()
                            for tokenIndex in range(0, len(tokens)):
                                if tokenIndex < subpart.element_type.value:
                                    face.vertex_indices.append(int(tokens[tokenIndex]))
                                else:
                                    face.material_ids.append(tokens[tokenIndex])
                            subpart.faces.append(face)
                        part.subparts.append(subpart)
                    facetModel.parts.append(part)
        except Exception as e:
            raise FileReadException(e)

        return facetModel

#endregion

#region Private Methods

    def __parse_element_line(self, line: str) -> Any:
        tokens                   : [str        ] = line.split()
        element_type             : [ElementType] = None  if len(tokens) <  1 else ElementType(int(tokens[0]))
        element_count            : [int        ] = 0     if len(tokens) <  2 else int(tokens[1])
        vertex_count             : [int        ] = 0     if len(tokens) <  3 else int(tokens[2])
        material_field_two_sided : [bool       ] = False if len(tokens) <  4 else tokens[3] == "1"
        vertex_parameter_present : [bool       ] = False if len(tokens) <  5 else tokens[4] == "1"
        vertex_normal_present    : [bool       ] = False if len(tokens) <  6 else tokens[5] == "1"
        element_curvature_present: [bool       ] = False if len(tokens) <  7 else tokens[6] == "1"
        outer_region_id          : [str        ] = ""    if len(tokens) <  8 else tokens[7]
        inner_region_id          : [str        ] = ""    if len(tokens) <  9 else tokens[8]
        boundary_condition       : [str        ] = ""    if len(tokens) < 10 else tokens[9]

        return element_type             , \
               element_count            , \
               vertex_count             , \
               material_field_two_sided , \
               vertex_parameter_present , \
               vertex_normal_present    , \
               element_curvature_present, \
               outer_region_id          , \
               inner_region_id          , \
               boundary_condition
    
    def __parse_format_line(self, line: str) -> Any:
        tokens       : [str     ] = line.split('\t')
        format       : [str     ] = ""   if len(tokens) < 1 else tokens[0]
        creation_time: [datetime] = None if len(tokens) < 2 else datetime.strptime(tokens[1], FacetFileReader.__FORMAT_DATE_TIME)
        platform     : [str     ] = ""   if len(tokens) < 3 else tokens[2]
        
        return format, creation_time, platform

    def __read_next_non_blank_line(self, file: io.TextIOBase) -> str:
        line = file.readline().strip()
        while len(line) == 0:
            line = file.readline().strip()
        return line

#endregion
