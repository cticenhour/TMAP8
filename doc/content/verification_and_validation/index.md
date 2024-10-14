For [software quality assurance](sqa/index.md exact=True) purposes, TMAP8 undergoes verification and validation. Verification consists of comparing TMAP8 predictions against analytical solutions in different conditions, which are often simple cases. Validation consists of comparing TMAP8 predictions against experimental data.

Note that in addition to monitoring TMAP8 performance and reproducibility in verification and validation cases, the effects of changes made to TMAP8 are tracked. A series of automated tests are performed via continuous integration using [CIVET](https://civet.inl.gov/repo/530) to help identify any changes in TMAP8's predictions, therefore ensuring stability and robustness.

TMAP8 also contains [example cases](examples/tmap_index.md), which showcase how TMAP8 can be used. Finally, for more references of TMAP8 usage, a list of publications supporting TMAP8 development can be found [here](publications.md).

# List of verification cases

| Case    | Title                                                                                             |
| ------- | ------------------------------------------------------------------------------------------------- |
| ver-1a  | [Depleting Source Problem](ver-1a.md)                                                             |
| ver-1b  | [Diffusion Problem with Constant Source Boundary Condition](ver-1b.md)                            |
| ver-1c  | [Diffusion Problem with Partially Preloaded Slab](ver-1c.md)                                      |
| ver-1d  | [Permeation Problem with Trapping](ver-1d.md)                                                     |
| ver-1dc | [Permeation Problem with Multiple Trapping](ver-1dc.md)                                           |
| ver-1dd | [Permeation Problem without Trapping](ver-1dd.md)                                                 |
| ver-1e  | [Diffusion in Composite Material Layers](ver-1e.md)                                               |
| ver-1fa | [Heat Conduction with Heat Generation](ver-1fa.md)                                                |
| ver-1fb | [Thermal Transient](ver-1fb.md)                                                                   |
| ver-1fc | [Conduction in Composite Structure with Constant Surface Temperatures](ver-1fc.md)                |
| ver-1fd | [Convective Heating](ver-1fd.md)                                                                  |
| ver-1g  | [Simple Forward Chemical Reaction](ver-1g.md)                                                     |
| ver-1gc | [Series Chemical Reactions](ver-1gc.md)                                                           |
| ver-1ha | [Convective Gas Outflow Problem in Three Enclosures](ver-1ha.md)                    |
| ver-1hb | [Convective Gas Outflow Problem in Equilibrating Enclosures](ver-1hb.md)        |
| ver-1ja | [Radioactive Decay of Mobile Tritium in a Slab](ver-1ja.md)                                       |
| ver-1jb | [Radioactive Decay of Mobile Tritium in a Slab with a Distributed Trap Concentration](ver-1jb.md) |


# List of benchmarking cases

| Case    | Title                                                                              |
| ------- | ---------------------------------------------------------------------------------- |
| ver-1fc | [Conduction in Composite Structure with Constant Surface Temperatures](ver-1fc.md) |


# List of validation cases

| Case   | Title                                          |
| ------ | ---------------------------------------------- |
| val-2b | [Diffusion Experiment in Beryllium](val-2b.md) |
