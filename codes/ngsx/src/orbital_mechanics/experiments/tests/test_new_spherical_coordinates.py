# test_spherical_coordinate.py

import pytest
import numpy as np
from scipy.spatial.transform import Rotation as R
from fractions import Fraction
from math import pi

from src.orbital_mechanics.experiments.new_spherical_coordinate import SphericalCoordinate, radian, degree, \
    get_relative_position_in_observer_frame, angles_close
from src.orbital_mechanics.experiments.new_vector3d import ReferenceFrame, Vector3D
from src.orbital_mechanics.experiments.quantities import Unit, meter, kilometer


# Assuming the classes Unit, Quantity, Vector3D, ReferenceFrame, and SphericalCoordinate are defined in a module named 'physics_module'
# from physics_module import Unit, Quantity, Vector3D, ReferenceFrame, SphericalCoordinate

# For this example, we'll define the necessary units and classes directly


# Include the updated SphericalCoordinate class
# [Include the adjusted SphericalCoordinate class from the previous message here]

# Now, write the pytest test functions

def test_spherical_coordinate_creation():
    # Test creating a SphericalCoordinate with default units and reference frame
    sc = SphericalCoordinate(range=1.0, azimuth=0.5, elevation=0.25)
    assert sc.range == 1.0
    assert sc.azimuth == 0.5
    assert sc.elevation == 0.25
    assert sc.range_unit == meter
    assert sc.angle_unit == radian
    assert sc.reference_frame == ReferenceFrame.ECI


def test_spherical_coordinate_creation_with_units():
    # Test creating a SphericalCoordinate with specified units and reference frame
    sc = SphericalCoordinate(
        range=1000.0,
        azimuth=45.0,
        elevation=30.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECEF
    )
    assert sc.range == 1000.0
    assert sc.azimuth == 45.0
    assert sc.elevation == 30.0
    assert sc.range_unit == kilometer
    assert sc.angle_unit == degree
    assert sc.reference_frame == ReferenceFrame.ECEF


def test_spherical_to_cartesian():
    # Test converting SphericalCoordinate to Cartesian coordinates
    sc = SphericalCoordinate(
        range=1.0,
        azimuth=90.0,
        elevation=0.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )
    cartesian = sc.to_cartesian()
    expected_x = 0.0
    expected_y = 1.0
    expected_z = 0.0
    assert np.isclose(cartesian.x, expected_x, atol=1e-6)
    assert np.isclose(cartesian.y, expected_y, atol=1e-6)
    assert np.isclose(cartesian.z, expected_z, atol=1e-6)
    assert cartesian.unit == kilometer
    assert cartesian.reference_frame == ReferenceFrame.ECI


def test_cartesian_to_spherical():
    # Test converting Cartesian coordinates to SphericalCoordinate
    cartesian = Vector3D(
        x=0.0,
        y=1.0,
        z=0.0,
        unit=kilometer,
        reference_frame=ReferenceFrame.ECI
    )
    sc = SphericalCoordinate.from_cartesian(cartesian, angle_unit=degree)
    expected_range = 1.0
    expected_azimuth = 90.0
    expected_elevation = 0.0
    assert np.isclose(sc.range, expected_range, atol=1e-6)
    assert np.isclose(sc.azimuth, expected_azimuth, atol=1e-6)
    assert np.isclose(sc.elevation, expected_elevation, atol=1e-6)
    assert sc.range_unit == kilometer
    assert sc.angle_unit == degree
    assert sc.reference_frame == ReferenceFrame.ECI


def test_spherical_conversion():
    # Test converting SphericalCoordinate units
    sc = SphericalCoordinate(
        range=1000.0,
        azimuth=45.0,
        elevation=30.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )
    sc_converted = sc.to(meter, radian)
    expected_range = 1_000_000.0  # 1000 km in meters
    expected_azimuth = np.deg2rad(45.0)
    expected_elevation = np.deg2rad(30.0)
    assert np.isclose(sc_converted.range, expected_range, atol=1e-6)
    assert np.isclose(sc_converted.azimuth, expected_azimuth, atol=1e-6)
    assert np.isclose(sc_converted.elevation, expected_elevation, atol=1e-6)
    assert sc_converted.range_unit == meter
    assert sc_converted.angle_unit == radian
    assert sc_converted.reference_frame == ReferenceFrame.ECI


