from dataclasses import dataclass
import numpy as np
from math import sin, cos, asin, atan2
from scipy.spatial.transform import Rotation as R
from fractions import Fraction

from src.orbital_mechanics.experiments.new_vector3d import Vector3D, ReferenceFrame
from src.orbital_mechanics.experiments.quantities import Unit, meter, kilometer

# Assuming Unit, Quantity, Vector3D, ReferenceFrame, and base units are defined as in previous code

# Define angle units
radian = Unit('rad', {'rad': Fraction(1)}, factor=1.0)
degree = Unit('deg', {'rad': Fraction(1)}, factor=np.pi / 180.0)  # 1 degree = π/180 radians


@dataclass(frozen=True)
class SphericalCoordinate:
    """Spherical coordinate class with unit handling and reference frame."""
    range: float  # Range value
    azimuth: float  # Azimuth angle value
    elevation: float  # Elevation angle value
    range_unit: Unit = meter  # Default to meters
    angle_unit: Unit = radian  # Default to radians
    reference_frame: ReferenceFrame = ReferenceFrame.ECI  # Default reference frame

    def as_array(self) -> np.ndarray:
        return np.array([self.range, self.azimuth, self.elevation])

    @staticmethod
    def from_array(
        array: np.ndarray,
        range_unit: Unit = meter,
        angle_unit: Unit = radian,
        reference_frame: ReferenceFrame = ReferenceFrame.ECI
    ) -> 'SphericalCoordinate':
        return SphericalCoordinate(array[0], array[1], array[2], range_unit, angle_unit, reference_frame)

    def __str__(self) -> str:
        return (
            f"({self.range} {self.range_unit}, "
            f"{self.azimuth} {self.angle_unit}, "
            f"{self.elevation} {self.angle_unit}), "
            f"Reference Frame: {self.reference_frame.name}"
        )

    def __repr__(self) -> str:
        return (
            f"SphericalCoordinate(range={self.range}, azimuth={self.azimuth}, elevation={self.elevation}, "
            f"range_unit={self.range_unit}, angle_unit={self.angle_unit}, reference_frame={self.reference_frame})"
        )

    def to_cartesian(self) -> Vector3D:
        # Convert angles to radians if necessary
        azimuth_rad = self._convert_angle_to_radians(self.azimuth)
        elevation_rad = self._convert_angle_to_radians(self.elevation)

        # Compute cartesian coordinates
        x = self.range * cos(elevation_rad) * cos(azimuth_rad)
        y = self.range * cos(elevation_rad) * sin(azimuth_rad)
        z = self.range * sin(elevation_rad)

        return Vector3D(x, y, z, unit=self.range_unit, reference_frame=self.reference_frame)

    @staticmethod
    def from_cartesian(
        cartesian: Vector3D,
        angle_unit: Unit = radian
    ) -> 'SphericalCoordinate':
        r = cartesian.norm().value  # Get magnitude with unit
        x, y, z = cartesian.x, cartesian.y, cartesian.z

        azimuth_rad = atan2(y, x)
        elevation_rad = asin(z / r)

        # Convert angles to desired unit
        azimuth = SphericalCoordinate._convert_angle_from_radians(azimuth_rad, angle_unit)
        elevation = SphericalCoordinate._convert_angle_from_radians(elevation_rad, angle_unit)

        return SphericalCoordinate(
            r,
            azimuth,
            elevation,
            cartesian.unit,
            angle_unit,
            reference_frame=cartesian.reference_frame
        )

    def _convert_angle_to_radians(self, angle_value: float) -> float:
        if self.angle_unit == radian:
            return angle_value
        elif self.angle_unit == degree:
            return angle_value * (np.pi / 180.0)
        else:
            raise ValueError(f"Unsupported angle unit: {self.angle_unit}")

    @staticmethod
    def _convert_angle_from_radians(angle_rad: float, angle_unit: Unit) -> float:
        if angle_unit == radian:
            return angle_rad
        elif angle_unit == degree:
            return angle_rad * (180.0 / np.pi)
        else:
            raise ValueError(f"Unsupported angle unit: {angle_unit}")

    def to(
        self,
        target_range_unit: Unit,
        target_angle_unit: Unit,
        target_reference_frame: ReferenceFrame = None
    ) -> 'SphericalCoordinate':
        # Convert range
        if not self.range_unit.is_compatible_with(target_range_unit):
            raise ValueError(f"Cannot convert range unit from {self.range_unit} to {target_range_unit}")
        range_factor = self.range_unit.conversion_factor_to(target_range_unit)
        new_range = self.range * range_factor

        # Convert angles
        azimuth_rad = self._convert_angle_to_radians(self.azimuth)
        elevation_rad = self._convert_angle_to_radians(self.elevation)
        azimuth = SphericalCoordinate._convert_angle_from_radians(azimuth_rad, target_angle_unit)
        elevation = SphericalCoordinate._convert_angle_from_radians(elevation_rad, target_angle_unit)

        # Use target reference frame if provided
        reference_frame = target_reference_frame if target_reference_frame else self.reference_frame

        return SphericalCoordinate(new_range, azimuth, elevation, target_range_unit, target_angle_unit, reference_frame)

