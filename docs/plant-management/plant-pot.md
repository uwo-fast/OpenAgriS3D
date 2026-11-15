# Plant Pot

- **Author:** Cameron K. Brooks, FAST Research Group
- **Licence:** MIT (see [LICENSING.md](../../LICENSING.md))
- **Source:** this repository, `cad/plant-pot/`

A tapered flowerpot, made by the `plant_pot()` module in
`cad/plant-pot/plant-pot.scad`. It is a library: it renders nothing on its own.

## Parameters

- **Body:** `body_height`, `body_thickness`, `upper_outer_diameter`,
  `lower_outer_diameter`, and `sides`, the number of faces around the body.
- **Lip** (optional, drawn only when all four are set): `lip_height`,
  `lip_thickness`, and the lip's top and bottom corner radii. `lip_fn` sets its
  smoothness.
- **Collar** (optional): `collar_height` and `collar_diameter`.
- **Snap ring** (optional), a ring around the body: `snap_position`,
  `snap_radius` and `snap_gaps`.
- **Internal vertical walls** (optional): `ivw_thickness`, `ivw_width`,
  `ivw_height` and `ivw_offset_angle`. `pos_ivw` adds four walls inside the pot.
  `neg_ivw` cuts four matching slots through the base.

## Use it

- `cad/plant-pot/examples/` has three pots sized in different ways: from two
  diameters, or from a wall angle and the upper or lower diameter.
- `cad/plant-pot/test-prints/pot_wall_snap.scad` is the snap-in pot. Its Customizer
  presets in `pot_wall_snap.json` cover each combination of collar and internal walls.
  From `cad/plant-pot/`:

  ```sh
  openscad -p test-prints/pot_wall_snap.json -P pot_wall_snap_ivw -o pot_wall_snap_ivw.stl test-prints/pot_wall_snap.scad
  ```

[`pot_comparison.md`](../../cad/plant-pot/pot_comparison.md) gives the mass and print
time of each preset against the two fixed-size cleat pots.

## Internal vertical walls

The optional walls follow
[Container Design Affects Shoot and Root Growth of Vegetable Plant](https://doi.org/10.21273/HORTSCI14954-20)
(HortScience 55(6), 787-794, 2020). In cucumber, pepper and tomato seedlings,
containers with internal vertical walls gave more root surface and biomass.
The type of container (round or square) had no effect, and the substrate (coir
fibre or perlite) no significant one. The authors suggest the walls may also help plants through
water deficit and transplanting.
