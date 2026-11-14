# Pot Comparison

- **Set sized pot with cleat retainer** has two variations:
  - Collar extension
  - No collar
- **Parameterized pot with snap-in retainer** has an arbitrary number of variations by changing the parameters:
  - Height, wall thickness, rim diameter, base diameter, lip dimensions, options for defining internal vertical walls (root support, shown to increase plant root biomass), number of faces (how "smooth" or circular the pot body is)

The comparison table compares the two cleat variations and four snap-in versions (collar and no collar) dimensioned to match the cleat pots.

| Name                                         | Mass (g) | Print Time (hh:mm) | File Name                                  |
| :------------------------------------------- | :------: | :----------------: | :----------------------------------------- |
| Set size no collar                           |  10.74   |       00:23        | pot_cup_cleat_nocollar (.3mf, .stl, .step) |
| Set size with collar                         |  27.37   |       00:49        | pot_cup_cleat (.3mf, .stl, .step)          |
| Parameterized no collar, no internal walls   |  11.21   |       00:20        | preset `pot_wall_snap` (.3mf)              |
| Parameterized no collar, with internal walls |  13.17   |       00:26        | preset `pot_wall_snap_ivw` (.3mf)          |
| Parameterized with collar, no internal walls |  29.24   |       00:48        | preset `pot_wall_snap_collar` (.3mf)       |
| Parameterized with collar and internal walls |  31.18   |       00:54        | preset `pot_wall_snap_collar_ivw` (.3mf)   |

The cleat pots are in `fusion-cleat-model/`, modelled in Fusion (`.f3d`, with
`.step`, `.stl` and `.3mf` exports). The parameterized pots come from
`test-prints/pot_wall_snap.scad`, one Customizer preset in
`test-prints/pot_wall_snap.json` per row. Export one with, for example:

```sh
openscad -p test-prints/pot_wall_snap.json -P pot_wall_snap_ivw -o pot_wall_snap_ivw.stl test-prints/pot_wall_snap.scad
```

The `.3mf` files are PrusaSlicer projects for these prints, with their slicer settings.
