from math import cos, sin
from typing import Tuple

import numpy as np

from src.orbital_mechanics.experiments.new_classic_orbital_elements import ClassicalOrbitalElements
from src.orbital_mechanics.experiments.new_vector3d import Vector3D, ReferenceFrame
from src.orbital_mechanics.experiments.quantities import Quantity, dimensionless, radian, second, meter, Dimension, \
    DimensionSymbol

# Constants
SMALL = 1e-8
UNDEFINED = None
TWO_PI = 2 * np.pi

"""
this was all derived from a combination of obsessing over bad poliastro code and 
Curtis, H. D. (2005). Orbital Mechanics for Engineering Students (1st ed.). Elsevier Butterworth-Heinemann.
"""


import math
from fractions import Fraction

# Assuming necessary imports for Vector3D, Quantity, Unit, Dimension, DimensionSymbol, ClassicalOrbitalElements
# from your_module import Vector3D, Quantity, Unit, Dimension, DimensionSymbol, ClassicalOrbitalElements
# Also, ensure that units like meter, second, radian, dimensionless are defined as in your code.

def rv2coe(r_vec: Vector3D, v_vec: Vector3D, mu: Quantity) -> ClassicalOrbitalElements:
    """
    Converts position and velocity vectors to classical orbital elements.

    Parameters:
    - r_vec: Vector3D
        The position vector in an inertial reference frame, with units of length.
    - v_vec: Vector3D
        The velocity vector in an inertial reference frame, with units of length/time.
    - mu: Quantity
        The standard gravitational parameter, with units of length^3/time^2.

    Returns:
    - coe: ClassicalOrbitalElements
        The classical orbital elements corresponding to the given position and velocity.

    Raises:
    - ValueError: If input units are inconsistent.
    """

    # --- Unit Enforcement and Conversion ---

    # Enforce that r_vec has units of length
    if not r_vec.unit.is_length():
        raise ValueError("Position vector r_vec must have units of length.")

    # Enforce that v_vec has units of speed (length/time)
    if not v_vec.unit.is_speed():
        raise ValueError("Velocity vector v_vec must have units of speed (length/time).")

    # Enforce that mu has units of length^3 / time^2
    expected_mu_dimension = Dimension({
        DimensionSymbol.LENGTH: Fraction(3),
        DimensionSymbol.TIME: Fraction(-2)
    })
    if not mu.unit.dimension == expected_mu_dimension:
        raise ValueError("Gravitational parameter mu must have units of length^3 / time^2.")

    # Convert all quantities to SI units (meters and seconds) for consistency
    r_vec_si = r_vec.to(meter)
    meters_per_second = meter / second
    v_vec_si = v_vec.to(meters_per_second)
    mu_si_units = (meter ** 3) / (second ** 2)
    mu_si = mu.to(mu_si_units)

    # --- Begin Calculations ---

    # Compute the magnitudes of the position and velocity vectors
    r = r_vec_si.magnitude()  # Quantity with units of meters
    v = v_vec_si.magnitude()  # Quantity with units of meters per second

    # Compute the radial velocity component (vr)
    vr = r_vec_si.dot(v_vec_si) / r  # Quantity with units of meters per second

    # Compute the specific angular momentum vector (h_vec) and its magnitude (h)
    h_vec = r_vec_si.cross(v_vec_si)  # Vector3D with units of m^2 / s
    h = h_vec.magnitude()  # Quantity with units of m^2 / s

    # Define the unit vector along the z-axis (k_vec)
    k_vec = Vector3D(0.0, 0.0, 1.0, unit=dimensionless)

    # Compute the node vector (n_vec) and its magnitude (n)
    n_vec = k_vec.cross(h_vec)  # Vector3D with units of m^2 / s
    n = n_vec.magnitude()  # Quantity with units of m^2 / s

    # Compute the eccentricity vector (e_vec) and eccentricity (e)
    term_1 = (v_vec_si.cross(h_vec) / mu_si)
    term_2 = r_vec_si / r.value
    e_vec = term_1.force_units(dimensionless) - term_2.force_units(dimensionless)  # Vector3D with units of dimensionless
    e = e_vec.magnitude().value  # Dimensionless scalar

    # Compute the specific mechanical energy (energy)
    energy = (v.value ** 2) / 2 - mu_si.value / r.value  # Units: m^2 / s^2

    # Compute the semi-major axis (a)
    if energy != 0:
        a_value = -mu_si.value / (2 * energy)  # Units: meters
    else:
        # Parabolic trajectory (energy == 0), semi-major axis is undefined
        a_value = float('inf')  # Represented as infinity
    semimajor_axis = Quantity(a_value, meter)

    # Compute the inclination (i)
    h_z: float = h_vec.z  # units of m^2 / s
    inclination = math.acos(h_z / h.value)  # Result in radians

    # Compute the right ascension of the ascending node (RAAN)
    if n.value != 0:
        n_x: float = n_vec.x  # Units: m^2 / s
        raan = math.acos(n_x / n.value)  # Result in radians
        if n_vec.y < 0:
            raan = 2 * math.pi - raan
    else:
        raan = 0.0  # For equatorial orbits, RAAN is undefined; set to zero

    # Compute the argument of perigee (ω)
    if n.value != 0 and e != 0:
        n_dot_e: float = n_vec.dot(e_vec).value  # Scalar value
        argument_of_perigee = math.acos(n_dot_e / (n.value * e))  # Result in radians
        if e_vec.z < 0:
            argument_of_perigee = 2 * math.pi - argument_of_perigee
    else:
        argument_of_perigee = 0.0  # Undefined; set to zero

    # Compute the true anomaly (ν)
    if e != 0:
        e_dot_r = e_vec.dot(r_vec_si).value  # Scalar value
        true_anomaly = math.acos(e_dot_r / (e * r.value))  # Result in radians
        if vr.value < 0:
            true_anomaly = 2 * math.pi - true_anomaly
    else:
        # For circular orbits, true anomaly is measured from the node line
        if n.value != 0:
            n_dot_r = n_vec.dot(r_vec_si).value
            true_anomaly = math.acos(n_dot_r / (n.value * r.value))
            if r_vec_si.z < 0:
                true_anomaly = 2 * math.pi - true_anomaly
        else:
            true_anomaly = 0.0  # Undefined; set to zero

    # --- Assemble the Classical Orbital Elements ---

    coe = ClassicalOrbitalElements(
        semimajor_axis=semimajor_axis,  # Semi-major axis (meters)
        eccentricity=e,  # Eccentricity (dimensionless)
        inclination=Quantity(inclination, radian),  # Inclination (radians)
        right_ascension_of_ascending_node=Quantity(raan, radian),  # RAAN (radians)
        argument_of_perigee=Quantity(argument_of_perigee, radian),  # Argument of perigee (radians)
        true_anomaly=Quantity(true_anomaly, radian)  # True anomaly (radians)
    )

    return coe



