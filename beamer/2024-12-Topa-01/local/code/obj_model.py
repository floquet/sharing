from face   import Face
from vertex import Vertex

class ObjModel(object):

#region Constructors

    def __init__(self                     ,
                 faces   : [Face  ] = None,
                 vertices: [Vertex] = None) -> None:

        self.__faces   : [Face  ] = [] if faces    is None else faces
        self.__vertices: [Vertex] = [] if vertices is None else vertices

#endregion

#region Properties

    @property
    def faces(self) -> [Face]:
        return self.__faces

    @faces.setter
    def faces(self, value: [Face]) -> None:
        self.__faces = value

    @property
    def vertices(self) -> [Vertex]:
        return self.__vertices

    @vertices.setter
    def vertices(self, value: [Vertex]) -> None:
        self.__vertices = value

#endregion

#region Overridden/Implemented Methods

    def __str__(self) -> str:
        return (
            "faces=["                                               +
            " ".join(f"({face!s})" for face in self.__faces)        +
            "],vertices=["                                          +
            " ".join(f"({vertex!s})" for vertex in self.__vertices) +
            "]"
        )

#endregion
