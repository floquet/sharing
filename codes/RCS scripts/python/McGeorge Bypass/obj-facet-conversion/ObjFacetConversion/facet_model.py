from part import Part

import datetime

class FacetModel(object):

#region Constructors

    def __init__(self                          ,
                 creation_time: datetime = None,
                 format       : str      = ""  ,
                 parts        : [Part]   = None,
                 platform     : str      = ""  ) \
                 -> None:

        self.__creation_time: datetime = creation_time
        self.__format       : str      = format
        self.__parts        : [Part]   = [] if parts is None else parts
        self.__platform     : str      = platform

#endregion

#region Properties

    @property
    def creation_time(self) -> datetime:
        return self.__creation_time

    @creation_time.setter
    def creation_time(self, value: datetime) -> None:
        self.__creation_time = value

    @property
    def format(self) -> str:
        return self.__format

    @format.setter
    def format(self, value: str) -> None:
        self.__format = value

    @property
    def parts(self) -> Part:
        return self.__parts

    @parts.setter
    def parts(self, value: Part) -> None:
        return self.__parts

    @property
    def platform(self) -> str:
        return self.__platform

    @platform.setter
    def platform(self, value: str) -> None:
        self.__platform = value

#endregion

#region Overridden/Implemented Methods

    def __str__(self) -> str:
        return (
            f"creation_time={str(self.__creation_time)},"                       +
            f"format=\"{self.__format}\","                                      +
            "parts=[" + " ".join(f"({part!s})" for part in self.__parts) + "]," +
            f"platform=\"{self.__platform}\""
        )

#endregion
