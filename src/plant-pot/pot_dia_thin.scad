use <plant-pot.scad>;

num_sides = 32; // number of points for the polygon

body_thickness = 2;
body_height = 100;

upper_dia = 100;
lower_dia_diff = 20;
lower_dia = upper_dia - lower_dia_diff;

echo("upper_dia: ", upper_dia);
echo("lower_dia: ", lower_dia);

resulting_angle = cone_angle(upper_dia, lower_dia, body_height);
echo("resulting_angle: ", resulting_angle);

lip_height = body_thickness * 4;
lip_thickness = body_thickness * 2;
lip_top_corner_radius = lip_thickness / 2;
lip_bottom_corner_radius = body_thickness / 3;
lip_fn = 32;

ivw_thickness = body_thickness;
ivw_width = lower_dia / 4;
ivw_height = body_height * 0.8;
ivw_offset_angle = 90;

ivw = true;

if (ivw)
{

    plant_pot(body_height, body_thickness, upper_dia, lower_dia, lip_height, lip_thickness, lip_top_corner_radius,
              lip_bottom_corner_radius, lip_fn, ivw_thickness, ivw_width, ivw_height, ivw_offset_angle, num_sides);
}
else
{
    plant_pot(body_height, body_thickness, upper_dia, lower_dia, lip_height, lip_thickness, lip_top_corner_radius,
              lip_bottom_corner_radius, lip_fn, num_sides);
}