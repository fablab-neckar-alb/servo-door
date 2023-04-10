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

// TODO: measure torque for locking/unlocking the door (quite some!).

// not measured, but inferred from measurements:
raw_base_r = raw_base_size[0]/2;
lock_r = lock_size[0]/2;
screw3_y = raw_base_size[1]-screw3_y_top;
lock_y = lock_y_min+lock_size[1]-lock_r;


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
  screw_r = 5; // NOTE: made up.
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

mountThickness =5;
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
  difference(){
    translate([-50,-50,])cube([100,150,raw_base_size[2]+mountThickness]);
    
    // part of the door, to illustrate right margin:
    translate([-raw_base_r,0,-10])
      cube([raw_base_size[0]+right_margin,raw_base_size[1],10]);
    color([0.6,0.6,0.6]) union() {
      // raw base
      hull() for (i=[0,1])
        translate([0,i*(raw_base_size[1]-raw_base_r*2)+raw_base_r,0])
          cylinder(r=raw_base_r,h=raw_base_size[2]);
      // screw holes (actually filled with screws)
      for (y=[screw1_y,screw2_y,screw3_y])
        translate([0,y,-1])
          cylinder(r=screw_r,h=raw_base_size[2]+mountThickness+2);
    }
    // actual lock
    translate([0,lock_y,0])
      rotate([0,0,180]) schliesszylinder(h=lock_size[2]);
    #translate([0,-20,raw_base_size[2]+mountThickness-2])sensorboard();
  }
  
  
}

//door_frame_representative();
mount();

