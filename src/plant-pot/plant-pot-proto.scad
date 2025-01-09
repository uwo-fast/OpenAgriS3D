// plant pot

$fn = 32; // [16:512]

rot_poly = 16; // number of points for the polygon

zFite = 0.1; // z offset for fitting

body_thickness = 4;

body_height = 100;

upper_outer_diameter = 100;
upper_inner_diameter = upper_outer_diameter - 2 * body_thickness;

lower_dia_diff = 20;
lower_outer_diameter = upper_outer_diameter - lower_dia_diff;
lower_inner_diameter = lower_outer_diameter - 2 * body_thickness;

// calculate cone angle
cone_angle = atan((upper_outer_diameter - lower_outer_diameter) / (2 * body_height));

echo("cone angle: ", cone_angle);

showlines = false;

ivw_thickness = 2;
ivw_width = lower_inner_diameter / 4;
ivw_height = body_height * 0.8;
ivw_offset_angle = 90;

lip_height = body_thickness * 4;
lip_thickness = body_thickness * 2;
lip_top_corner_radius = lip_thickness / 2 / 2;
lip_bottom_corner_radius = body_thickness / 3 / 2;

// body
module body()
{
    translate([ 0, 0, body_thickness ]) difference()
    {
        cylinder(h = body_height, d1 = lower_outer_diameter, d2 = upper_outer_diameter, $fn = rot_poly);
        translate([ 0, 0, -zFite / 2 ])
            cylinder(h = body_height + zFite, d1 = lower_inner_diameter, d2 = upper_inner_diameter, $fn = rot_poly);
    }
    if (showlines)
    {
        // draw lines to show the cone angle
        translate([ lower_outer_diameter / 2, 0, 0 ]) rotate(a = cone_angle, v = [ 0, 1, 0 ]) color("red")
            cube([ 1, 1, body_height ], center = false);

        color("blue") translate([ upper_outer_diameter / 2, 0, 0 ]) cube([ 1, 1, body_height ], center = false);
    }
}

// base
module base()
{
    rotate_extrude(angle = 360, convexity = 10, $fn = rot_poly)
        translate([ lower_inner_diameter / 2, body_thickness ]) union()
    {
        difference()
        {
            circle(body_thickness);

            square([ body_thickness, body_thickness ]);

            translate([ -body_thickness, -body_thickness ]) square([ body_thickness, body_thickness * 2 ]);
        }

        translate([ -lower_inner_diameter / 2, -body_thickness ]) square([ lower_inner_diameter / 2, body_thickness ]);
    }
}

function arc_points(radius, angle, angle_offset = 0) =
    let(step = angle / ($fn - 1),
        points = [for (i = [0:$fn -
                              1])[radius * cos(angle_offset + i * step), radius *sin(angle_offset + i * step)]]) points;

function translatePts(points, offset) = [for (p = points)[p[0] + offset[0], p[1] + offset[1]]];

module lip()
{ // points_bl = arc_points(lip_top_corner_radius, 90, 180);
    points_bl = [[ 0, 0 ]];
    points_br = translatePts(arc_points(lip_bottom_corner_radius, 90, 270),
                             [ lip_thickness - lip_bottom_corner_radius, lip_bottom_corner_radius ]);

    points_tl = translatePts(arc_points(lip_top_corner_radius, 90, 90),
                             [ +lip_top_corner_radius, lip_height - lip_top_corner_radius ]);
    points_tr = translatePts(arc_points(lip_top_corner_radius, 90, 0),
                             [ lip_thickness - lip_top_corner_radius, lip_height - lip_top_corner_radius ]);

    lip_poly = concat(points_br, points_tr, points_tl, points_bl);

    translate([ 0, 0, body_height + body_thickness ])
    {
        rotate_extrude(angle = 360, convexity = 10, $fn = rot_poly) translate([ upper_inner_diameter / 2, 0 ])
            polygon(lip_poly);
    }
}

// lip seam
module lip_seam()
{
    translate([ 0, 0, body_height + body_thickness - lip_bottom_corner_radius ])
    {
        rotate_extrude(angle = 360, convexity = 10, $fn = rot_poly) translate([ upper_outer_diameter / 2, 0 ])
            difference()
        {

            square([ lip_bottom_corner_radius, lip_bottom_corner_radius ]);
            translate([ lip_bottom_corner_radius, 0 ]) circle(r = lip_bottom_corner_radius);
        }
    }
}

module internal_vertical_wall()
{
    d_prime = upper_inner_diameter - (body_height + body_thickness) * tan(cone_angle);
    ivw_pts =
        [ [ 0, 0 ], [ ivw_width, 0 ], [ ivw_width + ivw_height * tan(cone_angle), ivw_height ], [ 0, ivw_height ] ];
    translate([ lower_inner_diameter / 2 - ivw_width, ivw_thickness / 2, body_thickness ]) rotate([ 90, 0, 0 ])
        linear_extrude(ivw_thickness) polygon(ivw_pts);
}

module plant_pot()
{
    union()
    {
        body();
        base();
        lip();
        lip_seam();
        for (i = [0:3])
        {
            rotate([ 0, 0, i * 90 ]) internal_vertical_wall();
        }
    }
}

plant_pot();