from dataclasses import dataclass, field
from functools import cache
import numpy as np

from src.orbital_mechanics.experiments.new_vector3d import Vector3D, ReferenceFrame
from src.orbital_mechanics.experiments.quantities import meter, Quantity
from src.orbital_mechanics.experiments.quantities import Unit  # Ensure Unit is imported


@dataclass(frozen=True)
class Size3D:
    """
    Represents a 3D size using a Vector3D to encapsulate length, width, and height dimensions.

    Attributes:
        dimensions (Vector3D):
            A Vector3D instance representing the size dimensions along the x, y, and z axes.
            Each component must have units of length (e.g., meters) and a ReferenceFrame of NONE.
    """
    dimensions: Vector3D = field(
        default_factory=lambda: Vector3D(0.0, 0.0, 0.0, unit=meter, reference_frame=ReferenceFrame.NONE))

    def __post_init__(self):
        """
        Validates that all dimensions are non-negative and have appropriate units.
        """
        # Ensure that all dimensions are non-negative
        if (self.dimensions.x < 0) or (self.dimensions.y < 0) or (self.dimensions.z < 0):
            raise ValueError("All dimensions must be non-negative.")

        # Ensure that dimensions have length units
        if not self.dimensions.unit.is_length():
            raise ValueError("All dimensions must have units of length.")

        # Ensure that the reference frame is NONE, as size is frame-independent
        if self.dimensions.reference_frame != ReferenceFrame.NONE:
            raise ValueError("Dimensions must have a ReferenceFrame of NONE.")

    @cache
    def as_array(self) -> np.ndarray:
        """
        Returns the size dimensions as a NumPy array in meters.

        Returns:
            np.ndarray:
                A 1D array containing the length, width, and height in meters.
        """
        return self.dimensions.to(meter).as_array()

    @cache
    def volume(self) -> Quantity:
        """
        Calculates the volume based on the size dimensions.

        Returns:
            Quantity:
                The volume in cubic meters (m³).
        """
        volume_value = self.dimensions.x * self.dimensions.y * self.dimensions.z  # meters^3
        return Quantity(volume_value, meter ** 3)

    @cache
    def surface_area(self) -> Quantity:
        """
        Calculates the surface area based on the size dimensions.

        Returns:
            Quantity:
                The surface area in square meters (m²).
        """
        l, w, h = self.as_array()  # meters
        surface_area_value = 2 * (l * w + l * h + w * h)  # meters^2
        return Quantity(surface_area_value, meter ** 2)

    def __str__(self) -> str:
        """
        Returns a human-readable string representation of the size dimensions.

        Returns:
            str:
                A string in the format "(length, width, height) [unit]".
        """
        return f"Size3D(dimensions={self.dimensions})"

    def __repr__(self) -> str:
        """
        Returns an unambiguous string representation of the Size3D instance.

        Returns:
            str:
                A string in the format "Size3D(dimensions=Vector3D(...))".
        """
        return f"Size3D(dimensions={repr(self.dimensions)})"

    # Additional Methods for Enhanced Functionality

    def scale(self, factor: float) -> 'Size3D':
        """
        Scales the size dimensions by a given factor.

        Parameters:
            factor (float):
                The scaling factor to apply to each dimension.

        Returns:
            Size3D:
                A new Size3D instance with scaled dimensions.
        """
        scaled_dimensions = self.dimensions * factor
        return Size3D(dimensions=scaled_dimensions)

    def fits_inside(self, other: 'Size3D') -> bool:
        """
        Determines if the current size can fit inside another size.

        Parameters:
            other (Size3D):
                The Size3D instance to compare against.

        Returns:
            bool:
                True if each dimension of the current size is less than or equal to the corresponding
                dimension of the other size; False otherwise.
        """
        self_array = self.as_array()
        other_array = other.as_array()
        return np.all(self_array <= other_array)
