import math
import pytest

from src.orbital_mechanics.experiments.new_classic_orbital_elements import ClassicalOrbitalElements
from src.orbital_mechanics.experiments.quantities import Quantity, radian, kilometer, degree, second


def test_semilatus_rectum():
    """
    Test the semilatus_rectum method with known values.
    """
    # Given semimajor axis and eccentricity
    semimajor_axis = Quantity(10000, kilometer)  # Example value
    eccentricity = 0.1

    # Expected semilatus rectum calculation
    expected_semilatus_rectum = semimajor_axis * (1 - eccentricity ** 2)

    # Create an instance of ClassicalOrbitalElements
    coe = ClassicalOrbitalElements(
        semimajor_axis=semimajor_axis,
        eccentricity=eccentricity,
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=Quantity(0.0, radian),
        argument_of_perigee=Quantity(0.0, radian),
        true_anomaly=Quantity(0.0, radian)
    )

    # Compute the semilatus rectum
    computed_semilatus_rectum = coe.semilatus_rectum

    # Assert that the computed value matches the expected value
    assert math.isclose(
        computed_semilatus_rectum.value, expected_semilatus_rectum.value, rel_tol=1e-9
    ), f"Computed semilatus rectum {computed_semilatus_rectum} does not match expected {expected_semilatus_rectum}"

def test_mean_anomaly():
    """
    Test the mean_anomaly method with known elliptical orbit parameters.
    """
    # Given eccentricity and true anomaly
    eccentricity = 0.1
    true_anomaly_deg = 30.0  # degrees
    true_anomaly = Quantity(math.radians(true_anomaly_deg), radian)

    # Expected mean anomaly calculation
    e = eccentricity
    nu = true_anomaly.value
    E = 2 * math.atan(math.tan(nu / 2) * math.sqrt((1 - e) / (1 + e)))
    M_expected = (E - e * math.sin(E)) % (2 * math.pi)
    M_expected_quantity = Quantity(M_expected, radian)

    # Create an instance of ClassicalOrbitalElements
    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),  # Arbitrary value
        eccentricity=eccentricity,
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=Quantity(0.0, radian),
        argument_of_perigee=Quantity(0.0, radian),
        true_anomaly=true_anomaly
    )

    # Compute the mean anomaly
    mean_anomaly = coe.mean_anomaly()

    # Assert that the computed mean anomaly matches the expected value
    assert math.isclose(
        mean_anomaly.value, M_expected_quantity.value, rel_tol=1e-9
    ), f"Computed mean anomaly {mean_anomaly} does not match expected {M_expected_quantity}"

def test_mean_anomaly_exception():
    """
    Test that mean_anomaly raises a ValueError for non-elliptical orbits (e >= 1).
    """
    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),
        eccentricity=1.0,  # Parabolic orbit (invalid for mean anomaly)
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=Quantity(0.0, radian),
        argument_of_perigee=Quantity(0.0, radian),
        true_anomaly=Quantity(0.0, radian)
    )
    with pytest.raises(ValueError):
        coe.mean_anomaly()

def test_hyperbolic_mean_anomaly():
    """
    Test the hyperbolic_mean_anomaly method with known hyperbolic orbit parameters.
    """
    eccentricity = 1.5
    true_anomaly_deg = 60.0  # degrees
    true_anomaly = Quantity(math.radians(true_anomaly_deg), radian)

    # Expected hyperbolic mean anomaly calculation
    e = eccentricity
    nu = true_anomaly.value
    sqrt_e2_minus_1 = math.sqrt(e ** 2 - 1)
    numerator = math.sin(nu) * sqrt_e2_minus_1
    denominator = e * math.cos(nu) + 1
    H = math.asinh(numerator / denominator)
    Mh_expected = e * math.sinh(H) - H
    Mh_expected_quantity = Quantity(Mh_expected, radian)

    # Create an instance of ClassicalOrbitalElements
    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),  # Arbitrary value
        eccentricity=eccentricity,
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=Quantity(0.0, radian),
        argument_of_perigee=Quantity(0.0, radian),
        true_anomaly=true_anomaly
    )

    # Compute the hyperbolic mean anomaly
    Mh = coe.hyperbolic_mean_anomaly()

    # Assert that the computed hyperbolic mean anomaly matches the expected value
    assert math.isclose(
        Mh.value, Mh_expected_quantity.value, rel_tol=1e-9
    ), f"Computed hyperbolic mean anomaly {Mh} does not match expected {Mh_expected_quantity}"

