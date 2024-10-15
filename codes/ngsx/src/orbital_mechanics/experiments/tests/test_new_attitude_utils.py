# test_attitude_utils.py

import pytest
import numpy as np
from scipy.spatial.transform import Rotation
from fractions import Fraction
from math import pi

from src.orbital_mechanics.experiments.new_attitude_utils import AttitudeUtils
from src.orbital_mechanics.experiments.new_spherical_coordinate import radian, degree
from src.orbital_mechanics.experiments.new_vector3d import Vector3D
from src.orbital_mechanics.experiments.quantities import Unit, second, radian_per_second


def test_euler_to_rotation_radians():
    # Test euler_to_rotation with angles in radians
    roll = pi / 4  # 45 degrees in radians
    pitch = pi / 6  # 30 degrees in radians
    yaw = pi / 3  # 60 degrees in radians
    rotation = AttitudeUtils.euler_to_rotation(roll, pitch, yaw, angle_unit=radian)
    # Convert back to Euler angles to check
    roll_out, pitch_out, yaw_out = rotation.as_euler('xyz')
    assert np.isclose(roll_out, roll, atol=1e-6)
    assert np.isclose(pitch_out, pitch, atol=1e-6)
    assert np.isclose(yaw_out, yaw, atol=1e-6)

def test_euler_to_rotation_degrees():
    # Test euler_to_rotation with angles in degrees
    roll = 45.0
    pitch = 30.0
    yaw = 60.0
    rotation = AttitudeUtils.euler_to_rotation(roll, pitch, yaw, angle_unit=degree)
    # Convert back to Euler angles in degrees
    roll_out, pitch_out, yaw_out = AttitudeUtils.rotation_to_euler(rotation, angle_unit=degree)
    assert np.isclose(roll_out, roll, atol=1e-6)
    assert np.isclose(pitch_out, pitch, atol=1e-6)
    assert np.isclose(yaw_out, yaw, atol=1e-6)

def test_rotation_to_euler_radians():
    # Test rotation_to_euler with angles in radians
    rotation = Rotation.from_euler('xyz', [pi / 4, pi / 6, pi / 3])
    roll, pitch, yaw = AttitudeUtils.rotation_to_euler(rotation, angle_unit=radian)
    assert np.isclose(roll, pi / 4, atol=1e-6)
    assert np.isclose(pitch, pi / 6, atol=1e-6)
    assert np.isclose(yaw, pi / 3, atol=1e-6)

def test_rotation_to_euler_degrees():
    # Test rotation_to_euler with angles in degrees
    rotation = Rotation.from_euler('xyz', [45.0, 30.0, 60.0], degrees=True)
    roll, pitch, yaw = AttitudeUtils.rotation_to_euler(rotation, angle_unit=degree)
    assert np.isclose(roll, 45.0, atol=1e-6)
    assert np.isclose(pitch, 30.0, atol=1e-6)
    assert np.isclose(yaw, 60.0, atol=1e-6)

def test_propagate_attitude_zero_angular_velocity():
    # Test propagate_attitude with zero angular velocity
    initial_attitude = Rotation.identity()
    attitude_vector_as_euler = initial_attitude.as_euler('xyz')
    attitude_vector = Vector3D(*attitude_vector_as_euler, unit=radian)
    angular_velocity = Vector3D(0.0, 0.0, 0.0, unit=radian_per_second)
    dt = 10.0  # seconds
    new_attitude = AttitudeUtils.propagate_attitude(attitude_vector, angular_velocity, dt)
    # Attitude should remain the same
    new_attitude_rotation = Rotation.from_euler('xyz', new_attitude.as_array())
    assert np.allclose(new_attitude_rotation.as_matrix(), initial_attitude.as_matrix(), atol=1e-6)

def test_propagate_attitude_nonzero_angular_velocity():
    # Test propagate_attitude with non-zero angular velocity
    initial_attitude = Rotation.identity()
    attitude_vector_as_euler = initial_attitude.as_euler('xyz')
    attitude_vector = Vector3D(*attitude_vector_as_euler, unit=radian)
    angular_velocity = Vector3D(0.0, 0.0, 0.1, unit=radian_per_second)  # Rotate around z-axis
    dt = 10.0  # seconds
    new_attitude = AttitudeUtils.propagate_attitude(attitude_vector, angular_velocity, dt)
    # Expected total rotation angle
    total_angle = 0.1 * dt  # radians
    # Create expected rotation
    expected_rotation = Rotation.from_rotvec([0.0, 0.0, total_angle])
    # Compare the resulting rotation matrices
    new_attitude_rotation = Rotation.from_euler('xyz', new_attitude.as_array())
    assert np.allclose(new_attitude_rotation.as_matrix(), expected_rotation.as_matrix(), atol=1e-6)

def test_propagate_attitude_large_rotation():
    # Test propagate_attitude with rotation exceeding 2π radians
    initial_attitude = Rotation.identity()
    attitude_vector_as_euler = initial_attitude.as_euler('xyz')
    attitude_vector = Vector3D(*attitude_vector_as_euler, unit=radian)

    angular_velocity = Vector3D(0.0, 0.0, 1.0, unit=radian_per_second)  # Rotate around z-axis
    dt = 8 * pi  # seconds, total rotation would be 8π radians
    new_attitude = AttitudeUtils.propagate_attitude(attitude_vector, angular_velocity, dt)
    # Expected total rotation angle after modulo 2π
    total_angle = (1.0 * dt) % (2 * pi)  # Should be 0 radians
    # Create expected rotation (identity rotation)
    expected_rotation = Rotation.identity()
    # Compare the resulting rotation matrices
    new_attitude_rotation = Rotation.from_euler('xyz', new_attitude.as_array())

    assert np.allclose(new_attitude_rotation.as_matrix(), expected_rotation.as_matrix(), atol=1e-6)

