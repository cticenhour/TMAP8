# Validation Problem #2ea from TMAP4/TMAP7 V&V document
# Deuterium permeation through 0.05-mm Pd at 825 K.
# No Soret effect, or trapping included.

# Physical Constants
# Note that we do NOT use the same number of digits as in TMAP4/TMAP7.
# This is to be consistent with PhysicalConstant.h
kb = '${units 1.380649e-23 J/K}' # Boltzmann constant
R = '${units 8.31446261815324 J/mol/K}' # Gas constant

# Enclosure data used in TMAP7 case
surface_area = '${units 1.8e-4 m^2 -> mum^2}'
temperature = '${units 870 K}'
pressure_enclosure1 = '${units 1e-7 Pa}'
pressure_enclosure4 = '${units 1e-10 Pa}'
pressure_initial_enclosure2 = '${units 1e-7 Pa}'
pressure_initial_enclosure2_H2 = '${units 0.063 Pa}'
pressure_initial_enclosure3 = '${units 1e-20 Pa}'
volume_enclosure = '${units 0.005 m^3 -> mum^3}'
flow_rate = '${units 0.1 m^3/s -> mum^3/s}'
flow_rate_by_V = '${fparse flow_rate / volume_enclosure}'

# Diffusion data used in TMAP7 case
diffusivity_pre_D = '${units 2.636e-4 m^2/s -> mum^2/s}'
diffusivity_energy_D = '${units ${fparse 1315.8 * R} J/mol}'
diffusivity_pre_H = '${units 3.728e-4 m^2/s -> mum^2/s}'
diffusivity_energy_H = '${units ${fparse 1315.8 * R} J/mol}'
solubility_exponent = 0.9297 # -
solubility_pre = '${units ${fparse 9.355e22 / 1e18} at/mum^3/Pa^0.9297}'
solubility_energy = '${units ${fparse 5918 * R} J/mol}'

# Modeling data used in current case
slab_thickness = '${units 2.5e-5 m -> mum}'
num_node = 20 # -
concentration_to_pressure_conversion_factor = '${units ${fparse kb*temperature} Pa*m^3 -> Pa*mum^3}'
file_name = 'val-2ed_out'
simulation_time = '${units 1000 s}'

[Mesh]
  [generated]
    type = GeneratedMeshGenerator
    dim = 1
    nx = '${num_node}'
    xmax = '${slab_thickness}'
  []
[]

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
[]

[Variables]
  # concentration in the SiC layer in atoms/microns^3
  [D2_pressure_upstream]
    initial_condition = '${pressure_initial_enclosure2}'
  []
  [H2_pressure_upstream]
    initial_condition = '${pressure_initial_enclosure2_H2}'
  []
  [HD_pressure_upstream]
    initial_condition = '${pressure_initial_enclosure2}'
  []

  [D2_pressure_downstream]
    initial_condition = '${pressure_initial_enclosure3}'
  []
  [H2_pressure_downstream]
    initial_condition = '${pressure_initial_enclosure3}'
  []
  [HD_pressure_downstream]
    initial_condition = '${pressure_initial_enclosure3}'
  []

  [D_concentration]
    initial_condition = 0
  []
  [H_concentration]
    initial_condition = 0
  []
[]

[AuxVariables]
  [D2_pressure_enclosure1]
    initial_condition = '${pressure_enclosure1}'
  []
  [H2_pressure_enclosure1]
    initial_condition = '${pressure_enclosure1}'
  []
  [HD_pressure_enclosure1]
    initial_condition = '${pressure_enclosure1}'
  []
  [D2_pressure_enclosure4]
    initial_condition = '${pressure_enclosure4}'
  []
  [H2_pressure_enclosure4]
    initial_condition = '${pressure_enclosure4}'
  []
  [HD_pressure_enclosure4]
    initial_condition = '${pressure_enclosure4}'
  []
  [D2_pressure_enclosure5]
    initial_condition = 1.8421e-4
  []
  [H2_pressure_enclosure5]
    initial_condition = '${pressure_initial_enclosure2_H2}'
  []
  [HD_pressure_enclosure5]
    initial_condition = '${pressure_enclosure4}'
  []

  [D2_partial_pressure_upstream]
    initial_condition = '${fparse pressure_initial_enclosure2 + pressure_initial_enclosure2/2}'
  []
  [D2_partial_pressure_downstream]
    initial_condition = '${fparse pressure_initial_enclosure3 + pressure_initial_enclosure3/2}'
  []
  [H2_partial_pressure_upstream]
    initial_condition = '${fparse pressure_initial_enclosure2_H2 + pressure_initial_enclosure2/2}'
  []
  [H2_partial_pressure_downstream]
    initial_condition = '${fparse pressure_initial_enclosure3 + pressure_initial_enclosure3/2}'
  []

  [sqrt_PH2_sqrt_PD2_upstream]
  []
  [sqrt_PH2_sqrt_PD2_downstream]
  []

  [HD_pressure_upstream_reference]
  []
  [HD_pressure_downstream_reference]
  []
