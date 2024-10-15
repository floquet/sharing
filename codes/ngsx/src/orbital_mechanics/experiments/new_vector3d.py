from dataclasses import dataclass
from math import sqrt
from typing import Union
from enum import Enum
import numpy as np

from enum import auto

from src.orbital_mechanics.experiments.quantities import Unit, dimensionless, Quantity, meter


# Define a dimensionless unit

class ReferenceFrame(Enum):
    NONE = auto()
    ECI = auto()
    ECEF = auto()
    ITRF = auto()
    # Add other reference frames as needed

@dataclass
class Vector3D:
    """3D vector class with unit-aware components and reference frame."""
    x: float
    y: float
    z: float
    unit: Unit = dimensionless  # Default to dimensionless
    reference_frame: ReferenceFrame = ReferenceFrame.ECI  # Default reference frame

    def __post_init__(self):
        if not isinstance(self.unit, Unit):
            raise TypeError("unit must be an instance of Unit")
        if not isinstance(self.reference_frame, ReferenceFrame):
            raise TypeError("reference_frame must be an instance of ReferenceFrame")

    def __add__(self, other: 'Vector3D') -> 'Vector3D':
        if self.reference_frame != other.reference_frame:
            raise ValueError(f"Cannot add vectors in different reference frames: {self.reference_frame} and {other.reference_frame}.")
        if self.unit.is_compatible_with(other.unit):
            # Convert other's unit to self's unit
            factor = other.unit.conversion_factor_to(self.unit)
            return Vector3D(
                self.x + other.x * factor,
                self.y + other.y * factor,
                self.z + other.z * factor,
                self.unit,
                self.reference_frame
            )
        else:
            raise ValueError(f"Cannot add vectors with units {self.unit} and {other.unit}.")

    def __sub__(self, other: 'Vector3D') -> 'Vector3D':
        if self.reference_frame != other.reference_frame:
            raise ValueError(f"Cannot subtract vectors in different reference frames: {self.reference_frame} and {other.reference_frame}.")
        if self.unit.is_compatible_with(other.unit):
            factor = other.unit.conversion_factor_to(self.unit)
            return Vector3D(
                self.x - other.x * factor,
                self.y - other.y * factor,
                self.z - other.z * factor,
                self.unit,
                self.reference_frame
            )
        else:
            raise ValueError(f"Cannot subtract vectors with units {self.unit} and {other.unit}.")

    def __mul__(self, other: Union[float, int, 'Quantity']) -> 'Vector3D':
        if isinstance(other, (float, int)):
            # Scalar multiplication
            return Vector3D(
                self.x * other,
                self.y * other,
                self.z * other,
                self.unit,
                self.reference_frame
            )
        elif isinstance(other, Quantity):
            # Quantity multiplication
            # Multiply each component by the Quantity's value and adjust the unit
            new_unit = self.unit * other.unit
            return Vector3D(
                self.x * other.value,
                self.y * other.value,
                self.z * other.value,
                new_unit,
                self.reference_frame
            )
        else:
            raise TypeError("Unsupported multiplication type. Must be a scalar (float or int) or Quantity.")

    def __rmul__(self, other: Union[float, int, 'Quantity']) -> 'Vector3D':
        return self.__mul__(other)

    def __truediv__(self, other: Union[float, int, 'Quantity']) -> 'Vector3D':
        if isinstance(other, (float, int)):
            # Scalar division
            return Vector3D(
                self.x / other,
                self.y / other,
                self.z / other,
                self.unit,
                self.reference_frame
            )
        elif isinstance(other, Quantity):
            # Quantity division
            # Divide each component by the Quantity's value and adjust the unit
            new_unit = self.unit / other.unit
            return Vector3D(
                self.x / other.value,
                self.y / other.value,
                self.z / other.value,
                new_unit,
                self.reference_frame
            )

    def dot(self, other: 'Vector3D') -> Quantity:
        if self.reference_frame != other.reference_frame:
            raise ValueError(
                f"Cannot compute dot product of vectors in different reference frames: {self.reference_frame} and {other.reference_frame}.")

        # Compute the dot product without considering unit compatibility
        dot_product = self.x * other.x + self.y * other.y + self.z * other.z

        # The resulting unit is the product of the two units
        result_unit = self.unit * other.unit

        return Quantity(dot_product, result_unit)

    def cross(self, other: 'Vector3D') -> 'Vector3D':
        if self.reference_frame != other.reference_frame:
            raise ValueError(
                f"Cannot compute cross product of vectors in different reference frames: {self.reference_frame} and {other.reference_frame}.")

        # Compute the cross product without considering unit compatibility
        x = self.y * other.z - self.z * other.y
        y = self.z * other.x - self.x * other.z
        z = self.x * other.y - self.y * other.x

        # The resulting unit is the product of the two units
        result_unit = self.unit * other.unit

        return Vector3D(x, y, z, result_unit, self.reference_frame)

    def norm(self) -> Quantity:
        magnitude = sqrt(self.x ** 2 + self.y ** 2 + self.z ** 2)
        return Quantity(magnitude, self.unit)

    def magnitude(self) -> Quantity:
        return self.norm()

    def normalize(self) -> 'Vector3D':
        magnitude = self.norm().value
        if magnitude == 0:
            raise ValueError("Cannot normalize a zero vector.")
        return Vector3D(
            self.x / magnitude,
            self.y / magnitude,
            self.z / magnitude,
            dimensionless,  # Normalized vector is dimensionless
            self.reference_frame
        )

    def to(self, target_unit: Unit) -> 'Vector3D':
        """
        Converts the vector to the specified target unit, scaling its components accordingly.

        Parameters:
        - target_unit: Unit
            The unit to convert the vector to.

        Returns:
        - Vector3D
            A new Vector3D instance with components converted to the target unit.

        Raises:
        - ValueError: If units are not compatible.
        """
        # Ensure the target unit is compatible with the current unit
        if not self.unit.is_compatible_with(target_unit):
            raise ValueError(f"Cannot convert from {self.unit} to {target_unit} as they are not compatible.")

        # Calculate the conversion factor
        factor = self.unit.conversion_factor_to(target_unit)

        # Apply the conversion factor to each component
        return Vector3D(
            x=self.x * factor,
            y=self.y * factor,
            z=self.z * factor,
            unit=target_unit,
            reference_frame=self.reference_frame
        )

    def force_units(self, target_unit: Unit) -> 'Vector3D':
        """Return a new Vector3D with the provided unit without converting the components."""
        return Vector3D(
            self.x,
            self.y,
            self.z,
            target_unit,
            self.reference_frame
        )

    def force_reference_frame(self, target_reference_frame: ReferenceFrame) -> 'Vector3D':
        """Return a new Vector3D with the provided reference frame without changing components."""
        return Vector3D(
            self.x,
            self.y,
            self.z,
            self.unit,
            target_reference_frame
        )

    def as_array(self) -> np.ndarray:
        """Return the vector components as a numpy array."""
        return np.array([self.x, self.y, self.z])

    def __str__(self):
        return f"Vector3D({self.x}, {self.y}, {self.z}) {self.unit}, Reference Frame: {self.reference_frame.name}"

    def as_json(self):
        return {
            "x": self.x,
            "y": self.y,
            "z": self.z,
            "unit": str(self.unit),
            "reference_frame": self.reference_frame.name
        }

    def __hash__(self):
        return hash((self.x, self.y, self.z, self.unit, self.reference_frame))


