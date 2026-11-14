$fn = 100;
// all units in mm
H = 130;            // total height of press cylinder
bthickness = 8;     // thickness of base
based = 100;        // diameter of base piece
wall = 4;           // thickness of cylinder wall
boltd = 6.35;       // diameter of threaded rod being used for exo
screenh = 50;       // height of screened part
screenw = 2;        // screen gap size
numscreen = 50;     // even number of screen holes
ribw = 4;           // width of rib
numbolt = 5;        // number of bolts
screwd = 12.5;      // diameter of drive screw used
nutthickness = 7.5; // thickness of rim around nut
wtotal = 1.5 * 25.4 * 0.5;
wface = 11.;
hnut = 7.6;

D = based - 2 * boltd * 2.3622; // outter diameter of press
h = H - bthickness;             // height of inner cylinder
d = D - 2 * wall;               // inner diameter of press
dp = d - 2;                     // outter diameter of press plunger
boltholed = 1.1111 * boltd + 1;
screenangle = 360 / (numscreen / 2);
boltangle = 360 / numbolt;
numboltribs = numbolt;
numnonboltribs = 0;
anglenonboltribs = boltangle;

module cylinders()
{
    difference()
    {
        union()
        {
            cylinder(bthickness, d = based);
            translate([ 0, 0, bthickness ]) cylinder(nutthickness, d = screwd * 3);
        }
        cylinder(50, d = 14.5, center = true);
    }
}

module boltholes()
{
    for (i = [1:numbolt])
    {
        rotate([ 0, 0, boltangle * i ]) translate([ 0, D / 2 + 0.5 * (based - D) / 2, -2 ])
            cylinder(2 * bthickness, d = boltholed);
    }
}

module supports()
{
    for (i = [1:numboltribs])
    {
        rotate([ 0, 0, boltangle * i ]) union()
        {
            translate([ boltholed + ribw + 0.2, -3 + based / 4, bthickness + nutthickness / 4 ])
                cube([ ribw, (based) / 2, nutthickness / 2 ], center = true);

            translate([ -boltholed - ribw - 0.2, -3 + based / 4, bthickness + nutthickness / 4 ])
                cube([ ribw, (based) / 2, nutthickness / 2 ], center = true);
        }
    }
}

module rings()
{
    difference()
    {
        translate([ 0, 0, bthickness ]) cylinder(nutthickness, d = D + 1.5);

        translate([ 0, 0, bthickness ]) cylinder(nutthickness, d = d - 1.5);
    }
}

module nut()
{

    translate([ 0, 0, +bthickness + hnut / 2 ]) union()
    {
        rotate([ 0, 0, 0 ]) translate([ 0, 0, 0 ]) cube([ wtotal, wface, hnut ], center = true);

        rotate([ 0, 0, 60 ]) cube([ wtotal, wface, hnut ], center = true);

        rotate([ 0, 0, -60 ]) cube([ wtotal, wface, hnut ], center = true);
    }
}

difference()
{
    union()
    {
        difference()
        {
            cylinders();
            boltholes();
        }

        difference()
        {
            supports();
            rings();
        }
    }

    nut();
}