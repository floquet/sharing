class ResultData(object):
    """ The ResultData class represents individual backscatter RCS results. """

#region Constructors

    def __init__(self                            ,
                 theta      : float   = 0.0      ,
                 phi        : float   = 0.0      ,
                 theta_theta: complex = complex(),
                 phi_theta  : complex = complex(),
                 theta_phi  : complex = complex(),
                 phi_phi    : complex = complex()) \
                 -> None:
        """ Initializes this result set.

            Args:
                theta       (float)  : the theta value to use
                phi         (float)  : the phi value to use
                theta_theta (complex): the theta-theta value to use
                phi_theta   (complex): the phi-theta value to use
                theta_phi   (complex): the theta-phi value to use
                phi_phi     (complex): the phi-phi value to use
        """

        self.__theta       : float   = theta
        self.__phi         : float   = phi
        self.__theta_theta : complex = theta_theta
        self.__phi_theta   : complex = phi_theta
        self.__theta_phi   : complex = theta_phi
        self.__phi_phi     : complex = phi_phi

#endregion

#region Properties

    @property
    def theta(self) -> float:
        """ Gets the theta value of this data.

            Returns:
                float: the theta value of this data
        """

        return self.__theta

    @theta.setter
    def theta(self, value: float) -> None:
        """ Sets the theta value of this data.

            Args:
                value (float): the theta value to use
        """

        self.__theta = value

    @property
    def phi(self) -> float:
        """ Gets the phi value of this data.

            Returns:
                float: the phi value of this data
        """

        return self.__phi

    @phi.setter
    def phi(self, value: float) -> None:
        """ Sets the phi value of this data.

            Args:
                value (float): the phi value to use
        """

        self.__phi = value

    @property
    def theta_theta(self) -> complex:
        """ Gets the theta-theta value of this data.

            Returns:
                complex: the theta-theta value of this data
        """

        return self.__theta_theta

    @theta_theta.setter
    def theta_theta(self, value: complex) -> None:
        """ Sets the theta-theta value of this data.

            Args:
                value (complex): the theta-theta value to use
        """

        self.__theta_theta = value

    @property
    def phi_theta(self) -> complex:
        """ Gets the phi-theta value of this data.

            Returns:
                complex: the phi-theta value of this data
        """

        return self.__phi_theta

    @phi_theta.setter
    def phi_theta(self, value: complex) -> None:
        """ Sets the phi-theta value of this data.

            Args:
                value (complex): the phi-theta value to use
        """

        self.__phi_theta = value

    @property
    def theta_phi(self) -> complex:
        """ Gets the theta-phi value of this data.

            Returns:
                complex: the theta-phi value of this data
        """

        return self.__theta_phi

    @theta_phi.setter
    def theta_phi(self, value: complex) -> None:
        """ Sets the theta-phi value of this data.

            Args:
                value (complex): the theta-phi value to use
        """

        self.__theta_phi = value

    @property
    def phi_phi(self) -> complex:
        """ Gets the phi-phi value of this data.

            Returns:
                complex: the phi-phi value of this data
        """

        return self.__phi_phi

    @phi_phi.setter
    def phi_phi(self, value: complex) -> None:
        """ Sets the phi-phi value of this data.

            Args:
                value (complex): the phi-phi value to use
        """

        self.__phi_phi = value

#endregion

#region Overridden/Implemented Methods

    def __str__(self) -> str:
        """ Returns a string representation of this data.

            Returns:
                str: a string representation of this data
        """
        return (
            f"theta={self.__theta},"             +
            f"phi={self.__phi},"                 +
            f"theta_theta={self.__theta_theta}," +
            f"phi_theta={self.__phi_theta},"     +
            f"theta_phi={self.__theta_phi},"     +
            f"phi_phi={self.__phi_phi}"
        )

#endregion
