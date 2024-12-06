! 3456789 123456789 223456789 323456789 423456789 523456789 623456789 723456789 823456789 923456789 023456789 123456789 223456789 32
! Library of Satellite Models

module mLibSatelliteModels
    use mClassSatellite,                only : satellite, baseSatellite
    use mPrecisionDefinitions,          only : rp

    implicit none

    ! Moons of Neptune.
    ! Thalassa, Despina, Galatea, Larissa, and Proteus are inner moons,
    ! Triton is Neptune's largest moon with a retrograde orbit,
    ! and Nereid, Halimede, Sao, Laomedeia, Psamathe, and Neso are irregular outer moons
    type ( satellite ) :: despina0, galatea0, halimede0, hippocamp0, laomedeia0, larissa0, nereid0, &
                          neso0, proteus0, psamathe0, sao0, thalassa0, triton0

contains

    ! templates
    subroutine initialize_satellites ( )
        thalassa0 = baseSatellite
        call Thalassa0 % set_satellite_parameters ( moniker = "Thalassa-Class", model = "Thalassa", &
                                                    mass_metal = 1000.0_rp, mass_fuel = 2000.0_rp, color = 3 )

        despina0 = baseSatellite
        call Despina0 % set_satellite_parameters ( moniker = "Despina-Class", model = "Despina", &
                                                   mass_metal = 1200.0_rp, mass_fuel = 2500.0_rp, color = 2 )

        psamathe0 = baseSatellite
        call psamathe0 % set_satellite_parameters ( moniker = "Psamathe-Class", model = "Psamathe", &
                                                   mass_metal = 1200.0_rp, mass_fuel = 2500.0_rp, color = 1 )
        
    end subroutine initialize_satellites

end module mLibSatelliteModels
