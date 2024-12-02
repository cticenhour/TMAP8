# ver-1a

# Depleting Source Problem

## General Case Description

This verification case consists of an enclosure containing a finite concentration of atoms which
are allowed to thermally diffuse through a SiC layer over time. No Soret effects, solubility, or trapping effects are included.

This is one of the original problems introduced in [!cite](longhurst1992verification) for TMAP4 and adapted in [!cite](ambrosek2008verification) for TMAP7. Note, however, that the verification cases for TMAP4 and TMAP7, although using the exact same setup, use different quantities to verify their implementation (see [ver-1a_comparison_analytical_TMAP4_release_fraction], [ver-1a_comparison_analytical_TMAP7_release_fraction], and [ver-1a_comparison_analytical_TMAP7_flux]). In TMAP8, for completeness, we perform verification on all these quantities and show agreement with analytical solutions from both TMAP4 and TMAP7.

## Case Set up

[ver-1a_schematic] shows a schematic of the ver-1a case, along with an illustration of the quantities used for verification. It consists of an enclosure that is pre-charged with a fixed quantity of tritium in gaseous form and a finite SiC slab. At time t > 0, the tritium is allowed to thermally diffuse through the SiC slab, initially at zero concentration. The surface of the slab in contact with the source is assumed to be in equilibrium with the source enclosure, assuming a temperature-dependent solubility $S$. As a boundary condition, the concentration at the outer surface of the SiC slab is kept at zero for all time. The diffusion of the tritium through the SiC slab is calculated by neglecting Soret and trapping effects. Different aspects of the diffusion are compared against analytical solutions, as described below. The values used to characterize the necessary material properties and the case geometry are provided in [ver-1a_set_up_values].

!media figures/ver-1a_schematic.png
    style=width:50%;margin-bottom:2%;margin-left:auto;margin-right:auto
    id=ver-1a_schematic
    caption= Schematic of the ver-1a case and illustration of the quantities used for verification.

!table id=ver-1a_set_up_values caption=Values of material properties and case geometry with $R$, the gas constant, as defined in [PhysicalConstants](source/utils/PhysicalConstants.md).
| Parameter | Description                | Value                                  | Units      |
| --------- | -------------------------- | -------------------------------------- | ---------- |
| $V$       | Enclosure volume           | 5.20e-11                               | m$^3$      |
| $A$       | SiC slab surface area      | 2.16e-6                                | m$^2$      |
| $P_0$     | Initial enclosure pressure | 1e6                                    | Pa         |
| $T$       | Temperature                | 2373                                   | K          |
| $D$       | Tritium diffusivity in SiC | 1.58e-4 $\times \exp(-308000.0/(R*T))$ | m$^2$/2    |
| $S$       | Tritium solubility in SiC  | 7.244e22 / $T$                         | 1/m$^3$/Pa |
| $l$       | Slab thickness             | 3.30e-5                                | m          |

## Verification of the release fraction on the outer surface of the SiC slab (TMAP4)

### Analytical solution

In [!cite](longhurst1992verification), i.e., TMAP4, the verification test focused on the fractional release from the outside of the slab. The analytical solution for this quantity is given by

\begin{equation}
    FR(t) = 1.0 - \sum_{n=1}^{\infty} \frac{2\ L \sec (\alpha_{n}) \exp\left(-\alpha_{n}^2[D t/l^{2}]\right)}{L(L+1) + \alpha_n^{2}},
\end{equation}

where

\begin{equation}
    L = \frac{lA}{V \phi}
\end{equation}
with
\begin{equation}
    \phi = \frac{\text{source concentration}}{\text{layer concentration}} = \frac{1}{S k_b T},
\end{equation}

where the "source concentration" is the concentration in the enclosure ($P(t)/k_b/T$), $k_b$ is the Boltzmann constant (as defined in [PhysicalConstants](source/utils/PhysicalConstants.md)), and "layer concentration" is the concentration in the slab at the interface with the enclosure ($S P(t)$). $\phi$ is constant in time, and $\alpha_n$ are the roots of

