// plant pot
zFite = $preview ? 0.1 : 0; // z-fighting fix

function cone_angle(d1, d2, h) = atan((d1 - d2) / (2 * h));

function lower_rad_from_angle(angle, h, d1) = d1 - 2 * h * tan(angle);

function upper_rad_from_angle(angle, h, d2) = d2 + 2 * h * tan(angle);

// body
module body(body_height, upper_outer_diameter, lower_outer_diameter, body_thickness, rot_poly, showlines = false)
{
    upper_inner_diameter = upper_outer_diameter - 2 * body_thickness;
    lower_inner_diameter = lower_outer_diameter - 2 * body_thickness;
    translate([ 0, 0, body_thickness ]) difference()
    {
        cylinder(h = body_height, d1 = lower_outer_diameter, d2 = upper_outer_diameter, $fn = rot_poly);
        translate([ 0, 0, -zFite / 2 ])
            cylinder(h = body_height + zFite, d1 = lower_inner_diameter, d2 = upper_inner_diameter, $fn = rot_poly);
    }
    if (showlines)
    {
        // draw lines to show the cone angle
        translate([ lower_outer_diameter / 2, 0, 0 ])
            rotate(a = cone_angle(upper_outer_diameter, lower_outer_diameter, body_height), v = [ 0, 1, 0 ])
                color("red") cube([ 1, 1, body_height ], center = false);

        color("blue") translate([ upper_outer_diameter / 2, 0, 0 ]) cube([ 1, 1, body_height ], center = false);
    }
}

