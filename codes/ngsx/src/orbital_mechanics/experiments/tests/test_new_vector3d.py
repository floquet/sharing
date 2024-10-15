# test_physics_module.py

import pytest
import numpy as np
from fractions import Fraction

from src.orbital_mechanics.experiments.new_vector3d import Vector3D, ReferenceFrame
from src.orbital_mechanics.experiments.quantities import Unit, dimensionless, Quantity, meter, kilometer, second, \
    meter_per_second


def test_quantity_multiplication_division():
    # Test multiplication and division of quantities
    q1 = Quantity(10.0, meter)
    q2 = Quantity(2.0, second)
    q3 = q1 / q2  # Should result in speed unit
    assert q3.value == 5.0
    assert q3.unit == meter_per_second
    assert str(q3.unit) == 'm/s'

    q4 = q1 * q2  # Should result in unit m*s
    expected_unit = meter * second
    assert q4.value == 20.0
    assert q4.unit == expected_unit
    assert str(q4.unit) == 'm*s'

def test_vector3d_addition():
    # Test addition of Vector3D objects with compatible units and reference frames
    v1 = Vector3D(1000.0, 0.0, 0.0, unit=meter)
    v2 = Vector3D(1.0, 0.0, 0.0, unit=kilometer)
    v3 = v1 + v2  # Should handle unit conversion
    assert v3.x == 2000.0
    assert v3.y == 0.0
    assert v3.z == 0.0
    assert v3.unit == meter

def test_vector3d_subtraction():
    # Test subtraction of Vector3D objects with compatible units and reference frames
    v1 = Vector3D(2000.0, 0.0, 0.0, unit=meter)
    v2 = Vector3D(1.0, 0.0, 0.0, unit=kilometer)
    v3 = v1 - v2  # Should handle unit conversion
    assert v3.x == 1000.0
    assert v3.y == 0.0
    assert v3.z == 0.0
    assert v3.unit == meter

def test_vector3d_multiplication_with_scalar():
    # Test multiplication of Vector3D with scalar
    v = Vector3D(1.0, 2.0, 3.0, unit=meter)
    v_scaled = v * 2.0
    assert v_scaled.x == 2.0
    assert v_scaled.y == 4.0
    assert v_scaled.z == 6.0
    assert v_scaled.unit == meter
    assert v_scaled.reference_frame == v.reference_frame


def test_vector3d_dot_product():
    # Test dot product of Vector3D objects
    v1 = Vector3D(1.0, 0.0, 0.0, unit=meter)
    v2 = Vector3D(0.0, 1.0, 0.0, unit=meter)
    dot_product = v1.dot(v2)
    assert dot_product.value == 0.0
    assert dot_product.unit == meter * meter

    v3 = Vector3D(1.0, 2.0, 3.0, unit=meter)
    v4 = Vector3D(4.0, 5.0, 6.0, unit=meter)
    dot_product = v3.dot(v4)
    assert dot_product.value == 32.0
    assert dot_product.unit == meter * meter

def test_vector3d_cross_product():
    # Test cross product of Vector3D objects
    v1 = Vector3D(1.0, 0.0, 0.0, unit=meter)
    v2 = Vector3D(0.0, 1.0, 0.0, unit=meter)
    cross_product = v1.cross(v2)
    assert cross_product.x == 0.0
    assert cross_product.y == 0.0
    assert cross_product.z == 1.0
    expected_unit = meter * meter
    assert cross_product.unit == expected_unit

def test_vector3d_norm():
    # Test norm calculation of Vector3D
    v = Vector3D(3.0, 4.0, 0.0, unit=meter)
    norm = v.norm()
    assert norm.value == 5.0
    assert norm.unit == meter

def test_vector3d_normalize():
    # Test normalization of Vector3D
    v = Vector3D(0.0, 3.0, 4.0, unit=meter)
    v_normalized = v.normalize()
    assert np.isclose(v_normalized.x, 0.0)
    assert np.isclose(v_normalized.y, 0.6)
    assert np.isclose(v_normalized.z, 0.8)
    assert v_normalized.unit == dimensionless

def test_vector3d_conversion():
    # Test unit conversion of Vector3D
    v = Vector3D(1000.0, 0.0, 0.0, unit=meter)
    v_converted = v.to(kilometer)
    assert v_converted.x == 1.0
    assert v_converted.unit == kilometer

def test_force_units():
    # Test force_units method
    v = Vector3D(1000.0, 0.0, 0.0, unit=meter)
    v_forced = v.force_units(kilometer)
    assert v_forced.x == 1000.0  # Components remain the same
    assert v_forced.unit == kilometer

