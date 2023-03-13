include <MCAD/units.scad>
use <MCAD/involute_gears.scad>

//cloned from https://github.com/urish/trumpet-robot/blob/master/hardware/parts/servo-gear.scad
//and fitted for https://www.thingiverse.com/thing:2304335/files

function servoGearInnerRadius() = 13.45;
function servoGearOuterRadius() = 16.36;

//translate([35,-0,-20])import("original_gear.stl");
module ServoGear(thickness=7) {
    linear_extrude(thickness)
    difference() {
        gear_shape(
            number_of_teeth=22,
            pitch_radius=servoGearOuterRadius() - 2.1,
            root_radius=servoGearInnerRadius(),
            base_radius=servoGearOuterRadius() - 2.34,
            outer_radius=servoGearOuterRadius(),
            half_thick_angle=5.,
            involute_facets=6
        );
        
        circle(d=6, $fn=12);
    }
    
    linear_extrude(3)
    difference() {
        circle(r=6, $fn=60);
        
        circle(d=3, h=3+epsilon, $fn=12);
    }
}

ServoGear();


pitch = 200;


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

wheel();