def test_example():
    # Example usage of Unit arithmetic with numbers and arrays
    # Multiplying Unit by a scalar
    distance = 3 * meter  # Should create Quantity(3, meter)
    print(distance)  # Output: 3 m

    # Multiplying Unit by an ndarray of shape (3,)
    array = np.array([1.0, 2.0, 3.0])
    position = meter * array  # Should create Vector3D with components [1.0, 2.0, 3.0] meters
    print(position)  # Output: Vector3D(1.0, 2.0, 3.0) m, Reference Frame: NONE

    # Multiplying Vector3D by ndarray of shape (3,)
    v = Vector3D(1.0, 2.0, 3.0, unit=meter)
    scaling_factors = np.array([2.0, 0.5, 1.0])
    v_scaled = v * scaling_factors  # Multiplies components element-wise
    print(v_scaled)  # Output: Vector3D(2.0, 1.0, 3.0) m, Reference Frame: NONE

    # Attempting to multiply with incorrect shape
    try:
        wrong_array = np.array([1.0, 2.0])
        v_wrong = v * wrong_array
    except ValueError as e:
        print(f"Error: {e}")  # Output: Error: Multiplication ndarray must have shape (3,).

    # Using exponentiation with Unit
    area_unit = meter ** 2
    print(f"Area unit: {area_unit}")  # Output: Area unit: m**2

