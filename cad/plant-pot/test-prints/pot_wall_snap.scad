use <../plant-pot.scad>;

$fn = $preview ? 32 : 64; // number of fractions for a circle

// High numbers produce a circle, low numbers produce a polygon (i.e. 4 = square, 6 = hexagon, etc.)
num_sides = 32; // number of sides on the pot
// TODO: why does this break when set to above 32

// Diameter of the nozzle for the 3D printer
nozzle_diameter = 0.4;
// Number of nozzle diameters for the thickness of the body
body_thicknesses = 3;
// Thickness of the body
body_thickness = nozzle_diameter * body_thicknesses;
// Dimensions of the pot
body_height = 50;
// upper diameter of the pot
upper_dia = 54;
// lower diameter of the pot
lower_dia = 38;
// collar diameter
collar_diameter = 100;
// collar height
collar_height = 53;

// Internal vertical wall flag
ivw = true;
// flag to create internal vertical walls
ivw_pos = true;
// flag to create internal vertical slots
ivw_neg = true;

// thickness of the internal vertical walls
ivw_thickness = body_thickness;
// width of the internal vertical walls
ivw_width = lower_dia / 2 / 3;
// height of the internal vertical walls
ivw_height = body_height * 0.7;

// Offset from the top of the body
snap_offset = 11;
// [percentage of circumfirence to cover, number of gaps]
snap_gaps = [ 0.25, 4 ];

// Position of the snap
snap_height_pos = body_height - snap_offset;
// Radius of the snap
snap_radius = nozzle_diameter;

if (ivw)
{
    plant_pot(body_height = body_height, body_thickness = body_thickness, upper_outer_diameter = upper_dia,
              lower_outer_diameter = lower_dia, ivw_thickness = ivw_thickness, ivw_width = ivw_width,
              ivw_height = ivw_height, pos_ivw = ivw_pos, neg_ivw = ivw_neg, snap_position = snap_height_pos,
              snap_radius = snap_radius, snap_gaps = snap_gaps, collar_height = collar_height,
              collar_diameter = collar_diameter, sides = num_sides, showlines = false);
}
else
{
    plant_pot(body_height = body_height, body_thickness = body_thickness, upper_outer_diameter = upper_dia,
              lower_outer_diameter = lower_dia, snap_position = snap_height_pos, snap_radius = snap_radius,
              collar_height = collar_height, collar_diameter = collar_diameter, sides = num_sides, showlines = false);
}