/********************************************************/
/*             DO NOT MODIFY THIS HEADER                */
/* TMAP8: Tritium Migration Analysis Program, Version 8 */
/*                                                      */
/*    Copyright 2021 Battelle Energy Alliance, LLC      */
/*               ALL RIGHTS RESERVED                    */
/********************************************************/

#include "LMDiffusion.h"

registerMooseObject("TMAPApp", LMDiffusion);

InputParameters
LMDiffusion::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addRequiredCoupledVar("v", "The coupled variable from which to pull the Laplacian");
  params.addParam<Real>("lm_sign", 1, "The sign of the lagrange multiplier in the primal equation");
  params.addParam<Real>("diffusivity", 1, "The value of the diffusivity");
  return params;
}

LMDiffusion::LMDiffusion(const InputParameters & parameters)
  : Kernel(parameters),
    _v_var(coupled("v")),
    _second_v(coupledSecond("v")),
    _second_v_phi(getVar("v", 0)->secondPhi()),
    _lm_sign(getParam<Real>("lm_sign")),
    _diffusivity(getParam<Real>("diffusivity"))
{
  if (_var.number() == _v_var)
    mooseError("Coupled variable 'v' needs to be different from 'variable' with "
               "LMDiffusion");
}

Real
LMDiffusion::computeQpResidual()
{
  return _lm_sign * _test[_i][_qp] * -_diffusivity * _second_v[_qp].tr();
}

Real
LMDiffusion::computeQpJacobian()
{
  return 0;
}

Real
LMDiffusion::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _v_var)
    return _lm_sign * _test[_i][_qp] * -_diffusivity * _second_v_phi[_j][_qp].tr();

  return 0;
}
