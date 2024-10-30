# This input file re-creates the deuterium-tritium fuel cycle model
# described by Abdou et al (2021).
# "Physics and technology considerations for the deuterium-tritium fuel cycle
#   and conditions for tritium fuel self sufficiency" M Abdou & M Riva & A Ying
#   & C Day & A Loarte & L R Baylor & P Humrickhouse & T F Fuerst & S Cho
#   Nucl. Fusion 61 (2021) https://doi.org/10.1088/1741-4326/abbf35

# The mesh is completely ignored, but TMAP/MOOSE will complain without it. If high-fidelity
# models of specific components are required, the scalar variables can be coupled to
# "Field" variables which can vary spatially across the mesh, or could be co-ordinated
# with sub-apps.

[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 1
  nx = 1
[]

# One variable for each inventory of tritium is generated. All variables
# are defined as "SCALAR", meaning that they are a single value and are
# disconnected from any specific geometry

[Variables]
  [T_01_BZ]
    family = SCALAR
  []
  [T_02_TES]
    family = SCALAR
  []
  [T_03_FW]
    family = SCALAR
  []
  [T_04_DIV]
    family = SCALAR
  []
  [T_05_HX]
    family = SCALAR
  []
  [T_06_CPS]
    family = SCALAR
  []
  [T_07_vacuum]
    family = SCALAR
  []
  [T_08_FCU]
    family = SCALAR
  []
  [T_09_ISS]
    family = SCALAR
  []
  [T_10_exhaust]
    family = SCALAR
  []
  [T_11_storage]
    family = SCALAR
    initial_condition = 225.4215
  []
[]

# Tritium burn fraction is going to be small. Much
# will be lost to the scrape-off-layer (SOL) and
# recycled.

# TES - tritium extraction system pulls tritium from
# the blanket

# CPS - Coolant purification system pulls tritium from
# the coolant

# An ODE is defined in TMAP8 such that all of the terms must
# be on the left hand side. The terms can be split
# across multiple "ScalarKernels", which are additive,
# so that we have one ODETimeDerivative for each tritium
# inventory and a ParsedODEKernel for the rest of the
# terms. These equations should reflect those described
# in Appendix A of the paper (A.1-A.13), with negation
# on the ParsedODEKernels due to moving the terms to the
# left hand side.


[ScalarKernels]
  [I1t]
    type = ODETimeDerivative
    variable = T_01_BZ
  []
  [I2t]
    type = ODETimeDerivative
    variable = T_02_TES
  []
  [I3t]
    type = ODETimeDerivative
    variable = T_03_FW
  []
  [I4t]
    type = ODETimeDerivative
    variable = T_04_DIV
  []
  [I5t]
    type = ODETimeDerivative
    variable = T_05_HX
  []
  [I6t]
    type = ODETimeDerivative
    variable = T_06_CPS
  []
  [I7t]
    type = ODETimeDerivative
    variable = T_07_vacuum
  []
  [I8t]
    type = ODETimeDerivative
    variable = T_08_FCU
  []
  [I9t]
    type = ODETimeDerivative
    variable = T_09_ISS
  []
  [I10t]
    type = ODETimeDerivative
    variable = T_10_exhaust
  []
  [I11t]
    type = ODETimeDerivative
    variable = T_11_storage
  []
  [I1] # Breeding Zone
    type = ParsedODEKernel
    expression = '-(tritium_burn_rate * TBR + (1 - TES_efficiency)*T_02_TES/residence2 - T_01_BZ/residence1 - T_01_BZ*epsilon1/residence1 - T_01_BZ*tdecay)'
    variable = 'T_01_BZ'
    coupled_variables = 'T_02_TES'
    postprocessors = 'TBR tritium_burn_rate TES_efficiency residence1 residence2 tdecay epsilon1'
  []
  [I2] #Tritium Extraction System
    type = ParsedODEKernel
    expression = '-((1 - BZ_HX_leak_fraction)*T_01_BZ/residence1 - T_02_TES/residence2 - T_02_TES*epsilon2/residence2 - T_02_TES*tdecay)'
    variable = 'T_02_TES'
    coupled_variables = 'T_01_BZ'
    postprocessors = 'BZ_HX_leak_fraction residence1 residence2 tdecay epsilon2'
  []
  [I3] #First Wall
    type = ParsedODEKernel
    expression = '-(P_FW_leak_fraction*tritium_burn_rate /tritium_burn_fraction / tritium_fueling_efficiency + HX_FW_leak_fraction * (1 - HX_CPS_leak_fraction) * (1 - HX_EXO_leak_fraction)
                  * T_05_HX/residence5 + CPS_FW_leak_fraction * (1 - CPS_efficiency) * T_06_CPS/residence6 - T_03_FW/residence3 - T_03_FW*epsilon3/residence3 - T_03_FW*tdecay)'
    variable = 'T_03_FW'
    coupled_variables = 'T_05_HX T_06_CPS'
    postprocessors = 'P_FW_leak_fraction tritium_burn_rate tritium_burn_fraction tritium_fueling_efficiency HX_FW_leak_fraction HX_CPS_leak_fraction HX_EXO_leak_fraction residence5 CPS_FW_leak_fraction CPS_efficiency residence6 residence3 tdecay epsilon3'
  []
  [I4] #Divertor
    type = ParsedODEKernel
    expression = '-(P_DIV_leak_fraction * tritium_burn_rate/tritium_burn_fraction / tritium_fueling_efficiency + (1-HX_FW_leak_fraction)*
                  (1-HX_CPS_leak_fraction)*(1-HX_EXO_leak_fraction)* T_05_HX/residence5 + (1-CPS_FW_leak_fraction)*(1 - CPS_efficiency) * T_06_CPS/residence6  - T_04_DIV*epsilon4/residence4 - T_04_DIV/residence4 - T_04_DIV*tdecay)'
    variable = 'T_04_DIV'
    coupled_variables = 'T_06_CPS T_05_HX'
    postprocessors = 'P_DIV_leak_fraction tritium_burn_rate tritium_burn_fraction tritium_fueling_efficiency HX_FW_leak_fraction HX_CPS_leak_fraction HX_EXO_leak_fraction residence5 CPS_FW_leak_fraction CPS_efficiency residence6 residence4 tdecay epsilon4'
  []
  [I5] #Heat eXchanger
    type = ParsedODEKernel
    expression = '-(BZ_HX_leak_fraction * T_01_BZ/residence1 + T_03_FW/residence3 + T_04_DIV/residence4 - T_05_HX/residence5 - T_05_HX*epsilon5/residence5 -T_05_HX*tdecay)'
    variable = 'T_05_HX'
    coupled_variables = 'T_01_BZ T_03_FW T_04_DIV'
    postprocessors = 'BZ_HX_leak_fraction residence1 residence3 residence4 residence5 tdecay epsilon5'
  []
  [I6] #Coolant Purification System
    type = ParsedODEKernel
    expression = '-(HX_CPS_leak_fraction * (1 - HX_EXO_leak_fraction)*T_05_HX/residence5 - T_06_CPS/residence6 - T_06_CPS*epsilon6/residence6 - T_06_CPS*tdecay)'
    variable = 'T_06_CPS'
    coupled_variables = 'T_05_HX'
    postprocessors = 'HX_CPS_leak_fraction HX_EXO_leak_fraction residence5 residence6 tdecay epsilon6'
  []
  [I7] #Vacuum Pump
    type = ParsedODEKernel
    expression = '-((1-tritium_burn_fraction*tritium_fueling_efficiency - P_FW_leak_fraction - P_DIV_leak_fraction)*
                  tritium_burn_rate/(tritium_burn_fraction * tritium_fueling_efficiency) - T_07_vacuum/residence7 - T_07_vacuum*epsilon7/residence7 - T_07_vacuum*tdecay)'
    variable = 'T_07_vacuum'
    postprocessors = 'tritium_burn_rate tritium_fueling_efficiency P_FW_leak_fraction P_DIV_leak_fraction tritium_burn_fraction residence7 tdecay epsilon7'
  []
  [I8] #Fuel clean-up
    type = ParsedODEKernel
    expression = '-(T_07_vacuum/residence7 - T_08_FCU/residence8 - T_08_FCU*epsilon8/residence8 - T_08_FCU*tdecay)'
    variable = 'T_08_FCU'
    postprocessors = 'residence7 residence8 tdecay epsilon8'
    coupled_variables = 'T_07_vacuum'
  []
  [I9] #Isotope Separation System
    type = ParsedODEKernel
    expression = '-((1-FCU_STO_fraction)*T_08_FCU/residence8 + T_10_exhaust/residence10 + TES_efficiency*T_02_TES/residence2 + CPS_efficiency*T_06_CPS/residence6 - T_09_ISS/residence9 - T_09_ISS*epsilon9/residence9 - T_09_ISS*tdecay)'
    variable = 'T_09_ISS'
    coupled_variables = 'T_08_FCU T_10_exhaust T_02_TES T_06_CPS'
    postprocessors = 'FCU_STO_fraction residence8 residence10 TES_efficiency residence2 CPS_efficiency residence6 residence9 tdecay epsilon9'
  []
  [I10] #Exhaust and Water Detritiation System (EXO)
    type = ParsedODEKernel
    expression = '-(HX_EXO_leak_fraction * T_05_HX/residence5 + ISS_EXO_leak_fraction*T_09_ISS/residence9 - T_10_exhaust/residence10 - T_10_exhaust*epsilon10/residence10 - T_10_exhaust*tdecay)'
    variable = 'T_10_exhaust'
    coupled_variables = 'T_05_HX T_09_ISS'
    postprocessors = 'HX_EXO_leak_fraction residence5 ISS_EXO_leak_fraction residence9 residence10 tdecay epsilon10'
  []
  [I11] #Storage and Management (STO)
    type = ParsedODEKernel
    expression = '-(FCU_STO_fraction * T_08_FCU/residence8 + (1-ISS_EXO_leak_fraction)*T_09_ISS/residence9 - tritium_burn_rate/tritium_burn_fraction/tritium_fueling_efficiency - T_11_storage*tdecay)'
    variable = 'T_11_storage'
    coupled_variables = 'T_08_FCU T_09_ISS'
    postprocessors = 'FCU_STO_fraction residence8 ISS_EXO_leak_fraction residence9 tritium_burn_rate tritium_burn_fraction tritium_fueling_efficiency tdecay'
  []
