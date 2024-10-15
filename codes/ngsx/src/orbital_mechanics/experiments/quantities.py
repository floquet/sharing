from dataclasses import dataclass, field
from fractions import Fraction
from typing import Dict, Union

import numpy as np


from enum import Enum, StrEnum


class DimensionSymbol(StrEnum):
    LENGTH = 'L'
    MASS = 'M'
    TIME = 'T'
    ANGLE = 'Θ'  # Using capital theta for angle
    ELECTRIC_CURRENT = 'I'
    TEMPERATURE = 'Θ_T'  # Distinguish from angle
    AMOUNT_OF_SUBSTANCE = 'N'
    LUMINOUS_INTENSITY = 'J'
    # We'll add other dimensions as needed



@dataclass(frozen=True)
class Dimension:
    exponents: Dict[DimensionSymbol, Fraction]

    def __mul__(self, other: 'Dimension') -> 'Dimension':
        new_exponents = self.exponents.copy()
        for dim, exponent in other.exponents.items():
            new_exponents[dim] = new_exponents.get(dim, Fraction(0)) + exponent
        return Dimension(new_exponents)

    def __truediv__(self, other: 'Dimension') -> 'Dimension':
        new_exponents = self.exponents.copy()
        for dim, exponent in other.exponents.items():
            new_exponents[dim] = new_exponents.get(dim, Fraction(0)) - exponent
        return Dimension(new_exponents)

    def __pow__(self, power: int) -> 'Dimension':
        new_exponents = {dim: exponent * power for dim, exponent in self.exponents.items()}
        return Dimension(new_exponents)

    def __eq__(self, other: 'Dimension') -> bool:
        # Remove zero exponents for comparison
        exponents_self = {k: v for k, v in self.exponents.items() if v != 0}
        exponents_other = {k: v for k, v in other.exponents.items() if v != 0}
        return exponents_self == exponents_other

    def __str__(self) -> str:
        parts = []
        for dim, exponent in self.exponents.items():
            if exponent != 0:
                if exponent == 1:
                    parts.append(dim.value)
                else:
                    parts.append(f"{dim.value}^{exponent}")
        return " * ".join(parts) if parts else "dimensionless"

    def __hash__(self):
        return hash(frozenset(self.exponents.items()))



