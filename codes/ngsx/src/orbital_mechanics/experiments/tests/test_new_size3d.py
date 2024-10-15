import pytest
import numpy as np

from src.orbital_mechanics.experiments.new_size3d import Size3D
from src.orbital_mechanics.experiments.new_vector3d import Vector3D, ReferenceFrame
from src.orbital_mechanics.experiments.quantities import meter, Quantity, Dimension, DimensionSymbol


def test_size3d_creation_valid():
    """
    Test creating a valid Size3D instance with positive dimensions.
    """
    dimensions = Vector3D(3.0, 4.0, 5.0, unit=meter, reference_frame=ReferenceFrame.NONE)
    size = Size3D(dimensions=dimensions)

    assert size.dimensions.x == 3.0
    assert size.dimensions.y == 4.0
    assert size.dimensions.z == 5.0
    assert size.dimensions.unit == meter
    assert size.dimensions.reference_frame == ReferenceFrame.NONE
    print("Test `test_size3d_creation_valid` passed.")


def test_size3d_creation_negative_dimension():
    """
    Test that creating a Size3D instance with a negative dimension raises ValueError.
    """
    dimensions = Vector3D(-3.0, 4.0, 5.0, unit=meter, reference_frame=ReferenceFrame.NONE)
    with pytest.raises(ValueError, match="All dimensions must be non-negative."):
        Size3D(dimensions=dimensions)
    print("Test `test_size3d_creation_negative_dimension` passed.")


def test_size3d_creation_incorrect_unit():
    """
    Test that creating a Size3D instance with incorrect units raises ValueError.
    """
    # Assume 'second' is a defined Unit representing time
    from src.orbital_mechanics.experiments.quantities import second
    dimensions = Vector3D(3.0, 4.0, 5.0, unit=second, reference_frame=ReferenceFrame.NONE)
    with pytest.raises(ValueError, match="All dimensions must have units of length."):
        Size3D(dimensions=dimensions)
    print("Test `test_size3d_creation_incorrect_unit` passed.")


def test_size3d_as_array():
    """
    Test the as_array method returns the correct NumPy array in meters.
    """
    dimensions = Vector3D(1.0, 2.0, 3.0, unit=meter, reference_frame=ReferenceFrame.NONE)
    size = Size3D(dimensions=dimensions)

    expected_array = np.array([1.0, 2.0, 3.0])
    assert np.array_equal(size.as_array(), expected_array), "as_array method failed."
    print("Test `test_size3d_as_array` passed.")


def test_size3d_volume():
    """
    Test the volume calculation.
    """
    dimensions = Vector3D(2.0, 3.0, 4.0, unit=meter, reference_frame=ReferenceFrame.NONE)
    size = Size3D(dimensions=dimensions)

    expected_volume = 24.0  # m^3
    computed_volume = size.volume()
    assert computed_volume.value == pytest.approx(expected_volume, rel=1e-9), "Volume calculation failed."
    assert computed_volume.unit == meter ** 3, "Volume unit is incorrect."
    print("Test `test_size3d_volume` passed.")


def test_size3d_surface_area():
    """
    Test the surface area calculation.
    """
    dimensions = Vector3D(2.0, 3.0, 4.0, unit=meter, reference_frame=ReferenceFrame.NONE)
    size = Size3D(dimensions=dimensions)

    expected_surface_area = 52.0  # m^2
    computed_surface_area = size.surface_area()
    assert computed_surface_area.value == pytest.approx(expected_surface_area,
                                                        rel=1e-9), "Surface area calculation failed."
    assert computed_surface_area.unit == meter ** 2, "Surface area unit is incorrect."
    print("Test `test_size3d_surface_area` passed.")


def test_size3d_str_repr():
    """
    Test the __str__ and __repr__ methods.
    """
    dimensions = Vector3D(1.5, 2.5, 3.5, unit=meter, reference_frame=ReferenceFrame.NONE)
    size = Size3D(dimensions=dimensions)

    expected_str = f"Size3D(dimensions={dimensions})"
    expected_repr = f"Size3D(dimensions={repr(dimensions)})"

    assert str(size) == expected_str, "__str__ method failed."
    assert repr(size) == expected_repr, "__repr__ method failed."
    print("Test `test_size3d_str_repr` passed.")


def test_size3d_scale():
    """
    Test the scaling of Size3D dimensions.
    """
    dimensions = Vector3D(1.0, 2.0, 3.0, unit=meter, reference_frame=ReferenceFrame.NONE)
    size = Size3D(dimensions=dimensions)

    scaled_size = size.scale(2.0)
    expected_dimensions = Vector3D(2.0, 4.0, 6.0, unit=meter, reference_frame=ReferenceFrame.NONE)

    assert scaled_size.dimensions.x == expected_dimensions.x
    assert scaled_size.dimensions.y == expected_dimensions.y
    assert scaled_size.dimensions.z == expected_dimensions.z
    print("Test `test_size3d_scale` passed.")


def test_size3d_fits_inside_true():
    """
    Test the fits_inside method where the size fits inside another.
    """
    size1 = Size3D(Vector3D(1.0, 2.0, 3.0, unit=meter, reference_frame=ReferenceFrame.NONE))
    size2 = Size3D(Vector3D(2.0, 3.0, 4.0, unit=meter, reference_frame=ReferenceFrame.NONE))

    assert size1.fits_inside(size2) == True, "fits_inside should return True."
    print("Test `test_size3d_fits_inside_true` passed.")


def test_size3d_fits_inside_false():
    """
    Test the fits_inside method where the size does not fit inside another.
    """
    size1 = Size3D(Vector3D(3.0, 4.0, 5.0, unit=meter, reference_frame=ReferenceFrame.NONE))
    size2 = Size3D(Vector3D(2.0, 3.0, 4.0, unit=meter, reference_frame=ReferenceFrame.NONE))

    assert size1.fits_inside(size2) == False, "fits_inside should return False."
    print("Test `test_size3d_fits_inside_false` passed.")


def test_size3d_fits_inside_edge_case():
    """
    Test the fits_inside method where the size dimensions are exactly equal.
    """
    size1 = Size3D(Vector3D(2.0, 3.0, 4.0, unit=meter, reference_frame=ReferenceFrame.NONE))
    size2 = Size3D(Vector3D(2.0, 3.0, 4.0, unit=meter, reference_frame=ReferenceFrame.NONE))

    assert size1.fits_inside(size2) == True, "fits_inside should return True when dimensions are equal."
    print("Test `test_size3d_fits_inside_edge_case` passed.")


# Example of running all tests
if __name__ == "__main__":
    test_size3d_creation_valid()
    test_size3d_creation_negative_dimension()
    test_size3d_creation_incorrect_unit()
    test_size3d_as_array()
    test_size3d_volume()
    test_size3d_surface_area()
    test_size3d_str_repr()
    test_size3d_scale()
    test_size3d_fits_inside_true()
    test_size3d_fits_inside_false()
    test_size3d_fits_inside_edge_case()
    print("All Size3D tests passed successfully.")