def test_hyperbolic_mean_anomaly_exception():
    """
    Test that hyperbolic_mean_anomaly raises a ValueError for non-hyperbolic orbits (e <= 1).
    """
    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),
        eccentricity=1.0,  # Parabolic orbit (invalid for hyperbolic mean anomaly)
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=Quantity(0.0, radian),
        argument_of_perigee=Quantity(0.0, radian),
        true_anomaly=Quantity(0.0, radian)
    )
    with pytest.raises(ValueError):
        coe.hyperbolic_mean_anomaly()

def test_argument_of_latitude():
    """
    Test the argument_of_latitude method.
    """
    argument_of_perigee_deg = 40.0
    true_anomaly_deg = 30.0
    argument_of_perigee = Quantity(math.radians(argument_of_perigee_deg), radian)
    true_anomaly = Quantity(math.radians(true_anomaly_deg), radian)

    # Expected argument of latitude
    expected_u = argument_of_perigee + true_anomaly

    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),
        eccentricity=0.1,
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=Quantity(0.0, radian),
        argument_of_perigee=argument_of_perigee,
        true_anomaly=true_anomaly
    )

    # Compute the argument of latitude
    u = coe.argument_of_latitude()

    # Assert that the computed value matches the expected value
    assert math.isclose(
        u.value, expected_u.value, rel_tol=1e-9
    ), f"Computed argument of latitude {u} does not match expected {expected_u}"

def test_true_longitude():
    """
    Test the true_longitude method.
    """
    raan_deg = 50.0
    argument_of_perigee_deg = 40.0
    true_anomaly_deg = 30.0
    raan = Quantity(math.radians(raan_deg), radian)
    argument_of_perigee = Quantity(math.radians(argument_of_perigee_deg), radian)
    true_anomaly = Quantity(math.radians(true_anomaly_deg), radian)

    # Expected true longitude
    expected_l = (raan.value + argument_of_perigee.value + true_anomaly.value) % (2 * math.pi)
    expected_l_quantity = Quantity(expected_l, radian)

    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),
        eccentricity=0.1,
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=raan,
        argument_of_perigee=argument_of_perigee,
        true_anomaly=true_anomaly
    )

    # Compute the true longitude
    l = coe.true_longitude()

    # Assert that the computed value matches the expected value
    assert math.isclose(
        l.value, expected_l_quantity.value, rel_tol=1e-9
    ), f"Computed true longitude {l} does not match expected {expected_l_quantity}"

def test_longitude_of_periapsis():
    """
    Test the longitude_of_periapsis method.
    """
    raan_deg = 50.0
    argument_of_perigee_deg = 40.0
    raan = Quantity(math.radians(raan_deg), radian)
    argument_of_perigee = Quantity(math.radians(argument_of_perigee_deg), radian)

    # Expected longitude of periapsis
    expected_Pi = (raan.value + argument_of_perigee.value) % (2 * math.pi)
    expected_Pi_quantity = Quantity(expected_Pi, radian)

    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),
        eccentricity=0.1,
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=raan,
        argument_of_perigee=argument_of_perigee,
        true_anomaly=Quantity(0.0, radian)
    )

    # Compute the longitude of periapsis
    Pi = coe.longitude_of_periapsis()

    # Assert that the computed value matches the expected value
    assert math.isclose(
        Pi.value, expected_Pi_quantity.value, rel_tol=1e-9
    ), f"Computed longitude of periapsis {Pi} does not match expected {expected_Pi_quantity}"