@dataclass(frozen=True)
class Unit:
    name: str
    base_units: Dict[str, Fraction] = field(default_factory=dict)
    factor: float = 1.0
    dimension: Dimension = Dimension({})
    # Other fields and methods remain the same

    def __mul__(self, other: Union['Unit', float, int, np.ndarray]) -> Union['Unit', 'Quantity', 'Vector3D']:
        if isinstance(other, Unit):
            new_base_units = self.base_units.copy()
            for unit_symbol, exponent in other.base_units.items():
                new_base_units[unit_symbol] = new_base_units.get(unit_symbol, Fraction(0)) + exponent
            new_dimension = self.dimension * other.dimension
            new_unit_name = f"{self.name}*{other.name}"
            return Unit(name=new_unit_name, base_units=new_base_units, factor=self.factor * other.factor,
                        dimension=new_dimension)
        elif isinstance(other, (float, int)):
            return Quantity(other, self)  # <-- Remove multiplication by self.factor
        elif isinstance(other, np.ndarray) and other.shape == (3,):
            from src.orbital_mechanics.experiments.new_vector3d import Vector3D
            from src.orbital_mechanics.experiments.new_vector3d import ReferenceFrame
            vals = tuple(other)
            return Vector3D(
                x=vals[0],
                y=vals[1],
                z=vals[2],
                unit=self,
                reference_frame=ReferenceFrame.NONE
            )
        else:
            raise TypeError("Unsupported multiplication type with Unit.")

    def __rmul__(self, other: Union[float, int, np.ndarray]) -> Union['Quantity', 'Vector3D']:
        return self.__mul__(other)

    def __truediv__(self, other: 'Unit') -> 'Unit':
        if isinstance(other, Unit):
            new_base_units = self.base_units.copy()
            for unit_symbol, exponent in other.base_units.items():
                new_base_units[unit_symbol] = new_base_units.get(unit_symbol, Fraction(0)) - exponent
            new_dimension = self.dimension / other.dimension
            new_unit_name = f"{self.name}/{other.name}"
            return Unit(new_unit_name, base_units=new_base_units, factor=self.factor / other.factor, dimension=new_dimension)
        else:
            raise TypeError("Unit division only supports division by another Unit.")

    def __pow__(self, power: Union[int, float, Fraction]) -> 'Unit':
        if not isinstance(power, (int, float, Fraction)):
            raise TypeError("Power must be an integer or a Fraction.")

        new_base_units = {unit_symbol: exponent * power for unit_symbol, exponent in self.base_units.items()}
        new_dimension = self.dimension ** power
        new_factor = self.factor ** float(power)
        new_unit_name = f"{self.name}**{power}"

        return Unit(
            name=new_unit_name,
            base_units=new_base_units,
            factor=new_factor,
            dimension=new_dimension
        )

    def is_dimension(self, dimension: Dimension) -> bool:
        return self.dimension == dimension

    def has_dimension(self, dimension_symbol: DimensionSymbol) -> bool:
        return dimension_symbol in self.dimension.exponents and self.dimension.exponents[dimension_symbol] != 0

    def is_compatible_with(self, other: 'Unit') -> bool:
        return self.dimension == other.dimension

    def conversion_factor_to(self, other: 'Unit') -> float:
        if not self.is_compatible_with(other):
            raise ValueError(f"Units {self} and {other} are not compatible.")

        factor_ratio = self.factor / other.factor
        return factor_ratio

    def is_length(self) -> bool:
        return self.dimension == Dimension({DimensionSymbol.LENGTH: Fraction(1)})

    def is_angle(self) -> bool:
        return self.dimension == Dimension({DimensionSymbol.ANGLE: Fraction(1)})

    def is_speed(self) -> bool:
        expected_dimension = Dimension({
            DimensionSymbol.LENGTH: Fraction(1),
            DimensionSymbol.TIME: Fraction(-1)
        })
        return self.dimension == expected_dimension

    def is_angular_velocity(self) -> bool:
        expected_dimension = Dimension({
            DimensionSymbol.ANGLE: Fraction(1),
            DimensionSymbol.TIME: Fraction(-1)
        })
        return self.dimension == expected_dimension

    def is_dimensionless(self) -> bool:
        return len(self.dimension.exponents) == 0 or all(
            exponent == 0 for exponent in self.dimension.exponents.values())

    def __str__(self):
        if self.name:
            return self.name
        else:
            # Build the unit string from base units and exponents

            numerator = []
            denominator = []
            for unit, exponent in self.base_units.items():
                if exponent > 0:
                    if exponent == 1:
                        numerator.append(f"{unit}")
                    else:
                        numerator.append(f"{unit}**{exponent}")
                elif exponent < 0:
                    if exponent == -1:
                        denominator.append(f"{unit}")
                    else:
                        denominator.append(f"{unit}**{-exponent}")
            num_str = '*'.join(numerator) if numerator else '1'
            denom_str = '*'.join(denominator)
            if denom_str:
                return f"({num_str})/({denom_str})"
            else:
                return num_str

    def __eq__(self, other: 'Unit') -> bool:
        return self.base_units == other.base_units and self.factor == other.factor


    def simplify(self, unit_registry: Dict[str, 'Unit'] = None) -> 'Unit':
        """
        Simplify the unit by canceling out units in the numerator and denominator.
        Adjusts the factor based on the units being canceled.

        :param unit_registry: A dictionary mapping unit symbols to Unit instances.
                              This is used to resolve derived units to base units.
        :return: A new simplified Unit instance.
        """
        if unit_registry is None:
            unit_registry = {}

        simplified_base_units = {}
        total_factor = self.factor
        simplified_dimension_exponents = {}

        for unit_symbol, exponent in self.base_units.items():
            # Resolve the unit to its base units if it's a derived unit
            if unit_symbol in unit_registry:
                base_unit = unit_registry[unit_symbol]
                total_factor *= base_unit.factor ** exponent
                for base_symbol, base_exponent in base_unit.base_units.items():
                    simplified_base_units[base_symbol] = simplified_base_units.get(base_symbol, Fraction(
                        0)) + base_exponent * exponent
            else:
                # It's a base unit
                simplified_base_units[unit_symbol] = simplified_base_units.get(unit_symbol, Fraction(0)) + exponent
                # Adjust the dimension
                for dim_symbol, dim_exponent in self.dimension.exponents.items():
                    simplified_dimension_exponents[dim_symbol] = simplified_dimension_exponents.get(dim_symbol,
                                                                                                    Fraction(
                                                                                                        0)) + dim_exponent * exponent

        # Remove units with zero exponent
        simplified_base_units = {u: e for u, e in simplified_base_units.items() if e != 0}
        simplified_dimension_exponents = {d: e for d, e in simplified_dimension_exponents.items() if e != 0}

        # Generate the simplified unit name
        numerator = []
        denominator = []
        for unit, exponent in simplified_base_units.items():
            if exponent > 0:
                if exponent == 1:
                    numerator.append(f"{unit}")
                else:
                    numerator.append(f"{unit}**{exponent}")
            elif exponent < 0:
                if exponent == -1:
                    denominator.append(f"{unit}")
                else:
                    denominator.append(f"{unit}**{-exponent}")
        num_str = '*'.join(numerator) if numerator else '1'
        denom_str = '*'.join(denominator)
        if denom_str:
            simplified_name = f"({num_str})/({denom_str})"
        else:
            simplified_name = num_str

        # Create the simplified Dimension
        simplified_dimension = Dimension(simplified_dimension_exponents)

        return Unit(
            name=simplified_name,
            base_units=simplified_base_units,
            factor=total_factor,
            dimension=simplified_dimension
        )

    def __hash__(self):
        base_units_frozenset = frozenset(self.base_units.items())
        dimension_hash = hash(self.dimension)

        return hash((base_units_frozenset, self.factor, dimension_hash))


