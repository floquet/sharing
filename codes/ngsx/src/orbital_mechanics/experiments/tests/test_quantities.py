import pytest
from fractions import Fraction
import numpy as np

from src.orbital_mechanics.experiments.new_vector3d import Vector3D, ReferenceFrame
from src.orbital_mechanics.experiments.quantities import DimensionSymbol, Dimension, meter, kilometer, second, \
    meter_per_second, radian, degree, dimensionless, kilometer_per_hour, hour, Quantity, Unit, radian_per_second


def test_dimension_creation():
    # Test creating Dimension objects
    dim_length = Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    assert dim_length.exponents == {DimensionSymbol.LENGTH: Fraction(1)}
    dim_time = Dimension({DimensionSymbol.TIME: Fraction(1)})
    assert dim_time.exponents == {DimensionSymbol.TIME: Fraction(1)}
    dim_dimensionless = Dimension({})
    assert dim_dimensionless.exponents == {}

def test_dimension_operations():
    # Test Dimension multiplication, division, and exponentiation
    dim_length = Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    dim_time = Dimension({DimensionSymbol.TIME: Fraction(1)})
    dim_speed = dim_length / dim_time
    assert dim_speed.exponents == {
        DimensionSymbol.LENGTH: Fraction(1),
        DimensionSymbol.TIME: Fraction(-1)
    }
    dim_acceleration = dim_length / (dim_time ** 2)
    assert dim_acceleration.exponents == {
        DimensionSymbol.LENGTH: Fraction(1),
        DimensionSymbol.TIME: Fraction(-2)
    }
    dim_area = dim_length ** 2
    assert dim_area.exponents == {
        DimensionSymbol.LENGTH: Fraction(2)
    }

def test_dimension_equality():
    # Test Dimension equality
    dim1 = Dimension({DimensionSymbol.LENGTH: Fraction(1), DimensionSymbol.TIME: Fraction(-1)})
    dim2 = Dimension({DimensionSymbol.LENGTH: Fraction(1), DimensionSymbol.TIME: Fraction(-1)})
    assert dim1 == dim2
    dim3 = Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    assert dim1 != dim3

def test_dimension_str():
    # Test string representation of Dimension
    dim = Dimension({DimensionSymbol.LENGTH: Fraction(1), DimensionSymbol.TIME: Fraction(-1)})
    assert str(dim) == 'L * T^-1'
    dim = Dimension({DimensionSymbol.ANGLE: Fraction(1)})
    assert str(dim) == 'Θ'
    dim = Dimension({})
    assert str(dim) == 'dimensionless'

def test_unit_creation():
    # Test creating Unit objects
    assert meter.name == 'm'
    assert meter.factor == 1.0
    assert meter.dimension == Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    assert kilometer.name == 'km'
    assert kilometer.factor == 1000.0
    assert kilometer.dimension == Dimension({DimensionSymbol.LENGTH: Fraction(1)})

def test_unit_operations():
    # Test Unit multiplication, division, and exponentiation
    speed_unit = meter / second
    assert speed_unit.name == 'm/s'
    assert speed_unit.factor == 1.0
    assert speed_unit.dimension == Dimension({
        DimensionSymbol.LENGTH: Fraction(1),
        DimensionSymbol.TIME: Fraction(-1)
    })
    area_unit = meter * meter
    assert area_unit.name == 'm*m'
    assert area_unit.factor == 1.0
    assert area_unit.dimension == Dimension({DimensionSymbol.LENGTH: Fraction(2)})
    volume_unit = meter ** 3
    assert volume_unit.name == 'm**3'
    assert volume_unit.factor == 1.0
    assert volume_unit.dimension == Dimension({DimensionSymbol.LENGTH: Fraction(3)})

def test_unit_is_dimension():
    # Test is_dimension method
    assert meter.is_dimension(Dimension({DimensionSymbol.LENGTH: Fraction(1)}))
    assert not meter.is_dimension(Dimension({DimensionSymbol.TIME: Fraction(1)}))
    assert meter_per_second.is_dimension(Dimension({
        DimensionSymbol.LENGTH: Fraction(1),
        DimensionSymbol.TIME: Fraction(-1)
    }))

def test_unit_has_dimension():
    # Test has_dimension method
    assert meter.has_dimension(DimensionSymbol.LENGTH)
    assert not meter.has_dimension(DimensionSymbol.TIME)
    assert meter_per_second.has_dimension(DimensionSymbol.LENGTH)
    assert meter_per_second.has_dimension(DimensionSymbol.TIME)
    assert not meter_per_second.has_dimension(DimensionSymbol.ANGLE)

def test_unit_is_length():
    # Test is_length method
    assert meter.is_length()
    assert not second.is_length()
    assert not meter_per_second.is_length()