def test_get_relative_position_in_observer_frame():
    # Test computing relative position in observer's frame
    observer_position = Vector3D(0.0, 0.0, 0.0, unit=meter, reference_frame=ReferenceFrame.ECI)
    observer_attitude = R.identity()
    target_position = Vector3D(100.0, 0.0, 0.0, unit=meter, reference_frame=ReferenceFrame.ECI)

    result = get_relative_position_in_observer_frame(
        observer_attitude, observer_position, target_position
    )

    expected_range = 100.0
    expected_azimuth = 0.0
    expected_elevation = 0.0
    assert np.isclose(result.range, expected_range, atol=1e-6)
    assert np.isclose(result.azimuth, expected_azimuth, atol=1e-6)
    assert np.isclose(result.elevation, expected_elevation, atol=1e-6)
    assert result.range_unit == meter
    assert result.angle_unit == radian
    assert result.reference_frame == ReferenceFrame.NONE  # Since it's in observer's local frame


def test_reference_frame_mismatch_error():
    # Test that an error is raised when observer and target have different reference frames
    observer_position = Vector3D(0.0, 0.0, 0.0, unit=meter, reference_frame=ReferenceFrame.ECI)
    observer_attitude = R.identity()
    target_position = Vector3D(100.0, 0.0, 0.0, unit=meter, reference_frame=ReferenceFrame.ECEF)

    with pytest.raises(ValueError) as excinfo:
        _ = get_relative_position_in_observer_frame(
            observer_attitude, observer_position, target_position
        )
    assert "Observer and target positions must be in the same reference frame" in str(excinfo.value)


def test_angle_unit_conversion():
    # Test angle unit conversion within SphericalCoordinate
    sc = SphericalCoordinate(
        range=1.0,
        azimuth=np.pi / 2,  # 90 degrees in radians
        elevation=0.0,
        range_unit=meter,
        angle_unit=radian,
        reference_frame=ReferenceFrame.ECI
    )
    sc_converted = sc.to(meter, degree)
    expected_azimuth = 90.0
    expected_elevation = 0.0
    assert np.isclose(sc_converted.azimuth, expected_azimuth, atol=1e-6)
    assert np.isclose(sc_converted.elevation, expected_elevation, atol=1e-6)
    assert sc_converted.angle_unit == degree


def test_spherical_coordinate_str():
    # Test string representation of SphericalCoordinate
    sc = SphericalCoordinate(
        range=1000.0,
        azimuth=45.0,
        elevation=30.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECEF
    )
    expected_str = (
        f"(1000.0 km, 45.0 deg, 30.0 deg), Reference Frame: ECEF"
    )
    assert str(sc) == expected_str


def test_spherical_coordinate_from_array():
    # Test creating SphericalCoordinate from array
    array = np.array([1000.0, 45.0, 30.0])
    sc = SphericalCoordinate.from_array(
        array,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECEF
    )
    assert sc.range == 1000.0
    assert sc.azimuth == 45.0
    assert sc.elevation == 30.0
    assert sc.range_unit == kilometer
    assert sc.angle_unit == degree
    assert sc.reference_frame == ReferenceFrame.ECEF


def test_spherical_coordinate_incompatible_units():
    # Test that an error is raised when converting to incompatible units
    sc = SphericalCoordinate(
        range=1000.0,
        azimuth=45.0,
        elevation=30.0,
        range_unit=kilometer,
        angle_unit=degree
    )
    # Define a unit incompatible with length (e.g., second)
    second = Unit('s', {'s': Fraction(1)}, factor=1.0)
    with pytest.raises(ValueError) as excinfo:
        _ = sc.to(second, degree)
    assert "Cannot convert range unit from km to s" in str(excinfo.value)


def test_spherical_coordinate_to_different_reference_frame():
    # Test changing reference frame using the to() method
    sc = SphericalCoordinate(
        range=1000.0,
        azimuth=45.0,
        elevation=30.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )
    sc_new_frame = sc.to(kilometer, degree, target_reference_frame=ReferenceFrame.ECEF)
    assert sc_new_frame.reference_frame == ReferenceFrame.ECEF, "Reference frame not updated"
    assert sc_new_frame.range == sc.range, "Range changed unexpectedly"
    assert sc_new_frame.azimuth == sc.azimuth, "Azimuth changed unexpectedly"
    assert angles_close(sc_new_frame.elevation, sc.elevation), "Elevation changed unexpectedly"


