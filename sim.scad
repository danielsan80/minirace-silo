$fn = 200;

min_thick=0.3;
fix = 0.1;
a_few = 2;
a_lot = 100;
outer_r=40;
inner_r=14;

inner_thick = 4;

thick=7;

overhang_width = 1;

magnet_r = 1.5;
magnet_h = 1.6;
magnet_dinstance = 0.5;

magnet_r_play = 0.3;
magnet_h_play = 1.2;

magnet_void_r = magnet_r+magnet_r_play;
magnet_void_h = magnet_h+magnet_h_play;


upright_length = 50;

traverse_thick = 5.5;
traverse_length = 22;
traverse_height=sin(45)*traverse_length;

traverse_magnet_shift = 0.1;

cap_play = 0.5;
cap_hangover = 0.5;
cap_width = magnet_void_r*2-cap_play;
cap_height = magnet_void_h-cap_play;

cap_deep = 2;

module magnet() {
    color("red")
    cylinder(r=magnet_void_r, h=magnet_void_h);
}

module magnet_void(degree=0) {
    rotate([0,0,degree])
    color("red")
    hull() {
        magnet();
        
        translate([8,0,0])
        magnet();
    }
    
//    magnet();
}



module outer_wheel() {
    difference() {    
        cylinder(r=outer_r, h=thick);
        translate([0,0,-fix])
        cylinder(r=outer_r-thick, h=thick+fix*2);
    }
}

module inner_wheel() {
    difference() {    
        cylinder(r=inner_r+inner_thick, h=inner_thick+1);
        translate([0,0,-fix])
        cylinder(r=inner_r, h=thick+fix*2);
    }
    
    difference() {    
        cylinder(r=inner_r+overhang_width, h=overhang_width);
        translate([0,0,-fix])
        cylinder(r=inner_r-overhang_width, h=overhang_width+fix*2);
    }
}





module radius() {
    translate([inner_r+a_few,-thick/2,0])
    cube([outer_r-inner_r-a_few*2,thick, inner_thick]);
}

module wheel() {
    outer_wheel();
    inner_wheel();
    radius();
    rotate([0,0,120])
    radius();
    rotate([0,0,240])
    radius();
}

module upright() {
    
    difference() {
        union() {
            translate([outer_r-thick,-thick/2,-upright_length])
            cube([thick, thick, upright_length]);
            
            translate([outer_r-thick,-traverse_thick/2,-traverse_height])
            rotate([0,-45,0])
            cube([traverse_thick, traverse_thick, traverse_length]);
        }
        
        translate([0,-a_lot/2,0])
        cube([a_lot,a_lot,a_lot]);        
    }    

}


module cap() {
    
    translate([cap_hangover,cap_hangover])
    cube([cap_width,cap_height,cap_deep]);

    cube([cap_width+cap_hangover*2,cap_height+cap_hangover*2,cap_hangover]);
}

module sim_upright() {
    
    difference() {
        upright();
    
        translate([outer_r-thick/2,0,-magnet_void_h - magnet_dinstance])
        magnet_void(0);
        
        translate([outer_r-thick-traverse_height+traverse_thick+traverse_magnet_shift,0, -magnet_void_h-magnet_dinstance])
        magnet_void(90);
    }
}

module sim_uprights() {
    sim_upright();
    
    rotate([0,0,120])
    sim_upright();
    

    rotate([0,0,240])
    sim_upright();
}


module sim_wheel() {
    
    module voids() {
        translate([outer_r-thick/2,0,magnet_dinstance])
        magnet_void(0);
        
        translate([outer_r-thick-traverse_height+traverse_thick+traverse_magnet_shift,0,magnet_dinstance])
        magnet_void(90);
    }
    
    difference() {
        wheel();

        voids();
        
        rotate([0,0,120])
        voids();

        rotate([0,0,240])        
        voids();
        
    }
}

module print_caps() {
    n = 1;
    m = 1;
    dinstance = 7;
    
    cube([n*dinstance+cap_width+cap_hangover*2, m*dinstance+cap_height+cap_hangover*2,min_thick/2]);
    for(i = [0:n]) {
        for(j = [0:m]) {
            translate([i*dinstance,j*dinstance,0])
            cap();
        }
    }
        
    
}

module print_upright() {
    sim_upright();
    translate([17,-7,-min_thick/2])
    cube([24,14,min_thick/2]);
}

//intersection() {
//    sim_wheel();
//    translate([outer_r-10,-5,0])
//    cube(10,10,10);
//}

//sim_wheel();

//sim_upright();
//print_upright();
//sim_uprights();

//print_caps();

cap();
    