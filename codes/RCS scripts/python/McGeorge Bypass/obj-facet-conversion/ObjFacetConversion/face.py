class Face(object):

#region Constructors

    def __init__(self                        , \
                 material_ids  : [str] = None, \
                 vertex_indices: [int] = None) \
                 -> None:

        self.__material_ids  : [str] = [] if material_ids   is None else material_ids
        self.__vertex_indices: [int] = [] if vertex_indices is None else vertex_indices

#endregion

    @property
    def material_ids(self) -> [str]:
        return self.__material_ids

    @material_ids.setter
    def material_ids(self, value: [str]) -> None:
        self.__material_ids = value

    @property
    def vertex_indices(self) -> [int]:
        return self.__vertex_indices

    @vertex_indices.setter
    def vertex_indices(self, value: [int]) -> None:
        self.__vertex_indices = value

#region Overridden/Implemented Methods

    def __str__(self) -> str:
        return (
            "material_ids=[" + " ".join(material_id for material_id in self.__material_ids) + "],"
            "vertex_indices=[" + " ".join(str(vertex_index) for vertex_index in self.__vertex_indices) + "]"
        )

#endregion
