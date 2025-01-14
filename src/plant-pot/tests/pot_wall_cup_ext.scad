use <../plant-pot.scad>;

num_sides = 32; // number of points for the polygon

body_thickness = 1.2;
body_height = 50;

upper_dia = 54 + 1;
lower_dia = 38;

collar_diameter = 100;
collar_height = 53;

ivw = true;
slots = true;

if (ivw)
{
    ivw_thickness = body_thickness / 2;                   // half of the body thickness
    ivw_width = (lower_dia - body_thickness * 2) / 2 / 3; // 1/3 of the inner lower radius
    ivw_height = body_height * 0.8;                       // 80% of the body height

    plant_pot(body_height = body_height, body_thickness = body_thickness, upper_outer_diameter = upper_dia,
              lower_outer_diameter = lower_dia, ivw_thickness = ivw_thickness, ivw_width = ivw_width,
              ivw_height = ivw_height, pos_ivw = ivw, neg_ivw = slots, collar_height = collar_height,
              collar_diameter = collar_diameter, sides = num_sides);
}
else
{
    plant_pot(body_height = body_height, body_thickness = body_thickness, upper_outer_diameter = upper_dia,
              lower_outer_diameter = lower_dia);
}