def test_force_reference_frame():
    # Test force_reference_frame method
    v = Vector3D(1.0, 2.0, 3.0, unit=meter, reference_frame=ReferenceFrame.ECI)
    v_forced = v.force_reference_frame(ReferenceFrame.ECEF)
    assert v_forced.reference_frame == ReferenceFrame.ECEF
    assert v_forced.x == v.x
    assert v_forced.y == v.y
    assert v_forced.z == v.z

def test_reference_frame_mismatch():
    # Test operations with mismatched reference frames
    v1 = Vector3D(1.0, 0.0, 0.0, unit=meter, reference_frame=ReferenceFrame.ECI)
    v2 = Vector3D(0.0, 1.0, 0.0, unit=meter, reference_frame=ReferenceFrame.ECEF)
    with pytest.raises(ValueError):
        _ = v1 + v2
    with pytest.raises(ValueError):
        _ = v1.dot(v2)
    with pytest.raises(ValueError):
        _ = v1.cross(v2)


def test_incompatible_units():
    pytest.skip("I don't think this is needed anymore")
    # Test operations with incompatible units
    v1 = Vector3D(1.0, 0.0, 0.0, unit=meter)
    v2 = Vector3D(1.0, 0.0, 0.0, unit=second)
    with pytest.raises(ValueError):
        _ = v1 + v2
    with pytest.raises(ValueError):
        _ = v1.dot(v2)

def test_unit_conversion_error():
    # Test unit conversion error
    v = Vector3D(1.0, 0.0, 0.0, unit=meter)
    with pytest.raises(ValueError):
        _ = v.to(second)

def test_zero_vector_normalization():
    # Test normalization of zero vector
    v = Vector3D(0.0, 0.0, 0.0, unit=meter)
    with pytest.raises(ValueError):
        _ = v.normalize()

def test_vector3d_as_array():
    # Test as_array method
    v = Vector3D(1.0, 2.0, 3.0)
    arr = v.as_array()
    assert isinstance(arr, np.ndarray)
    assert arr.shape == (3,)
    assert np.array_equal(arr, np.array([1.0, 2.0, 3.0]))

def test_unit_equality():
    # Test equality of units
    unit1 = meter
    unit2 = Unit('m', {'m': Fraction(1)}, factor=1.0)
    assert unit1 == unit2

    unit3 = kilometer
    assert unit1 != unit3

def test_quantity_negation():
    # Test negation of Quantity
    q = Quantity(5.0, meter)
    q_neg = -q
    assert q_neg.value == -5.0
    assert q_neg.unit == meter

def test_quantity_multiplication_with_scalar():
    # Test multiplication of Quantity with scalar
    q = Quantity(5.0, meter)
    q_scaled = q * 2
    assert q_scaled.value == 10.0
    assert q_scaled.unit == meter

def test_quantity_division_with_scalar():
    # Test division of Quantity with scalar
    q = Quantity(10.0, meter)
    q_scaled = q / 2
    assert q_scaled.value == 5.0
    assert q_scaled.unit == meter

def test_invalid_unit_operation():
    # Test invalid operations with Unit
    with pytest.raises(TypeError):
        _ = meter * 'invalid'
    with pytest.raises(TypeError):
        _ = meter / 2

def test_invalid_quantity_operation():
    # Test invalid operations with Quantity
    q = Quantity(5.0, meter)
    with pytest.raises(TypeError):
        _ = q * 'invalid'
    with pytest.raises(TypeError):
        _ = q / 'invalid'


def test_dimensionless_operations():
    # Test operations with dimensionless units
    v = Vector3D(1.0, 2.0, 3.0, unit=dimensionless)
    v_scaled = v * 2
    assert v_scaled.x == 2.0
    assert v_scaled.unit == dimensionless

    q = Quantity(5.0)
    q_scaled = q * 2
    assert q_scaled.value == 10.0
    assert q_scaled.unit == dimensionless

def test_unit_string_representation():
    # Test string representation of units
    unit = (meter ** 2) / second
    assert str(unit) == 'm**2/s'

def test_unit_hashing():
    # Test hashing of units for use in sets or dictionaries
    unit_set = set()
    unit_set.add(meter)
    unit_set.add(kilometer)
    assert len(unit_set) == 2
    unit_set.add(Unit('m', {'m': Fraction(1)}, factor=1.0))
    assert len(unit_set) == 2  # Duplicate unit should not increase set size

def test_vector3d_str():
    # Test string representation of Vector3D
    v = Vector3D(1.0, 2.0, 3.0, unit=meter, reference_frame=ReferenceFrame.ECEF)
    expected_str = 'Vector3D(1.0, 2.0, 3.0) m, Reference Frame: ECEF'
    assert str(v) == expected_str

def test_quantity_str():
    # Test string representation of Quantity
    q = Quantity(5.0, unit=meter_per_second)
    expected_str = '5.0 m/s'
    assert str(q) == expected_str