\begin{equation}
    \alpha_n = \frac{L}{\tan \ \alpha_n}.
\end{equation}


!alert warning title=Typo in [!cite](longhurst1992verification)
The expression in Eq. (1) of [!cite](longhurst1992verification) writes $-\alpha_{n}^2(D T/l^{2})$ instead of the correct $-\alpha_{n}^2(D t/l^{2})$ in the exponential. If the interested reader needs convincing, analyze the units in the original report for consistency. Despite this typo, their results are accurate.


### Results

[ver-1a_comparison_analytical_TMAP4_release_fraction] shows the comparison of the TMAP8 calculation and the analytical solution provided in [!cite](longhurst1992verification). There is agreement between the two plots with a root mean square percentage error of RMSPE = 0.19 % for $t \geq 1$ s.

!media comparison_ver-1a.py
       image_name=ver-1a_comparison_analytical_TMAP4_release_fraction.png
       style=width:50%;margin-bottom:2%;margin-left:auto;margin-right:auto
       id=ver-1a_comparison_analytical_TMAP4_release_fraction
       caption=Comparison of TMAP8 calculation with the analytical solution for the release fraction on the outer surface of the SiC slab [!cite](longhurst1992verification).

## Verification of the release fraction on the inner surface of the SiC slab (TMAP7)

### Analytical solution

In [!cite](ambrosek2008verification), i.e., TMAP7, the verification test focuses on the fractional release as determined by the amount of gas release from the enclosure. It is therefore defined as
\begin{equation}
    FR(t) = 1.0 - \frac{P(t)}{P_0},
\end{equation}
where $P(t)$ is the pressure at the surface of the enclosure over time.

To derive $FR(t)$, [!cite](ambrosek2008verification) first references the analytical solution for an analogous heat transfer problem [!cite](Carslaw1959conduction), which provides the solute concentration profile in the membrane as

\begin{equation}
    C(x,t) = 2 S P_0 L' \sum_{n=1}^{\infty} \frac{\exp \left(-\alpha_{n}^2 D t\right) \sin (\alpha_{n} x)}{[l(\alpha_{n}^2 + L'^2)+L'] \sin (\alpha_{n} l)},
\end{equation}
where $x=l$ is the position of the surface in contact with the enclosure, and $x=0$ is the position of the outer surface (as defined in [!cite](ambrosek2008verification) - see note below),
\begin{equation}
    L' = \frac{S T A k_b}{V},
\end{equation}
and $\alpha_n$ are the roots of
\begin{equation}
    \alpha_n = \frac{L}{\tan (\alpha_n l)}.
\end{equation}

By linking the concentration on the surface of the slab in contact with the enclosure ($x=l$ as used in [!cite](ambrosek2008verification)) with the pressure of the enclosure, Henry's law provides
\begin{equation}
    P(t) = \frac{C(l,t)}{S} = 2 P_0 L' \sum_{n=1}^{\infty} \frac{\exp \left(-\alpha_{n}^2 D t\right)}{l(\alpha_{n}^2 + L'^2)+L'},
\end{equation}
which leads to
\begin{equation}
    FR(t) = 1.0 - \frac{P(t)}{P_0} = 1 - 2 L' \sum_{n=1}^{\infty} \frac{\exp \left(-\alpha_{n}^2 D t\right)}{l(\alpha_{n}^2 + L'^2)+L'}.
\end{equation}

