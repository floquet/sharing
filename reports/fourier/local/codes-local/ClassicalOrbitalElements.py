from dataclasses import dataclass
import math

from src.orbital_mechanics.experiments.new_vector3d import Vector3D
from src.orbital_mechanics.experiments.quantities import Quantity, radian, kilometer, second

km_cubed_per_s_squared = kilometer ** 3 / second ** 2

EARTH_GRAVITATIONAL_PARAMETER = Quantity(398600.4418, km_cubed_per_s_squared)

@dataclass(frozen=True)
class ClassicalOrbitalElements:
    semimajor_axis: Quantity  # km
    eccentricity: float  # dimensionless
    inclination: Quantity  # rad
    right_ascension_of_ascending_node: Quantity  # rad
    argument_of_perigee: Quantity  # rad
    true_anomaly: Quantity  # rad

    def semilatus_rectum(self) -> Quantity:
        """Calculate the semilatus rectum with units."""
        return self.semimajor_axis * (1 - self.eccentricity ** 2)

    def mean_anomaly(self) -> Quantity:
        """
        Calculate the mean anomaly (M) in radians for elliptical orbits (eccentricity e < 1).

        The mean anomaly represents the fraction of the orbital period that has elapsed since
        the satellite passed periapsis, expressed as an angle. It is calculated from the
        true anomaly using Kepler's equation.

        Returns:
            Quantity: Mean anomaly in radians.
        """
        # Ensure the orbit is elliptical
        if self.eccentricity >= 1:
            raise ValueError("Mean anomaly is only defined for elliptical orbits (e < 1).")

        # Extract orbital parameters
        e = self.eccentricity
        true_anomaly_rad = self.true_anomaly.to(radian).value  # True anomaly in radians

        # Calculate the denominator term for eccentric anomaly calculation
        denominator = 1 + e * math.cos(true_anomaly_rad)

        # Compute sine and cosine of the eccentric anomaly (E)
        sin_E = (math.sqrt(1 - e ** 2) * math.sin(true_anomaly_rad)) / denominator
        cos_E = (e + math.cos(true_anomaly_rad)) / denominator

        # Calculate eccentric anomaly (E) using atan2 to determine the correct quadrant
        eccentric_anomaly = math.atan2(sin_E, cos_E)

        # Apply Kepler's equation to find mean anomaly (M): M = E - e * sin(E)
        mean_anomaly = eccentric_anomaly - e * math.sin(eccentric_anomaly)

        # Normalize mean anomaly to the range [0, 2π) radians
        mean_anomaly_normalized = mean_anomaly % (2 * math.pi)

        # Return the mean anomaly as a Quantity with radians unit
        return Quantity(mean_anomaly_normalized, radian)

    def hyperbolic_mean_anomaly(self) -> Quantity:
        """
        Calculate the hyperbolic mean anomaly (Mh) in radians for hyperbolic orbits (eccentricity e > 1).

        The hyperbolic mean anomaly relates the time since periapsis passage to the geometry of the hyperbolic trajectory.
        It is used in solving Kepler's equation for hyperbolic orbits.

        Returns:
            Quantity: Hyperbolic mean anomaly in radians.
        """
        # Ensure the orbit is hyperbolic
        if self.eccentricity <= 1:
            raise ValueError("Eccentricity must be greater than 1 for hyperbolic orbits.")

        # Extract orbital parameters
        e = self.eccentricity  # Eccentricity of the orbit (e > 1)
        true_anomaly_rad = self.true_anomaly.to(radian).value  # True anomaly (ν) in radians

        # Calculate (e² - 1), which is always positive for hyperbolic orbits
        e_squared_minus_one = e ** 2 - 1

        # Compute sine and cosine of the true anomaly (ν)
        sin_nu = math.sin(true_anomaly_rad)
        cos_nu = math.cos(true_anomaly_rad)

        # Calculate the square root of (e² - 1)
        sqrt_e_squared_minus_one = math.sqrt(e_squared_minus_one)

        # Compute the numerator for the hyperbolic eccentric anomaly calculation
        # numerator = sin(ν) * sqrt(e² - 1)
        numerator = sin_nu * sqrt_e_squared_minus_one

        # Compute the denominator for the hyperbolic eccentric anomaly calculation
        # denominator = e * cos(ν) + 1
        denominator = e * cos_nu + 1

        # Compute the argument for the inverse hyperbolic sine function (asinh)
        # argument = numerator / denominator
        argument = numerator / denominator