[]

[AuxKernels]
  [D2_pressure_enclosure5_kernel]
    type = FunctionAux
    variable = D2_pressure_enclosure5
    function = D2_pressure_enclosure5_function
  []
  [H2_pressure_enclosure5_kernel]
    type = FunctionAux
    variable = H2_pressure_enclosure5
    function = H2_pressure_enclosure5_function
  []

  [sqrt_PH2_sqrt_PD2_upstream_kernel]
    type = ParsedAux
    variable = sqrt_PH2_sqrt_PD2_upstream
    coupled_variables = 'D2_pressure_upstream H2_pressure_upstream'
    expression = 'sqrt(D2_pressure_upstream) * sqrt(H2_pressure_upstream)'
  []
  [sqrt_PH2_sqrt_PD2_downstream_kernel]
    type = ParsedAux
    variable = sqrt_PH2_sqrt_PD2_downstream
    coupled_variables = 'D2_pressure_downstream H2_pressure_downstream'
    expression = 'sqrt(D2_pressure_downstream) * sqrt(H2_pressure_downstream)'
  []

  [D2_partial_pressure_upstream_kernel]
    type = ParsedAux
    variable = D2_partial_pressure_upstream
    coupled_variables = 'D2_pressure_upstream HD_pressure_upstream'
    expression = 'D2_pressure_upstream + HD_pressure_upstream / 2'
  []
  [D2_partial_pressure_downstream_kernel]
    type = ParsedAux
    variable = D2_partial_pressure_downstream
    coupled_variables = 'D2_pressure_downstream HD_pressure_downstream'
    expression = 'D2_pressure_downstream + HD_pressure_downstream / 2'
  []
  [H2_partial_pressure_upstream_kernel]
    type = ParsedAux
    variable = H2_partial_pressure_upstream
    coupled_variables = 'H2_pressure_upstream HD_pressure_upstream'
    expression = 'H2_pressure_upstream + HD_pressure_upstream / 2'
  []
  [H2_partial_pressure_downstream_kernel]
    type = ParsedAux
    variable = H2_partial_pressure_downstream
    coupled_variables = 'H2_pressure_downstream HD_pressure_downstream'
    expression = 'H2_pressure_downstream + HD_pressure_downstream / 2'
  []

  [HD_pressure_upstream_reference_kernel]
    type = ParsedAux
    variable = HD_pressure_upstream_reference
    coupled_variables = 'D2_pressure_upstream H2_pressure_upstream'
    expression = '2 * sqrt(D2_pressure_upstream) * sqrt(H2_pressure_upstream)'
  []
  [HD_pressure_downstream_reference_kernel]
    type = ParsedAux
    variable = HD_pressure_downstream_reference
    coupled_variables = 'D2_pressure_downstream H2_pressure_downstream'
    expression = '2 * sqrt(D2_pressure_downstream) * sqrt(H2_pressure_downstream)'
  []
[]

[Functions]
  [D2_pressure_enclosure5_function]
    type = ParsedFunction
    expression = 'if(t < 150, 1.8421e-4,
                  if(t < 250, 1e-3,
                  if(t < 350, 3e-3,
                  if(t < 450, 0.009,
                  if(t < 550, 0.027,
                  if(t < 650, 0.081,
                  if(t < 750, 0.243,
                  if(t < ${simulation_time}, 0.729, 0.729))))))))'
  []
  [H2_pressure_enclosure5_function]
    type = ParsedFunction
    expression = '${pressure_initial_enclosure2_H2}' # Pa
  []
[]

