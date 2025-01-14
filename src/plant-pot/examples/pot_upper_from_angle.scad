use <../plant-pot.scad>;

num_sides = 32; // number of points for the polygon

body_thickness = 4;

body_height = 100;

lower_dia = 80;
angle = 12;
upper_dia = upper_rad_from_angle(angle, body_height, lower_dia);

echo("upper_dia: ", upper_dia);
echo("lower_dia: ", lower_dia);
echo("angle: ", angle);

lip_height = body_thickness * 4;
lip_thickness = body_thickness * 2;
lip_top_corner_radius = lip_thickness / 2 / 2;
lip_bottom_corner_radius = body_thickness / 3 / 2;
lip_fn = 32;

ivw = true;

if (ivw)
{
    ivw_thickness = 2;
    ivw_width = lower_dia / 4;
    ivw_height = body_height * 0.8;
    ivw_offset_angle = 90;
    plant_pot(body_height, body_thickness, upper_dia, lower_dia, lip_height, lip_thickness, lip_top_corner_radius,
              lip_bottom_corner_radius, lip_fn, ivw_thickness, ivw_width, ivw_height, ivw_offset_angle, num_sides);
}
else
{
    plant_pot(body_height, body_thickness, upper_dia, lower_dia, lip_height, lip_thickness, lip_top_corner_radius,
              lip_bottom_corner_radius, lip_fn, num_sides);
}