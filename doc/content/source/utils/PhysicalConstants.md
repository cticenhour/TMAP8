# PhysicalConstants

## Overview

This object lists physical constants to use consistent values across TMAP8. It contains the values listed in [PhysicalConstants_table]. To use these constants in the code, add `#include "PhysicalConstants.h"` at the top of your class and use `PhysicalConstants::<IN_CODE_NAME>`. For example, to use the ideal gas constant, use `PhysicalConstants::ideal_gas_constant`.

!table id=PhysicalConstants_table caption=List of physical constants available in PhysicalConstants.
| Symbol   | In code name              | Description                              | Value            | Units     | Reference                 |
| -------- | ------------------------- | ---------------------------------------- | ---------------- | --------- | ------------------------- |
| $N_a$    | avogadro_number           | Avogadro's number                        | 6.02214076e23    | atoms/mol | [!cite](CODATA2021552941) |
| $k_b$    | boltzmann_constant        | Boltzmann constant                       | 1.380649e-23     | J/K       | [!cite](CODATA2021552941) |
|          | eV_to_J                   | Conversion coefficient from eV to Joules | 1.602176634e-19  | eV/J      | [!cite](CODATA2021552941) |
| $R$      | ideal_gas_constant        | Ideal gas constant                       | 8.31446261815324 | J/K/mol   | [!cite](CODATA2021552941) |
| $\sigma$ | stefan_boltzmann_constant | Stefan-Boltzmann constant                | 5.670374419e-8   | W/m^2/K^4 | [!cite](CODATA2021552941) |