[Kernels]
  # Gas flow kernels
  # Equation for D2 in enclosure upstream
  [timeDerivative_upstream_D2]
    type = ADTimeDerivative
    variable = D2_pressure_upstream
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_D2_influx_5]
    type = ADMatReaction
    variable = D2_pressure_upstream
    v = 'D2_pressure_enclosure5'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_D2_influx_1]
    type = ADMatReaction
    variable = D2_pressure_upstream
    v = 'D2_pressure_enclosure1'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_D2_outflux_4]
    type = ADMatReaction
    variable = D2_pressure_upstream
    v = 'D2_pressure_upstream'
    reaction_rate = -${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_D2_reaction]
    type = ADMatReaction
    variable = D2_pressure_upstream
    v = 'sqrt_PH2_sqrt_PD2_upstream'
    reaction_rate = -1
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_D2_re_reaction]
    type = ADMatReaction
    variable = D2_pressure_upstream
    v = 'HD_pressure_upstream'
    reaction_rate = 0.5
    extra_vector_tags = 'ref'
  []
  # Equation for H2 in enclosure upstream
  [timeDerivative_upstream_H2]
    type = ADTimeDerivative
    variable = H2_pressure_upstream
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_H2_influx_5]
    type = ADMatReaction
    variable = H2_pressure_upstream
    v = 'H2_pressure_enclosure5'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_H2_influx_1]
    type = ADMatReaction
    variable = H2_pressure_upstream
    v = 'H2_pressure_enclosure1'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_H2_outflux_4]
    type = ADMatReaction
    variable = H2_pressure_upstream
    v = 'H2_pressure_upstream'
    reaction_rate = -${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_H2_reaction]
    type = ADMatReaction
    variable = H2_pressure_upstream
    v = 'sqrt_PH2_sqrt_PD2_upstream'
    reaction_rate = -1
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_H2_re_reaction]
    type = ADMatReaction
    variable = H2_pressure_upstream
    v = 'HD_pressure_upstream'
    reaction_rate = 0.5
    extra_vector_tags = 'ref'
  []
  # Equation for HD in enclosure upstream
  [timeDerivative_upstream_HD]
    type = ADTimeDerivative
    variable = HD_pressure_upstream
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_HD_influx_5]
    type = ADMatReaction
    variable = HD_pressure_upstream
    v = 'HD_pressure_enclosure5'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_HD_influx_1]
    type = ADMatReaction
    variable = HD_pressure_upstream
    v = 'HD_pressure_enclosure1'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_HD_outflux_4]
    type = ADMatReaction
    variable = HD_pressure_upstream
    v = 'HD_pressure_upstream'
    reaction_rate = -${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_HD_reaction]
    type = ADMatReaction
    variable = HD_pressure_upstream
    v = 'sqrt_PH2_sqrt_PD2_upstream'
    reaction_rate = 2
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_HD_re_reaction]
    type = ADMatReaction
    variable = HD_pressure_upstream
    v = 'HD_pressure_upstream'
    reaction_rate = -1
    extra_vector_tags = 'ref'
  []
  # Membrane upstream
  [MatReaction_upstream_outflux_membrane_D]
    type = ADMatBodyForce
    variable = D2_pressure_upstream
    material_property = 'membrane_reaction_rate_right_D'
    extra_vector_tags = 'ref'
  []
  [MatReaction_upstream_outflux_membrane_H]
    type = ADMatBodyForce
    variable = H2_pressure_upstream
    material_property = 'membrane_reaction_rate_right_H'
    extra_vector_tags = 'ref'
  []

  # Equation for D2 enclosure downstream
  [timeDerivative_downstream_D2]
    type = ADTimeDerivative
    variable = D2_pressure_downstream
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_D2_influx_1]
    type = ADMatReaction
    variable = D2_pressure_downstream
    v = 'D2_pressure_enclosure1'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_D2_outflux_4]
    type = ADMatReaction
    variable = D2_pressure_downstream
    v = 'D2_pressure_downstream'
    reaction_rate = -${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_D2_reaction]
    type = ADMatReaction
    variable = D2_pressure_downstream
    v = 'sqrt_PH2_sqrt_PD2_downstream'
    reaction_rate = -1
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_D2_re_reaction]
    type = ADMatReaction
    variable = D2_pressure_downstream
    v = 'HD_pressure_downstream'
    reaction_rate = 0.5
    extra_vector_tags = 'ref'
  []
  # Equation for H2 enclosure downstream
  [timeDerivative_downstream_H2]
    type = ADTimeDerivative
    variable = H2_pressure_downstream
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_H2_influx_1]
    type = ADMatReaction
    variable = H2_pressure_downstream
    v = 'H2_pressure_enclosure1'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_H2_outflux_4]
    type = ADMatReaction
    variable = H2_pressure_downstream
    v = 'H2_pressure_downstream'
    reaction_rate = -${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_H2_reaction]
    type = ADMatReaction
    variable = H2_pressure_downstream
    v = 'sqrt_PH2_sqrt_PD2_downstream'
    reaction_rate = -1
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_H2_re_reaction]
    type = ADMatReaction
    variable = H2_pressure_downstream
    v = 'HD_pressure_downstream'
    reaction_rate = 0.5
    extra_vector_tags = 'ref'
  []
  # Equation for HD enclosure downstream
  [timeDerivative_downstream_HD]
    type = ADTimeDerivative
    variable = HD_pressure_downstream
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_HD_influx_1]
    type = ADMatReaction
    variable = HD_pressure_downstream
    v = 'HD_pressure_enclosure1'
    reaction_rate = ${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_HD_outflux_4]
    type = ADMatReaction
    variable = HD_pressure_downstream
    v = 'HD_pressure_downstream'
    reaction_rate = -${flow_rate_by_V}
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_HD_reaction]
    type = ADMatReaction
    variable = HD_pressure_downstream
    v = 'sqrt_PH2_sqrt_PD2_downstream'
    reaction_rate = 2
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_HD_re_reaction]
    type = ADMatReaction
    variable = HD_pressure_downstream
    v = 'HD_pressure_downstream'
    reaction_rate = -1
    extra_vector_tags = 'ref'
  []
  # Membrane downstream
  [MatReaction_downstream_influx_membrane_D]
    type = ADMatBodyForce
    variable = D2_pressure_downstream
    material_property = 'membrane_reaction_rate_left_D'
    extra_vector_tags = 'ref'
  []
  [MatReaction_downstream_influx_membrane_H]
    type = ADMatBodyForce
    variable = H2_pressure_downstream
    material_property = 'membrane_reaction_rate_left_H'
    extra_vector_tags = 'ref'
  []

  # Diffusion kernels
  [timeDerivative_diffusion_D]
    type = ADTimeDerivative
    variable = D_concentration
    extra_vector_tags = 'ref'
  []
  [MatDiffusion_diffusion_D]
    type = ADMatDiffusion
    variable = D_concentration
    diffusivity = diffusivity_D
    extra_vector_tags = 'ref'
  []
  [timeDerivative_diffusion_H]
    type = ADTimeDerivative
    variable = H_concentration
    extra_vector_tags = 'ref'
  []
  [MatDiffusion_diffusion_H]
    type = ADMatDiffusion
    variable = H_concentration
    diffusivity = diffusivity_H
    extra_vector_tags = 'ref'
  []
