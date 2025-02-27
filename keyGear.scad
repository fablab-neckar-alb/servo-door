include <BOSL2/std.scad>
include <BOSL2/gears.scad>


modulus = 2;
clearance = 0.167;
pressurreAngle = 20;
keythickness=2.6;
keywidth=35;
hires=true;
$fn = hires ? 120 : 60;

function thickness() = 5;
function keyTeeth() = 37;
function servoTeeth() = 7;

function gearDistance() = (keyTeeth()+servoTeeth())*modulus/2;


function bearingDimensions() = [
  62, // outer diameter
  20, // height
  35  // inner diameter
  ];


module keygear(bearing = bearingDimensions(),thickness=thickness(),keyMaxwith=27)
{
  headthickness = thickness / 2;
  difference()
  {
    union()
    {
      difference(){
        union(){
          translate([0,0,thickness/2])spur_gear(mod=modulus,teeth=keyTeeth(), thickness=thickness,pressure_angle=20, clearance=0.167);
          translate([0,0,0]) cylinder(d=bearing[0]+2,h=bearing[1]+headthickness);
        }
        //material removed for the bearing
        #translate([0,0,headthickness+1]) cylinder(d=bearing[0]+0.1,h=bearing[1]+0.1);
        translate([0,0,headthickness]) cylinder(d=bearing[0]+0.1-5,h=bearing[1]+0.1);
      }
      //inner key driving cylinder
      translate([0,0,headthickness])cylinder(d=keyMaxwith,h=bearing[1]-2);
    }
    cube([keythickness,keywidth,100],center=true);
  }
}

module motorGear(thickness=thickness()){
    transmissionDiameter = 6;
    transmissionFlangeOffset = 4.4 - transmissionDiameter/2;
    transmissionRodHeight = 11;
    difference(){
      union(){
      translate([0,0,thickness/2])
        spur_gear(mod=modulus, teeth=servoTeeth(), thickness=thickness, pressure_angle=20, clearance=0.167);
        cylinder(d=10,h=thickness);
      }
        
        translate([0,0,-0.2])difference(){
        cylinder(d=transmissionDiameter,h=transmissionRodHeight+0.4);
        translate([transmissionFlangeOffset,-transmissionDiameter/2,0])cube([6,6,11]);
        }
    
      
      
      
      
    
    }

}

module servoGear(thickness=thickness()){
    servoholeDiameter = 9;
    servoholeDist = 14.7/2;
    mountholes = [[servoholeDist,0,-0.01],[-servoholeDist,0,-0.01]];
    difference(){
      translate([0,0,thickness/2])
        spur_gear(mod=modulus, teeth=servoTeeth(), thickness=thickness, pressure_angle=20, clearance=0.167);
      translate([0,0,-1]) cylinder(d=servoholeDiameter,h=thickness+2);
      for(mounthole=mountholes){
        translate(mounthole)cylinder(d=2.2,h=thickness+1);
        translate(mounthole+[0,0,1])cylinder(d=5.5,h=10);
      }
      translate([0,0,3])cylinder(d1=14,d2=28,h=10);
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
//motorGear();
keygear();