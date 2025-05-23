// plant pot
zFite = $preview ? 0.1 : 0; // z-fighting fix
$fn = $preview ? 64 : 128; // number of fractions for a circle

function cone_angle(d1, d2, h) = atan((d1 - d2) / (2 * h));

function lower_dia_from_angle(angle, h, d1) = d1 - 2 * h * tan(angle);

function upper_dia_from_angle(angle, h, d2) = d2 + 2 * h * tan(angle);

function arc_points(radius, angle, fn, angle_offset = 0) =
    let(step = angle / (fn - 1),
        points = [for (i = [0:fn -
                              1])[radius * cos(angle_offset + i * step), radius *sin(angle_offset + i * step)]]) points;

function translate2dPts(points, offset) = [for (p = points)[p[0] + offset[0], p[1] + offset[1]]];

function cyl_dia_delta(target_height, upper_outer_diameter, lower_outer_diameter,
                       body_height) = target_height *
                                      tan(cone_angle(upper_outer_diameter, lower_outer_diameter, body_height));

module body(body_height, upper_outer_diameter, lower_outer_diameter, body_thickness, rot_poly, snap_position = undef,
            snap_rad = undef, snap_gaps = undef, showlines = false)
{
    wall_height = body_height - body_thickness;
    upper_inner_diameter = upper_outer_diameter - 2 * body_thickness;
    lower_inner_diameter = lower_outer_diameter - 2 * body_thickness;

    union()
    {
        // main body
        translate([ 0, 0, body_thickness ]) difference()
        {
            cylinder(h = wall_height, d1 = lower_outer_diameter, d2 = upper_outer_diameter, $fn = rot_poly);
            translate([ 0, 0, -zFite / 2 ])
                cylinder(h = wall_height + zFite, d1 = lower_inner_diameter, d2 = upper_inner_diameter, $fn = rot_poly);
        }

        // create snap seam
        if (!is_undef(snap_position) && !is_undef(snap_rad))
        {

            cone_ang = cone_angle(upper_outer_diameter, lower_outer_diameter, body_height);
            loc_upper_outer_diameter =
                upper_dia_from_angle(angle = cone_ang, h = snap_position, d2 = lower_outer_diameter);
            snapseam_pts = arc_points(radius = snap_rad, angle = 360, fn = rot_poly, angle_offset = -90 - cone_ang);
            snapseam_rot_pts = translate2dPts(snapseam_pts, [ loc_upper_outer_diameter / 2, 0 ]);
            if (is_undef(snap_gaps))
                translate([ 0, 0, snap_position ]) rotate_extrude(angle = 360) polygon(points = snapseam_rot_pts);
            else
                translate([ 0, 0, snap_position ])
                {
                    for (i = [0:snap_gaps[1] - 1])
                        rotate([ 0, 0, i * 360 / snap_gaps[1] + 360 / 2 * snap_gaps[0] / snap_gaps[1] ])
                            rotate_extrude(angle = (360 * snap_gaps[0]) / snap_gaps[1])
                                polygon(points = snapseam_rot_pts);
                }
        }
    }

    // draw lines to show the cone angle
    if (showlines)
    {
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

module lip(lip_height, lip_thickness, lip_top_corner_radius, lip_bottom_corner_radius, lip_fn, body_height,
           body_thickness, upper_outer_diameter, rot_poly)
{
    upper_inner_diameter = upper_outer_diameter - 2 * body_thickness;
    // points_bl = arc_points(lip_top_corner_radius, 90, 180);
    points_bl = [[ 0, 0 ]];
    points_br = translate2dPts(arc_points(lip_bottom_corner_radius, 90, lip_fn, 270),
                               [ lip_thickness - lip_bottom_corner_radius, lip_bottom_corner_radius ]);

    points_tl = translate2dPts(arc_points(lip_top_corner_radius, 90, lip_fn, 90),
                               [ +lip_top_corner_radius, lip_height - lip_top_corner_radius ]);
    points_tr = translate2dPts(arc_points(lip_top_corner_radius, 90, lip_fn, 0),
                               [ lip_thickness - lip_top_corner_radius, lip_height - lip_top_corner_radius ]);

    lip_poly = concat(points_br, points_tr, points_tl, points_bl);

    translate([ 0, 0, body_height ])
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
                              ivw_width, ivw_height)
{
    lower_inner_diameter = lower_outer_diameter - 2 * body_thickness;
    ivw_pts = [
        [ 0, 0 ], [ ivw_width, 0 ],
        [ ivw_width + cyl_dia_delta(ivw_height, upper_outer_diameter, lower_outer_diameter, body_height), ivw_height ],
        [ 0, ivw_height ]
    ];
    translate([ lower_inner_diameter / 2 - ivw_width, ivw_thickness / 2, body_thickness ]) rotate([ 90, 0, 0 ])
        linear_extrude(ivw_thickness) polygon(ivw_pts);
}

module plant_pot(body_height, body_thickness, upper_outer_diameter, lower_outer_diameter, lip_height = undef,
                 lip_thickness = undef, lip_top_corner_radius = undef, lip_bottom_corner_radius = undef, lip_fn = 32,
                 ivw_thickness = undef, ivw_width = undef, ivw_height = undef, pos_ivw = false, neg_ivw = false,
                 ivw_offset_angle = 90, collar_height = undef, collar_diameter = undef, snap_position = undef,
                 snap_radius = undef, snap_gaps = undef, sides = 32, showlines = false)
{
    difference()
    {
        union()
        {
            // body
            body(body_height = body_height, upper_outer_diameter = upper_outer_diameter,
                 lower_outer_diameter = lower_outer_diameter, body_thickness = body_thickness, rot_poly = sides,
                 snap_position = snap_position, snap_rad = snap_radius, snap_gaps = snap_gaps, showlines = showlines);

            // base
            base(lower_outer_diameter = lower_outer_diameter, body_thickness = body_thickness, rot_poly = sides);

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
                if (!is_undef(lip_height) || !is_undef(lip_thickness) || !is_undef(lip_top_corner_radius) ||
                    !is_undef(lip_bottom_corner_radius))
                {
                    echo("Error, lip: all lip parameters must be defined or all not defined");
                }
            }

            // collar
            if (!is_undef(collar_height) && !is_undef(collar_diameter))
            {
                translate([ 0, 0, body_height ])
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
                    echo("Error, collar: height and diameter must be defined or all not defined");
                }
            }

            // internal vertical walls
            if (!is_undef(ivw_thickness) && !is_undef(ivw_width) && !is_undef(ivw_height) && pos_ivw)
            {
                for (i = [0:3])
                {
                    rotate([ 0, 0, i * 90 + ivw_offset_angle ])
                    {
                        internal_vertical_wall(upper_outer_diameter, lower_outer_diameter, body_height, body_thickness,
                                               ivw_thickness, ivw_width, ivw_height);
                    }
                }
            }
            else
            {
                if (!is_undef(ivw_thickness) || !is_undef(ivw_width) || !is_undef(ivw_height))
                {
                    echo("Error, ivw: all ivw parameters must be defined or all not defined");
                }
            }
        }

        // cut out slots (negative ivw)
        if (!is_undef(ivw_thickness) && !is_undef(ivw_width) && !is_undef(ivw_height) && !is_undef(ivw_offset_angle) &&
            neg_ivw)
        {
            neg_ivw_width =
                ivw_width + cyl_dia_delta(ivw_height, upper_outer_diameter, lower_outer_diameter,
                                          body_height); // width of the bottom width of the neg ivw must equal
                                                        // the top width of the pos ivw so they can fit together
            neg_ivw_thickness =
                ivw_thickness * 1.5; // make the negative ivw thicker than the positive ivw so it can fit
            neg_ivw_height =
                ivw_height + ivw_thickness; // make the negative ivw taller than the positive ivw  so it can fit

            for (i = [0:3])
            {
                rotate([ 0, 0, i * 90 + 45 + ivw_offset_angle ])
                    translate([ body_thickness, 0, -body_thickness - zFite ])
                {
                    internal_vertical_wall(upper_outer_diameter, lower_outer_diameter, body_height, body_thickness,
                                           neg_ivw_thickness, neg_ivw_width, neg_ivw_height);
                }
            }
        }
    }
}