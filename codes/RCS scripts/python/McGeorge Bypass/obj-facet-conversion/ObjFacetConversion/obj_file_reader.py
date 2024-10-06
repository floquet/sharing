from face                import Face
from file_reader         import FileReader
from file_read_exception import FileReadException
from obj_model           import ObjModel
from typing              import Any
from vertex              import Vertex

import io

class ObjFileReader(FileReader):

#region Constructors

    def __init__(self) -> None:
        pass

#endregion

#region Public Methods

    def read(self, file_name: str) -> ObjModel:
        try:
            objModel: ObjModel = ObjModel()
            with io.open(file_name, 'r') as file:
                line: str = file.readline()
                lineNumber: int = 0
                while line:
                    tokens: [str] = line.strip().split(' ')
                    if len(tokens) >= 4:
                        type = tokens[0]
                        if type.lower() == 'f':
                            face = Face()
                            for tokenIndex in range(1, len(tokens)):
                                slashIndex = tokens[tokenIndex].find("/")
                                if slashIndex >= 0:
                                    face.vertex_indices.append(int(tokens[tokenIndex][0:slashIndex]))
                                else:
                                    face.vertex_indices.append(int(tokens[tokenIndex]))
                            objModel.faces.append(face)
                        elif type.lower() == 'v':
                            w: float = Vertex.DEFAULT_W
                            if len(tokens) > 4:
                                w = float(tokens[4])

                            vertex: Vertex = Vertex(float(tokens[1]),
                                                    float(tokens[2]),
                                                    float(tokens[3]),
                                                    w)
                            objModel.vertices.append(vertex)

                    line        = file.readline()
                    lineNumber += 1
        except Exception as e:
            raise FileReadException(e)

        return objModel

#endregion
