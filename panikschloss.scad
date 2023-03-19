blendenlaenge=235;
blendendicke=24;
lochabstandzueinander=209;
lochabstandoben=13;
lochdicke=5.7;
blechdicke=3;
kassettenabstandhinten=4;
kassettendicke=14;
kassettenhoehe=165;
kassettenbreite=85;
kassettenabstandoben=35;
dornmass=55;
klinkeoben=98;
klinkeschloss=72;
horizontalerhaltelochabstand=38;
horizontalbisklinke=38/2;
mittlereshaltelochbisklinke=21.5;
obereshaltelochbisklinke=46;
montagelochdurchmesser=7.5;
klinkedurchmesser=21;
klinkepfadhoehe=15.5;
rechts=true;
montageloecher=[
  [0,klinkeoben,dornmass+horizontalbisklinke],
  [0,klinkeoben,dornmass-horizontalbisklinke],
  [0,klinkeoben+mittlereshaltelochbisklinke,dornmass],
  [0,klinkeoben-obereshaltelochbisklinke,dornmass]
];

module blech(){
  union(){
    translate([0,blendendicke/2])hull(){
      cylinder(d=blendendicke,h=blechdicke);
      translate([0,blendenlaenge-blendendicke]){
        cylinder(d=blendendicke,h=blechdicke);
      }
    };
    translate([0,lochabstandoben])cylinder(d=lochdicke,h=10);
    translate([0,lochabstandoben+lochabstandzueinander])cylinder(d=lochdicke,h=10);
  };
}


module kassette(){
  cube([kassettendicke,kassettenhoehe,kassettenbreite]);
}

module schliesszylinder(h = 10){
  length = 33.5;
  slotwidth = 10.5;
  keycylinderwidth = 17;
  cylinder(d=keycylinderwidth,h);
  hull(){
    translate([0,33-slotwidth/2 -keycylinderwidth / 2,0]){cylinder(d=10.1,h);}
    cylinder(d=10.1,h);
  }
}

module kassettenaussparung(rechts=true,dornmass=55){
  translate([blendendicke/2,0])blech();
  translate([-40,klinkeoben+klinkeschloss,dornmass])rotate([0,90,0])schliesszylinder(h=100);
  //klinke
  translate([-40,klinkeoben,dornmass])rotate([0,90,0])cylinder(h=100,d=klinkedurchmesser);

  //montageloecher
  for(point = montageloecher){
    translate([-40,0,0]+point)rotate([0,90,0])cylinder(h=100,d=montagelochdurchmesser);
  }

  if(rechts){
    rechterAbstand=blendendicke-kassettenabstandhinten-kassettendicke;
    klinkenpfadoffset=rechterAbstand-(klinkepfadhoehe-kassettendicke)/2;
    translate([rechterAbstand,kassettenabstandoben])kassette();
    translate([klinkenpfadoffset,klinkeoben-klinkedurchmesser/2,0])cube([klinkepfadhoehe,klinkedurchmesser,dornmass]);
  } else{
    klinkenpfadoffset=kassettenabstandhinten-(klinkepfadhoehe-kassettendicke)/2;
    translate([kassettenabstandhinten,kassettenabstandoben])kassette();
    translate([klinkenpfadoffset,klinkeoben-klinkedurchmesser/2,0])cube([klinkepfadhoehe,klinkedurchmesser,dornmass]);
  }
}
difference(){
  cube([blendendicke,blendenlaenge,kassettenbreite]);
  kassettenaussparung();
}
