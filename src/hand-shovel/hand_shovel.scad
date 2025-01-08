




scale(0.75)rotate([0,180,0])handle();
scale(0.75) rotate([ 0, 180, 0 ]) adaptor();
scale(0.75)rotate([180,0,0])shovel();

// this function generates each handle segment for the shovel
module adaptor(height = 17,    // the height in mm of the handle
               radius = 25,    // the radius in mm of the handle
               fit_size = 16,  // length and width of square connector in mm
               fit_height = 14 // the depth in mm of the square connector
)
{
    small_fit = 8.75 * (4 / 3);
    difference()
    {
        translate([ 0, 0, -height / 2 ]) cylinder(r = radius, h = height, center = true);

        translate([ -fit_size / 2, -fit_size / 2, -fit_height + 1 ]) cube([ fit_size, fit_size, fit_height ]);
    }
    translate([ -(small_fit - 1) / 2, -(small_fit - 1) / 2, -height - 10 ])
        cube([ small_fit - 1, small_fit - 1, fit_height - 1 ]);
}

// this function generates each handle segment for the shovel
module handle(height = 127,   // the height in mm of the handle
              radius = 25,    // the radius in mm of the handle
              fit_size = 16,  // length and width of square connector in mm
              fit_height = 14 // the depth in mm of the square connector
)
{
    difference()
    {
        translate([ 0, 0, -height / 2 ]) cylinder(r = radius, h = height, center = true);

        translate([ -fit_size / 2, -fit_size / 2, -fit_height + 1 ]) cube([ fit_size, fit_size, fit_height ]);
    }
    translate([ -(fit_size - 1) / 2, -(fit_size - 1) / 2, -height - 10 ])
        cube([ fit_size - 1, fit_size - 1, fit_height - 1 ]);
}

// this is a helper function for the shovel end
module handle_reciever(height = 50, // the length in mm of the support beam that supports the handle
                       radius = 25, // the radius in mm of the support beam that supports the handle
                       fit_size = 16, fit_height = 20)
{
    translate([ -fit_size / 2, -fit_size / 2, -fit_height + 1 ]) cube([ fit_size, fit_size, fit_height ]);
}

// this is a helper function for the shovel end
module shovel_support(height = 50, radius = 25, fit_size = 16, fit_height = 14)
{
    difference()
    {
        translate([ 0, 0, -height / 2 ]) cylinder(r = radius, h = height, center = true);

        translate([ -fit_size / 2, -fit_size / 2, -fit_height + 1 ]) cube([ fit_size, fit_size, fit_height ]);
    }
}

// this module constructs the actual shovel end support
module shovel(shovel_height = 200, // the length of the shovel before in-function scaling occurs
              shovel_width = 80    // the width of the shovel before in-function scaling occurs
)
{
    difference()
    {
        minkowski()
        {
            union()
            {
                translate([ 0, -40, -shovel_height / 2 ]) difference()
                {
                    scale([ 2.5, 1, 1 ]) cylinder(r = shovel_width / 2, h = shovel_height, center = true);

                    rotate([ 7, 0, 0 ]) translate([ 0, -shovel_height * 10 / 150, -15 ]) scale([ 2.5, 1, 1 ])
                        cylinder(r = shovel_width / 2, h = shovel_height, center = true);
                }

                translate([ 0, -20, 0 ]) scale(0.75) rotate([ 0, 0, 0 ]) shovel_support();
            }
            sphere(2);
        }
        translate([ 0, -20, 2 ]) scale(0.75) rotate([ 0, 0, 0 ]) handle_reciever();
    }
}