def test_unit_is_angle():
    # Test is_angle method
    assert radian.is_angle()
    assert degree.is_angle()
    assert not meter.is_angle()

def test_unit_is_speed():
    # Test is_speed method
    assert meter_per_second.is_speed()
    assert not meter.is_speed()
    assert not radian_per_second.is_speed()

def test_unit_is_angular_velocity():
    # Test is_angular_velocity method
    assert radian_per_second.is_angular_velocity()
    assert not meter_per_second.is_angular_velocity()
    assert not radian.is_angular_velocity()

def test_unit_is_dimensionless():
    # Test is_dimensionless method
    assert dimensionless.is_dimensionless()
    assert not meter.is_dimensionless()

def test_unit_is_compatible_with():
    # Test is_compatible_with method
    assert meter.is_compatible_with(kilometer)
    assert not meter.is_compatible_with(second)
    assert meter_per_second.is_compatible_with(kilometer_per_hour)
    assert not meter.is_compatible_with(meter_per_second)

def test_unit_conversion_factor_to():
    # Test conversion_factor_to method
    factor = kilometer.conversion_factor_to(meter)
    assert factor == 1000.0
    factor = hour.conversion_factor_to(second)
    assert factor == 3600.0
    with pytest.raises(ValueError):
        meter.conversion_factor_to(second)

def test_quantity_creation():
    # Test creating Quantity objects
    distance = Quantity(100.0, meter)
    assert distance.value == 100.0
    assert distance.unit == meter
    time = Quantity(2.0, second)
    assert time.value == 2.0
    assert time.unit == second

def test_quantity_to():
    # Test unit conversion
    distance_km = Quantity(1.0, kilometer)
    distance_m = distance_km.to(meter)
    assert distance_m.value == 1000.0
    assert distance_m.unit == meter
    angle_deg = Quantity(180.0, degree)
    angle_rad = angle_deg.to(radian)
    assert np.isclose(angle_rad.value, np.pi)
    assert angle_rad.unit == radian
    with pytest.raises(ValueError):
        distance_km.to(second)

def test_quantity_addition():
    # Test addition of quantities with compatible units
    q1 = Quantity(500.0, meter)
    q2 = Quantity(0.5, kilometer)
    q3 = q1 + q2
    assert q3.value == 1000.0
    assert q3.unit == meter
    with pytest.raises(ValueError):
        q1 + Quantity(1.0, second)

def test_quantity_subtraction():
    # Test subtraction of quantities with compatible units
    q1 = Quantity(5.0, hour)
    q2 = Quantity(1800.0, second)
    q3 = q1 - q2.to(hour)
    assert np.isclose(q3.value, 4.5)
    assert q3.unit == hour
    with pytest.raises(ValueError):
        q1 - Quantity(1.0, meter)

def test_quantity_multiplication():
    # Test multiplication of quantities
    q1 = Quantity(5.0, meter)
    q2 = Quantity(2.0, meter)
    q3 = q1 * q2
    assert q3.value == 10.0
    assert q3.unit.dimension == Dimension({DimensionSymbol.LENGTH: Fraction(2)})

def test_quantity_division():
    # Test division of quantities
    q1 = Quantity(10.0, meter)
    q2 = Quantity(2.0, second)
    q3 = q1 / q2
    assert q3.value == 5.0
    assert q3.unit.dimension == Dimension({
        DimensionSymbol.LENGTH: Fraction(1),
        DimensionSymbol.TIME: Fraction(-1)
    })

def test_quantity_negation():
    # Test negation of a quantity
    q = Quantity(10.0, meter)
    q_neg = -q
    assert q_neg.value == -10.0
    assert q_neg.unit == meter

def test_quantity_str():
    # Test string representation of Quantity
    q = Quantity(5.0, meter_per_second)
    assert str(q) == '5.0 m/s'

def test_quantity_multiplication_with_scalar():
    # Test multiplying a Quantity by a scalar
    q = Quantity(10.0, meter)
    q_scaled = q * 2
    assert q_scaled.value == 20.0
    assert q_scaled.unit == meter

def test_quantity_division_by_scalar():
    # Test dividing a Quantity by a scalar
    q = Quantity(10.0, meter)
    q_scaled = q / 2
    assert q_scaled.value == 5.0
    assert q_scaled.unit == meter

def test_quantity_invalid_operations():
    # Test that invalid operations raise appropriate errors
    q1 = Quantity(10.0, meter)
    q2 = Quantity(2.0, second)
    with pytest.raises(ValueError):
        q1 + q2
    with pytest.raises(ValueError):
        q1.to(second)

def test_unit_str():
    # Test string representation of Unit
    assert str(meter) == 'm'
    assert str(meter_per_second) == 'm/s'
    assert str(kilometer_per_hour) == 'km/h'