[]

[Materials]
  [diffusivity_D]
    type = ADParsedMaterial
    property_name = 'diffusivity_D'
    expression = '${diffusivity_pre_D} * exp( - ${diffusivity_energy_D} / ${R} / ${temperature})'
  []
  [diffusivity_H]
    type = ADParsedMaterial
    property_name = 'diffusivity_H'
    expression = '${diffusivity_pre_H} * exp( - ${diffusivity_energy_H} / ${R} / ${temperature})'
  []
  [membrane_reaction_rate_right_D]
    type = ADParsedMaterial
    property_name = 'membrane_reaction_rate_right_D'
    postprocessor_names = flux_surface_right_D
    expression = 'flux_surface_right_D * ${surface_area} / ${volume_enclosure} * ${concentration_to_pressure_conversion_factor}/2'
  []
  [membrane_reaction_rate_left_D]
    type = ADParsedMaterial
    property_name = 'membrane_reaction_rate_left_D'
    postprocessor_names = flux_surface_left_D
    expression = 'flux_surface_left_D * ${surface_area} / ${volume_enclosure} * ${concentration_to_pressure_conversion_factor}/2'
  []
  [membrane_reaction_rate_right_H]
    type = ADParsedMaterial
    property_name = 'membrane_reaction_rate_right_H'
    postprocessor_names = flux_surface_right_H
    expression = 'flux_surface_right_H * ${surface_area} / ${volume_enclosure} * ${concentration_to_pressure_conversion_factor}/2'
  []
  [membrane_reaction_rate_left_H]
    type = ADParsedMaterial
    property_name = 'membrane_reaction_rate_left_H'
    postprocessor_names = flux_surface_left_H
    expression = 'flux_surface_left_H * ${surface_area} / ${volume_enclosure} * ${concentration_to_pressure_conversion_factor}/2'
  []

  [converter_to_regular]
    type = MaterialADConverter
    ad_props_in = 'diffusivity_D diffusivity_H'
    reg_props_out = 'diffusivity_D_nonAD diffusivity_H_nonAD'
    outputs = none
  []
