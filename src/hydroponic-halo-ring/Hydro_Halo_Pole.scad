module cylindrical_pole () {
difference () {
cylinder(h=190, r=5, center = true);

translate([-5,0,0])
cube([10,10,195], center = true);
}
}

cylindrical_pole ();