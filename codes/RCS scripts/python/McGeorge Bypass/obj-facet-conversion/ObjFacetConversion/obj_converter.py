from face        import Face
from facet_model import FacetModel
from obj_model   import ObjModel
from part        import Part
from subpart     import ElementType, Subpart

import datetime

class ObjConverter(object):

#region Constructors

    def __init__(self):
        pass

#endregion

#region Public Methods

    def from_facet_model(self, facet_model: FacetModel) -> ObjModel:
        assert(facet_model is not None)

        obj_model: ObjModel = ObjModel()
        for part in facet_model.parts:
            obj_model.vertices.extend(part.vertices)
            for subpart in part.subparts:
                obj_model.faces.extend(subpart.faces)

        return obj_model

#endregion
