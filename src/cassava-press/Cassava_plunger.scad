$fn=100;
//all units in mm
H=130;    //total height of press cylinder
bthickness=5; // thickness of base
based=100; //diameter of base piece
wall=4; //thickness of cylinder wall
boltd=6.35 ;//diameter of threaded rod being used for exo
screenh=50; //height of screened part
screenw=2; //screen gap size
numscreen=50;//even number of screen holes
ribw=4;//width of rib
numbolt=5; //number of bolts
screwd=12.5;// diameter of drive screw used
nutthickness=10;//thickness of rim around nut


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
plungerd=d-2;//diameter of plunger
plungerh=7;

module cylinders() {

cylinder(plungerh,d=plungerd);
translate([0,0,plungerh])
cylinder(plungerh,d=screwd*2);
}

module psupports(){
	for (i = [1:numboltribs]) {
	rotate([0,0,boltangle*i])
translate([0,0,plungerh+plungerh/4])
	cube([ribw,plungerd-4,plungerh/2],center=true);
}}

difference(){
union(){
cylinders();
//psupports();
}

translate([0,0,plungerh+3])
cylinder(plungerh,d=screwd+2);

}
