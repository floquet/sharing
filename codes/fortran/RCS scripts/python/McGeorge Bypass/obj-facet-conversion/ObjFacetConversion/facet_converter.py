from face        import Face
from facet_model import FacetModel
from obj_model   import ObjModel
from part        import Part
from subpart     import ElementType, Subpart

import datetime

class FacetConverter(object):

#region Constants

    __DEFAULT_FORMAT              : str         = "FACET FILE V3.4"
    __DEFAULT_PART_MIRRORED       : bool        = False
    __DEFAULT_PART_NAME           : str         = "<PTW MeshModel>"
    __DEFAULT_PLATFORM            : str         = ""
    __DEFAULT_SUBPART_NAME        : str         = "<PTW MeshSheet>"
    __DEFAULT_SUBPART_ELEMENT_TYPE: ElementType = ElementType.TRIANGLE
    __DEFAULT_SUBPART_MATERIAL_ID : str         = "0"

#endregion
    
#region Constructors

    def __init__(self):
        pass

#endregion

#region Public Methods

    def from_obj_model(self, obj_model: ObjModel) -> FacetModel:
        assert(obj_model is not None)

        facet_model: FacetModel   = FacetModel()
        facet_model.format        = FacetConverter.__DEFAULT_FORMAT
        facet_model.creation_time = datetime.datetime.now()
        facet_model.platform      = FacetConverter.__DEFAULT_PLATFORM

        part: Part    = Part()
        part.name     = FacetConverter.__DEFAULT_PART_NAME
        part.mirrored = FacetConverter.__DEFAULT_PART_MIRRORED
        part.vertices.extend(obj_model.vertices)

        subpart: Subpart     = Subpart()
        subpart.name         = FacetConverter.__DEFAULT_SUBPART_NAME
        subpart.element_type = FacetConverter.__DEFAULT_SUBPART_ELEMENT_TYPE
        for obj_face in obj_model.faces:
            facet_face: Face = Face()
            facet_face.material_ids.append(FacetConverter.__DEFAULT_SUBPART_MATERIAL_ID)
            facet_face.vertex_indices.extend(obj_face.vertex_indices)
            subpart.faces.append(facet_face)

        part.subparts.append(subpart)
        facet_model.parts.append(part)

        return facet_model

#endregion
