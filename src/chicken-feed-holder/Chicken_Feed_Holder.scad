diameter = 200;
top_height = 160;
handle_diameter = 5;
bottom_radius = .8 * diameter / 2;
top_radius = .6 * diameter / 2;
wall = 3;
number_of_feet = 3;
$fn = 100;

union()
{
    // Base
    difference()
    {
        sphere(r = diameter / 2);
        translate([ 0, 0, diameter / 2 - diameter / 10 ])
        {
            cube(diameter, center = true);
        }
        translate([ 0, 0, -diameter / 2 - diameter / 4 ])
        {
            cube(diameter, center = true);
        }
        translate([ 0, 0, -diameter / 2 * .45 ])
        {
            cylinder(diameter / 5, .88 * diameter / 2, diameter / 2);
        }
    }

    // Top cylinder
    translate([ 0, 0, -diameter / 10 ])
    {
        difference()
        {
            cylinder(top_height, bottom_radius, top_radius);
            translate([ 0, 0, -10 ])
            {
                cylinder(top_height * 180 / 160, bottom_radius - wall, top_radius - wall);
            }
        }
    }

    // Feet
    for (i = [0:number_of_feet - 1])
        rotate([ 0, 0, 360 / number_of_feet * i ])
            translate([ -diameter / 20, bottom_radius - diameter / 20 * .6, -diameter / 4 + .01 ])
                cube([ diameter / 10, diameter / 20 * .6, diameter / 2 * .36 ]);

    // Handle
    translate([ 0, 0, top_height - 30 ])
    {
        rotate([ 0, 90, 0 ])
        {
            cylinder(top_radius * 2 + 10, r = handle_diameter / 2, center = true);
        }
    }
}