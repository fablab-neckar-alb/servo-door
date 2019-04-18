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