include<../OpenScadParts/servos.scad>


//servohalterueberstand = 8;
//haltebackuntenbiszahnkranzoben = 16.8;

plattendicke=4;
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



function servoGearInnerRadius() = 63;
function servoGearOuterRadius() = 66;

module wheel()
{


//cloned from https://github.com/urish/trumpet-robot/blob/master/hardware/parts/servo-gear.scad
//and fitted for https://www.thingiverse.com/thing:2304335/files

    difference()
    {
        union()
        {
            difference(){
                union(){
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
        translate([45/2,-25,-10])cube([32,62.3,baseplateheight+10]);
        translate([-(45/2)-10,-25,-10])cube([10,50,13]);
        cylinder(d=43,h=7);
		//translate([-19,20,0]) cube([56,25,25]);	
        cylinder(d=35,24);
        translate([44.5,0,10])rotate([-180,0,90])servo(servoDimensions[0],holdblock=true); 
	}
    /*translate([0,0,3.001])
    difference()
	{
        cylinder(d=68,h=20);
        cylinder(d=43,h=20);
    }*/
	translate([-0,0,3]) cylinder(d=30,22);

	translate([-0,0,-.1])schliesszylinder(5.1);
	translate([44.5,0,10])rotate([-180,0,90])servo(servoDimensions[0],cutout=true); 
   // holes for the screws of the actual lock.
   for (p = screw_pos) {
     translate([-p[0],-p[1],-0.01])
       cylinder(r1=screw_r, r2=screw_r+baseplateheight, h=baseplateheight+0.02);
//       cylinder(r=screw_r, h=baseplateheight+2);
   }
}
}


module servowheel()
{
   difference()
    {
        union()
        {
            linear_extrude(5)
            {
              gear(number_of_teeth=29, circular_pitch=pitch,flat=true, gear_thickness=10, bore_diameter=3); // setting gear_thickness>rim_thickness removes a warning due to a bug in the involute_gears code.
                
            }
            translate([0,0,5])cylinder(d=32,h=1);

            translate([0,0,5]) rotate_extrude(convexity = 10) translate([16, 0, 0])
            {
                circle(r = 1);
            }
        }
        //#translate([0,0,-2])cylinder(d=6,h=5);
        translate([0,0,5])cylinder(d1=10,d2=16,h=1.2);
        cylinder(d=10,h=10);
        translate([0,12,4])cylinder(d=3,h=5);
        translate([0,-12,4])cylinder(d=3,h=5);
    }
}
module servowheel_2D(layer=0) {
  if (layer == 0) {
    difference() {
      gear(number_of_teeth=13, circular_pitch=pitch,flat=true, gear_thickness=10, bore_diameter=3); // setting gear_thickness>rim_thickness removes a warning due to a bug in the involute_gears code.
      servo_axis();
    }
  } else {
    difference() {
      circle(d=30);
      circle(d=3);
    }
  }
}
*union() {
  translate([0,30.5])
    servowheel();
  for (l=[0:1])
    translate([0,0,l*3])
      linear_extrude(height=3)
        servowheel_2D(layer=l);
}  



//servowheel();
{
   // translate([44.5,0,26]) servowheel();

//translate([0,0,13])
//projection(cut=true)
{
    //rotate([90,0,0])
    {
//difference()
{
    holder();
  
 //   translate([-1,-1,-2]*5000)cube(10000);
}
//translate([0,0,10])
translate([0,0,5])wheel();
        }
//translate([44.5,0,-doorshieldheight])rotate([0,0,90])servo(model=true); 
}
}