def test_dimensionless_unit():
    # Test dimensionless unit
    q = Quantity(5.0, dimensionless)
    assert q.unit.is_dimensionless()
    assert str(q) == '5.0 dimensionless'

def test_unit_equality_and_hashing():
    # Test equality and hashing of units
    unit_set = set()
    unit_set.add(meter)
    unit_set.add(kilometer)
    unit_set.add(Unit(
        name='m',
        base_units={'m': Fraction(1)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)}),
    ))
    assert len(unit_set) == 2  # meter and kilometer are different

def test_unit_mul_with_scalar_and_array():
    # Test multiplying a unit with a scalar and a numpy array
    distance = 5 * meter
    assert isinstance(distance, Quantity)
    assert distance.value == 5.0
    assert distance.unit == meter

    array = np.array([1.0, 2.0, 3.0])
    # Assuming Vector3D is properly imported and defined
    # position = meter * array
    # assert isinstance(position, Vector3D)
    # assert position.x == 1.0
    # assert position.y == 2.0
    # assert position.z == 3.0
    # assert position.unit == meter

def test_unit_conversion_with_incompatible_units():
    # Test conversion factor between incompatible units
    with pytest.raises(ValueError):
        meter.conversion_factor_to(second)

def test_quantity_operations_with_dimensionless():
    # Test operations involving dimensionless quantities
    q1 = Quantity(5.0)
    q2 = Quantity(3.0)
    q3 = q1 + q2
    assert q3.value == 8.0
    assert q3.unit.is_dimensionless()
    q4 = q1 * Quantity(2.0, meter)
    assert q4.value == 10.0
    assert q4.unit == meter


def test_unit_multiplication():
    # Test multiplication of units
    area_unit = meter * meter
    assert area_unit.base_units == {'m': Fraction(2)}
    assert area_unit.factor == 1.0
    assert str(area_unit) == 'm*m'


def test_unit_division():
    # Test division of units
    speed_unit = kilometer / hour
    assert speed_unit.base_units == {'m': Fraction(1), 's': Fraction(-1)}
    assert speed_unit.factor == 1000.0 / 3600.0
    assert str(speed_unit) == 'km/h'


def test_unit_exponentiation():
    # Test exponentiation of units
    volume_unit = meter ** 3
    assert volume_unit.base_units == {'m': Fraction(3)}
    assert volume_unit.factor == 1.0
    assert str(volume_unit) == 'm**3'


def test_unit_multiplication_with_number():
    # Test multiplication of unit with a scalar
    distance = 5.01 * meter
    assert isinstance(distance, Quantity)
    assert distance.value == 5.01
    assert distance.unit == meter
    assert str(distance) == '5.01 m'


def test_unit_multiplication_with_array():
    # Test multiplication of unit with ndarray
    array = np.array([1.0, 2.0, 3.0])
    position = meter * array
    assert isinstance(position, Vector3D)
    assert position.x == 1.0
    assert position.y == 2.0
    assert position.z == 3.0
    assert position.unit == meter
    assert position.reference_frame == ReferenceFrame.NONE


def test_quantity_operations():
    # Test addition and subtraction of quantities
    q1 = Quantity(10.0, meter)
    q2 = Quantity(1.0, kilometer)
    q3 = q1 + q2  # Should handle unit conversion
    assert q3.value == 1010.0
    assert q3.unit == meter

    q4 = q2 - q1  # Should handle unit conversion
    assert q4.value == 0.99
    assert q4.unit == kilometer


def test_unit_simplification():
    from fractions import Fraction

    # Define some base units
    meter = Unit(
        name="m",
        base_units={"m": Fraction(1)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    )

    second = Unit(
        name="s",
        base_units={"s": Fraction(1)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.TIME: Fraction(1)})
    )

    # Create a unit representing meters per second
    meter_per_second = meter / second
    assert str(meter_per_second) == 'm/s'

    times_second = second * meter_per_second
    simplified = times_second.simplify()
    assert simplified == meter

def test_more_complex_unit_simplification():
    from fractions import Fraction

    # Define some base units
    meter = Unit(
        name="m",
        base_units={"m": Fraction(1)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    )

    second = Unit(
        name="s",
        base_units={"s": Fraction(1)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.TIME: Fraction(1)})
    )

    kilometer = Unit(
        name="km",
        base_units={"m": Fraction(1)},
        factor=1000.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    )

    hour = Unit(
        name="h",
        base_units={"s": Fraction(1)},
        factor=3600.0,
        dimension=Dimension({DimensionSymbol.TIME: Fraction(1)})
    )

    # Create a unit representing kilometers per hour
    kilometer_per_hour = kilometer / hour
    assert str(kilometer_per_hour) == 'km/h'

    times_second = second * kilometer_per_hour
    simplified = times_second.simplify()

    expected_unit = Unit(
        name="km/3600",
        base_units={"m": Fraction(1)},
        factor=1000.0 / 3600.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    )
    assert simplified == expected_unit, f"Expected {expected_unit}, got {simplified}"

    times_hour = hour * kilometer_per_hour
    simplified = times_hour.simplify()
    assert simplified == kilometer


