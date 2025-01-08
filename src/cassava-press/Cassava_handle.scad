wtotal=1.5*25.4*0.5;
wface=11.;
h=7.6;
whandle=20;
lhandle=3.5*25.4;
dhandle=20;
hhandle=2.*25.4;
module nut(){
rotate([0,0,0])
translate([0,0,0])
cube([wtotal,wface,h],center=true);

rotate([0,0,60])
cube([wtotal,wface,h],center=true);

rotate([0,0,-60])
cube([wtotal,wface,h],center=true);}

module handle(){
cylinder(15,d=28);
translate([0,-whandle/2,0])
cube([lhandle,whandle,h]);
translate([lhandle,0,0])
cylinder(hhandle,d=dhandle);
}

difference(){
handle();
translate([0,0,0.1+15-h+h/2])
nut();
cylinder(50,d=14.5, center=true);
}