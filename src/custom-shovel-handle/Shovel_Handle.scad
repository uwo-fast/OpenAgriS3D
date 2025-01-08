
/*[Overall Dimesnions]*/

//length of overlap on handle
O_Length = 50;

//Inner Diameter of overlap
In_Dia = 38;

//Outer diamter of overlap
Out_Dia = 48;

//length from start of overlap to center of grip
S_Length =  120;

//diameter of Grip
G_Dia = 30;

//length of grip
G_Length = 150;

//distance to trim (leave here at 40, unless model comes out with excess from the rods)
trim = 40;

/*[mounting holes]*/

// You can have up to 3 holes, for more add to the source code
// Holes will be completly through from one side to the other of the overlap

//Hole 1 diameter
H1_Dia = 5;

// Hole 1 X location
H1_X = 0;

//Hole 1 Y location
H1_Y= 0;

//Hole 1 Z loaction
H1_Z = 30;

//Hole 1 X Rotation 
H1_Xrot = 90;

//Hole 1 Y Rotaion
H1_Yrot = 0;

//Hole 1 Z Rotation
H1_Zrot = 0;

//Hole 2 diameter ((leave at 0 to not have))
H2_Dia = 5;

// Hole 2 X location
H2_X = 0;

//Hole 2 Y location
H2_Y= 0;

//Hole 2 Z loaction
H2_Z = 15;

//Hole 2 X Rotation
H2_Xrot = 0;

//Hole 2 Y Rotaion
H2_Yrot = 90;

//Hole 2 Z Rotation
H2_Zrot = 0;

//Hole 3 diameter ((leave at 0 to not have))
H3_Dia = 0;

// Hole 3 X location
H3_X = 0;

//Hole 3 Y location
H3_Y= 0;

//Hole 3 Z loaction
H3_Z = 0;

//Hole 3 X Rotation 
H3_Xrot = 0;

//Hole 3 Y Rotaion
H3_Yrot = 0;

//Hole 3 Z Rotation
H3_Zrot = 0;
/*[Hidden]*/

//math
hyp = sqrt( pow(S_Length, 2) + pow( .5 * G_Length,2));

//angle
angle = atan( ((.5 * G_Length)-(.33*G_Dia))/S_Length);


//overlap section
module overlap () {
difference (){
cylinder(h = O_Length, d = Out_Dia, center=false);
}
}

//handle to grip
module grip () {
rotate([0,90,0]) translate([-S_Length,0,0])cylinder(h = G_Length, d = G_Dia, center=true);
}

//now, try to make the important part the connetor beams
module bars (){
union(){
rotate([0,angle,0])cylinder(h = hyp, d = .75*G_Dia, center = false);
rotate([0,-angle,0])cylinder(h = hyp, d = .75*G_Dia, center = false);
}
}

//cap to cover top of wooden shovel handle
module cap (){
translate([0,0,O_Length])cylinder(h=.2*Out_Dia, d = Out_Dia, center=false);
}

//mounting holes
module hole_1 (){
translate([H1_X,H1_Y,H1_Z])rotate([H1_Xrot,H1_Yrot,H1_Zrot])cylinder(h=Out_Dia*2, d=H1_Dia, center=true);
}

module hole_2 (){
translate([H2_X,H2_Y,H2_Z])rotate([H2_Xrot,H2_Yrot,H2_Zrot])cylinder(h=Out_Dia*2, d=H2_Dia, center=true);
}

module hole_3 (){
translate([H3_X,H3_Y,H3_Z])rotate([H3_Xrot,H3_Yrot,H3_Zrot])cylinder(h=Out_Dia*2, d=H3_Dia, center=true);
}


//joing solid parts together
module handle_together (){
union () {
overlap();
cap();
bars();
grip();

}
}

//pulling hollow, trimming parts out
module trimmed () {
difference (){
handle_together();
rotate([0,180,0])translate([0,0,-1])cylinder(h= trim, d = Out_Dia + 20, center=false);
rotate([0,90,0])translate([-S_Length, 0, .5*G_Length])cylinder(h= trim, d = G_Dia + 20, center=false);
rotate([0,90,0])translate([-S_Length, 0, -.5*G_Length-trim])cylinder(h= trim, d = G_Dia + 20, center=false);
cylinder(h = O_Length, d = In_Dia, center=false);
hole_1();
hole_2();
hole_3();
}
}
trimmed();