def test_exponent_unit_simplification():
    from fractions import Fraction

    # Define base units
    meter = Unit(
        name="m",
        base_units={"m": Fraction(1)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)})
    )

    second = Unit(
        name="s",
        base_units={"s": Fraction(1)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.TIME: Fraction(1)})
    )

    # Exponentiation with a positive integer exponent
    square_meter = meter ** 2
    simplified_square_meter = square_meter.simplify()
    expected_square_meter = Unit(
        name="m**2",
        base_units={"m": Fraction(2)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(2)})
    )
    assert simplified_square_meter == expected_square_meter, f"Expected {expected_square_meter}, got {simplified_square_meter}"

    # Exponentiation with a negative integer exponent
    per_meter = meter ** -1
    simplified_per_meter = per_meter.simplify()
    expected_per_meter = Unit(
        name="1/m",
        base_units={"m": Fraction(-1)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(-1)})
    )
    assert simplified_per_meter == expected_per_meter, f"Expected {expected_per_meter}, got {simplified_per_meter}"

    # Exponentiation with a fractional exponent (square root)
    root_meter = meter ** Fraction(1, 2)
    simplified_root_meter = root_meter.simplify()
    expected_root_meter = Unit(
        name="m**1/2",
        base_units={"m": Fraction(1, 2)},
        factor=1.0,
        dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1, 2)})
    )
    assert simplified_root_meter == expected_root_meter, f"Expected {expected_root_meter}, got {simplified_root_meter}"

    # Exponentiation with fractional exponent resulting in whole exponent after simplification
    # Example: (m^2)^(1/2) = m
    square_root_of_square_meter = square_meter ** Fraction(1, 2)
    simplified_result = square_root_of_square_meter.simplify()
    assert simplified_result == meter, f"Expected {meter}, got {simplified_result}"

    # Combined exponentiation and multiplication
    acceleration = meter / (second ** 2)
    simplified_acceleration = acceleration.simplify()
    expected_acceleration = Unit(
        name="(m)/(s**2)",
        base_units={"m": Fraction(1), "s": Fraction(-2)},
        factor=1.0,
        dimension=Dimension({
            DimensionSymbol.LENGTH: Fraction(1),
            DimensionSymbol.TIME: Fraction(-2)
        })
    )
    assert simplified_acceleration == expected_acceleration, f"Expected {expected_acceleration}, got {simplified_acceleration}"


def test_unit_conversion():
    length_in_meters = Quantity(1000.0, meter)
    length_in_kilometers = length_in_meters.to(kilometer)
    assert length_in_kilometers.value == pytest.approx(1.0, rel=1e-6)


def test_complex_unit_conversion():
    # Define units
    km = Unit('km', {'m': Fraction(1)}, factor=1000.0, dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)}))
    m = Unit('m', {'m': Fraction(1)}, factor=1.0, dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)}))
    s = Unit('s', {'s': Fraction(1)}, factor=1.0, dimension=Dimension({DimensionSymbol.TIME: Fraction(1)}))

    # Define complex units
    km3_per_s2 = (km ** 3) / (s ** 2)
    m3_per_s2 = (m ** 3) / (s ** 2)

    # Create Quantity
    mu_km = Quantity(398600.4418, km3_per_s2)

    # Convert to m^3/s^2
    mu_m = mu_km.to(m3_per_s2)

    # Expected value
    expected_mu_m_value = 398600.4418 * 1e9  # Since 1 km^3 = 1e9 m^3

    assert mu_m.value == expected_mu_m_value, "Conversion factor incorrect for complex units."
    print(f"mu in m^3/s^2: {mu_m.value}")


def test_km_s_to_m_s():
    # Define units
    km = Unit('km', {'m': Fraction(1)}, factor=1000.0, dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)}))
    m = Unit('m', {'m': Fraction(1)}, factor=1.0, dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)}))
    s = Unit('s', {'s': Fraction(1)}, factor=1.0, dimension=Dimension({DimensionSymbol.TIME: Fraction(1)}))

    # Define complex units
    km_per_s = km / s
    m_per_s = m / s

    # Create Quantity
    speed_km_s = Quantity(7.5, km_per_s)

    # Convert to m/s
    speed_m_s = speed_km_s.to(m_per_s)

    # Expected value
    expected_speed_m_s_value = 7.5 * 1000.0  # Since 1 km = 1000 m

    actual_converted = speed_km_s.to(m_per_s)

    assert actual_converted.value == expected_speed_m_s_value, "Conversion factor incorrect for complex units."
    print(f"Speed in m/s: {speed_m_s.value}")
