$fn=100;
H=130;    //total height of press cylinder
bthickness=5; // thickness of base
based=100; //diameter of base piece
wall=4; //thickness of cylinder wall
boltd=6.35 ;//diameter of threaded rod being used for exo
screenh=25; //height of screened part
screenw=2; //screen gap size
numscreen=50;//even number of screen holes
ribw=4;//width of rib
numbolt=5; //number of bolts

D=based-2*boltd*2.3622;    //outter diameter of press
h=H-bthickness; //height of inner cylinder
d=D-2*wall; //inner diameter of press
dp=d-2;   //outter diameter of press plunger
boltholed=1.1111*boltd+1;
screenangle=360/(numscreen/2);
boltangle=360/numbolt;
numboltribs=numbolt;
numnonboltribs=0;
anglenonboltribs=boltangle;


module cylinders() {
difference(){
cylinder(bthickness,d=based);
translate([0,0,-10])
cylinder(h+20,d=d);
}
translate([0,0,bthickness])
difference(){
cylinder(h,d=D);
translate([0,0,-10])
cylinder(h+20,d=d);
}

}

module boltholes() {
for (i = [1:numbolt]) {
rotate([0,0,boltangle*i])
translate([0,D/2+0.5*(based-D)/2,-2])
cylinder(2*bthickness,d=boltholed);

}}

module screen(){
for (i = [1:numscreen]) {
rotate([0,0,screenangle*i])
translate([0,0,1+bthickness+screenh/2])
cube([screenw,D+5,screenh],center=true);
}}

module ribs(){
	for (i = [1:numboltribs]) {
	rotate([0,0,boltangle*i])
	union(){
	translate([boltholed,-(D-d)/2+D/2+(based-D)/4,bthickness+h/2])
	cube([ribw,(based-D)/2,h],center=true);
	
	translate([-boltholed,-(D-d)/2+D/2+(based-D)/4,bthickness+h/2])
	cube([ribw,(based-D)/2,h],center=true);
	}}

//	for (i = [1:numnonboltribs]) {
//	rotate([0,0,boltangle*i+boltangle/2])
//	translate([0,-(D-d)/2+D/2+(based-D)/4,bthickness+h/2])
//	cube([ribw,(based-D)/2,h],center=true);
//	}
}
	

difference(){
cylinders();
boltholes();
screen();
}

ribs();
translate([0,0,15])
difference(){
cylinder(h=7.5,d=D);
cylinder(h=7.5,d=d);
}