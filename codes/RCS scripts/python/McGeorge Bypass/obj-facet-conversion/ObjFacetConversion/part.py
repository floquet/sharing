from subpart import Subpart
from vertex  import Vertex

class Part(object):

#region Constructors
    
    def __init__(self                       ,
                 mirrored: bool      = False,
                 name    : str       = ""   ,
                 subparts: [Subpart] = None ,
                 vertices: [Vertex ] = None ) \
                 -> None:
        
        self.__mirrored: bool      = mirrored
        self.__name    : str       = name
        self.__subparts: [Subpart] = [] if subparts is None else subparts
        self.__vertices: [Vertex ] = [] if vertices is None else vertices

#endregion

#region Properties

    @property
    def mirrored(self) -> bool:
        return self.__mirrored

    @mirrored.setter
    def mirrored(self, value: bool) -> None:
        self.__mirrored = value

    @property
    def name(self) -> str:
        return self.__name

    @name.setter
    def name(self, value: str) -> None:
        self.__name = value

    @property
    def subparts(self) -> Subpart:
        return self.__subparts

    @subparts.setter
    def subparts(self, value: Subpart) -> None:
        self.__subpart = value

    @property
    def vertices(self) -> Vertex:
        return self.__vertices

    @vertices.setter
    def vertices(self, value: Vertex) -> None:
        self.__vertices = value

#endregion

#region Overridden/Implemented Methods

    def __str__(self) -> str:
        return (
            f"mirrored={self.__mirrored},"                                                  +
            f"name=\"{self.__name}\","                                                      +
            "subparts=[" + " ".join(f"({subpart!s})" for subpart in self.__subparts) + "]," +
            "vertices=[" + " ".join(f"({vertex!s})"  for vertex  in self.__vertices) + "]"
        )

#endregion