def test_mean_to_true_anomaly():
    """
    Test the mean_to_true_anomaly static method with valid inputs.
    """
    e = 0.1
    M_deg = 40.0
    M = math.radians(M_deg)

    # Compute the true anomaly using the static method
    nu = ClassicalOrbitalElements.mean_to_true_anomaly(M, e)

    # Expected true anomaly calculation
    E = M
    for _ in range(100):  # Simple iterative solution for testing
        E_next = M + e * math.sin(E)
        if abs(E - E_next) < 1e-6:
            break
        E = E_next
    true_anomaly_expected = 2 * math.atan2(
        math.sqrt(1 + e) * math.sin(E / 2),
        math.sqrt(1 - e) * math.cos(E / 2)
    )
    true_anomaly_expected = true_anomaly_expected % (2 * math.pi)

    # Assert that the computed true anomaly matches the expected value
    assert math.isclose(
        nu, true_anomaly_expected, rel_tol=1e-6
    ), f"Computed true anomaly {nu} does not match expected {true_anomaly_expected}"

def test_mean_to_true_anomaly_exception():
    """
    Test that mean_to_true_anomaly raises a ValueError for invalid eccentricity (e >= 1).
    """
    e = 1.0  # Invalid eccentricity for elliptical orbits
    M = math.radians(40.0)
    with pytest.raises(ValueError):
        ClassicalOrbitalElements.mean_to_true_anomaly(M, e)

def test_hyperbolic_mean_to_true_anomaly():
    """
    Test the hyperbolic_mean_to_true_anomaly static method with valid inputs.

    NOTE: This test sucks because it just replicates the existing method, need to find a better way to validate that this works.
    """
    e = 1.5
    Mh = Quantity(0.5, radian)  # Hyperbolic mean anomaly in radians

    # Compute the true anomaly using the static method
    nu = ClassicalOrbitalElements.hyperbolic_mean_to_true_anomaly(Mh, e)

    # Expected true anomaly calculation using the same method as in hyperbolic_mean_to_true_anomaly
    # Solve Kepler's equation for H using Newton-Raphson (could reuse the method here for consistency)
    # For testing purposes, let's directly use the same iterative process

    # Initialize hyperbolic eccentric anomaly (H)
    H = math.asinh(Mh.value / e)

    # Newton-Raphson Iterative Process
    for _ in range(100):
        F_H = e * math.sinh(H) - H - Mh.value
        F_H_derivative = e * math.cosh(H) - 1
        delta_H = -F_H / F_H_derivative
        H += delta_H
        if abs(delta_H) < 1e-6:
            break

    # Compute the expected true anomaly using the same formulas as in the method
    sqrt_e_squared_minus_one = math.sqrt(e ** 2 - 1)
    sinh_H = math.sinh(H)
    cosh_H = math.cosh(H)
    denominator = e * cosh_H - 1

    sin_nu_expected = (sinh_H * sqrt_e_squared_minus_one) / denominator
    cos_nu_expected = (e - cosh_H) / denominator

    true_anomaly_expected = math.atan2(sin_nu_expected, cos_nu_expected)
    true_anomaly_expected_quantity = Quantity(true_anomaly_expected, radian)

    # Assert that the computed true anomaly is a Quantity
    assert isinstance(nu, Quantity), f"Returned true anomaly {nu} is not a Quantity"

    # Assert that the computed true anomaly is close to the expected value
    assert math.isclose(
        nu.value, true_anomaly_expected_quantity.value, rel_tol=1e-6
    ), f"Computed true anomaly {nu} does not match expected {true_anomaly_expected_quantity}"

def test_hyperbolic_mean_to_true_anomaly_exception():
    """
    Test that hyperbolic_mean_to_true_anomaly raises a ValueError for invalid eccentricity (e <= 1).
    """
    e = 1.0  # Invalid eccentricity for hyperbolic orbits
    Mh = Quantity(0.5, radian)
    with pytest.raises(ValueError):
        ClassicalOrbitalElements.hyperbolic_mean_to_true_anomaly(Mh, e)