!alert warning title=Typos in [!cite](ambrosek2008verification)
1. The units and expression of the solubility provided in [!cite](ambrosek2008verification) have typos. The correct values and units are provided above in [ver-1a_set_up_values]. The value provided in [!cite](ambrosek2008verification) is $S=3.053 \times 10^{\bold{\underline{29}}}$ kg $\cdot$ m $^2$/s$^2$ instead of $S=7.244\times 10^{22} / T = 3.053 \times 10^{\bold{\underline{19}}}$ 1/m$^3$/Pa when $T=2373$ K. The correct value of $S$ is used in the input file decks in [!cite](longhurst1992verification,ambrosek2008verification).
2. The release fraction in [!cite](ambrosek2008verification) is described as $P(t)/P_0$ in their Eq. (5) but is actually plotted as $1-(P(t)/P_0)$ in Figure 1 of that report.
3. Not a typo, per se, but a potential source of confusion for users is that in [!cite](ambrosek2008verification), $x=0$ represents the surface not exposed to the enclosure (where $c=0$), and $x=l$ represents the surface exposed to the enclosure. In the TMAP8 documentation, we have kept this convention to correspond to the TMAP7 case, but note that the TMAP8 input file fixes $x=0$ at the enclosure surface and $x=l$ for the outer surface.

### Results

[ver-1a_comparison_analytical_TMAP7_release_fraction] shows the comparison of the TMAP8 calculation and the analytical solution for release fraction provided in [!cite](ambrosek2008verification). There is agreement between the two plots with a root mean square percentage error of RMSPE = 0.07 % for $t \geq 1$ s.

!media comparison_ver-1a.py
       image_name=ver-1a_comparison_analytical_TMAP7_release_fraction.png
       style=width:50%;margin-bottom:2%;margin-left:auto;margin-right:auto
       id=ver-1a_comparison_analytical_TMAP7_release_fraction
       caption=Comparison of TMAP8 calculation with the analytical solution for the release fraction on the inner surface of the SiC slab [!cite](ambrosek2008verification).

## Verification of the tritium flux at the outer surface of the SiC slab (TMAP7)

### Analytical solution

In [!cite](ambrosek2008verification), i.e., TMAP7, the verification test also tests the model's accuracy in determining the tritium flux across the outer surface of the SiC slab. Using the expression of the concentration provided above, the flux on the outer surface of the SiC slab can be derived as

\begin{equation}
    J(t) = D \frac{\partial C(x,t)}{\partial x}\Bigr|_{\substack{x=0}} = 2 S P_0 L' D \sum_{n=1}^{\infty} \frac{\exp \left(-\alpha_{n}^2 D t\right) \alpha_{n}}{[l(\alpha_{n}^2 + L'^2)+L'] \sin (\alpha_{n} l)},
\end{equation}
which can be compared to TMAP8 predictions.

!alert warning title=Typos in [!cite](ambrosek2008verification)
Again, be aware of the typos in [!cite](ambrosek2008verification) and the different coordinates used in TMAP8 and TMAP7 discussed above.

### Results

[ver-1a_comparison_analytical_TMAP7_flux] shows the comparison of the TMAP8 calculation and the analytical solution for flux at the outer surface of the SiC slab in [!cite](ambrosek2008verification). There is agreement between the two plots with a root mean square percentage error of RMSPE = 0.26 % for $t \geq 1$ s.

!media comparison_ver-1a.py
       image_name=ver-1a_comparison_analytical_TMAP7_flux.png
       style=width:50%;margin-bottom:2%;margin-left:auto;margin-right:auto
       id=ver-1a_comparison_analytical_TMAP7_flux
       caption=Comparison of TMAP8 calculation with the analytical solution for the tritium flux at the outer surface of the SiC slab [!cite](ambrosek2008verification).

## Input files

!style halign=left
It is important to note that the input file used to reproduce these results and the input file used as test in TMAP8 are different. Indeed, the input file [/ver-1a.i] has a fine mesh and uses small time steps to accurately match the analytical solutions and reproduce the figures above. To limit the computational costs of the tests, however, the tests run a version of the file with a coarser mesh and larger time steps. More information about the changes can be found in the test specification file for this case [/ver-1a/tests].

!bibtex bibliography