dimensionless = Unit('dimensionless', {}, 1.0)

# Length units
meter = Unit(
    name='m',
    base_units={'m': Fraction(1)},
    factor=1.0,
    dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)}),
)

kilometer = Unit(
    name='km',
    base_units={'m': Fraction(1)},
    factor=1000.0,
    dimension=Dimension({DimensionSymbol.LENGTH: Fraction(1)}),
)

# Time units
second = Unit(
    name='s',
    base_units={'s': Fraction(1)},
    factor=1.0,
    dimension=Dimension({DimensionSymbol.TIME: Fraction(1)}),
)

hour = Unit(
    name='h',
    base_units={'s': Fraction(1)},
    factor=3600.0,
    dimension=Dimension({DimensionSymbol.TIME: Fraction(1)}),
)

# Angle units
radian = Unit(
    name='rad',
    base_units={'rad': Fraction(1)},
    factor=1.0,
    dimension=Dimension({DimensionSymbol.ANGLE: Fraction(1)}),
)

degree = Unit(
    name='deg',
    base_units={'rad': Fraction(1)},
    factor=np.pi / 180.0,
    dimension=Dimension({DimensionSymbol.ANGLE: Fraction(1)}),
)

# Derived units

meter_per_second = meter / second
kilometer_per_hour = kilometer / hour
radian_per_second = radian / second



@dataclass(frozen=True)
class Quantity:
    value: float
    unit: Unit = dimensionless

    def to(self, target_unit: Unit) -> 'Quantity':
        if not self.unit.dimension == target_unit.dimension:
            raise ValueError(f"Cannot convert from {self.unit.dimension} to {target_unit.dimension}")
        factor = self.unit.conversion_factor_to(target_unit)
        converted_value = self.value * factor
        return Quantity(converted_value, target_unit)

    def __add__(self, other: 'Quantity') -> 'Quantity':
        if not self.unit.is_compatible_with(other.unit):
            raise ValueError(f"Cannot add quantities with units {self.unit} and {other.unit}.")
        other_converted = other.to(self.unit)
        return Quantity(self.value + other_converted.value, self.unit)

    def __sub__(self, other: 'Quantity') -> 'Quantity':
        if not self.unit.is_compatible_with(other.unit):
            raise ValueError(f"Cannot subtract quantities with units {self.unit} and {other.unit}.")
        other_converted = other.to(self.unit)
        return Quantity(self.value - other_converted.value, self.unit)

    def __mul__(self, other: Union['Quantity', float, int]) -> 'Quantity':
        if isinstance(other, Quantity):
            new_unit = self.unit * other.unit
            return Quantity(self.value * other.value, new_unit)
        elif isinstance(other, (float, int)):
            return Quantity(self.value * other, self.unit)
        else:
            raise TypeError("Unsupported multiplication type with Quantity.")

    def __rmul__(self, other: Union[float, int]) -> 'Quantity':
        return self.__mul__(other)

    def __truediv__(self, other: Union['Quantity', float, int]) -> 'Quantity':
        if isinstance(other, Quantity):
            new_unit = self.unit / other.unit
            return Quantity(self.value / other.value, new_unit)
        elif isinstance(other, (float, int)):
            return Quantity(self.value / other, self.unit)
        else:
            raise TypeError("Unsupported division type with Quantity.")

    def __pow__(self, exponent: Union[int, float, 'Quantity']) -> 'Quantity':
        if isinstance(exponent, Quantity):
            if not exponent.unit.is_dimensionless():
                raise ValueError("Exponent must be dimensionless.")
            new_unit = self.unit ** exponent.value
            return Quantity(self.value ** exponent.value, new_unit)
        elif isinstance(exponent, (int, float)):
            return Quantity(self.value ** exponent, self.unit ** exponent)
        else:
            raise TypeError("Unsupported exponent type with Quantity.")

    def __neg__(self):
        return Quantity(-self.value, self.unit)

    def __str__(self):
        return f"{self.value} {self.unit}"

    def __repr__(self):
        return f"Quantity({self.value}, {self.unit})"

    def __hash__(self):
        return hash((self.value, self.unit))


