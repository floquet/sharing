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

    @property
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

        # Calculate the hyperbolic eccentric anomaly (H)
        # H = asinh(numerator / denominator)
        hyperbolic_eccentric_anomaly = math.asinh(argument)

        # Compute the hyperbolic mean anomaly (Mh) from the hyperbolic eccentric anomaly (H)
        # Mh = e * sinh(H) - H
        sinh_H = math.sinh(hyperbolic_eccentric_anomaly)
        hyperbolic_mean_anomaly = e * sinh_H - hyperbolic_eccentric_anomaly

        # Wrap the mean anomaly into a Quantity with radians unit
        return Quantity(hyperbolic_mean_anomaly, radian)

    def argument_of_latitude(self) -> Quantity:
        """Calculate the argument of latitude in radians."""
        return self.argument_of_perigee + self.true_anomaly

    def true_longitude(self) -> Quantity:
        """
        Calculate the true longitude (L) in radians for the orbiting body.

        True longitude is defined as the sum of the right ascension of the ascending node (Ω),
        the argument of perigee (ω), and the true anomaly (ν).

        Mathematically:
            L = Ω + ω + ν

        The result is normalized to the range [0, 2π) radians.

        Returns:
            Quantity: True longitude in radians.
        """
        # Convert each orbital element to radians and extract the numerical value
        try:
            # Ensure the units are converted to radians before extraction
            raan_rad = self.right_ascension_of_ascending_node.to(radian).value  # Ω in radians
            arg_perigee_rad = self.argument_of_perigee.to(radian).value  # ω in radians
            true_anomaly_rad = self.true_anomaly.to(radian).value  # ν in radians
        except AttributeError as e:
            raise AttributeError("One of the orbital elements does not support unit conversion.") from e
        except Exception as e:
            raise ValueError("Error in converting orbital elements to radians.") from e

        # Calculate the sum of the orbital angles to obtain the true longitude
        true_longitude = raan_rad + arg_perigee_rad + true_anomaly_rad

        # Normalize the true longitude to be within [0, 2π) radians
        true_longitude_normalized = true_longitude % (2 * math.pi)

        # Return the true longitude as a Quantity with radians unit
        return Quantity(true_longitude_normalized, radian)

    def longitude_of_periapsis(self) -> Quantity:
        """
        Calculate the longitude of periapsis (Π) in radians.

        The longitude of periapsis is defined as the sum of the Right Ascension of the Ascending Node (Ω)
        and the Argument of Periapsis (ω).

        Mathematically:
            Π = Ω + ω

        The result is normalized to the range [0, 2π) radians.

        Returns:
            Quantity: Longitude of periapsis in radians.
        """
        try:
            # Convert Right Ascension of Ascending Node (Ω) to radians and extract its numerical value
            raan_rad = self.right_ascension_of_ascending_node.to(radian).value  # Ω in radians

            # Convert Argument of Periapsis (ω) to radians and extract its numerical value
            arg_periapsis_rad = self.argument_of_perigee.to(radian).value  # ω in radians
        except AttributeError as e:
            raise AttributeError("Orbital elements must support unit conversion to radians.") from e
        except Exception as e:
            raise ValueError("Error in converting orbital elements to radians.") from e

        # Calculate the longitude of periapsis by summing Ω and ω
        longitude_periapsis = raan_rad + arg_periapsis_rad

        # Normalize the longitude of periapsis to be within [0, 2π) radians
        longitude_periapsis_normalized = longitude_periapsis % (2 * math.pi)

        # Return the longitude of periapsis as a Quantity with radians unit
        return Quantity(longitude_periapsis_normalized, radian)

    @staticmethod
    def from_rv(position: Vector3D, velocity: Vector3D, gravitational_parameter=EARTH_GRAVITATIONAL_PARAMETER) -> 'ClassicalOrbitalElements':
        from src.orbital_mechanics.experiments.new_coe_rv import rv2coe
        result = rv2coe(position, velocity, gravitational_parameter)
        return result

    def to_rv(self, gravitational_parameter=EARTH_GRAVITATIONAL_PARAMETER) -> tuple[Vector3D, Vector3D]:
        from src.orbital_mechanics.experiments.new_coe_rv import coe2rv
        result = coe2rv(self, gravitational_parameter)
        return result

    @staticmethod
    def mean_to_true_anomaly(mean_anomaly: float, eccentricity: float, max_iterations: int = 100,
                             tolerance: float = 1e-6) -> float:
        """
        Convert mean anomaly (M) to true anomaly (ν) for elliptical orbits (eccentricity e < 1)
        using the Newton-Raphson iterative method.

        Args:
            mean_anomaly (float): Mean anomaly M in radians.
            eccentricity (float): Eccentricity e of the orbit (0 <= e < 1).
            max_iterations (int, optional): Maximum number of iterations for convergence. Defaults to 100.
            tolerance (float, optional): Convergence threshold. Defaults to 1e-6 radians.

        Returns:
            float: True anomaly ν in radians, normalized between 0 and 2π.

        Raises:
            ValueError: If the eccentricity is not less than 1.
            RuntimeError: If the solution does not converge within the maximum iterations.
        """

        # Validate input eccentricity
        if eccentricity >= 1:
            raise ValueError("Mean anomaly to true anomaly conversion is only valid for e < 1 (elliptical orbits).")

        # Initialize eccentric anomaly (E) with mean anomaly (M) as the initial guess
        eccentric_anomaly = mean_anomaly

        # Iteratively solve Kepler's Equation: M = E - e * sin(E)
        for iteration in range(1, max_iterations + 1):
            # Calculate the function value F(E) = E - e * sin(E) - M
            f_E = eccentric_anomaly - eccentricity * math.sin(eccentric_anomaly) - mean_anomaly

            # Calculate the derivative F'(E) = 1 - e * cos(E)
            f_E_derivative = 1 - eccentricity * math.cos(eccentric_anomaly)

            # Prevent division by zero in derivative
            if f_E_derivative == 0:
                raise RuntimeError(f"Derivative is zero. Newton-Raphson method fails at iteration {iteration}.")

            # Newton-Raphson step: ΔE = -F(E) / F'(E)
            delta_E = -f_E / f_E_derivative

            # Update the estimate of eccentric anomaly
            eccentric_anomaly += delta_E

            # Debugging statements (optional)
            # print(f"Iteration {iteration}: E = {eccentric_anomaly}, F(E) = {f_E}, ΔE = {delta_E}")

            # Check for convergence
            if abs(delta_E) < tolerance:
                break
        else:
            # If the loop completes without breaking, convergence was not achieved
            raise RuntimeError("mean_to_true_anomaly did not converge within the maximum number of iterations.")

        # Compute true anomaly (ν) from eccentric anomaly (E)
        # Using the trigonometric relationships:
        # sin(ν) = (sqrt(1 - e^2) * sin(E)) / (1 - e * cos(E))
        # cos(ν) = (cos(E) - e) / (1 - e * cos(E))
        sqrt_one_minus_e_squared = math.sqrt(1 - eccentricity ** 2)
        sin_E = math.sin(eccentric_anomaly)
        cos_E = math.cos(eccentric_anomaly)
        denominator = 1 - eccentricity * cos_E

        sin_nu = (sqrt_one_minus_e_squared * sin_E) / denominator
        cos_nu = (cos_E - eccentricity) / denominator

        # Calculate true anomaly using atan2 to determine the correct quadrant
        true_anomaly = math.atan2(sin_nu, cos_nu)

        # Normalize the true anomaly to the range [0, 2π)
        true_anomaly_normalized = true_anomaly % (2 * math.pi)

        return true_anomaly_normalized

    @staticmethod
    def hyperbolic_mean_to_true_anomaly(hyperbolic_mean_anomaly: Quantity,
                                        eccentricity: float,
                                        max_iterations: int = 100,
                                        tolerance: float = 1e-6) -> Quantity:
        """
        Convert hyperbolic mean anomaly (Mh) to true anomaly (ν) for hyperbolic orbits (eccentricity e > 1)
        using the Newton-Raphson iterative method.

        Args:
            hyperbolic_mean_anomaly (Quantity): Hyperbolic mean anomaly Mh with units of radians.
            eccentricity (float): Eccentricity e of the hyperbolic orbit (e > 1).
            max_iterations (int, optional): Maximum number of iterations for convergence. Defaults to 100.
            tolerance (float, optional): Convergence threshold. Defaults to 1e-6 radians.

        Returns:
            Quantity: True anomaly ν in radians.

        Raises:
            ValueError: If the eccentricity is not greater than 1.
            RuntimeError: If the solution does not converge within the maximum iterations.
        """

        # Validate input eccentricity
        if eccentricity <= 1:
            raise ValueError("Eccentricity must be greater than 1 for hyperbolic orbits.")

        # Extract the numerical value from the Quantity object
        Mh = hyperbolic_mean_anomaly.to(radian).value  # Hyperbolic mean anomaly in radians

        # Initialize hyperbolic eccentric anomaly (H) with an initial guess
        # A reasonable initial guess is H = asinh(Mh / e)
        H = math.asinh(Mh / eccentricity)

        # Newton-Raphson Iterative Process to solve Kepler's Equation for hyperbolic orbits:
        # Mh = e * sinh(H) - H
        for iteration in range(1, max_iterations + 1):
            # Calculate the function value F(H) = e * sinh(H) - H - Mh
            F_H = eccentricity * math.sinh(H) - H - Mh

            # Calculate the derivative F'(H) = e * cosh(H) - 1
            F_H_derivative = eccentricity * math.cosh(H) - 1

            # Prevent division by zero in derivative
            if F_H_derivative == 0:
                raise RuntimeError(f"Derivative is zero. Newton-Raphson method fails at iteration {iteration}.")

            # Newton-Raphson step: ΔH = -F(H) / F'(H)
            delta_H = -F_H / F_H_derivative

            # Update the estimate of hyperbolic eccentric anomaly
            H += delta_H

            # Debugging statement (optional)
            # print(f"Iteration {iteration}: H = {H}, F(H) = {F_H}, ΔH = {delta_H}")

            # Check for convergence
            if abs(delta_H) < tolerance:
                # Converged to a solution within the specified tolerance
                break
        else:
            # If the loop completes without breaking, convergence was not achieved
            raise RuntimeError(
                "hyperbolic_mean_to_true_anomaly did not converge within the maximum number of iterations.")

        # Compute the true anomaly (ν) from the hyperbolic eccentric anomaly (H)
        # Using the relations:
        # sin(ν) = (sinh(H) * sqrt(e² - 1)) / (e * cosh(H) - 1)
        # cos(ν) = (e - cosh(H)) / (e * cosh(H) - 1)
        sqrt_e_squared_minus_one = math.sqrt(eccentricity ** 2 - 1)  # Always positive for hyperbolic orbits
        sinh_H = math.sinh(H)
        cosh_H = math.cosh(H)
        denominator = eccentricity * cosh_H - 1

        # Compute sine of true anomaly
        sin_nu = (sinh_H * sqrt_e_squared_minus_one) / denominator

        # Compute cosine of true anomaly
        cos_nu = (eccentricity - cosh_H) / denominator

        # Calculate true anomaly using atan2 to determine the correct quadrant
        true_anomaly = math.atan2(sin_nu, cos_nu)

        # Return the true anomaly as a Quantity with radians unit
        return Quantity(true_anomaly, radian)