def get_relative_position_in_observer_frame(
    observer_attitude: R,
    observer_position: Vector3D,
    target_position: Vector3D,
    angle_unit: Unit = radian,
    range_unit: Unit = meter
) -> 'SphericalCoordinate':
    if observer_position.reference_frame != target_position.reference_frame:
        raise ValueError("Observer and target positions must be in the same reference frame.")

    # Compute relative vector
    relative_vector = target_position - observer_position  # Vector3D subtraction handles units

    # Rotate relative vector into observer's frame
    relative_vector_in_observer_frame = observer_attitude.inv().apply(relative_vector.as_array())
    relative_vector_in_observer_frame = Vector3D(
        *relative_vector_in_observer_frame,
        unit=relative_vector.unit,
        reference_frame=ReferenceFrame.NONE  # Local to observer
    )

    # Compute range
    range_value = relative_vector_in_observer_frame.norm().value  # Get magnitude with unit

    # Compute azimuth and elevation in radians
    x, y, z = relative_vector_in_observer_frame.x, relative_vector_in_observer_frame.y, relative_vector_in_observer_frame.z
    azimuth_rad = atan2(y, x)
    elevation_rad = asin(z / range_value)

    # Convert angles to desired unit
    azimuth = SphericalCoordinate._convert_angle_from_radians(azimuth_rad, angle_unit)
    elevation = SphericalCoordinate._convert_angle_from_radians(elevation_rad, angle_unit)

    # Convert range to desired unit
    if not relative_vector_in_observer_frame.unit.is_compatible_with(range_unit):
        raise ValueError(f"Cannot convert range unit from {relative_vector_in_observer_frame.unit} to {range_unit}")
    range_factor = relative_vector_in_observer_frame.unit.conversion_factor_to(range_unit)
    range_converted = range_value * range_factor

    return SphericalCoordinate(
        range_converted,
        azimuth,
        elevation,
        range_unit,
        angle_unit,
        reference_frame=ReferenceFrame.NONE  # Since it's relative to the observer's frame
    )


def angles_close(angle1, angle2, atol=1e-6):
    """Check if two angles are close to each other, considering wrapping at ±π."""
    angle_diff = (angle1 - angle2 + np.pi) % (2 * np.pi) - np.pi
    return abs(angle_diff) < atol

def test_example_1():
    # Original spherical coordinate in ECI frame
    spherical_eci = SphericalCoordinate(
        range=7000.0,
        azimuth=45.0,
        elevation=30.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )

    # Convert to Cartesian in ECI frame
    cartesian_eci = spherical_eci.to_cartesian()

    # Transform to ECEF frame (assuming you have a rotation from ECI to ECEF)
    # For example purposes, let's use an identity rotation (no change)
    eci_to_ecef_rotation = R.identity()
    cartesian_ecef_array = eci_to_ecef_rotation.apply(cartesian_eci.as_array())

    # Create a Vector3D in ECEF frame
    cartesian_ecef = Vector3D(
        *cartesian_ecef_array,
        unit=cartesian_eci.unit,
        reference_frame=ReferenceFrame.ECEF
    )

    # Convert back to SphericalCoordinate in ECEF frame
    spherical_ecef = SphericalCoordinate.from_cartesian(cartesian_ecef, angle_unit=degree)

    print(f"Spherical Coordinate in ECEF Frame: {spherical_ecef}")

def test_example_2():
    # Two spherical coordinates in the same reference frame
    spherical1 = SphericalCoordinate(
        range=5000.0,
        azimuth=30.0,
        elevation=20.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )

    spherical2 = SphericalCoordinate(
        range=2000.0,
        azimuth=60.0,
        elevation=10.0,
        range_unit=kilometer,
        angle_unit=degree,
        reference_frame=ReferenceFrame.ECI
    )

    # Convert to Cartesian
    cartesian1 = spherical1.to_cartesian()
    cartesian2 = spherical2.to_cartesian()

    # Perform addition
    cartesian_sum = cartesian1 + cartesian2

    # Convert back to SphericalCoordinate
    spherical_sum = SphericalCoordinate.from_cartesian(cartesian_sum, angle_unit=degree)

    print(f"Sum of Spherical Coordinates: {spherical_sum}")


def test_observer_at_origin_facing_x_axis_target_along_x():
    observer_position = Vector3D(0.0, 0.0, 0.0, unit=meter, reference_frame=ReferenceFrame.ECI)
    observer_attitude = R.identity()
    target_position = Vector3D(100.0, 0.0, 0.0, unit=meter, reference_frame=ReferenceFrame.ECI)

    expected_range = 100.0
    expected_azimuth = 0.0
    expected_elevation = 0.0

    result = get_relative_position_in_observer_frame(
        observer_attitude, observer_position, target_position
    )

    assert np.isclose(result.range, expected_range, atol=1e-6)
    assert np.isclose(result.azimuth, expected_azimuth, atol=1e-6)
    assert np.isclose(result.elevation, expected_elevation, atol=1e-6)
    assert result.range_unit == meter
    assert result.angle_unit == radian
    assert result.reference_frame == ReferenceFrame.NONE  # Since it's relative to observer's frame




