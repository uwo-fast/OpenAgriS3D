



union()
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    difference()
                    {
                        union()
                        {
                            difference()
                            {
                                union()
                                {
                                    linear_extrude(height = 4, center = true, convexity = 10, twist = 0)
                                        translate([ 2, 0, 0 ]) circle(r = 15);

                                    translate([ 0, -32, 0 ]) scale([ 20, 7, 1 ]) cube(4, center = true);

                                    translate([ 12, 4, 0 ]) scale([ 7, 25, 1 ]) cube(4, center = true);

                                    rotate([ 0, 0, -35 ]) translate([ 0, -40, 0 ]) scale([ 25, 9, 1 ])
                                        cube(4, center = true);
                                }

                                linear_extrude(height = 7, center = true, convexity = 10, twist = 0)
                                    translate([ 2, 0, 0 ]) circle(r = 10);
                            }
                        }

                        translate([ -6, 7, 0 ]) union()
                        {
                            difference()
                            {

                                translate([ -10, 0, 0 ]) scale([ 1, 1.4, 1 ])
                                    linear_extrude(height = 7, center = true, convexity = 10, twist = 0)
                                        translate([ 2, 0, 0 ]) circle(r = 80);

                                translate([ -10, 0, 0 ]) scale([ 1, 1.4, 1 ])
                                    linear_extrude(height = 9, center = true, convexity = 10, twist = 0)
                                        translate([ 2, 0, 0 ]) circle(r = 40);
                            }
                        }
                    }
                }
            }

            difference()
            {
                rotate([ 0, 0, -35 ]) translate([ -30, -35, 0 ]) scale([ 20, 8, 1 ]) cube(4, center = true);

                rotate([ 0, 0, 90 ]) translate([ 0, 75, 0 ]) scale([ 20, 8, 2 ]) cube(4, center = true);
            }
        }
        union()

            rotate([ 0, 0, 55 ]) translate([ -35, 23, -3 ]) polyhedron(
                points =
                    [
                        [ 21, 31, 0 ], [ 21, -31, 0 ], [ 0, -16.1, 0 ], [ 0, 16.1, 0 ], // the four points at base
                        [ 9.5, 0, 70 ]
                    ], // the apex point
                faces =
                    [
                        [ 0, 1, 4 ], [ 1, 2, 4 ], [ 2, 3, 4 ], [ 3, 0, 4 ], // each triangle side
                        [ 1, 0, 3 ], [ 2, 1, 3 ]
                    ] // two triangles for square base
            );

        rotate([ 0, 0, 55 ]) translate([ -40, 23, 0 ]) polyhedron(
            points =
                [
                    [ 19, 40, 0 ], [ 19, -31, 0 ], [ 0, -16.1, 0 ], [ 0, 40.1, 0 ], // the four points at base
                    [ 9.5, 0, 50 ]
                ], // the apex point
            faces =
                [
                    [ 0, 1, 4 ], [ 1, 2, 4 ], [ 2, 3, 4 ], [ 3, 0, 4 ], // each triangle side
                    [ 1, 0, 3 ], [ 2, 1, 3 ]
                ] // two triangles for square base
        );
    }
}