def test_propagate_attitude_different_axes():
    # Test propagate_attitude with angular velocity around multiple axes
    initial_attitude = Rotation.identity()
    attitude_vector_as_euler = initial_attitude.as_euler('xyz')
    attitude_vector = Vector3D(*attitude_vector_as_euler, unit=radian)

    angular_velocity = Vector3D(0.1, 0.2, 0.3, unit=radian_per_second)
    dt = 5.0  # seconds
    new_attitude = AttitudeUtils.propagate_attitude(attitude_vector, angular_velocity, dt)
    # Expected rotation vector
    omega = np.array([0.1, 0.2, 0.3])
    omega_norm = np.linalg.norm(omega)
    total_angle = omega_norm * dt
    rotvec = total_angle * (omega / omega_norm)
    expected_rotation = Rotation.from_rotvec(rotvec)
    # Compare the resulting rotation matrices
    new_attitude_rotation = Rotation.from_euler('xyz', new_attitude.as_array())
    assert np.allclose(new_attitude_rotation.as_matrix(), expected_rotation.as_matrix(), atol=1e-6)

def test_propagate_attitude_zero_dt():
    # Test propagate_attitude with zero time step
    initial_attitude = Rotation.identity()
    attitude_vector_as_euler = initial_attitude.as_euler('xyz')
    attitude_vector = Vector3D(*attitude_vector_as_euler, unit=radian)


    angular_velocity = Vector3D(0.1, 0.2, 0.3, unit=radian_per_second)
    dt = 0.0  # seconds
    new_attitude = AttitudeUtils.propagate_attitude(attitude_vector, angular_velocity, dt)
    # Attitude should remain the same
    new_attitude_rotation = Rotation.from_euler('xyz', new_attitude.as_array())

    assert np.allclose(new_attitude_rotation.as_matrix(), initial_attitude.as_matrix(), atol=1e-6)

def test_propagate_attitude_invalid_angular_velocity_unit():
    # Test propagate_attitude with incorrect angular velocity unit
    initial_attitude = Rotation.identity()
    attitude_vector_as_euler = initial_attitude.as_euler('xyz')
    attitude_vector = Vector3D(*attitude_vector_as_euler, unit=radian)

    # Angular velocity with incorrect unit (e.g., degrees per second)
    angular_velocity = Vector3D(0.1, 0.2, 0.3, unit=degree / second)
    dt = 5.0  # seconds
    with pytest.raises(ValueError) as excinfo:
        _ = AttitudeUtils.propagate_attitude(attitude_vector, angular_velocity, dt)
    assert "Angular velocity must have units of rad/s." in str(excinfo.value)

def test_convert_angle_to_radians():
    # Test _convert_angle_to_radians method
    angle_deg = 180.0
    angle_rad = AttitudeUtils._convert_angle_to_radians(angle_deg, degree)
    assert np.isclose(angle_rad, pi, atol=1e-6)

def test_convert_angle_from_radians():
    # Test _convert_angle_from_radians method
    angle_rad = pi
    angle_deg = AttitudeUtils._convert_angle_from_radians(angle_rad, degree)
    assert np.isclose(angle_deg, 180.0, atol=1e-6)

def test_euler_to_rotation_invalid_angle_unit():
    # Test euler_to_rotation with invalid angle unit
    angle_unit = Unit('grad', {'rad': Fraction(1)}, factor=pi / 200.0)  # Gradians
    with pytest.raises(ValueError) as excinfo:
        _ = AttitudeUtils.euler_to_rotation(100.0, 50.0, 25.0, angle_unit=angle_unit)
    assert "Unsupported angle unit" in str(excinfo.value)

def test_rotation_to_euler_invalid_angle_unit():
    # Test rotation_to_euler with invalid angle unit
    rotation = Rotation.identity()
    angle_unit = Unit('grad', {'rad': Fraction(1)}, factor=pi / 200.0)  # Gradians
    with pytest.raises(ValueError) as excinfo:
        _ = AttitudeUtils.rotation_to_euler(rotation, angle_unit=angle_unit)
    assert "Unsupported angle unit" in str(excinfo.value)

def test_propagate_attitude_max_angle_per_step():
    # Test propagate_attitude with max_angle_per_step limiting the number of steps
    initial_attitude = Rotation.identity()
    attitude_vector_as_euler = initial_attitude.as_euler('xyz')
    attitude_vector = Vector3D(*attitude_vector_as_euler, unit=radian)

    angular_velocity = Vector3D(0.0, 0.0, 1.0, unit=radian_per_second)  # Rotate around z-axis
    dt = pi  # seconds, total rotation of π radians
    max_angle_per_step = pi / 8  # Smaller than total_angle to force multiple steps
    new_attitude = AttitudeUtils.propagate_attitude(
        attitude_vector,
        angular_velocity,
        dt,
        max_angle_per_step=max_angle_per_step
    )
    # Expected rotation
    expected_rotation = Rotation.from_rotvec([0.0, 0.0, pi])
    # Compare the resulting rotation matrices
    new_attitude_rotation = Rotation.from_euler('xyz', new_attitude.as_array())

    assert np.allclose(new_attitude_rotation.as_matrix(), expected_rotation.as_matrix(), atol=1e-6)