def test_circular_orbit_mean_anomaly():
    """
    Test mean_anomaly method for a circular orbit (e = 0).
    """
    # For a circular orbit, mean anomaly equals true anomaly
    eccentricity = 0.0
    true_anomaly_deg = 45.0
    true_anomaly = Quantity(math.radians(true_anomaly_deg), radian)

    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),
        eccentricity=eccentricity,
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=Quantity(0.0, radian),
        argument_of_perigee=Quantity(0.0, radian),
        true_anomaly=true_anomaly
    )

    mean_anomaly = coe.mean_anomaly()

    # For e=0, M = ν
    assert math.isclose(
        mean_anomaly.value, true_anomaly.value, rel_tol=1e-9
    ), f"Mean anomaly {mean_anomaly} does not equal true anomaly {true_anomaly} for circular orbit"

def test_edge_case_high_eccentricity():
    """
    Test mean_anomaly method for high eccentricity but valid elliptical orbit (e approaching 1).
    """
    eccentricity = 0.999
    true_anomaly_deg = 170.0
    true_anomaly = Quantity(math.radians(true_anomaly_deg), radian)

    coe = ClassicalOrbitalElements(
        semimajor_axis=Quantity(10000, kilometer),
        eccentricity=eccentricity,
        inclination=Quantity(0.0, radian),
        right_ascension_of_ascending_node=Quantity(0.0, radian),
        argument_of_perigee=Quantity(0.0, radian),
        true_anomaly=true_anomaly
    )

    mean_anomaly = coe.mean_anomaly()

    # Since we don't have an expected value, we ensure the function completes without error
    assert isinstance(mean_anomaly, Quantity), "Mean anomaly calculation failed for high eccentricity elliptical orbit"

def test_from_rv_and_to_rv():
    """
    Test the from_rv and to_rv methods for consistency.
    """
    pytest.skip("moving this to tests for coe_rv")

    # Assuming we have Vector3D and the necessary functions implemented
    from src.orbital_mechanics.experiments.new_vector3d import Vector3D

    # Define position and velocity vectors (example values)
    position = Vector3D(7000.0, -12124.0, 0.0, unit=kilometer)
    velocity = Vector3D(2.6679, 4.6210, 0.0, unit=kilometer / second)

    # Convert from position and velocity vectors to classical orbital elements
    coe = ClassicalOrbitalElements.from_rv(position, velocity)

    # Convert back from classical orbital elements to position and velocity vectors
    position_calculated, velocity_calculated = coe.to_rv()

    # Assert that the original and calculated position and velocity vectors are close
    assert math.isclose(position.x, position_calculated.x, rel_tol=1e-6)
    assert math.isclose(position.y, position_calculated.y, rel_tol=1e-6)
    assert math.isclose(position.z, position_calculated.z, rel_tol=1e-6)
    assert math.isclose(velocity.x, velocity_calculated.x, rel_tol=1e-6)
    assert math.isclose(velocity.y, velocity_calculated.y, rel_tol=1e-6)
    assert math.isclose(velocity.z, velocity_calculated.z, rel_tol=1e-6)

def test_example_usage():
    """
    Test an example usage of the ClassicalOrbitalElements class to ensure methods run without errors.
    """
    try:
        coe = ClassicalOrbitalElements(
            semimajor_axis=Quantity(11067.79, kilometer),
            eccentricity=0.83285,
            inclination=Quantity(87.87, degree).to(radian),
            right_ascension_of_ascending_node=Quantity(227.89, degree).to(radian),
            argument_of_perigee=Quantity(53.42, degree).to(radian),
            true_anomaly=Quantity(92.30, degree).to(radian)
        )

        # Perform various computations
        print(coe.semilatus_rectum)
        coe.mean_anomaly()
        coe.argument_of_latitude()
        coe.true_longitude()
        coe.longitude_of_periapsis()

    except Exception as e:
        pytest.fail(f"Example usage failed with exception: {e}")
