servohalterhoehe = 25;
servohalterueberstand = 8;
haltebackuntenbiszahnkranzoben = 16.8;

doorshieldheight=10;
doorcylinderaddition=5;
keyaddition=40;



	include <MCAD/units.scad>
use <MCAD/involute_gears.scad>

$fn = 60;
module schliesszylinder(h = 10){
	lenght = 33;
	slotwidth = 10;
	keycylinderwidth = 17;
	cylinder(d=keycylinderwidth,h);
	hull(){
		translate([0,33-slotwidth/2 -keycylinderwidth / 2,0]){cylinder(d=10.1,h);}
		cylinder(d=10.1,h);
	}
}
module servo(cutout = false, holdblock=false,model=false) {
    mitteX = 10.2;
    mitteY = 10;
    servoX = 39.5;
    servoY = 20;
    servolaenge = 39.5;
    servohalterlaenge = servolaenge+2*servohalterueberstand;
    
	if(cutout)
	{
		translate([-mitteX,-mitteY-1,0]) cube([39.5,21,100]);
		translate([-mitteX -8 + 4 , 5,0]) cylinder(d=3, h=100);
		translate([-mitteX -8 + 4 ,-5,0]) cylinder(d=3, h=100);
		translate([55-mitteX -8 - 4  ,5,0]) cylinder(d=3, h=100);
		translate([55-mitteX -8 - 4 ,-5,0]) cylinder(d=3, h=100);
        translate([0,-5,41]) cube([100,6,2.5],center=true);
        translate([0 ,5,41]) cube([100,6,2.5],center=true);
        translate([0 ,0,20]) rotate([0,-90,0])cylinder(d=5, h=100);
	}
    if(holdblock)
    {
        difference(){
            translate([-10.2 -8,-10,0]) cube([servohalterlaenge,20,servohalterhoehe]);
            translate([-10.2,-10,0]) cube([servolaenge,20,(34.3-25)+servohalterhoehe]);
			translate([-10.2 -8 + 4 ,5,servohalterhoehe]) cylinder(d=3, h=100);
            translate([-mitteX -8 + 4 , 5,0]) cylinder(d=3, h=100);
            translate([-mitteX -8 + 4 ,-5,0]) cylinder(d=3, h=100);
            translate([55-mitteX -8 - 4  ,5,0]) cylinder(d=3, h=100);
            translate([55-mitteX -8 - 4 ,-5,0]) cylinder(d=3, h=100);
        }
    }
	if(model)
	{
	color("blue") difference() {
		union() {

            
            mitteY = 10;
			translate([-10.2,-10,0]) cube([servolaenge,20,(34.3-25)+servohalterhoehe]);
			difference(){
				translate([-10.2 -8,-10,servohalterhoehe]) cube([servohalterlaenge,20,2]);
				translate([-10.2 -8 + 4 ,5,servohalterhoehe]) cylinder(d=3, h=100);
				translate([-10.2 -8 + 4 ,-5,servohalterhoehe]) cylinder(d=3, h=100);
				translate([servohalterlaenge-10.2 -8 - 4  ,5,servohalterhoehe]) cylinder(d=3, h=100);
				translate([servohalterlaenge-10.2 -8 - 4 ,-5,servohalterhoehe]) cylinder(d=3, h=100);
			}
			translate([0,0,(34.3-25)+servohalterhoehe]) {
				
					translate([0,0,0]) cylinder(d1=14,d2=11, h=1);
			}

		}	


	}
	color("white") translate([0,0,10+servohalterhoehe]) {
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
    baseplateheight=3;
	union(){
		//cylinder(d=62,h=3);
        translate([0,0,baseplateheight/2])cube([32*2,50,baseplateheight],center=true);
        translate([45/2,-18.2,-10])cube([32,55,baseplateheight+10]);
        translate([-(45/2)-10,-25,-10])cube([10,50,13]);
        cylinder(d=43,h=4);
		//translate([-19,20,0]) cube([56,25,25]);	
        cylinder(d=35,24);
        translate([44.5,0,-10])rotate([0,0,90])servo(holdblock=true); 
	}
    /*translate([0,0,3.001])
    difference()
	{
        cylinder(d=68,h=20);
        cylinder(d=43,h=20);
    }*/
	translate([-0,0,3]) cylinder(d=30,22);

	translate([-0,0,-.1])schliesszylinder(5.1);
	translate([44.5,0,-30])rotate([0,0,90])servo(true); 

   translate([-28,-20,-14])
   { 
       cylinder(d=3, h=100);
       translate([0,0,14]) cylinder(d1=3,d2=6, h=3);
   }
   translate([30,-13,-14])
   { 
       cylinder(d=3, h=100);
       translate([0,0,14]) cylinder(d1=3,d2=6, h=3);
   }
   #translate([30,32,-14])
   { 
       cylinder(d=3, h=100);
       translate([0,0,14]) cylinder(d1=3,d2=6, h=3);
   }
   translate([-28,20,-14])
   { 
       cylinder(d=3, h=100);
       translate([0,0,14]) cylinder(d1=3,d2=6, h=3);
   }
}
}
//translate([44.5,0,35]){rotate([0,0,-360/13*$t])linear_extrude(5){gear(number_of_teeth=13, circular_pitch=pitch,flat=true);}}
//translate([0,0,13])
difference()
{
    holder();
    translate([-1,-1,-2]*5000)cube(10000);
}
//translate([0,0,10])
//translate([0,0,18])wheel();
//translate([44.5,0,-doorshieldheight])rotate([0,0,90])servo(model=true); 
