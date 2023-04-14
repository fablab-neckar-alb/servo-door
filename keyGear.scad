include <BOSL2/std.scad>
include <BOSL2/gears.scad>


modulus = 2;
clearance = 0.167;
pressurreAngle = 20;
thickness = 5;
keythickness=2.6;
keywidth=28;
hires=true;
$fn = hires ? 120 : 60;

bearingDimensions = [
  62, // outer diameter
  20, // height
  35  // inner diameter
  ];


module keygear()
{
    difference()
    {
        union()
        {
            difference(){
                union(){
                    translate([0,0,thickness/2])spur_gear(mod=modulus,teeth=37, thickness=thickness,pressure_angle=20, clearance=0.167);
                    translate([0,0,thickness]) cylinder(d=64,h=bearingDimensions[1]);
                }
                
                translate([0,0,thickness]) cylinder(d=62.01,h=20+1);

            }
         translate([0,0,thickness])cylinder(d=27,h=10);
        }
        cube([keythickness,keywidth,100],center=true);

    }
    


}
keygear();