from obj_model import ObjModel

import io
import os

class ObjFileWriter(object):

#region Constructors

    def __init__(self) -> None:
        pass

#endregion

#region Public Methods

    def to_string(self               ,
                  obj_model: ObjModel) \
                  -> str:

        assert(obj_model is not None)

        representation: str = ""
        representation += "\n".join(f"v {vertex.x} {vertex.y} {vertex.z}" for vertex in obj_model.vertices) + "\n"
        representation += "\n".join(f"f {' '.join(str(vertex_index) for vertex_index in face.vertex_indices)}" for face in obj_model.faces) + "\n"

        return representation


    def write(self               ,
              file_name: str     ,
              obj_model: ObjModel) \
              -> None:

        assert(len(file_name) > 0)
        assert(obj_model is not None)

        with io.open(file_name, 'w') as file:
            representation: str = self.to_string(obj_model)
            file.write(representation)

#endregion
