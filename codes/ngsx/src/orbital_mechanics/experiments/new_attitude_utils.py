from typing import Tuple

import numpy as np
from scipy.spatial.transform import Rotation

from src.orbital_mechanics.experiments.new_spherical_coordinate import radian, degree
from src.orbital_mechanics.experiments.new_vector3d import Vector3D
from src.orbital_mechanics.experiments.quantities import Unit, radian_per_second


class AttitudeUtils:
    @staticmethod
    def euler_to_rotation(roll: float, pitch: float, yaw: float, angle_unit: Unit = radian) -> Rotation:
        """
        Convert Euler angles to a Rotation object.
        Assumes roll (x), then pitch (y), then yaw (z) rotation order.
        """
        # Convert angles to radians if necessary
        roll_rad = AttitudeUtils._convert_angle_to_radians(roll, angle_unit)
        pitch_rad = AttitudeUtils._convert_angle_to_radians(pitch, angle_unit)
        yaw_rad = AttitudeUtils._convert_angle_to_radians(yaw, angle_unit)
        return Rotation.from_euler('xyz', [roll_rad, pitch_rad, yaw_rad])

    @staticmethod
    def rotation_to_euler(rotation: Rotation, angle_unit: Unit = radian) -> Tuple[float, float, float]:
        """
        Convert a Rotation object to Euler angles (Radians).
        Returns (roll, pitch, yaw).
        """
        euler_rad = rotation.as_euler('xyz', degrees=False)
        # Convert angles from radians to desired unit
        roll = AttitudeUtils._convert_angle_from_radians(euler_rad[0], angle_unit)
        pitch = AttitudeUtils._convert_angle_from_radians(euler_rad[1], angle_unit)
        yaw = AttitudeUtils._convert_angle_from_radians(euler_rad[2], angle_unit)
        return roll, pitch, yaw

    @staticmethod
    def propagate_attitude(
        initial_attitude: Vector3D,
        angular_velocity: Vector3D,
        dt: float,
        max_angle_per_step: float = np.pi / 4,
        angle_unit: Unit = radian
    ) -> Vector3D:
        """
        Propagate the attitude given an initial attitude, angular velocity, and time step.
        Angular velocity should be a Vector3D with units of rad/s.
        """
        attitude_in_radians = initial_attitude.to(radian)

        if angular_velocity.unit != radian_per_second:
            raise ValueError("Angular velocity must have units of rad/s.")

        omega = np.array([angular_velocity.x, angular_velocity.y, angular_velocity.z])  # rad/s
        omega_norm = np.linalg.norm(omega)

        if omega_norm == 0 or dt == 0:
            return initial_attitude

        total_angle = omega_norm * dt  # Total rotation angle in radians

        # Limit total_angle to prevent excessively large rotations
        if total_angle > 2 * np.pi:
            total_angle = total_angle % (2 * np.pi)

        # Subdivide time step if necessary
        num_steps = max(1, int(np.ceil(total_angle / max_angle_per_step)))
        dt_step = dt / num_steps

        attitude = Rotation.from_euler('XYZ', initial_attitude.as_array())
        for _ in range(num_steps):
            delta_angle = omega_norm * dt_step
            rotvec = delta_angle * (omega / omega_norm)
            rotation_increment = Rotation.from_rotvec(rotvec)
            attitude = rotation_increment * attitude

        result_vector = Vector3D(*attitude.as_euler('XYZ'))

        return result_vector

    @staticmethod
    def _convert_angle_to_radians(angle_value: float, angle_unit: Unit) -> float:
        if angle_unit == radian:
            return angle_value
        elif angle_unit == degree:
            return angle_value * (np.pi / 180.0)
        else:
            raise ValueError(f"Unsupported angle unit: {angle_unit}")

    @staticmethod
    def _convert_angle_from_radians(angle_rad: float, angle_unit: Unit) -> float:
        if angle_unit == radian:
            return angle_rad
        elif angle_unit == degree:
            return angle_rad * (180.0 / np.pi)
        else:
            raise ValueError(f"Unsupported angle unit: {angle_unit}")
