

// Threads
// English - GHT
// GHT or "garden hose thread", which is 3/4" straight thread and a pitch of 11.5 TPI (male part has an outer diameter
// of 1 1⁄16 inches (26.99 mm)) and is used for 1/2", 5/8", and 3/4" hoses.
thread_pitch = 25.4 / 11.5;
thread_major_diameter = 26.99;
thread_height = 25.4 * .5;

padding = 3;
diameter = thread_major_diameter + padding;
inner_diameter = 5 / 8 * 25.4;
length = 25;

// Metric - BSP
// Outside the United States, the more common BSP standard is used, which is 3/4" and 14 TPI (male part OD is 26.441 mm
// or 1.04 in).

difference()
{
    for (z = [ 0, 120, 240 ])
    {
        rotate([ z, 90, 0 ]) translate([ 0, 0, length ]) cube([ diameter, diameter, length * 2 ], center = true);
    };

    for (z = [ 0, 120, 240 ])
    {
        rotate([ z, 90, 0 ]) union()
        {
            translate([ 0, 0, length + 11 ]) thread(thread_pitch, thread_major_diameter, thread_height, 30);

            cylinder(r = thread_major_diameter / 2 - 4, h = length * 2);
        };
    };
};

// Metric Screw Thread Library
// by Maximilian Karl <karlma@in.tum.de> (2012)
//
//
// only use module thread(P,D,h,step)
// with the parameters:
// P    - screw thread pitch
// D    - screw thread major diameter
// h    - screw thread height
// step - step size in degree
//
module screwthread_triangle(P)
{
    difference()
    {
        translate([ -sqrt(3) / 3 * P + sqrt(3) / 2 * P / 8, 0, 0 ]) rotate([ 90, 0, 0 ])
            cylinder(r = sqrt(3) / 3 * P, h = 0.00001, $fn = 3, center = true);

        translate([ 0, -P / 2, -P / 2 ]) cube([ P, P, P ]);
    }
}

module screwthread_onerotation(P, D_maj, step)
{
    H = sqrt(3) / 2 * P;
    D_min = D_maj - 5 * sqrt(3) / 8 * P;

    for (i = [0:step:360 - step])
        hull() for (j = [ 0, step ]) rotate([ 0, 0, (i + j) ]) translate([ D_maj / 2, 0, (i + j) / 360 * P ])
            screwthread_triangle(P);

    translate([ 0, 0, P / 2 ]) cylinder(r = D_min / 2, h = 2 * P, $fn = 360 / step, center = true);
}

module thread(P, D, h, step)
{
    for (i = [0:h / P])
        translate([ 0, 0, i * P ]) screwthread_onerotation(P, D, step);
}