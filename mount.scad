// build_part = undef; // use openscad -D build_part=\"parts_list\" ...
// build_part = "parts_list";
 build_part = "servowheel";
// build_part = "servowheel_2D";
// build_part = "holder";
// build_part = "wheel";
//// build_part = "cut";
include <OpenScadParts/servos.scad>
include <OpenScadParts/motor-jgy-370.scad>
use <keyGear.scad>;
use <dovetail/dovetail.scad>

servohalterhoehe = 24;
servohalterueberstand = 8;
haltebackuntenbiszahnkranzoben = 16.8;

baseplateheight=7;
bearinglift=1.5;

doorcylinderaddition=5;
keyaddition=40;

blende = [35,240,11];
doorCylinderHeight=9.73+4.22-blende[2];
minimalBorder=2;
motorheight=40;

// measurements: topscrew-bottomscrew = 113, topscrew-cylinder = 50, door-screwbase = 7.5
//screw_pos = [[0,70],[0,-42]];
screw_pos = [[0,15],[0,-42]];
//hall_screw_pos = [[10,60],[-10,60],[0,45]];
hall_screw_pos = [[10,60],[-14,20],[14,20]];
screw_d = 6;
screw_head_d = 12;
screw_head_h = 3.3;
// screw_l = 57;
// distance lock-baseplane: 6.2 (that should be baseplateheight)
//   however: the rest of the geometry does not depend on baseplateheight yet...

winkel=180;
rotierteDistance = [sin(winkel),-cos(winkel),0]*(gearDistance()+0.1);



$fn = 120;

module part(s="") {
  if (build_part == s) children();
  if (build_part == "parts_list") echo(str("PART: ",s));
}

module demo() {
  if (build_part == undef) children();
}

module schliesszylinder(h = 10,toleranz=0.5){
	length = 33;
	slotwidth = 10;
	keycylinderwidth = 17.3;
	cylinder(d=keycylinderwidth+toleranz*2,h);
	hull(){
		#translate([0,33-slotwidth/2 -keycylinderwidth / 2 + toleranz,0]){cylinder(d=10.3+toleranz*2,h);}
		#cylinder(d=10.3+toleranz*2,h);
	}
}



module holder(){
  width = hall_screw_pos[0][0]*2 + screw_head_d + minimalBorder;

  
  difference(){
    // Base object
  	union(){
          linear_extrude(height=baseplateheight) {
            hull() {
              
              #translate(-screw_pos[0]) square([width , screw_head_d + minimalBorder*2],center=true);
              // bottom mount hole encasement
              translate(-screw_pos[1]+[0,9.1]) square([60 , 46],center=true);

            }
          }
          
          cylinder(d=43,h=baseplateheight+bearinglift);
          cylinder(d=35,h=bearingDimensions()[1]+baseplateheight-1 );  
  	}
    
    translate([-0,0,3]) cylinder(d=30,40);
    translate([-0,0,-.1]) schliesszylinder(baseplateheight+bearinglift+0.2);
     // holes for the screws of the actual lock.
     //top and bottom mount hole
     screw = screw_pos[1];
    {
       translate(-screw){
         translate([0,0,-.05])cylinder(d=screw_d, h=baseplateheight+.1);
         translate([0,0,baseplateheight-screw_head_h])cylinder(d1=screw_d, d2=screw_head_d, h=screw_head_h+.1);
         translate([0,0,baseplateheight])cylinder(d=screw_head_d, h=.2);
       }
     }

     for (screw = hall_screw_pos) {
       translate([-screw[0],-screw[1],-0.01])
         cylinder(d=4, h=baseplateheight+0.02);
     }
     
  }
  //translate([0,0,baseplateheight+thickness()+bearingDimensions()[1]+ bearinglift] )rotate([180,0,winkel])  package();
  motorangle = 90;
  docklength = 20;
  motorHolderDim = [46,60,motorheight-baseplateheight];
  motorHolderHoledim = motorHolderDim + [2,-20,-10];
  motorstabi= 5;
  difference(){
    
    translate(rotierteDistance+[0,0,baseplateheight])rotate([0,0,motorangle])translate([-16,-motorHolderDim[1]/2,0])cube(motorHolderDim);  
    translate(rotierteDistance)rotate([0,0,motorangle])translate([-16,-motorHolderHoledim[1]/2,0])translate([0,0,baseplateheight+motorstabi]) cube(motorHolderHoledim);
    
    translate(rotierteDistance+[0,0,motorheight])rotate([180,0,motorangle])
    {
      JGY_370motor();
    }
    cylinder(d=11,h=12);
    translate([0,0,12-7])cylinder(d=18,h=7);
    translate([0,0,baseplateheight])cylinder(d=65,h=30);
    translate([0,0,baseplateheight+20])cylinder(d=80,h=10);
  }

  
}





part("servowheel") translate([0,0,26]+rotierteDistance) rotate([180,0,0]) motorGear();

part("servowheel_2D") offset(r=0.095) {
  union() {
    for (l=[0:1])
      translate([l*30.5,0])
        servowheel_2D(layer=l);
  }
}

part("holder") holder();
part("wheel") translate([0,0,26]) rotate([180,0,0]) keygear();

module all() {
  difference(){
    union(){
      holder();
      #translate([0,0,40-20]+rotierteDistance) rotate([0,0,360/14]) motorGear();
      translate([0,0,baseplateheight+bearingDimensions()[1]+thickness()/2+1]) rotate([180,0,0]) keygear();
      translate(rotierteDistance+[0,0,40])rotate([180,0,motorangle])rotate([0,0,270])JGY_370motor();
    }

    translate([0,-100,0])cube([100,200,100]);
  }
  
}

part("all") all();


module cut(){
  difference(){
    union(){
      intersection(){
        holder();
        // Next, setup the dimension of the cut: use the bounding box of your design
        dimension = [150, 50, 70];
        // Finally, setup the dovetail:
        // Teeth count, Teeth height, Teeth Clearance
        teeth = [3, baseplateheight+0.2, 0.1];
        union(){
          translate(rotierteDistance+[0,18,baseplateheight/2-0.101])rotate([-90,0,0])cutter(position=[0, 0, 0], dimension=dimension, teeths=teeth, male=false);
          translate(rotierteDistance+[-50,-177,0])cube([100,160,100]);
        }
        
      }/*
      translate([100,0])
      intersection(){
        holder();
        // Next, setup the dimension of the cut: use the bounding box of your design
        dimension = [150, 50, 70];
        // Finally, setup the dovetail:
        // Teeth count, Teeth height, Teeth Clearance
        teeth = [3, baseplateheight+0.2, 0.1];
        
        translate(rotierteDistance+[0,18,baseplateheight/2-0.101])rotate([-90,0,0])cutter(position=[0, 0, 0], dimension=dimension, teeths=teeth, male=true);
      }*/
    }
    translate(rotierteDistance+[-18,18,baseplateheight/2]) rotate([0,90,0])cylinder(d=3,h=200);
    translate(rotierteDistance+[-18,10,baseplateheight/2]) rotate([0,90,0])cylinder(d=3,h=200);
    translate(rotierteDistance+[-18,-12,baseplateheight/2]) rotate([0,90,0])cylinder(d=3,h=200);
  }
}




part("cut") cut();