[]

# These postprocessors define the constants referenced in
# the equations above. The value of any of these constants
# could be informed by more detailed models (using sub-apps
# and transfers), but it is important that the postprocessor
# is evaluated before the executioner attempts to solve the
# ODE, which is not the default behavior.
[Postprocessors]
  [BZ_HX_leak_fraction] #f_{1-5}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-2
  []
  [CPS_FW_leak_fraction] #f_{6-3}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0.6
  []
  [CPS_efficiency] #eta_6
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0.95
  []
  [FCU_STO_fraction] #f_{8-11}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0
  []
  [HX_CPS_leak_fraction] #f_{5-6}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-2
  []
  [HX_EXO_leak_fraction] #f_{5-10}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [HX_FW_leak_fraction] #f_{5-3}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0.6
  []
  [ISS_EXO_leak_fraction] #f_{9-10}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-1
  []
  [P_DIV_leak_fraction] #f_{P-4}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [P_FW_leak_fraction] #f_{P_3}
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [TES_efficiency] #eta_2
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0.95
  []
  [TBR] #According to the PhD Thesis referenced in the paper,
        # this is the required Tritium Breeding Ratio (TBR)
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1.9247
  []
  [epsilon1] #BZ
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0
  []
  [epsilon2] #TES
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [epsilon3] #FW
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0
  []
  [epsilon4] #DIV
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0
  []
  [epsilon5] #HX
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [epsilon6] #CPS
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [epsilon7] #Vac
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [epsilon8] #FCU
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value =  1e-4
  []
  [epsilon9] #ISS
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [epsilon10] #EXO
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1e-4
  []
  [epsilon11] #STO
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0
  []
  [residence1] #BZ
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 86400 #1 day, Abdou
    #value = 8640-86400 EXOTIC-6-7-8
  []
  [residence2] #TES
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 86400 # Abdou
    #value = 86400-432000 Riva
  []
  [residence3] #FW
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1000 #Riva
  []
  [residence4] #DIV
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1000 #Riva
  []
  [residence5] #HX
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1000 # Abdou 2021 paper chosen for analysis
  []
  [residence6] #CPS
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 864000 #Abdou analysis case
    #value 8640000 Abdou 1,4
  []
  [residence7] #Vac
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1
    #value = 1800 # 30 minutes (20-30 minutes)
  []
  [residence8] #FCU
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1
    #value = 4680 # 1.3 h as per Day
    #value = 5 h Coleman
    #value = 8640 Abdou
    #value = 86400 Abdou
  []
  [residence9] #ISS
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 14400
    #value = 7920 #(for four hour overall residence time in inner loop)
  []
  [residence10] #EXO
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 3600 # Day et al
    #value = 72000 #Coleman et al
  []
  [tdecay]
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 1.7828336471961835e-9
  []
  [tritium_burn_fraction]
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0.0036
  []
  [tritium_burn_rate]
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 5.3125e-6 # 0.459 kg/day
  []
  [tritium_fueling_efficiency]
    type = ConstantPostprocessor
    execute_on = 'TIMESTEP_BEGIN INITIAL LINEAR NONLINEAR'
    value = 0.25
  []
  # These postprocessors exist to sum up the tritium inventory
  #  across the entirety of the system
  [T_BZ]
    type = ScalarVariable
    variable = T_01_BZ
    execute_on = TIMESTEP_END
  []
  [T_TES]
    type = ScalarVariable
    variable = T_02_TES
    execute_on = TIMESTEP_END
  []
  [T_FW]
    type = ScalarVariable
    variable = T_03_FW
    execute_on = TIMESTEP_END
  []
  [T_DIV]
    type = ScalarVariable
    variable = T_04_DIV
    execute_on = TIMESTEP_END
  []
  [T_HX]
    type = ScalarVariable
    variable = T_05_HX
    execute_on = TIMESTEP_END
  []
  [T_CPS]
    type = ScalarVariable
    variable = T_06_CPS
    execute_on = TIMESTEP_END
  []
  [T_VAC]
    type = ScalarVariable
    variable = T_07_vacuum
    execute_on = TIMESTEP_END
  []
  [T_FCU]
    type = ScalarVariable
    variable = T_08_FCU
    execute_on = TIMESTEP_END
  []
  [T_ISS]
    type = ScalarVariable
    variable = T_09_ISS
    execute_on = TIMESTEP_END
  []
  [T_EXO]
    type = ScalarVariable
    variable = T_10_exhaust
    execute_on = TIMESTEP_END
  []
  [T_STO]
    type = ScalarVariable
    variable = T_11_storage
    execute_on = TIMESTEP_END
  []
  [total_tritium]
    type = SumPostprocessor
    values = 'T_BZ T_TES T_FW T_DIV T_HX T_CPS T_VAC T_FCU T_ISS T_EXO T_STO'
  []
