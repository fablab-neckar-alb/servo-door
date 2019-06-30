servohalterhoehe = 25;
servohalterueberstand = 8;
haltebackuntenbiszahnkranzoben = 16.8;

doorshieldheight=10;
doorcylinderaddition=5;
keyaddition=40;

// measurements: topscrew-bottomscrew = 113, topscrew-cylinder = 50, door-screwbase = 7.5
screw_pos = [[0,50],[0,50-113]];
screw_r = 6/2;
// screw_head_r = 12/2;
// screw_l = 57;
// distance lock-baseplane: 6.2 (that should be baseplateheight)
//   however: the rest of the geometry does not depend on baseplateheight yet...


use <MCAD/involute_gears.scad>

$fn = 60;
module schliesszylinder(h = 10){
	length = 33;
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
	

pitch = 200;

function servoGearInnerRadius() = 63;
function servoGearOuterRadius() = 66;

module wheel()
{


//cloned from https://github.com/urish/trumpet-robot/blob/master/hardware/parts/servo-gear.scad
//and fitted for https://www.thingiverse.com/thing:2304335/files


//translate([35,-0,-20])import("original_gear.stl");
    difference()
    {
        union()
        {
            difference(){
                union(){
                   translate([0,0,21])rotate([0,0,360/61*$t])linear_extrude(5)gear(number_of_teeth=67, circular_pitch=pitch,flat=true);
                    translate([0,0,11])cylinder(d=64,h=12);
                }
                
                cylinder(d=62.01,h=20);
                
            }
        translate([0,0,11])cylinder(d=27,h=10);
        }
        cube([3,30,100],center=true);
        
    }


}


module holder(){
difference(){
    baseplateheight=3;
	union(){
		//cylinder(d=62,h=3);
        //#translate([0,0,baseplateheight/2])cube([32*2,50,baseplateheight],center=true);
        linear_extrude(height=baseplateheight) hull() {
          square([32*2,50],center=true);
          for (p = screw_pos) {
            translate(-p)
              circle(r=3*screw_r+baseplateheight);
          }
        }
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
   translate([30,32,-14])
   { 
       cylinder(d=3, h=100);
       translate([0,0,14]) cylinder(d1=3,d2=6, h=3);
   }
   translate([-28,20,-14])
   { 
       cylinder(d=3, h=100);
       translate([0,0,14]) cylinder(d1=3,d2=6, h=3);
   }
   // holes for the screws of the actual lock.
   for (p = screw_pos) {
     translate([-p[0],-p[1],-0.01])
       cylinder(r1=screw_r, r2=screw_r+baseplateheight, h=baseplateheight+0.02);
//       cylinder(r=screw_r, h=baseplateheight+2);
   }
}
}


//gear()
{
    translate([44.5,0,26])
    {
        difference()
        {
            union()
            {
                linear_extrude(7)
                {
                    difference()
                    {
                        union()
                        {
                            gear(number_of_teeth=13, circular_pitch=pitch,flat=true);
                            circle(d=6);
                        }
                        circle(d=3);
                    }
                    
                }
                translate([0,0,7])cylinder(d=30,h=1);

                translate([0,0,7]) rotate_extrude(convexity = 10) translate([14, 0, 0])
                {
                    circle(r = 1);
                }
            }
            translate([0,0,-2])cylinder(d=6,h=5);
            #translate([0,0,7])cylinder(d=6,h=5);
        cylinder(d=3,h=10);
        }
    }

//translate([0,0,13])
//projection(cut=true)
{
    //rotate([90,0,0])
    {
difference()
{
    holder();
 //   translate([-1,-1,-2]*5000)cube(10000);
}
//translate([0,0,10])
//translate([0,0,5])wheel();
        }
//translate([44.5,0,-doorshieldheight])rotate([0,0,90])servo(model=true); 
}
}
