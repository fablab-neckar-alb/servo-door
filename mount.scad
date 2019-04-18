servohalterhoehe = 25;
zahnradaussen = 6;
zahnkranzdicke = 4;
haltebackuntenbiszahnkranzoben = 16.8;
	include <MCAD/units.scad>
use <MCAD/involute_gears.scad>

$fn = 60;
module schliesszylinder(h = 10){
	lenght = 33;
	slotwidth = 10;
	keycylinderwidth = 16.9;
	cylinder(d=keycylinderwidth,h);
	hull(){
		translate([0,33-slotwidth/2 -keycylinderwidth / 2,0]){cylinder(d=10,h);}
		cylinder(d=10,h);
	}
}
module servo(cutout = false) {
	if(cutout)
	{
		translate([-10.2,-10,0]) cube([39.5,20,100]);
		translate([-10.2 -8 + 4 ,5,0]) cylinder(d=3, h=100);
		translate([-10.2 -8 + 4 ,-5,0]) cylinder(d=3, h=100);
		translate([55-10.2 -8 - 4  ,5,0]) cylinder(d=3, h=100);
		translate([55-10.2 -8 - 4 ,-5,0]) cylinder(d=3, h=100);
	}
	else
	{
	color("blue") difference() {
		union() {
			
			translate([-10.2,-10,0]) cube([39.5,20,34.3]);
			difference(){
				translate([-10.2 -8,-10,25]) cube([55,20,2]);
				translate([-10.2 -8 + 4 ,5,0]) cylinder(d=3, h=100);
				translate([-10.2 -8 + 4 ,-5,0]) cylinder(d=3, h=100);
				translate([55-10.2 -8 - 4  ,5,0]) cylinder(d=3, h=100);
				translate([55-10.2 -8 - 4 ,-5,0]) cylinder(d=3, h=100);
			}
			translate([0,0,34.3]) {
				
					translate([0,0,0]) cylinder(d1=14,d2=11, h=1);
			}

		}	


	}
	color("white") translate([0,0,35]) {
		difference() {
			cylinder(d=6, h=3+1);
			translate([0,0,1]) cylinder(d=2, h=4);
		}
	}
	}
}
module housing_mittig(){
	rotate([0,0,270])translate([200,-120])import("keylock-housing.stl");
}
	



function servoGearInnerRadius() = 63;
function servoGearOuterRadius() = 66;
use <MCAD/involute_gears.scad>

module wheel()
{


//cloned from https://github.com/urish/trumpet-robot/blob/master/hardware/parts/servo-gear.scad
//and fitted for https://www.thingiverse.com/thing:2304335/files


//translate([35,-0,-20])import("original_gear.stl");
difference(){
    union(){
       translate([0,0,17])rotate([0,0,360/61*$t])linear_extrude(5)gear(number_of_teeth=67, circular_pitch=pitch,flat=true);
        cylinder(d=64,h=22);
    }
    
    cylinder(d=62.01,h=20);
    
}
cylinder(d=33,h=20);
}

pitch = 200;

module holder(){
difference(){
	union(){
		//cylinder(d=62,h=3);
        translate([0,0,1.5])cube([34*2,80,3],center=true);
        translate([39,0,-1])cube([30,80,25],center=true);
        translate([-40,-40,-13])cube([30,80,15]);
        cylinder(d=43,h=4);
		//translate([-19,20,0]) cube([56,25,25]);	
        cylinder(d=35,24);
	}
    translate([0,0,3])
    difference()
	{
        cylinder(d=64,h=20);
        cylinder(d=43,h=20);
    }
	translate([-0,0,3]) cylinder(d=30,22);

	schliesszylinder(4);
	#translate([44.5,0,-30])rotate([0,0,90])servo(true); 
	//translate([0,35,35])cylinder(r=16.4,h=10); 
	
//translate([-19,25,0])cube([11,21,10]); 	
//translate([27,25,0])cube([11,20,10]); 
}
}
translate([44.5,0,35]){rotate([0,0,-360/13*$t])linear_extrude(5){gear(number_of_teeth=13, circular_pitch=pitch,flat=true);}}
translate([0,0,13])holder();
//translate([0,0,10])
//translate([0,0,18])wheel();
//translate([44.5,0,0])rotate([0,0,90])servo(); 