// base
module base(lower_outer_diameter, body_thickness, rot_poly)
{
    lower_inner_diameter = lower_outer_diameter - 2 * body_thickness;
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

function arc_points(radius, angle, fn, angle_offset = 0) =
    let(step = angle / (fn - 1),
        points = [for (i = [0:fn -
                              1])[radius * cos(angle_offset + i * step), radius *sin(angle_offset + i * step)]]) points;

function translatePts(points, offset) = [for (p = points)[p[0] + offset[0], p[1] + offset[1]]];

module lip(lip_height, lip_thickness, lip_top_corner_radius, lip_bottom_corner_radius, lip_fn, body_height,
           body_thickness, upper_outer_diameter, rot_poly)
{
    upper_inner_diameter = upper_outer_diameter - 2 * body_thickness;
    // points_bl = arc_points(lip_top_corner_radius, 90, 180);
    points_bl = [[ 0, 0 ]];
    points_br = translatePts(arc_points(lip_bottom_corner_radius, 90, lip_fn, 270),
                             [ lip_thickness - lip_bottom_corner_radius, lip_bottom_corner_radius ]);

    points_tl = translatePts(arc_points(lip_top_corner_radius, 90, lip_fn, 90),
                             [ +lip_top_corner_radius, lip_height - lip_top_corner_radius ]);
    points_tr = translatePts(arc_points(lip_top_corner_radius, 90, lip_fn, 0),
                             [ lip_thickness - lip_top_corner_radius, lip_height - lip_top_corner_radius ]);

    lip_poly = concat(points_br, points_tr, points_tl, points_bl);

    translate([ 0, 0, body_height + body_thickness ])
    {
        rotate_extrude(angle = 360, convexity = 10, $fn = rot_poly) translate([ upper_inner_diameter / 2, 0 ])
            polygon(lip_poly);
    }
}

// lip seam
module lip_seam(lip_bottom_corner_radius, lip_thickness, body_height, body_thickness, upper_outer_diameter, rot_poly)
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

module internal_vertical_wall(upper_outer_diameter, lower_outer_diameter, body_height, body_thickness, ivw_thickness,
                              ivw_width, ivw_height, ivw_offset_angle)
{
    lower_inner_diameter = lower_outer_diameter - 2 * body_thickness;
    ivw_pts = [
        [ 0, 0 ], [ ivw_width, 0 ],
        [
            ivw_width + ivw_height * tan(cone_angle(upper_outer_diameter, lower_outer_diameter, body_height)),
            ivw_height
        ],
        [ 0, ivw_height ]
    ];
    translate([ lower_inner_diameter / 2 - ivw_width, ivw_thickness / 2, body_thickness ]) rotate([ 90, 0, 0 ])
        linear_extrude(ivw_thickness) polygon(ivw_pts);
}

module plant_pot(body_height, body_thickness, upper_outer_diameter, lower_outer_diameter, lip_height = undef,
                 lip_thickness = undef, lip_top_corner_radius = undef, lip_bottom_corner_radius = undef, lip_fn = 32,
                 ivw_thickness = undef, ivw_width = undef, ivw_height = undef, pos_ivw = false, neg_ivw = false,
                 ivw_offset_angle = 90, collar_height = undef, collar_diameter = undef, sides = 32, showlines = false)
{
    difference()
    {
        union()
        {
            // body
            body(body_height, upper_outer_diameter, lower_outer_diameter, body_thickness, sides, showlines);

            // base
            base(lower_outer_diameter, body_thickness, sides);

            // lip
            if (!is_undef(lip_height) && !is_undef(lip_thickness) && !is_undef(lip_top_corner_radius) &&
                !is_undef(lip_bottom_corner_radius))
            {
                lip(lip_height, lip_thickness, lip_top_corner_radius, lip_bottom_corner_radius, lip_fn, body_height,
                    body_thickness, upper_outer_diameter, sides);
                lip_seam(lip_bottom_corner_radius, lip_thickness, body_height, body_thickness, upper_outer_diameter,
                         sides);
            }
            else
            {
                echo("Error, lip: height, thickness, top_corner_radius, bottom_corner_radius, and fn must be defined");
            }

            // collar
            if (!is_undef(collar_height) && !is_undef(collar_diameter))
            {
                translate([ 0, 0, body_height + body_thickness ])
                {
                    difference()
                    {
                        cylinder(h = collar_height, d1 = upper_outer_diameter, d2 = collar_diameter, $fn = sides);
                        translate([ 0, 0, -zFite / 2 ])
                            cylinder(h = collar_height + zFite, d1 = upper_outer_diameter - 2 * body_thickness,
                                     d2 = collar_diameter - 2 * body_thickness, $fn = sides);
                    }
                }
            }
            else
            {
                if (!is_undef(collar_height) || !is_undef(collar_diameter))
                {
                    echo("Error, collar: height and diameter must be defined or sll not defined");
                }
            }

            // internal vertical walls
            if (!is_undef(ivw_thickness) && !is_undef(ivw_width) && !is_undef(ivw_height) && pos_ivw)
            {
                for (i = [0:3])
                {
                    rotate([ 0, 0, i * 90 ])
                    {
                        internal_vertical_wall(upper_outer_diameter, lower_outer_diameter, body_height, body_thickness,
                                               ivw_thickness, ivw_width, ivw_height, ivw_offset_angle);
                    }
                }
            }
            else
            {
                if (!is_undef(ivw_thickness) || !is_undef(ivw_width) || !is_undef(ivw_height))
                {
                    echo("Error, ivw: thickness, width, height, and offset_angle must  be defined or sll not defined");
                }
            }
        }

        // cut out slots (negative ivw)
        if (!is_undef(ivw_thickness) && !is_undef(ivw_width) && !is_undef(ivw_height) && !is_undef(ivw_offset_angle) &&
            neg_ivw)
        {
            for (i = [0:3])
            {
                rotate([ 0, 0, i * 90 + 45 ]) translate([ body_thickness, 0, -body_thickness - zFite ])
                {
                    internal_vertical_wall(upper_outer_diameter, lower_outer_diameter, body_height, body_thickness,
                                           ivw_thickness, ivw_width, ivw_height, ivw_offset_angle);
                }
            }
        }
    }
}