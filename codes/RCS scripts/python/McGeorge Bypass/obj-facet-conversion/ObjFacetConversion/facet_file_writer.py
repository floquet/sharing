from datetime    import datetime
from facet_model import FacetModel
from subpart     import Subpart
from part        import Part

import io
import os

class FacetFileWriter(object):

#region Constants

    __DEFAULT_MATERIAL_ID: str = "0"
    __FORMAT_DATE_TIME   : str = "%d-%b-%Y %H:%M:%S"
    __LENGTH_NAME        : int = 20

#endregion

#region Constructors

    def __init__(self) -> None:
        pass

#endregion

#region Public Methods

    def to_string(self                   ,
                  facet_model: FacetModel) \
                  -> str:

        assert(facet_model is not None)

        representation: str = ""
        representation += self.__make_format_line(facet_model) + "\n"
        representation += str(len(facet_model.parts)) + "\n"
        for part in facet_model.parts:
            representation += self.__pad_space(part.name, 20) + "\n"
            representation += ("1" if part.mirrored else "0") + "\n"

            representation += str(len(part.vertices)) + "\n"
            for vertex in part.vertices:
                representation += str(vertex.x) + " "
                representation += str(vertex.y) + " "
                representation += str(vertex.z) + "\n"

            representation += str(len(part.subparts)) + "\n"
            for subpart in part.subparts:
                representation += subpart.name + "\n"
                representation += self.__make_element_line(subpart) + "\n"

                for face in subpart.faces:
                    representation += " ".join(str(vertex_index) for vertex_index in face.vertex_indices)
                    if len(face.material_ids) > 0:
                        representation += " "
                        representation += " ".join(str(material_id) for material_id in face.material_ids)
                    representation += "\n"

        return representation


    def write(self                   ,
              file_name: str         ,
              facet_model: FacetModel) \
              -> None:

        assert(len(file_name) > 0)
        assert(facet_model is not None)

        with io.open(file_name, 'w') as file:
            representation: str = self.to_string(facet_model)
            file.write(representation)

#endregion

#region Private Methods

    def __make_element_line(self, subpart: Subpart) -> str:
        assert(subpart is not None)

        return (
            f"{subpart.element_type.value} "
            f"{len(subpart.faces)} "
            f"0 "
            f"{'1' if subpart.material_field_two_sided  else '0'} "
            f"{'1' if subpart.vertex_parameter_present  else '0'} "
            f"{'1' if subpart.vertex_normal_present     else '0'} "
            f"{'1' if subpart.element_curvature_present else '0'} "
            f"{subpart.outer_region_id} "
            f"{subpart.inner_region_id} "
            f"{subpart.boundary_condition}"
        ).strip()

    def __make_format_line(self, facet_model: FacetModel) -> str:
        assert(facet_model is not None)

        line: str = ""

        line += " " + facet_model.format
        if facet_model.creation_time is not None:
            line += "\t" + facet_model.creation_time.strftime(FacetFileWriter.__FORMAT_DATE_TIME)
        line += "\t" + facet_model.platform

        return line.strip()

    def __pad_space(self,
                    s: str,
                    length: int) \
                    -> str:

        return s if len(s) >= FacetFileWriter.__LENGTH_NAME else s + (" " * (length - len(s)))

#endregion
