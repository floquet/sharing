class Vertex(object):

    DEFAULT_W: float = 1.0

#region Constructor

    def __init__(self,
                 x: float = 0.0,
                 y: float = 0.0,
                 z: float = 0.0,
                 w: float = DEFAULT_W) -> None:
        self.__w: float = w
        self.__x: float = x
        self.__y: float = y
        self.__z: float = z

#endregion

#region Properties

    @property
    def w(self) -> float:
        return self.__w

    @w.setter
    def w(self, value: float) -> None:
        self.__w = value

    @property
    def x(self) -> float:
        return self.__x

    @x.setter
    def x(self, value: float) -> None:
        self.__x = value

    @property
    def y(self) -> float:
        return self.__y

    @y.setter
    def y(self, value: float) -> None:
        self.__y = value

    @property
    def z(self) -> float:
        return self.__z

    @z.setter
    def z(self, value: float) -> None:
        self.__z = value

#endregion

#region Overridden/Implemented Methods

    def __str__(self) -> str:
        return (
            f"{self.__x} "
            f"{self.__y} "
            f"{self.__z} "
            f"{self.__w}"
        )

#endregion