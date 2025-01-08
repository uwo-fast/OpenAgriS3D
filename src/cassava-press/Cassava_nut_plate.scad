$fn=100;
H=130;    //total height of press cylinder
bthickness=7.75; // thickness of base
based=100; //diameter of base piece
wall=4; //thickness of cylinder wall
boltd=6.35 ;//diameter of threaded rod being used for exo
screenh=50; //height of screened part
screenw=2; //screen gap size
numscreen=50;//even number of screen holes
ribw=4;//width of rib
numbolt=5; //number of bolts
wtotalsm=11.1;
wfacesm=6.35+.05;
hnutsm=6;


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
cylinder(hnutsm+bthickness,d=based);
}


module boltholes() {
for (i = [1:numbolt]) {
rotate([0,0,boltangle*i])
translate([0,D/2+0.5*(based-D)/2,-2])
cylinder(2*bthickness+10,d=boltholed);

}}

module nutholes(){
for (i = [1:numbolt]) {
rotate([0,0,boltangle*i])
translate([0,D/2+0.5*(based-D)/2,hnutsm/2])
rotate([0,0,30])
union(){
cube([wtotalsm,wfacesm,hnutsm],center=true);

rotate([0,0,60])
cube([wtotalsm,wfacesm,hnutsm],center=true);

rotate([0,0,-60])
cube([wtotalsm,wfacesm,hnutsm],center=true);}}}

//translate([0,0,hnutsm/2])
//nutholes();

difference(){
union(){
difference(){
cylinders();
boltholes();}}
nutholes();
}


