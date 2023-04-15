include <BOSL2/std.scad>
include <BOSL2/gears.scad>


modulus = 2;
clearance = 0.167;
pressurreAngle = 20;
keythickness=2.6;
keywidth=28;
hires=true;
$fn = hires ? 120 : 60;

function thickness() = 5;
function keyTeeth() = 37;
function servoTeeth() = 13;

function gearDistance() = (keyTeeth()+servoTeeth())*modulus/2;


function bearingDimensions() = [
  62, // outer diameter
  20, // height
  35  // inner diameter
  ];


module keygear(dimension = bearingDimensions(),thickness=thickness())
{
  difference()
  {
    union()
    {
      difference(){
        union(){
          translate([0,0,thickness/2])spur_gear(mod=modulus,teeth=keyTeeth(), thickness=thickness,pressure_angle=20, clearance=0.167);
          translate([0,0,thickness]) cylinder(d=64,h=dimension[1]);
        }
        translate([0,0,thickness]) cylinder(d=62.01,h=20+1);
      }
      translate([0,0,thickness])cylinder(d=27,h=10);
    }
    cube([keythickness,keywidth,100],center=true);
  }
}

module servoGear(thickness=thickness()){
    servoholeDiameter = 9;
    difference(){
      translate([0,0,thickness/2])
        spur_gear(mod=modulus, teeth=servoTeeth(), thickness=thickness, pressure_angle=20, clearance=0.167);
      translate([0,0,-1]) cylinder(d=servoholeDiameter,h=thickness+2);
    }

}

module bearing(dimensions = bearingDimensions() ){
  difference()
  {
    cylinder(d=dimensions[0],h=20);
    cylinder(d=dimensions[2],h=20);
  }
}

module package(){
  keygear();
  translate([0,gearDistance()])servoGear();
}

package();
/*
module servowheel()
{
   difference()
    {
        union()
        {
            linear_extrude(5)
            {
              gear(number_of_teeth=gears_n1, circular_pitch=pitch,flat=true, gear_thickness=10, bore_diameter=3); // setting gear_thickness>rim_thickness removes a warning due to a bug in the involute_gears code.

            }
            translate([0,0,5])cylinder(d=32,h=1);

            translate([0,0,5]) rotate_extrude(convexity = 10) translate([16, 0, 0])
            {
                circle(r = 1);
            }
        }
        //#translate([0,0,-2])cylinder(d=6,h=5);
        translate([0,0,7])cylinder(d=8,h=5);
        cylinder(d=3,h=10);
        translate([0,0,-2])
          linear_extrude(height=5)
           offset(r=0.25) // clearance for fitting
             servo_axis();
    }
}

module servowheel_2D(layer=0) {
  if (layer == 0) {
    difference() {
      gear(number_of_teeth=gears_n1, circular_pitch=pitch,flat=true, gear_thickness=10, bore_diameter=3); // setting gear_thickness>rim_thickness removes a warning due to a bug in the involute_gears code.
      servo_axis();
    }
  } else {
    difference() {
      circle(d=30);
      circle(d=3);
    }
  }
}
*/
