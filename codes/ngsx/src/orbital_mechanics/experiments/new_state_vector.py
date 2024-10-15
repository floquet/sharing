import numpy as np
from scipy.spatial.transform import Rotation
from dataclasses import dataclass
from datetime import datetime, timedelta
from typing import Tuple, Union, Optional


from src.orbital_mechanics.experiments.new_attitude_utils import AttitudeUtils
from src.orbital_mechanics.experiments.new_classic_orbital_elements import ClassicalOrbitalElements, \
    EARTH_GRAVITATIONAL_PARAMETER
from src.orbital_mechanics.experiments.new_spherical_coordinate import radian
from src.orbital_mechanics.experiments.new_vector3d import Vector3D
from src.orbital_mechanics.experiments.quantities import second, Quantity


@dataclass(frozen=True)
class StateVector:
    epoch: datetime
    position: Vector3D
    velocity: Vector3D
    attitude: Vector3D
    angular_velocity: Vector3D

    def to_coe(self, gravitational_parameter: Quantity = EARTH_GRAVITATIONAL_PARAMETER) -> ClassicalOrbitalElements:
        """
        Convert state vector to classical orbital elements.

        :param gravitational_parameter: Standard gravitational parameter (GM) in km^3/s^2
        :return: ClassicalOrbitalElements object
        """
        return ClassicalOrbitalElements.from_rv(self.position, self.velocity, gravitational_parameter)

    @classmethod
    def from_coe(cls, coe: ClassicalOrbitalElements, epoch: datetime,
                 attitude: Optional[Vector3D] = None,
                 angular_velocity: Optional[Vector3D] = None,
                 gravitational_parameter: float = EARTH_GRAVITATIONAL_PARAMETER) -> 'StateVector':
        """
        Create a StateVector from classical orbital elements.

        :param coe: ClassicalOrbitalElements object
        :param epoch: Epoch for the state vector
        :param attitude: Optional attitude as a Rotation object
        :param angular_velocity: Optional angular velocity vector
        :param gravitational_parameter: Standard gravitational parameter (GM) in km^3/s^2
        :return: StateVector object
        """
        position, velocity = coe.to_rv(gravitational_parameter)
        attitude = Vector3D(0,0,0) if attitude is None else attitude
        angular_velocity = Vector3D(0,0,0) if angular_velocity is None else angular_velocity

        return cls(epoch, position, velocity, attitude, angular_velocity)

    def __str__(self):
        epoch_iso8601 = self.epoch.isoformat()
        return f"StateVector(epoch={epoch_iso8601}, position={self.position}, velocity={self.velocity}, attitude={self.attitude}, angular_velocity={self.angular_velocity})"

    def __repr__(self):
        return str(self)

    def as_json(self):
        return {
            "epoch": self.epoch.isoformat(),
            "position": self.position.as_json(),
            "velocity": self.velocity.as_json(),
            "attitude": self.attitude.as_json(),
            "angular_velocity": self.angular_velocity.as_json()
        }


@dataclass(frozen=True)
class KinematicDelta:
    delta_v: Vector3D
    delta_omega: Vector3D

