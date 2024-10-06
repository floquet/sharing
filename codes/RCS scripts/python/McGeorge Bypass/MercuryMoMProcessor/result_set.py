from result_data import ResultData

class ResultSet(object):
    """ The ResultSet class represents the backscatter RCS results at a particular frequency. """

#region Constructors

    def __init__(self                            ,
                 frequency  : float        = 0.0 ,
                 k          : float        = 0.0 ,
                 lambdaValue: float        = 0.0 ,
                 data       : [ResultData] = None) \
                 -> None:
        """ Initializes this set.

            Args:
                frequency   (float)       : the frequency in MHz to use
                k           (float)       : the k in m-1 to use
                lambdaValue (float)       : the lambda in m to use
                data        ([ResultData]): the result data to use
        """

        self.__frequency  : float        = frequency
        self.__k          : float        = k
        self.__lambdaValue: float        = lambdaValue
        self.__data       : [ResultData] = [] if data is None else data

#endregion

#region Properties

    @property
    def frequency(self) -> float:
        """ Gets the frequency in MHz of this set.

            Returns:
                float: the frequency in MHz of this set
        """

        return self.__frequency

    @frequency.setter
    def frequency(self, value: float) -> None:
        """ Sets the frequency in MHz of this set.

            Args:
                value (float): the frequency in MHz to use
        """

        self.__frequency = value

    @property
    def k(self) -> float:
        """ Gets the k in m-1 of this set.

            Returns:
                float: the k in m-1 of this set
        """

        return self.__k

    @k.setter
    def k(self, value: float) -> None:
        """ Sets the k in m-1 of this set.

            Args:
                value (float): the k in m-1 to use
        """

        self.__k = value

    @property
    def lambdaValue(self) -> float:
        """ Gets the lambda in m value of this set.

            Returns:
                float: the lambda in m value of this set
        """

        return self.__lambdaValue

    @lambdaValue.setter
    def lambdaValue(self, value: float) -> None:
        """ Sets the lambda in m value of this set.

            Args:
                value (float): the lambda in m value to use
        """

        self.__lambdaValue = value

    @property
    def data(self) -> [ResultData]:
        """ Gets the data of this set.

            Returns:
                [ResultData]: the data of this set
        """

        return self.__data

    @data.setter
    def data(self, value: [ResultData]) -> None:
        """ Sets the data of this set.

            Args:
                value ([ResultData]): the data to use
        """

        self.__data : [ResultData] = [] if value is None else value

#region Overridden/Implemented Methods

    def __str__(self) -> str:
        """ Returns a string representation of this set.

            Returns:
                str: a string representation of this set
        """
        return (
            f"frequency={self.__frequency},"     +
            f"k={self.__k},"                     +
            f"lambdaValue={self.__lambdaValue}," +
            "data=[" + " ".join(f"({data!s})" for data in self.__data) + "]"
        )

#endregion
