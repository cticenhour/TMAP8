cl=3.1622e18

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 200
  xmax = 1
[]

[Problem]
  type = ReferenceResidualProblem
  extra_tag_vectors = 'ref'
  reference_vector = 'ref'
  solution_variables = 'mobile trapped'
[]

[Variables]
  [mobile][]
  [trapped][]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = mobile
    extra_vector_tags = ref
  [../]
  [./time]
    type = TimeDerivative
    variable = mobile
    extra_vector_tags = ref
  [../]
  [coupled_time]
    type = CoupledTimeDerivative
    variable = mobile
    v = trapped
    extra_vector_tags = ref
  []
[]

[NodalKernels]
  [time]
    type = TimeDerivativeNodalKernel
    variable = trapped
  []
  [trapping]
    type = TrappingNodalKernel
    variable = trapped
    alpha_t = 1e15
    N = ${fparse 3.1622e22 / cl}
    Ct0 = 0.1
    mobile = 'mobile'
    extra_vector_tags = ref
  []
  [release]
    type = ReleasingNodalKernel
    alpha_r = 1e13
    temp = 1000
    trapping_energy = 100
    variable = trapped
  []
[]

[BCs]
  [left]
    type = DirichletBC
    variable = mobile
    value = ${fparse 3.1622e18 / cl}
    boundary = left
  []
  [right]
    type = DirichletBC
    variable = mobile
    value = 0
    boundary = right
  []
[]

[Postprocessors]
  [outflux]
    type = SideFluxAverage
    boundary = 'right'
    diffusivity = 1
    variable = mobile
  []
  [scaled_outflux]
    type = ScalePostprocessor
    value = outflux
    scaling_factor = ${cl}
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  end_time = 3
  dt = .01
  dtmin = .01
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  automatic_scaling = true
  verbose = true
  compute_scaling_once = false
  nl_rel_tol = 1e-11
  l_tol = 1e-15
[]

[Outputs]
  exodus = true
  csv = true
  [dof]
    type = DOFMap
    execute_on = initial
  []
  perf_graph = true
[]
