include <BOSL2/std.scad>
include <BOSL2/gears.scad>



// measurements for the upper entrance of the Fablab Neckar-Alb e.V.

hires=false;
$fn = hires ? 120 : 60;

// actual measurements:
// x = right, y = top, z = away from door towards the inside.
raw_base_size = [31.7,240,9.8];
lock_size = [17.0,32.9,16.4];
lock_y_min = 38.3;
screw1_y = 21.4;
screw2_y = 133.2;
screw3_y_top = 25.5;
right_margin = 27;
bolt_space = [46,44,8.8]; // space in the frame for the bolt.
bolt_spacing = 5.4; // between door and bolt space area.
bolt_x_from_margin = -11.0+2.4; // TODO: just remembered, not noted down.
bolt_size = [20.5,34.8,[5.2,7.8]]; // actual bolt size; slightly V-shaped
d_top_sensor_screwholes = 48; // those are two screwholes at the to of the door, that may be used for a door switch.
doorhandle_lockcylinder_dist_y = 90;
doorhandle_height = 50;
doorhandle_r = 13;

zahnradmodul = 2;
thickness = 6;
z1=31;
z2=13;
dist= (z1+z2)/2*zahnradmodul;


// TODO: measure torque for locking/unlocking the door (quite some!).

// not measured, but inferred from measurements:
raw_base_r = raw_base_size[0]/2;
lock_r = lock_size[0]/2;
screw3_y = raw_base_size[1]-screw3_y_top;
lock_y = lock_y_min+lock_size[1]-lock_r;
abs_doorhandle_y = lock_y + doorhandle_lockcylinder_dist_y;


translate([0,lock_y,25])
rotate([0,0,90])union(){
spur_gear(mod=zahnradmodul,teeth=31, thickness=thickness,pressure_angle=20, clearance=0.167);
  translate([0,dist,0])
spur_gear(mod=zahnradmodul,teeth=13, thickness=thickness,pressure_angle=20, clearance=0.167);
}


// we cannibalize this from before, because lock cylinders are standardized.
module schliesszylinder(h = 10, add = 0.1){
  length = 33;
  slotwidth = 10;
  keycylinderwidth = 17;
  cylinder(d=keycylinderwidth,h);
  hull()
    for (y = [0,length-slotwidth/2 -keycylinderwidth / 2])
      translate([0,y,0])
        cylinder(d=slotwidth+add,h);
}

module door_frame_representative() {
  screw_r = 7/2; // NOTE: d measuered by eberhard.
  bolt_pos =  [raw_base_r+right_margin+bolt_x_from_margin,20,-20]; // NOTE: made up.
  // part of the door, to illustrate right margin:
  translate([-raw_base_r,0,-2])
    cube([raw_base_size[0]+right_margin,raw_base_size[1],2]);
  color([0.6,0.6,0.6]) difference() {
    // raw base
    hull() for (i=[0,1])
      translate([0,i*(raw_base_size[1]-raw_base_r*2)+raw_base_r,0])
        cylinder(r=raw_base_r,h=raw_base_size[2]);
    // screw holes (actually filled with screws)
    for (y=[screw1_y,screw2_y,screw3_y])
      translate([0,y,-1])
        cylinder(r=screw_r,h=raw_base_size[2]+2);
  }

  // doorhandle
  translate([0,abs_doorhandle_y, 0])
    cylinder(r=doorhandle_r,h=doorhandle_height);

  // actual lock
  translate([0,lock_y,0])
    rotate([0,0,180]) schliesszylinder(h=lock_size[2]);
    //cylinder(r=lock_r,h=lock_size[2]);

  // NOTE: actual bolt position was not measured (no use for that)
  translate(bolt_pos) {
    // hole in frame where bolt (and bolt sensor) may find space
    %cube(bolt_space);
    *translate([-bolt_spacing,0,0])
      cube([bolt_size[0],bolt_size[1],bolt_size[2][1]]);
    // actual bolt, when fully locked.
    color("green") translate([-bolt_spacing,0,0])
      rotate([-90,0,0])
        linear_extrude(height=bolt_size[1]) {
          polygon(let(w=bolt_size[0],d1=bolt_size[2][1],d2=bolt_size[2][0],dd=(d2-d1)/2)
            [[0,-d1],[0,0],[w,dd],[w,dd-d2]]);
        }
  }
}

mountThickness =7;
lowerforkdistance =32;
screw_r = 5; // NOTE: made up.
module sensorboard(){
  boardwidth = 30;
  boardheigth = 32;
  height = 2;
  
  diameter = 63.9;
  translate([-boardwidth/2,0,0])
  difference(){
    cube([boardwidth,boardheigth,height]);
    translate([boardwidth/2,boardheigth+25+3,-1]) cylinder(d=diameter,h=height+2);
  }
  
}



module mount() {
  move_x = raw_base_size[0] / 2;
  move_y = raw_base_size[1];
  height = raw_base_size[2]+mountThickness;
  e = 0.01;
  bluge_r = 30;
  difference(){
    hull(){

    //raw_base_size = [31.7,240,9.8];
      
      for(i=[[-move_x,0],[-move_x,move_y],[move_x,move_y],[move_x,0]]){
        translate(i) sphere(r=raw_base_size[2]+mountThickness);
      }
      translate([0,abs_doorhandle_y, 0]) cylinder(r = bluge_r, h = height);
    }
    //Remove bacside
    translate([-move_x-height,-height,-height])
      cube([move_x*2+2*height,move_y+2*height,height]);
     // doorhandle
    translate([0,abs_doorhandle_y, 0])
      cylinder(r=doorhandle_r,h=doorhandle_height);
    // cablechannel
    translate([0,abs_doorhandle_y]){

    }
    translate([0,abs_doorhandle_y,raw_base_size[2]+mountThickness/2]){
      rotate([0,0,-50])
        rotate_extrude(angle = 130, convexity = 10)
          translate([18, 0, 0])
            circle(d = 4);
      translate([-20,15,mountThickness/2 -6])cube([40,20,6+e]);
      #translate([10,-40,mountThickness/2-6])cube([5,30,5]);
      translate([-20,-doorhandle_r-35-1,mountThickness/2-6])
      difference(){
        cube([40,30,6+e]);
        translate([20,-20])      cylinder(d=63.9,h=6+e);
      }
    }

    union() {
      // raw base
      hull() for (i=[0,1])
        translate([0,i*(raw_base_size[1]-raw_base_r*2)+raw_base_r,-e])
          cylinder(r=raw_base_r,h=raw_base_size[2]+e);
      
    }
    // screw holes
    for (y=[screw1_y,screw2_y,screw3_y])
        translate([0,y,-1]) 
        cylinder(r=screw_r,h=raw_base_size[2]+mountThickness+2);
    // actual lock
    translate([0,lock_y,0])
      rotate([0,0,180])
      schliesszylinder(h=lock_size[2]+3);
    
  }

  
  
}


//sensorboard();
//door_frame_representative();
mount();

