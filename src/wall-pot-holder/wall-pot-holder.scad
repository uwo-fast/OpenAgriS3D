/**
 * @file wall-pot-holder.scad
 * @brief Wall Pot Holder
 * @author Cameron K. Brooks
 * @copyright 2025
 *
 * This file contains the OpenSCAD code for a Wall Pot Holder.
 *
 */

// WORK IN PROGRESS!!!

// --------------------------
// Global Parameters
// --------------------------

zFite = $preview ? 0.1 : 0.01; // z-fighting avoidance

// --------------------------
// User Parameters
// --------------------------

pots_diameter = 55; // diameter of the openings
pots_depth = 100;   // depth of the openings
pots_rows = 5;      // number of openings in a row
pots_cols = 3;      // number of openings in a column

pots_skewX = -45;                 // the skew of the openings in the x direction
pots_skewY = 0;                   // the skew of the openings in the y direction
pots_skewZ = 0;                   // the skew of the openings in the z direction
pots_skew = [ pots_skewX, 0, 0 ]; // the skew of the openings

pots_spacing_x = 100; // center-to-center spacing of the openings in the x direction
pots_spacing_y = 100; // center-to-center spacing of the openings in the y direction

dim = 100;                // dimension of the base
width = pots_cols * dim;  // x
height = pots_rows * dim; // y
depth = dim;              // z
thickness = 4;            // wall thickness

border = 25; // border around the pots

base_width = width + border * 2;
base_height = height + border * 2;

// This module places nxm cylinders in a grid with spacing and skew applied while remaining level on the z-axis
module potsSolids(diameter, inner_diameter = undef, depth, xshift, yshift, n, m, skew, adjust = 0.4)
{
    for (i = [0:n - 1])
    {
        for (j = [0:m - 1])
        {
            translate([ i * xshift, j * yshift, 0 ])
            {
                rotate([ skew[0], skew[1], skew[2] ])
                {
                    translate([ 0, 0, -depth / 2 + (2 * adjust - 1) * depth / 2 ]) difference()
                    {
                        cylinder(h = depth, d = diameter, $fn = 100);
                        if (!is_undef(inner_diameter))
                        {
                            translate([ 0, 0, -zFite / 2 ])
                            {
                                cylinder(h = depth + zFite, d = inner_diameter, $fn = 100);
                            }
                        }
                    }
                }
            }
        }
    }
}

module wall_pot_holder()
{
    // center point compensation for the pots
    centerShiftX = (pots_spacing_x * (pots_cols - (pots_cols % 2 ? 2 : 2.5)));
    centerShiftY = (pots_spacing_y * (pots_rows - (pots_rows % 2 ? 3 : 3.5)));

    union()
    {
        difference()
        {
            // base
            difference()
            {
                cube([ base_width, base_height, depth ], center = true);
                translate([ 0, 0, -thickness / 2 - zFite ])
                {
                    cube([ base_width - thickness * 2, base_height - thickness * 2, depth - thickness + zFite ],
                         center = true);
                }
            }
            // solids to represent the pots for the holder
            translate([ -centerShiftX, -centerShiftY, depth / 2 ])
                potsSolids(diameter = pots_diameter + thickness * 2, depth = pots_depth, xshift = pots_spacing_x,
                           yshift = pots_spacing_y, n = pots_cols, m = pots_rows, skew = pots_skew);
        }
        // create cup holders
        translate([ -centerShiftX, -centerShiftY, depth / 2 ]) potsSolids(
            diameter = pots_diameter + thickness * 2, inner_diameter = pots_diameter, depth = pots_depth,
            xshift = pots_spacing_x, yshift = pots_spacing_y, n = pots_cols, m = pots_rows, skew = pots_skew);
    }
}

wall_pot_holder();