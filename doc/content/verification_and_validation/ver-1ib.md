# ver-1ib

# Species Equilibration Problem in Ratedep Condition with Unequal Starting Pressures

## General Case Description

This verification problem is taken from [!cite](ambrosek2008verification) and builds on [ver-1ia](ver-1ia.md). The configuration and modeling parameters are the same as in [ver-1ia](ver-1ia.md), except that, in the current case, the starting pressures for A$_2$ and B$_2$ are not equal. The case is simulated in [/ver-1ia.i], but the starting pressures of A$_2$ and B$_2$ are $1 \times 10^4$ Pa and $1 \times 10^5$, respectively, and there is no AB initially present.

## Analytical solution

[!cite](ambrosek2008verification) provides the analytical equation for the partial pressure of AB when the conversion rate at the surface is high as

\begin{equation}
\label{eq:analytical_solution}
P_{AB}  = \frac{2 P_{A_2}^0 P_{B_2}^0}{P_{A_2}^0 + P_{B_2}^0} \left(1 - \exp \left( -\frac{S K_d k_b T}{V} t \right)\right).
\end{equation}

## Results

A comparison of the concentration of AB as a function of time is plotted in [ver-1ib_comparison_pressure]. The TMAP8 calculations are found to be in good agreement with the analytical solution, with a root mean square percentage error (RMSPE) of RMSPE =  1.32%. The concentrations of A$_2$ and B$_2$ as a function of time are also plotted in [ver-1ib_comparison_pressure].

!media comparison_ver-1ib.py
       image_name=ver-1ib_comparison_pressure.png
       style=width:50%;margin-bottom:2%;margin-left:auto;margin-right:auto
       id=ver-1ib_comparison_pressure
       caption=Comparison of concentration of AB as a function of time calculated through TMAP8 and analytically for the solution in ratedep condition when A$_2$ and B$_2$ have unequal pressures [!citep](ambrosek2008verification).

## Input files

!style halign=left
The input file for this case can be obtained by updating the initial pressure for B$_2$ in [/ver-1ia.i], which is the approach used to create tests in TMAP8 at [/ver-1ib/tests].

!bibtex bibliography
