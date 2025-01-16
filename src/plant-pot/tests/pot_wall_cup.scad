use <../plant-pot.scad>;

// Parameters
num_sides = 32; // number of points for the polygon
body_thickness = 1.2;
body_height = 50;

upper_dia = 54;
lower_dia = 38;
echo("upper_dia: ", upper_dia);
echo("lower_dia: ", lower_dia);

resulting_angle = cone_angle(upper_dia, lower_dia, body_height);
echo("resulting_angle: ", resulting_angle);

// Lip parameters as a function of the body_thickness
lip_height = body_thickness * 4;
lip_thickness = body_thickness * 1.5;
lip_top_corner_radius = lip_thickness / 2;
lip_bottom_corner_radius = body_thickness / 3;
lip_fn = 32;

ivw = true; // Internal vertical wall flag

if (ivw)
{

    ivw_pos = true; // Internal vertical wall flag to create internal vertical walls
    ivw_neg = true; // Internal vertical wall flag to create internal vertical (slot/negative) in the walls

    // Internal vertical wall parameters
    ivw_thickness = body_thickness;
    ivw_width = lower_dia / 3 / 2;
    ivw_height = body_height * 0.7;
    ivw_offset_angle = 90;

    resize(newsize = [ upper_dia, upper_dia, body_height ])
        plant_pot(body_height = body_height, body_thickness = body_thickness, upper_outer_diameter = upper_dia,
                  lower_outer_diameter = lower_dia, lip_height = lip_height, lip_thickness = lip_thickness,
                  lip_top_corner_radius = lip_top_corner_radius, lip_bottom_corner_radius = lip_bottom_corner_radius,
                  lip_fn = lip_fn, ivw_thickness = ivw_thickness, ivw_width = ivw_width, ivw_height = ivw_height,
                  pos_ivw = ivw_pos, neg_ivw = ivw_neg, ivw_offset_angle = ivw_offset_angle, sides = num_sides,
                  showlines = false);
}
else
{
    resize(newsize = [ upper_dia, upper_dia, body_height ])
        plant_pot(body_height = body_height, body_thickness = body_thickness, upper_outer_diameter = upper_dia,
                  lower_outer_diameter = lower_dia, lip_height = lip_height, lip_thickness = lip_thickness,
                  lip_top_corner_radius = lip_top_corner_radius, lip_bottom_corner_radius = lip_bottom_corner_radius,
                  lip_fn = lip_fn, sides = num_sides, showlines = false);
}