[]

[BCs]
  # The surface of the slab in contact with the source is assumed to be in equilibrium with the source enclosure
  [right_diffusion_D]
    type = EquilibriumBC
    variable = D_concentration
    enclosure_var = D2_partial_pressure_upstream
    boundary = 'right'
    Ko = '${solubility_pre}'
    activation_energy = '${solubility_energy}'
    p = '${solubility_exponent}'
    temperature = ${temperature}
  []
  [left_diffusion_D]
    type = EquilibriumBC
    variable = D_concentration
    enclosure_var = D2_partial_pressure_downstream
    boundary = 'left'
    Ko = '${solubility_pre}'
    activation_energy = '${solubility_energy}'
    p = '${solubility_exponent}'
    temperature = ${temperature}
  []
  [right_diffusion_H]
    type = EquilibriumBC
    variable = H_concentration
    enclosure_var = H2_partial_pressure_upstream
    boundary = 'right'
    Ko = '${solubility_pre}'
    activation_energy = '${solubility_energy}'
    p = '${solubility_exponent}'
    temperature = ${temperature}
  []
  [left_diffusion_H]
    type = EquilibriumBC
    variable = H_concentration
    enclosure_var = H2_partial_pressure_downstream
    boundary = 'left'
    Ko = '${solubility_pre}'
    activation_energy = '${solubility_energy}'
    p = '${solubility_exponent}'
    temperature = ${temperature}
  []
[]

[Postprocessors]
  # Pressure
  [pressure_upstream_D2]
    type = ElementAverageValue
    variable = D2_pressure_upstream
  []
  [pressure_downstream_D2]
    type = ElementAverageValue
    variable = D2_pressure_downstream
  []
  [pressure_upstream_H2]
    type = ElementAverageValue
    variable = H2_pressure_upstream
  []
  [pressure_downstream_H2]
    type = ElementAverageValue
    variable = H2_pressure_downstream
  []
  [pressure_upstream_HD]
    type = ElementAverageValue
    variable = HD_pressure_upstream
  []
  [pressure_upstream_HD_reference]
    type = ElementAverageValue
    variable = HD_pressure_upstream_reference
  []
  [pressure_downstream_HD]
    type = ElementAverageValue
    variable = HD_pressure_downstream
  []
  [pressure_downstream_HD_reference]
    type = ElementAverageValue
    variable = HD_pressure_downstream_reference
  []
  # Flux
  [flux_surface_right_D]
    type = SideDiffusiveFluxIntegral
    variable = D_concentration
    diffusivity = diffusivity_D_nonAD
    boundary = 'right'
    execute_on = 'initial timestep_end'
    outputs = 'console csv exodus'
  []
  [flux_surface_left_D]
    type = SideDiffusiveFluxIntegral
    variable = D_concentration
    diffusivity = diffusivity_D_nonAD
    boundary = 'left'
    execute_on = 'initial timestep_end'
    outputs = 'console csv exodus'
  []
  [flux_surface_right_H]
    type = SideDiffusiveFluxIntegral
    variable = H_concentration
    diffusivity = diffusivity_H_nonAD
    boundary = 'right'
    execute_on = 'initial timestep_end'
    outputs = 'console csv exodus'
  []
  [flux_surface_left_H]
    type = SideDiffusiveFluxIntegral
    variable = H_concentration
    diffusivity = diffusivity_H_nonAD
    boundary = 'left'
    execute_on = 'initial timestep_end'
    outputs = 'console csv exodus'
  []
[]

[Debug]
  show_var_residual_norms = true
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  automatic_scaling = true
  compute_scaling_once = true
  line_search = none
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-10
  dtmax = 5
  end_time = ${simulation_time}
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.01
    optimal_iterations = 12
    iteration_window = 1
    growth_factor = 1.1
    cutback_factor = 0.9
  []
[]

[Outputs]
  file_base = ${file_name}
  exodus = true
  perf_graph = true
  [csv]
    type = CSV
    execute_on = 'initial timestep_end'
  []
[]
