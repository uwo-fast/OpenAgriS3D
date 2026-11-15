# Root Scaffold

A concept, with no design yet: an OpenSCAD generator for root-guiding scaffolds.
Each scaffold would be printed in biodegradable filament and set into a pot, so roots
follow its paths and the scaffold decomposes later.

It would build on two existing generators:

- Field-guided recursive trees: [CameronBrooks11/GeoGrow](https://github.com/CameronBrooks11/GeoGrow)
- Lindenmayer systems: [CameronBrooks11/L-System-SCAD](https://github.com/CameronBrooks11/L-System-SCAD)

## Why it could work

- **Barriers redirect roots.** Roots grow along and around obstacles in the soil
  ([PMC9366319](https://pmc.ncbi.nlm.nih.gov/articles/PMC9366319),
  [PMC7522252](https://pmc.ncbi.nlm.nih.gov/articles/PMC7522252)).
- **Structure steers growth.** Structural inhomogeneities can induce preferential
  root tropism ([arXiv:1901.10402](https://arxiv.org/abs/1901.10402)).
- **Resistance shapes elongation.** Mechanical impedance affects root elongation,
  so a material that resists for a while can influence growth patterns
  ([Sci. Rep.](https://www.nature.com/articles/s41598-023-34025-x)).

## Open questions

- How fast should the material degrade: slowly enough to guide roots, quickly enough
  not to hinder them? PLA blends and PHA are the obvious candidates.
- Does it work? That needs trials with and without scaffolds, comparing biomass,
  growth rate and root architecture.
- Is it cheap and practical beyond a single pot?
