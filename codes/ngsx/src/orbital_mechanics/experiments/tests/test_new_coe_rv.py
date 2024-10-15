import pytest
import numpy as np
import math

# Import the necessary classes and functions from your project
from src.orbital_mechanics.experiments.new_coe_rv import rv2coe, coe2rv
from src.orbital_mechanics.experiments.new_classic_orbital_elements import ClassicalOrbitalElements
from src.orbital_mechanics.experiments.new_vector3d import Vector3D
from src.orbital_mechanics.experiments.quantities import radian, degree, kilometer, second, meter


def verified_values():
    """
    Provides verified position, velocity, classical orbital elements, and gravitational parameter
    for testing purposes. These values are verified using the Orbital Mechanics Calculator:
    https://elainecoe.github.io/orbital-mechanics-calculator/calculator.html
    """
    # Position (km) and Velocity (km/s) vectors
    position = np.array([6524.834, 6862.875, 6448.296])  # km
    velocity = np.array([4.901327, 5.533756, -1.976341])  # km/s

    # Classical Orbital Elements
    a = 36127.55012131963  * kilometer  # Semimajor axis (km)
    e = 0.8328542764449516  # Eccentricity (dimensionless)
    i = 87.86912617702644  * degree  # Inclination (degrees)
    Ω = 227.8982603572737  * degree  # Right Ascension of Ascending Node (degrees)
    ω = 53.38500680552308  * degree  # Argument of Perigee (degrees)
    v = 92.33508057507403  * degree  # True Anomaly (degrees)

    coe = ClassicalOrbitalElements(
        semimajor_axis=a,
        eccentricity=e,
        inclination=i,
        right_ascension_of_ascending_node=Ω,
        argument_of_perigee=ω,
        true_anomaly=v
    )

    # Gravitational Parameter (mu) in km^3/s^2
    mu = 3.986e5 * ((kilometer ** 3) / (second ** 2))

    return position, velocity, coe, mu

def test_rv2coe():
    position, velocity, expected_coe, mu = verified_values()

    # Create Vector3D instances for position and velocity with appropriate units
    r_vec = Vector3D(*position, unit=kilometer)
    v_vec = Vector3D(*velocity, unit=kilometer / second)

    # Perform the conversion from position-velocity to classical orbital elements
    computed_coe = rv2coe(r_vec, v_vec, mu)

    # Compare Semimajor Axis
    assert computed_coe.semimajor_axis.to(kilometer).value == pytest.approx(expected_coe.semimajor_axis.value, rel=1e-6), \
        "Semimajor axis does not match the expected value."

    # Compare Eccentricity
    assert computed_coe.eccentricity == pytest.approx(expected_coe.eccentricity, rel=1e-6), \
        "Eccentricity does not match the expected value."

    # Compare Inclination
    expected_inclination_rad = expected_coe.inclination.to(radian).value
    assert computed_coe.inclination.value == pytest.approx(expected_inclination_rad, rel=1e-6), \
        "Inclination does not match the expected value."

    # Compare Right Ascension of Ascending Node
    expected_raan_rad = expected_coe.right_ascension_of_ascending_node.to(radian).value
    assert computed_coe.right_ascension_of_ascending_node.value == pytest.approx(expected_raan_rad, rel=1e-6), \
        "Right Ascension of Ascending Node does not match the expected value."

    # Compare Argument of Perigee
    expected_argp_rad = expected_coe.argument_of_perigee.to(radian).value
    assert computed_coe.argument_of_perigee.value == pytest.approx(expected_argp_rad, rel=1e-6), \
        "Argument of Perigee does not match the expected value."

    # Compare True Anomaly
    expected_true_anomaly_rad = expected_coe.true_anomaly.to(radian).value
    assert computed_coe.true_anomaly.value == pytest.approx(expected_true_anomaly_rad, rel=1e-6), \
        "True Anomaly does not match the expected value."


def test_coe2rv():
    """
    Test the coe2rv function using verified orbital elements and expected position and velocity vectors.

    The test uses known orbital elements and their corresponding position and velocity vectors,
    and checks if the computed vectors from coe2rv match the expected values within a reasonable tolerance.
    """
    # Get the verified values
    position_km, velocity_kms, coe, mu = verified_values()

    # Compute position and velocity vectors from the orbital elements
    computed_r_vec, computed_v_vec = coe2rv(coe, mu)

    # Expected position and velocity vectors
    expected_r_vec = Vector3D(*position_km, unit=kilometer)
    expected_v_vec = Vector3D(*velocity_kms, unit=kilometer / second)

    # Tolerance for comparison (adjust as needed)
    tol = 1e-3  # km for position, km/s for velocity

    # Compare position vectors
    computed_r_array = computed_r_vec.to(kilometer).as_array()
    expected_r_array = expected_r_vec.as_array()
    assert np.allclose(computed_r_array, expected_r_array, atol=tol), \
        "Computed position vector does not match the expected value."

    # Compare velocity vectors
    computed_v_array = computed_v_vec.to(kilometer / second).as_array()
    expected_v_array = expected_v_vec.as_array()
    assert np.allclose(computed_v_array, expected_v_array, atol=tol), \
        "Computed velocity vector does not match the expected value."

