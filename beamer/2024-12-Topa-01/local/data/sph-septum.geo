Hemi Sphere, air diel

&MM_MOM
  bUseACA = .TRUE.,
  bSolve_ACA = .FALSE.,
  bOutOfCore = .FALSE.,
  bNormalizeToWaveLength = .TRUE.,
  bNormalize             = .FALSE.,
  dCloseLambda  = 0.100000,
  ACA_Factor_Tol = 0.000010,
  ACA_RHS_Tol = 0.000100,
  Point_Tolerance = 0.001000,
  Lop_Admissibility = WEAK,
  Kop_Admissibility = CLOSE
/ 

FREQUENCY
  ghz
  0.300000  0.000000  1

Excitation
  MONOSTATIC

Angle Cut
  1
  0.000000  360.000000  361
  AZIMUTH
  90.000000

Boundary Conditions
Mat.lib
2
R_Free_Space => Free_Space
R_PEC => PEC
3
1 BC_PEC R_PEC R_Free_Space
2 BC_PEC R_PEC R_Free_Space
3 BC_PEC R_PEC R_Free_Space

Geometry Type and Data
FACET
meters
sph_septum.facet
