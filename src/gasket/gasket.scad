// Customizable Gasket
//  This is a simple open-source parametric gasket

zFite = 0.1; // z offset for fitting

// CUSTOMIZER VARIABLES
// Defines the number of facets for the gasket
$fn = 64; // [16:512]

// Defines the height of the gasket
gasket_thickness = 1; //[1:10]

// Defines the gasket outer diameter
gasket_outer_diameter = 2; //[2:100]

// Defines the gasket inner diameter
gasket_inner_diameter = 1; // Numeric value smaller than Gasket Outer Diameter

// CUSTOMIZER VARIABLES END

module gasket()
{
    difference()
    {
        cylinder(h = gasket_thickness, r = gasket_outer_diameter * 2);
        translate([ 0, 0, -zFite / 2 ]) cylinder(h = gasket_thickness + zFite, r = gasket_inner_diameter * 2);
    }
}

gasket();