def rotation_matrix(angle, axis):
    """Generate a rotation matrix for a given angle and axis."""
    c, s = cos(angle), sin(angle)
    if axis == 0:  # x-axis
        return np.array([[1, 0, 0], [0, c, -s], [0, s, c]])
    elif axis == 1:  # y-axis
        return np.array([[c, 0, s], [0, 1, 0], [-s, 0, c]])
    elif axis == 2:  # z-axis
        return np.array([[c, -s, 0], [s, c, 0], [0, 0, 1]])


import numpy as np
import math
from typing import Tuple

def coe2rv(coe: ClassicalOrbitalElements, mu: Quantity) -> Tuple[Vector3D, Vector3D]:
    """
    Converts classical orbital elements to position and velocity vectors in the Geocentric Equatorial Inertial (ECI) frame,
    ensuring all calculations are performed using standard International System of Units (SI).

    Parameters:
    - coe: ClassicalOrbitalElements
        The classical orbital elements defining the orbit.
    - mu: Quantity
        The gravitational parameter (μ = G * M) of the central body, with units of length^3 / time^2.

    Returns:
    - r_vector: Vector3D
        The position vector in the ECI frame, with units of meters (m).
    - v_vector: Vector3D
        The velocity vector in the ECI frame, with units of meters per second (m/s).

    Raises:
    - ValueError: If input units are inconsistent or invalid.

    Notes:
    - This function internally converts all input quantities to SI units before performing calculations.
    - Angles provided in orbital elements are converted to radians.
    - The output vectors are in the ECI frame with SI units.
    - Reference:
        - Bate, Roger R., et al. "Fundamentals of Astrodynamics." Courier Corporation, 1971.
    """
    import numpy as np

    # --- Unit Enforcement and Conversion ---

    # Ensure that all angle quantities are converted to radians
    try:
        inclination_rad = coe.inclination.to(radian).value  # radians
        raan_rad = coe.right_ascension_of_ascending_node.to(radian).value  # radians
        argp_rad = coe.argument_of_perigee.to(radian).value  # radians
        nu_rad = coe.true_anomaly.to(radian).value  # radians
    except AttributeError:
        raise ValueError("All angular elements in COE must have angle units (e.g., radians or degrees).")

    # Convert semimajor axis to meters
    if not coe.semimajor_axis.unit.is_length():
        raise ValueError("Semimajor axis must have units of length.")
    a_m = coe.semimajor_axis.to(meter).value  # meters

    # Extract eccentricity (dimensionless)
    e = coe.eccentricity
    if e < 0:
        raise ValueError("Eccentricity must be non-negative.")

    # Ensure gravitational parameter mu has correct dimensions and convert to SI units
    expected_mu_dimension = Dimension({
        DimensionSymbol.LENGTH: Fraction(3),
        DimensionSymbol.TIME: Fraction(-2)
    })
    if not mu.unit.dimension == expected_mu_dimension:
        raise ValueError("Gravitational parameter mu must have units of length^3 / time^2.")
    mu_si = mu.to(meter ** 3 / second ** 2).value  # m^3/s^2

    # --- Begin Calculations ---

    # Compute the distance (r) from the focal point to the spacecraft
    # Equation: r = a * (1 - e^2) / (1 + e * cos(nu))
    denominator = 1 + e * math.cos(nu_rad)
    if denominator == 0:
        raise ValueError("Denominator in distance calculation is zero, leading to infinite distance.")
    r_mag = a_m * (1 - e ** 2) / denominator  # meters

    # Compute position in perifocal coordinate system (PQW frame)
    r_pf_x = r_mag * math.cos(nu_rad)
    r_pf_y = r_mag * math.sin(nu_rad)
    r_pf_z = 0.0  # By definition in the perifocal frame
    r_pf_vec = np.array([r_pf_x, r_pf_y, r_pf_z])  # meters

    # Compute velocity in perifocal coordinate system
    p = a_m * (1 - e ** 2)  # Semilatus rectum, meters
    v_factor = math.sqrt(mu_si / p)  # meters per second

    v_pf_x = -v_factor * math.sin(nu_rad)
    v_pf_y = v_factor * (e + math.cos(nu_rad))
    v_pf_z = 0.0
    v_pf_vec = np.array([v_pf_x, v_pf_y, v_pf_z])  # meters per second

    # Compute rotation matrices components
    cos_raan = math.cos(raan_rad)
    sin_raan = math.sin(raan_rad)
    cos_i = math.cos(inclination_rad)
    sin_i = math.sin(inclination_rad)
    cos_argp = math.cos(argp_rad)
    sin_argp = math.sin(argp_rad)

    # Compute rotation matrix from perifocal to ECI frame
    rotation_matrix = np.array([
        [
            cos_raan * cos_argp - sin_raan * sin_argp * cos_i,
            -cos_raan * sin_argp - sin_raan * cos_argp * cos_i,
            sin_raan * sin_i
        ],
        [
            sin_raan * cos_argp + cos_raan * sin_argp * cos_i,
            -sin_raan * sin_argp + cos_raan * cos_argp * cos_i,
            -cos_raan * sin_i
        ],
        [
            sin_argp * sin_i,
            cos_argp * sin_i,
            cos_i
        ]
    ])  # Dimensionless

    # Transform position and velocity vectors to ECI frame
    r_vec_eci = rotation_matrix @ r_pf_vec  # meters
    v_vec_eci = rotation_matrix @ v_pf_vec  # meters per second

    # Create Vector3D instances with SI units
    r_vector = Vector3D(*r_vec_eci, unit=meter, reference_frame=ReferenceFrame.ECI)
    v_vector = Vector3D(*v_vec_eci, unit=meter / second, reference_frame=ReferenceFrame.ECI)

    return r_vector, v_vector

