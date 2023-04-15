// build_part = undef; // use openscad -D build_part=\"parts_list\" ...
// build_part = "parts_list";
// build_part = "servowheel";
// build_part = "servowheel_2D";
build_part = "holder";
// build_part = "wheel";
include <../OpenScadParts/servos.scad>
use <keyGear.scad>;


servohalterhoehe = 24;
servohalterueberstand = 8;
haltebackuntenbiszahnkranzoben = 16.8;

baseplateheight=7;
bearinglift=.3;

doorcylinderaddition=5;
keyaddition=40;

blende = [35,240,11];
doorCylinderHeight=9.73+4.22-blende[2];

// measurements: topscrew-bottomscrew = 113, topscrew-cylinder = 50, door-screwbase = 7.5
screw_pos = [[0,70],[0,-42]];
hall_screw_pos = [[10,60],[-10,60],[0,45]];
screw_r = 6/2;
// screw_head_r = 12/2;
// screw_l = 57;
// distance lock-baseplane: 6.2 (that should be baseplateheight)
//   however: the rest of the geometry does not depend on baseplateheight yet...



hires=true;
$fn = hires ? 120 : 60;

module part(s="") {
  if (build_part == s) children();
  if (build_part == "parts_list") echo(str("PART: ",s));
}

module demo() {
  if (build_part == undef) children();
}

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


servoblockaddition =  14;
servo = servoTowerProMG996R();
winkel=50;
rotierteDistance = [sin(winkel),-cos(winkel),0]*gearDistance();
module holder(){
  totalServoLength = servo[1] + servo[3] * 2;
  servosCenter = servo[3] + servo[5];
  difference(){
    // Base object
  	union(){
          linear_extrude(height=baseplateheight) {
            hull() {
              //top and bottom mount hole encasement
              for (screw = screw_pos) {
                translate(-screw) circle(r=3*screw_r+baseplateheight);
              }
              //wide part for connecting the servo
              rotate([0,0,180])translate([- rotierteDistance[0]+servo[2]/2,-servosCenter - rotierteDistance[1],0])
              square([0.01,totalServoLength]);

            }
          }
          //translate([0,-25,])#cube([32,50,baseplateheight]);
          cylinder(d=43,h=baseplateheight+bearinglift);
          cylinder(d=35,h=bearingDimensions()[1]+baseplateheight-1 );  
  	}
    
  	translate([-0,0,3]) cylinder(d=30,40);
  	translate([-0,0,-.1]) schliesszylinder(baseplateheight+bearinglift+0.2);
     // holes for the screws of the actual lock.
     //top and bottom mount hole
     for (screw = screw_pos) {
       translate([-screw[0],-screw[1],-0.01])
         cylinder(r1=screw_r, r2=screw_r+baseplateheight, h=baseplateheight+0.02);
     }

     for (screw = hall_screw_pos) {
       translate([-screw[0],-screw[1],-0.01])
         cylinder(d=4, , h=baseplateheight+0.02);
     }
  }
}


//translate([0,0,baseplateheight+thickness()+bearingDimensions()[1]+ bearinglift] )rotate([180,0,winkel])  package();
difference(){
translate(rotierteDistance+[0,0,operativeHeight(servo)-blende[2]] ){
  rotate([0,0,-90]) servo(servoTowerProMG996R(),cutout = false, holdblock=true,model=false, mountingscrewidth = 2);
  };
  translate([-50,-100,-100])cube([100,100,100]);;
}



part("servowheel") translate([0,0,6]) rotate([180,0,0]) servowheel();

part("servowheel_2D") offset(r=0.095) {
  union() {
    for (l=[0:1])
      translate([l*30.5,0])
        servowheel_2D(layer=l);
  }
}

part("holder") holder();
part("wheel") translate([0,0,26]) rotate([180,0,0]) wheel();

demo() {
  translate(servo_pos+[0,0,26]) {
    servowheel();
    translate([0,-40,0])
      for (l=[0:1])
        translate([0,0,l*3])
          linear_extrude(height=3)
            servowheel_2D(layer=l);
  }
  difference()
  {
      holder();
   //   translate([-1,-1,-2]*5000)cube(10000);
  }
  /*translate([0,0,5])
    wheel();*/
  /*translate([0,0,7])
    bearing();*/
  %translate(servo_pos+[0,0,-doorshieldheight])rotate([0,0,90])servo(model=true);
}
