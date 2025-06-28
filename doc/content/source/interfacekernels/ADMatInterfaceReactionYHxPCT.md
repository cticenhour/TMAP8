# ADMatInterfaceReactionYHxPCT

!syntax description /InterfaceKernels/ADMatInterfaceReactionYHxPCT

## Description

The composition of metal hydrides like yttrium hydride (YHx) is described by pressure-composition-temperature (PCT) data.
In TMAP8, the PCT curve can be imposed by an interface kernel that then dictates the material composition.
Hence, the `ADMatInterfaceReactionYHxPCT` interface kernel imposes the surface concentration of H in YHx based on the input pressure (Pa) and temperature (K). `ADMatInterfaceReactionYHxPCT` is related to [ADMatInterfaceReaction.md], but includes the YHx PCT curves.
 At the interface between a solid (main) and a gas (neighbor), it imposes:
\begin{equation} \label{eq:test_interfacereactionYHxPCT}
\frac{d C_s}{dt} = 0 = K ( f_{at}(T,P) \rho - C_s ),
\end{equation}
where $C_s$ is the surface H concentration,
$K$ is the surface reaction rate,
$f_{at}(T,P)$ is the composition in atomic fraction of H in YHx given a gas temperature $T$ and gas pressure $P$,
and $\rho$ is the yttrium atomic density.

[YHx_PCT_fit_2D] shows the data used in this interface kernel. The experimental data originates from [!cite](Lundin_1962), and the fit is from [!cite](Matthews2021SWIFT).

!media comparison_YHx_PCT.py
       image_name=YHx_PCT_fit_2D.png
       style=width:80%;margin-bottom:2%;margin-left:auto;margin-right:auto
       id=YHx_PCT_fit_2D
       caption=PCT data for YHx from [!cite](Lundin_1962) with fits from [!cite](Matthews2021SWIFT) implemented in TMAP8, and test results.

The plateau representing phase transition is captured as [!citep](Matthews2021SWIFT):
\begin{equation} \label{eq:pressure_plateau}
P_{lim} = \exp\left(-26.1+3.88 \times 10^{-2} T - 9.7 \times 10^{-6} T^2 \right),
\end{equation}
with $P_{lim}$ being the hydrogen partial pressure limit delineating the plateau in Pa and $T$ being the temperature in K.
This fit is shown in [YHx_PCT_plateau_pressure_fit].

!media comparison_YHx_PCT.py
       image_name=YHx_PCT_plateau_pressure_fit.png
       style=width:50%;margin-bottom:2%;margin-left:auto;margin-right:auto
       id=YHx_PCT_plateau_pressure_fit
       caption=Fit phase transition region as pressure as a function of temperature.

The model currently only captures the high pressure region of the data, i.e., for pressure and temperatures above the plateau, the atomic fraction $f_{at}$ is determined as [!citep](Matthews2021SWIFT):
\begin{equation} \label{eq:atomic_fraction}
f_{at}(T,P) = 2-\left[1+\exp(21.6 -0.0225 T + (-0.0445 + 7.18 \times 10^{-4} T) (\log\left(P - P_{lim}(T)\right)))\right]^{-1},
\end{equation}
where $P$ is the hydrogen partial pressure in Pa. This fit is plotted in [YHx_PCT_fit_2D].

The `silence_warning` option can be used to dictates how TMAP8 reacts when the pressure gets out of bounds.
If `silence_warning = false`, which is the default behavior, then TMAP8 will print a warning stating that the pressure and temperature are outside the bounds of the atomic fraction correlation.
If `silence_warning = true`, then TMAP8 will let the simulation continue without issuing any warnings.

## Test

[/YHx_PCT.i] tests the implantation of the YHx PCT curves in TMAP8.
The domain contains two blocks: gas (left) and YHx (right) with an interface between the two blocks.
The diffusion is given by [!citep](MAJER2002438) and the surface reaction rate $K$ is taken from [!citep](FISHER19841536).
To model the interface, the input file employs the [InterfaceDiffusion.md] object to model the flux of hydrogen at the surface, and `ADMatInterfaceReactionYHxPCT` to model the steady-state condition for the hydrogen concentration at the surface $C_s$ defined by:
\begin{equation} \label{eq:test_interfacereaction}
\frac{d C_s}{dt} = 0 = K (f_{at}(T,P) \rho - C_s),
\end{equation}
where $\rho$ is the yttrium atomic density.

The results of the test for ($T$, $P$) = (1173.15 K, $1 \times 10^{3}$ Pa), (1173.15 K, $1 \times 10^{4}$ Pa), (1173.15 K, $5 \times 10^{4}$ Pa), and(1473.15 K, $5 \times 10^{4}$ Pa) are shown in [YHx_PCT_fit_2D] and show good agreement with the implanted expression listed in [eq:atomic_fraction].

## Example Input File Syntax

!listing test/tests/yttrium_hydrogen_system/YHx_PCT.i block=InterfaceKernels/interface_reaction_YHx_PCT

!syntax parameters /InterfaceKernels/ADMatInterfaceReactionYHxPCT

!syntax inputs /InterfaceKernels/ADMatInterfaceReactionYHxPCT

!syntax children /InterfaceKernels/ADMatInterfaceReactionYHxPCT

