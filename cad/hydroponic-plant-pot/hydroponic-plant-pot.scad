// Parametric hydroponic cup (C)2012 vik@diamondage.co.nz

cup_top_rad = 47 / 2;
cup_wall = 1.5;
cup_bottom_rad = 38 / 2;
cup_height = 60;
grid_ht = 2.3;

difference()
{
    union()
    {
        cylinder(h = cup_height, r1 = cup_bottom_rad, r2 = cup_top_rad);
        // Rim
        translate([ 0, 0, cup_height - 2 ]) cylinder(h = 2, r2 = cup_top_rad + cup_wall, r1 = cup_top_rad);
    }
    translate([ 0, 0, -0.1 ])
        cylinder(h = cup_height + 0.2, r1 = cup_bottom_rad - cup_wall, r2 = cup_top_rad - cup_wall);
}

// grid for base.
translate([ 0, 0, grid_ht / 2 ]) intersection()
{
    union()
    {
        cube([ cup_wall, cup_bottom_rad * 2, grid_ht ], center = true);
        translate([ cup_bottom_rad * .5, 0, 0 ]) cube([ cup_wall, cup_bottom_rad * 2, grid_ht ], center = true);
        translate([ cup_bottom_rad * -.5, 0, 0 ]) cube([ cup_wall, cup_bottom_rad * 2, grid_ht ], center = true);

        rotate([ 0, 0, 90 ])
        {
            cube([ cup_wall, cup_bottom_rad * 2, grid_ht ], center = true);
            translate([ cup_bottom_rad * .5, 0, 0 ]) cube([ cup_wall, cup_bottom_rad * 2, grid_ht ], center = true);
            translate([ cup_bottom_rad * -.5, 0, 0 ]) cube([ cup_wall, cup_bottom_rad * 2, grid_ht ], center = true);
        }
    }
    translate([ 0, 0, -grid_ht ]) cylinder(h = 3 * grid_ht, r = cup_bottom_rad - cup_wall / 2);
}