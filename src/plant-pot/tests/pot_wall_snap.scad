use <../plant-pot.scad>;

$fn = $preview ? 32 : 64; // number of fractions for a circle

// High numbers produce a circle, low numbers produce a polygon (i.e. 4 = square, 6 = hexagon, etc.)
num_sides = 32; // number of sides on the pot
// TODO: why does this break when set to above 32

// Main user parameters
body_thickness = 1.2;
body_height = 50;
upper_dia = 54;
lower_dia = 38;
collar_diameter = 100;
collar_height = 53;

// Internal vertical wall parameters
ivw = true; // Internal vertical wall flag

ivw_pos = true; // flag to create internal vertical walls
ivw_neg = true; // flag to create internal vertical slots

ivw_thickness = body_thickness; // Same thickness as the body
ivw_width = lower_dia / 2 / 3;  // 1/3 of the inner lower radius
ivw_height = body_height * 0.7; // 70% of the body height
ivw_offset_angle = 90;          // Offset angle for the internal vertical walls

// Snaps to click into the holder
snap_offset = 11; // Offset from the top of the body
snap_height_pos = body_height - snap_offset;
snap_radius = body_thickness * 0.75; // Radius of the snap
snap_gaps = [ 0.5, 4 ];              // 50%  and 4 gap cuts

if (ivw)
{
    plant_pot(body_height = body_height, body_thickness = body_thickness, upper_outer_diameter = upper_dia,
              lower_outer_diameter = lower_dia, ivw_thickness = ivw_thickness, ivw_width = ivw_width,
              ivw_height = ivw_height, pos_ivw = ivw_pos, neg_ivw = ivw_neg, ivw_offset_angle = ivw_offset_angle,
              snap_position = snap_height_pos, snap_radius = snap_radius, snap_gaps = snap_gaps,
              collar_height = collar_height, collar_diameter = collar_diameter, sides = num_sides, showlines = false);
}
else
{
    plant_pot(body_height = body_height, body_thickness = body_thickness, upper_outer_diameter = upper_dia,
              lower_outer_diameter = lower_dia, snap_position = snap_height_pos, snap_radius = snap_radius,
              collar_height = collar_height, collar_diameter = collar_diameter, sides = num_sides, showlines = false);
}