def test_rv_coe_rv_round_trip():
    """
    Test the round-trip conversion from position-velocity vectors to classical orbital elements and back.

    This test verifies that converting a given position and velocity vector (RV) to classical orbital elements (COE)
    and then back to position and velocity vectors results in vectors that closely match the original inputs
    within specified numerical tolerances.

    Steps:
    1. Obtain verified position and velocity vectors along with their corresponding COE and gravitational parameter.
    2. Convert the original RV to COE using `rv2coe`.
    3. Convert the computed COE back to RV using `coe2rv`.
    4. Compare the original RV and the round-trip RV to ensure they match within tolerances.

    Raises:
    - AssertionError: If the round-trip conversion results differ beyond the specified tolerances.
    """
    # Obtain verified values for testing
    position_km, velocity_kms, coe_expected, mu = verified_values()

    # Create Vector3D instances for the original position and velocity
    r_vec_original = Vector3D(*position_km, unit=kilometer)
    v_vec_original = Vector3D(*velocity_kms, unit=kilometer / second)

    # --- Round-Trip Conversion ---

    # Step 1: Convert original RV to COE
    coe_computed = rv2coe(r_vec_original, v_vec_original, mu)

    # Step 1.5: validate the coe_computed

    # Compare Semimajor Axis
    assert coe_computed.semimajor_axis.to(kilometer).value == pytest.approx(coe_expected.semimajor_axis.value, rel=1e-6), \
        "Semimajor axis does not match the expected value."

    # Compare Eccentricity
    assert coe_computed.eccentricity == pytest.approx(coe_expected.eccentricity, rel=1e-6), \
        "Eccentricity does not match the expected value."

    # Compare Inclination
    expected_inclination_rad = coe_expected.inclination.to(radian).value
    assert coe_computed.inclination.value == pytest.approx(expected_inclination_rad, rel=1e-6), \
        "Inclination does not match the expected value."

    # Compare Right Ascension of Ascending Node
    expected_raan_rad = coe_expected.right_ascension_of_ascending_node.to(radian).value
    assert coe_computed.right_ascension_of_ascending_node.value == pytest.approx(expected_raan_rad, rel=1e-6), \
        "Right Ascension of Ascending Node does not match the expected value."

    # Compare Argument of Perigee
    expected_argp_rad = coe_expected.argument_of_perigee.to(radian).value
    assert coe_computed.argument_of_perigee.value == pytest.approx(expected_argp_rad, rel=1e-6), \
        "Argument of Perigee does not match the expected value."

    # Compare True Anomaly
    expected_true_anomaly_rad = coe_expected.true_anomaly.to(radian).value
    assert coe_computed.true_anomaly.value == pytest.approx(expected_true_anomaly_rad, rel=1e-6), \
        "True Anomaly does not match the expected value."


    # Step 2: Convert computed COE back to RV
    r_vec_computed, v_vec_computed = coe2rv(coe_computed, mu)

    # --- Comparison of Position Vectors ---

    # Convert both vectors to the same unit for comparison (kilometers)
    r_vec_original_km = r_vec_original.to(kilometer)
    r_vec_computed_km = r_vec_computed.to(kilometer)

    # Extract numpy arrays for comparison
    r_original_array = r_vec_original_km.as_array()
    r_computed_array = r_vec_computed_km.as_array()

    # Define tolerance levels
    position_tolerance = 1e-3  # kilometers (1 meter)

    # Assert that the original and computed position vectors are close within the tolerance
    assert np.allclose(
        r_original_array,
        r_computed_array,
        atol=position_tolerance,
        rtol=1e-6
    ), (
        f"Round-trip position vectors do not match.\n"
        f"Original: {r_original_array} km\n"
        f"Computed: {r_computed_array} km\n"
        f"Tolerance: {position_tolerance} km"
    )

    # --- Comparison of Velocity Vectors ---

    # Convert both vectors to the same unit for comparison (kilometers per second)
    v_vec_original_kms = v_vec_original.to(kilometer / second)
    v_vec_computed_kms = v_vec_computed.to(kilometer / second)

    # Extract numpy arrays for comparison
    v_original_array = v_vec_original_kms.as_array()
    v_computed_array = v_vec_computed_kms.as_array()

    # Define tolerance levels
    velocity_tolerance = 1e-6  # kilometers per second (1 mm/s)

    # Assert that the original and computed velocity vectors are close within the tolerance
    assert np.allclose(
        v_original_array,
        v_computed_array,
        atol=velocity_tolerance,
        rtol=1e-6
    ), (
        f"Round-trip velocity vectors do not match.\n"
        f"Original: {v_original_array} km/s\n"
        f"Computed: {v_computed_array} km/s\n"
        f"Tolerance: {velocity_tolerance} km/s"
    )
