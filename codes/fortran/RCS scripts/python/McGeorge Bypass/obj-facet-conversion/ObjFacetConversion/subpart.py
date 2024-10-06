from enum import Enum
from face import Face

class ElementType(Enum):
    EDGE     = 2
    TRIANGLE = 3
    MIXED    = 15

class Subpart(object):

#region Constructors

    def __init__(self,
                 boundary_condition       : int         = 0               ,
                 element_count            : int         = 0               ,
                 element_curvature_present: bool        = False           ,
                 element_type             : ElementType = ElementType.EDGE,
                 faces                    : [Face]      = None            ,
                 inner_region_id          : int         = 0               ,
                 material_field_two_sided : bool        = False           ,
                 name                     : str         = ""              ,
                 outer_region_id          : str         = ""              ,
                 vertex_count             : int         = 0               ,
                 vertex_normal_present    : bool        = False           ,
                 vertex_parameter_present : bool        = False           ) \
                -> None:

        self.__boundary_condition       : int         = boundary_condition
        self.__element_count            : int         = element_count
        self.__element_curvature_present: bool        = element_curvature_present
        self.__element_type             : ElementType = element_type
        self.__faces                    : [Face]      = [] if faces is None else faces
        self.__inner_region_id          : str         = inner_region_id
        self.__material_field_two_sided : bool        = material_field_two_sided
        self.__name                     : str         = name
        self.__outer_region_id          : str         = outer_region_id
        self.__vertex_count             : int         = vertex_count
        self.__vertex_normal_present    : bool        = vertex_normal_present
        self.__vertex_parameter_present : bool        = vertex_parameter_present

#endregion

#region Properties

    @property
    def boundary_condition(self) -> int:
        return self.__boundary_condition

    @boundary_condition.setter
    def boundary_condition(self, value: int) -> None:
        self.__boundary_condition = value

    @property
    def element_count(self) -> int:
        return self.__element_count

    @element_count.setter
    def element_count(self, value: int) -> None:
        self.__element_count = value

    @property
    def element_curvature_present(self) -> bool:
        return self.__element_curvature_present

    @element_curvature_present.setter
    def element_curvature_present(self, value: bool) -> None:
        self.__element_curvature_present = value

    @property
    def element_type(self) -> ElementType:
        return self.__element_type

    @element_type.setter
    def element_type(self, value: ElementType) -> None:
        self.__element_type = value

    @property
    def faces(self) -> [Face]:
        return self.__faces

    @faces.setter
    def faces(self, value: [Face]) -> None:
        self.__faces = value

    @property
    def inner_region_id(self) -> int:
        return self.__inner_region_id

    @inner_region_id.setter
    def inner_region_id(self, value: int) -> None:
        self.__inner_region_id = value

    @property
    def material_field_two_sided(self) -> bool:
        return self.__material_field_two_sided

    @material_field_two_sided.setter
    def material_field_two_sided(self, value: bool) -> None:
        self.__material_field_two_sided = value

    @property
    def name(self) -> str:
        return self.__name

    @name.setter
    def name(self, value: str) -> None:
        self.__name = value

    @property
    def outer_region_id(self) -> str:
        return self.__outer_region_id

    @outer_region_id.setter
    def outer_region_id(self, value: str) -> None:
        self.__outer_region_id = value

    @property
    def vertex_count(self) -> int:
        return self.__vertex_count

    @vertex_count.setter
    def vertex_count(self, value: int) -> None:
        self.__vertex_count = value

    @property
    def vertex_normal_present(self) -> bool:
        return self.__vertex_normal_present

    @vertex_normal_present.setter
    def vertex_normal_present(self, value: bool) -> None:
        self.__vertex_normal_present = value

    @property
    def vertex_parameter_present(self) -> bool:
        return self.__vertex_parameter_present

    @vertex_parameter_present.setter
    def vertex_parameter_present(self, value: bool) -> None:
        self.__vertex_parameter_present = value

#endregion

#region Overridden/Implemented Methods

    def __str__(self) -> str:
        return (
            f"boundary_condition={self.__boundary_condition},"                  +
            f"element_count={self.__element_count},"                            +
            f"element_curvature_present={self.__element_curvature_present},"    +
            f"element_type={self.__element_type},"                              +
            "faces=[" + " ".join(f"({face!s})" for face in self.__faces) + "]," +
            f"inner_region_id={self.__inner_region_id},"                        +
            f"material_field_two_sided={self.__material_field_two_sided},"      +
            f"name=\"{self.__name}\","                                          +
            f"outer_region_id={self.__outer_region_id},"                        +
            f"vertex_count={self.__vertex_count},"                              +
            f"vertex_normal_present={self.__vertex_normal_present},"            +
            f"vertex_parameter_present={self.__vertex_parameter_present}"
        )

#endregion
