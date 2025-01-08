module hydroring()
{
    rotate_extrude()
    {
        translate([ 76.2, 0, 0 ]) circle(r = 12.7);
    }
}

module cutout_hydroring()
{
    difference()
    {
        hydroring();
        rotate_extrude()
        {
            translate([ 76.2, 0, 0 ]) circle(r = 7.7);
        }
    }
}

module cube_cutout()
{
    difference()
    {
        cutout_hydroring();
        translate([ 0, 0, 12.5 ]) cube([ 180, 180, 20 ], center = true);
    }
}

module add_cube_top()
{
    union()
    {
        cube_cutout();
        rotate_extrude()
        {
            translate(
                [ 76.2, 4, 0 ]) // translate the Y coordinate back to 4 to return the top of the halo back to normal
                square([ 25.4, 5 ], center = true);
        }
    }
}

module add_stalk_clearance()
{
    difference()
    {
        add_cube_top();
        translate([ 76.2, 0, 0 ]) cube([ 30, 25.4, 30 ], center = true);
    }
}

module capoff_stalk_clearance()
{
    union()
    {
        add_stalk_clearance();
        translate([ 75.2, 14.2, -1 ]) cube([ 18, 3, 14 ], center = true);
        translate([ 75.2, -14.2, -1 ]) cube([ 18, 3, 14 ], center = true);
    }
}

module shower_spouts()
{
    translate([ 76.2, 0, -10 ]) cylinder(h = 15, r = 2.5, center = true);
}

module add_shower_spout_cutouts()
{
    difference()
    {
        capoff_stalk_clearance();
        for (i = [0:7])
        {
            rotate(i * 325 / 16, [ 0, 0, 1 ]) shower_spouts();
        }
        for (i = [0:7])
        {
            rotate(i * -325 / 16, [ 0, 0, 1 ]) shower_spouts();
        }
    }
}

module cylindrical_stake_cutout()
{
    difference()
    {
        cylinder(h = 15, r = 5.5, center = true);
        translate([ 5.5, 0, 0 ]) cube([ 11, 11, 20 ], center = true);
    }
}

module stake_holders()
{
    for (i = [0:2])
    {
        rotate(i * 360 / 3, [ 0, 0, 1 ]) difference()
        {
            translate([ -76.2, 0, -15.20 ]) cylinder(h = 15, r = 7.5, center = true);
            translate([ -76.2, 0, -20.20 ]) cylindrical_stake_cutout();
        }
    }
}

module halo_plus_stake_holders()
{
    union()
    {
        stake_holders();
        add_shower_spout_cutouts();
    }
}

module half_inch_cutout()
{
    translate([ -95, 0, -4 ]) rotate([ 0, 90, 0 ]) cylinder(h = 40, r = 4.35, center = true);
}

module half_inch_barb()
{
    translate([ -97, 0, -4 ]) rotate([ 0, 90, 0 ]) cylinder(h = 25.4, r = 6.35, center = true);

    translate([ -109.7, 0, -4 ]) rotate([ 0, 90, 0 ]) cylinder(h = 6.35, r1 = 6.35, r2 = 8, center = true);

    translate([ -103.35, 0, -4 ]) rotate([ 0, 90, 0 ]) cylinder(h = 6.35, r1 = 6.35, r2 = 8, center = true);

    translate([ -97, 0, -4 ]) rotate([ 0, 90, 0 ]) cylinder(h = 6.35, r1 = 6.35, r2 = 8, center = true);

    translate([ -90.65, 0, -4 ]) rotate([ 0, 90, 0 ]) cylinder(h = 6.35, r1 = 6.35, r2 = 8, center = true);
}

module semi_final_compilation()
{
    union()
    {
        translate([ 0, 0, 2.5 ]) half_inch_barb();
        halo_plus_stake_holders();
    }
}

module final_compilation()
{
    difference()
    {
        semi_final_compilation();
        translate([ 0, 0, 2.5 ]) half_inch_cutout();
    }
}

final_compilation();