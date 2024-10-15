from datetime import datetime, timezone

from src.orbital_mechanics.experiments.new_state_vector import StateVector
from src.orbital_mechanics.experiments.new_classic_orbital_elements import ClassicalOrbitalElements
from src.orbital_mechanics.experiments.quantities import kilometer, degree


def test_print_from_coe():
    epoch = datetime(2022, 1, 1, 0, 0, 0, tzinfo=timezone.utc)
    a = 36127.55012131963  * kilometer  # Semimajor axis (km)
    e = 0.8328542764449516  # Eccentricity (dimensionless)
    i = 87.86912617702644  * degree  # Inclination (degrees)
    Ω = 227.8982603572737  * degree  # Right Ascension of Ascending Node (degrees)
    ω = 53.38500680552308  * degree  # Argument of Perigee (degrees)
    v = 92.33508057507403  * degree  # True Anomaly (degrees)

    coe = ClassicalOrbitalElements(
        semimajor_axis=a,
        eccentricity=e,
        inclination=i,
        right_ascension_of_ascending_node=Ω,
        argument_of_perigee=ω,
        true_anomaly=v
    )

    sv = StateVector.from_coe(coe, epoch)
    sv_str = str(sv)
    print(sv_str)

    as_json = sv.as_json()
    print(as_json)