[]
[UserObjects]
  [terminator]
    type = Terminator
    expression = 'T_STO < 0'
    fail_mode = 'HARD'
    message = 'Tritium in storage has been depleted'
  []
  [terminator2]
    type = Terminator
    expression = 'total_tritium < 0'
    fail_mode = 'HARD'
    message = 'Tritium in system has been depleted'
  []
[]
# The tritium breeding ratio is not directly given in the paper,
# but is specified as a "five year" doubling time from the initial
# inventory. As such, it may be necessary to force the simulation to
# record a timestep at exactly five years, or whatever doubling time
# is wanted, to dial in the tritium breeding ratio. This can be done
# using the IterationAdaptiveDT settings commented out below along
# with this function.
#
#[Functions]
#  [catch_five_year]
#    type = PiecewiseLinear
#    x = '0 157680000 157680100 864000000.0'
#    y = '0 0 1 1'
#  []
#[]

[Executioner]
  type = Transient
  start_time = 0
  dtmin = 1
  end_time = 946080000.0
  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.4
    dt = 5
    #timestep_limiting_function = 'catch_five_year'
    #max_function_change = 0.5
    #force_step_every_function_point = true
  []
  solve_type = 'PJFNK'
  nl_rel_tol = 1e-08
  nl_abs_tol = 1e-14
[]
[Outputs]
  hide = "BZ_HX_leak_fraction CPS_FW_leak_fraction CPS_efficiency FCU_STO_fraction HX_CPS_leak_fraction HX_EXO_leak_fraction HX_FW_leak_fraction ISS_EXO_leak_fraction P_DIV_leak_fraction P_FW_leak_fraction TBR TES_efficiency T_BZ T_CPS T_DIV T_EXO T_FCU T_FW T_HX T_ISS T_STO T_TES T_VAC epsilon1 epsilon10 epsilon11 epsilon2 epsilon3 epsilon4 epsilon5 epsilon6 epsilon7 epsilon8 epsilon9 residence1 residence10 residence2 residence3 residence4 residence5 residence6 residence7 residence8 residence9 tdecay tritium_burn_fraction tritium_burn_rate tritium_fueling_efficiency"
  csv = true
  console = false
[]