def test_spherical_coordinate_operations_with_reference_frame():
    # Test operations between spherical coordinates considering reference frames
    sc1 = SphericalCoordinate(
        range=1000.0,
        azimuth=0.0,
        elevation=0.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )
    sc2 = SphericalCoordinate(
        range=500.0,
        azimuth=90.0,
        elevation=0.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )
    # Convert to Cartesian
    cartesian1 = sc1.to_cartesian()
    cartesian2 = sc2.to_cartesian()
    # Add vectors
    cartesian_sum = cartesian1 + cartesian2
    # Convert back to SphericalCoordinate
    sc_sum = SphericalCoordinate.from_cartesian(cartesian_sum, angle_unit=degree)
    assert sc_sum.reference_frame == ReferenceFrame.ECI


def test_spherical_coordinate_operations_different_reference_frames():
    # Test that an error is raised when performing operations with different reference frames
    sc1 = SphericalCoordinate(
        range=1000.0,
        azimuth=0.0,
        elevation=0.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )
    sc2 = SphericalCoordinate(
        range=500.0,
        azimuth=90.0,
        elevation=0.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECEF
    )
    # Convert to Cartesian
    cartesian1 = sc1.to_cartesian()
    cartesian2 = sc2.to_cartesian()
    with pytest.raises(ValueError) as excinfo:
        _ = cartesian1 + cartesian2
    assert "Cannot add vectors in different reference frames" in str(excinfo.value)


def test_spherical_coordinate_negative_elevation():
    # Test SphericalCoordinate with negative elevation angle
    sc = SphericalCoordinate(
        range=1.0,
        azimuth=45.0,
        elevation=-30.0,
        range_unit=kilometer,
        angle_unit=degree
    )
    cartesian = sc.to_cartesian()
    # Expected z should be negative
    assert cartesian.z < 0


def test_spherical_coordinate_zero_range():
    # Test SphericalCoordinate with zero range
    sc = SphericalCoordinate(
        range=0.0,
        azimuth=45.0,
        elevation=30.0,
        range_unit=kilometer,
        angle_unit=degree
    )
    cartesian = sc.to_cartesian()
    # All Cartesian coordinates should be zero
    assert cartesian.x == 0.0
    assert cartesian.y == 0.0
    assert cartesian.z == 0.0


def test_get_relative_position_with_rotation():
    # Test get_relative_position_in_observer_frame with observer rotation
    observer_position = Vector3D(0.0, 0.0, 0.0, unit=meter)
    # Rotate observer 90 degrees around Z-axis
    observer_attitude = R.from_euler('z', 90, degrees=True)
    target_position = Vector3D(100.0, 0.0, 0.0, unit=meter)
    result = get_relative_position_in_observer_frame(
        observer_attitude, observer_position, target_position
    )
    expected_range = 100.0
    expected_azimuth = -np.pi / 2  # -90 degrees in radians
    expected_elevation = 0.0
    # Adjust azimuth to be within (-π, π)
    azimuth = (result.azimuth + np.pi) % (2 * np.pi) - np.pi
    assert np.isclose(result.range, expected_range, atol=1e-6)
    assert np.isclose(azimuth, expected_azimuth, atol=1e-6)
    assert np.isclose(result.elevation, expected_elevation, atol=1e-6)


def test_spherical_coordinate_large_angles():
    # Test SphericalCoordinate with angles larger than 360 degrees or 2π radians
    sc = SphericalCoordinate(
        range=1.0,
        azimuth=450.0,  # 450 degrees, which is 90 degrees over a full circle
        elevation=0.0,
        range_unit=kilometer,
        angle_unit=degree
    )
    cartesian = sc.to_cartesian()
    # Expected coordinates should be equivalent to azimuth of 90 degrees
    expected_x = 0.0
    expected_y = 1.0
    expected_z = 0.0
    assert np.isclose(cartesian.x, expected_x, atol=1e-6)
    assert np.isclose(cartesian.y, expected_y, atol=1e-6)
    assert np.isclose(cartesian.z, expected_z, atol=1e-6)


def test_spherical_coordinate_invalid_angle_unit():
    # Test that an error is raised for unsupported angle units
    # Define an unsupported angle unit
    gradian = Unit('gon', {'rad': Fraction(1)}, factor=pi / 200.0)  # 1 gradian = π/200 radians
    sc = SphericalCoordinate(
        range=1.0,
        azimuth=100.0,
        elevation=50.0,
        range_unit=kilometer,
        angle_unit=gradian
    )
    with pytest.raises(ValueError) as excinfo:
        _ = sc.to_cartesian()
    assert "Unsupported angle unit" in str(excinfo.value)
