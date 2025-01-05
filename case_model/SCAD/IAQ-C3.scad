//##############################################################################
/* 
	Speeduino v0.3.x enclosure.
    Made by Josh Stewart
    
    Originally based off the Gizmo2 enclosure by Brian Welsby 

*/
//##############################################################################
include <pins.scad>

if($preview)
{
    translate([-99.5,116.5,2.5]) import("IAQ-C3-pcb.stl");
}
$fn=64;

pcb_thickness = 1.6;
thickness = 2.2; //Extra wall thickness (No more than 5)

length = 42;
width = 77;
height = 7.7;

font = "Liberation Sans :style=Bold Italic";
letter_size = 16;
letter_height = 4;

// Screw positions
//Near analog pins
post_r1 = 2.7/2;
post_r2 = 2.0/2;
post_h1 = 23.3;
post_h2 = 5;
post1_x = 51.7;
post1_y = 37.9;
post2_x = post1_x+23.25;
post2_y = post1_y;
post3_x = post1_x;
post3_y = post1_y-24;
post4_x = post2_x;
post4_y = post3_y;

//Corner pins
pin_r = 1.3;
pin_h = thickness*2-.1;
pin1_x = -(thickness)-.5;
pin1_y = -(thickness)-.5;
pin2_x = pin1_x;
pin2_y = .5+length+thickness;
pin3_x = (thickness)+.5+width;
pin3_y = pin2_y;
pin4_x = pin3_x;
pin4_y = pin1_y;

// LEDs
LED_y  = 6.248;
LED1_x = 16.85;
LED_spacing = 9.39;

//base_height = 10.7;
base_height = 13.9;
base_z = -9;

// Choose what to render and view or print

// These are just for viewing during development
//inner(); 
//box();
//exploded_view();


//##############################################################################
// Print items - uncomment one,render and export the STL

//rotate([180,0,0]) translate([0,20,0]) top();
//base();
//top();
stand();

//##############################################################################
//##############################################################################
//
// This is a composite of all the elements that make up the space inside the box,
// with extra parts to create holes in walls where required. This will then be
// subtracted from a solid block which is then sliced for printing
//
module inner() {
    
	difference() {
		union() { 
            screw_window_height = 20;
            screw_window_z = 4.7;
            
			// Main inner board space 
			translate([-1,-1,-10]) 	cube([width+thickness,length+thickness,height+thickness-base_z]);


		}
	}
}


//##############################################################################
//
// The final enclosure in one piece 
//
module box_hull()
{
	hull() {
        translate([-thickness,-thickness,-9])		sphere(r=3, $fn=100);
        translate([-thickness,length+thickness,-9])		sphere(r=3, $fn=100);
        translate([width+thickness,-thickness,-9])		sphere(r=3, $fn=100);
        translate([width+thickness,length+thickness,-9])	sphere(r=3, $fn=100);

        translate([-thickness,-thickness,height])		sphere(r=3, $fn=100);
        translate([-thickness,length+thickness,height])		sphere(r=3, $fn=100);
        translate([width+thickness,-thickness,height])		sphere(r=3, $fn=100);
        translate([width+thickness,length+thickness,height])	sphere(r=3, $fn=100);
            
    }
}

module box() {
    
    //Add the top text
    cube_size = 60;

	difference() {
		// Start with a rounded box 
        box_hull();

		// Now remove all the inside and openings
		inner();
        
        // USB cutout
        translate([5+(2.8),16.3,3.5]) rotate([0,0,90]) cube([15,20,7]);
        
        //Base vents
        vent_width = 3;
        vent_length = 5;
        vent_y = 2;
        vent_x = 0;
        vent_spacing = 3;
        for(x=[0:4])
        {
            for(y=[0:7])
            {
                translate([vent_x+((vent_width+vent_spacing)*y),vent_y+((vent_length+vent_spacing)*x),-10-thickness]) cube([vent_width,vent_length,height+thickness]);
            }

        }
        
        //Cutouts for the particulate sensor
        for(x=[0:4])
        {
          translate([5+(2.8*x),-15,-6-thickness]) cube([2.2,20,5]);
        }
        
        //Cutout 1 for the Co2 sensor
        for(x=[0:4])
        {
          translate([width,20+(2.8*x),-6-thickness]) cube([20.2,2,7.5]);
        }
        //Cutout 2 for the Co2 sensor
        for(x=[0:5])
        {
          translate([54,7+(2*x),-10-thickness]) cube([9,vent_length/4,height+thickness]);
        }
        
        //Cutout for button
        translate([34,17,8.8]) cylinder(h=thickness,r1=2.3, r2=8);
        
        //Cutouts for the LEDs
        translate([LED1_x,LED_y,7]) lightTube(false);
        translate([LED1_x+LED_spacing,LED_y,7]) lightTube(false);
        translate([LED1_x+LED_spacing*2,LED_y,7]) lightTube(false);
        
        //Cutouts for the OLED risers
        translate([post1_x,post1_y,-10])	cylinder(r=post_r1+.4, h=post_h1);
        translate([post2_x,post2_y,-10])	cylinder(r=post_r1+.4, h=post_h1);
        translate([post3_x,post3_y,-10])	cylinder(r=post_r1+.4, h=post_h1);
        translate([post4_x,post4_y,-10])	cylinder(r=post_r1+.4, h=post_h1);
        
        //Cutout for the OLED 4 pin header
        translate([post3_x+4.5,post3_y-post_r1-.7, -10]) cube([post4_x-post3_x-9, (post_r1+.5)*2, post_h1]);
        
	}


}

module lightTube(cutout=true) {
    tubeHeight = 3.7;
    if(cutout)
    {
        difference()
        {
            cylinder(h=tubeHeight,r=2.6);
            translate([0,0,-.05]) cylinder(h=tubeHeight+0.1,r=2);
        }
    }
    else 
    { 
        translate([0,0,-.05]) cylinder(h=tubeHeight+0.1,r=2);
    }
}


//##############################################################################
//
// The various sections for printing, 
//
//##############################################################################

module base()  {
	difference() {
		box();
		// Cut off middle + top
		translate([-10,-10,(base_z+base_height)]) cube([width+20,length+20,53]);
	}
    
    // OLED posts
    //translate([post1_x,post1_y,-10])	cylinder(r=post_r1, h=post_h1);
    //translate([post2_x,post2_y,-10])	cylinder(r=post_r1, h=post_h1);
    translate([post3_x,post3_y,-10])	cylinder(r=post_r1, h=post_h1);
    translate([post4_x,post4_y,-10])	cylinder(r=post_r1, h=post_h1);
    
    //Corner pins to connect 2 halves
    translate([pin1_x, pin1_y, pin_h]) pin(r=pin_r, h=pin_h);
    translate([pin2_x, pin2_y, pin_h]) pin(r=pin_r, h=pin_h);
    translate([pin3_x, pin3_y, pin_h]) pin(r=pin_r, h=pin_h);
    translate([pin4_x, pin4_y, pin_h]) pin(r=pin_r, h=pin_h);
}

module top()  {
	difference() 
    {
		box();
        // Cut off middle + bottom
        //translate([-10,-10,-15]) cube([width+20,130,51]);
        translate([-20,-10,(base_z-10)]) cube([width+40,130,base_height+10]);
        
        translate([pin1_x, pin1_y, pin_h-.1]) pinhole(r=pin_r, h=pin_h);
        translate([pin2_x, pin2_y, pin_h-.1]) pinhole(r=pin_r, h=pin_h);
        translate([pin3_x, pin3_y, pin_h-.1]) pinhole(r=pin_r, h=pin_h);
        translate([pin4_x, pin4_y, pin_h-.1]) pinhole(r=pin_r, h=pin_h);
	}
        
    //Cutouts for the LEDs
    translate([LED1_x,LED_y,7]) lightTube();
    translate([LED1_x+LED_spacing,LED_y,7]) lightTube();
    translate([LED1_x+LED_spacing*2,LED_y,7]) lightTube();
}

module stand()
{
  base_extra_width = 40;
  base_extra_height = 25;
  tolerance_scale = 1.01;
  difference()
  {
    union()
    {
        translate([-base_extra_width/2,40,3-height-base_extra_height/2]) cube([width+base_extra_width,20,height+base_extra_height]);
    }
    scale([tolerance_scale,tolerance_scale,tolerance_scale]) box_hull();
  }
}



//##############################################################################
//
// Exploded view of all the enclosure parts
//
module exploded_view () {
	translate([0,0,10]) top();
	base();
	translate([0,115,-8]) rotate([90,0,0]) end_cover();
	translate([15,-7,35]) rotate([90,90,0])	button();
	translate([30,-7,35]) rotate([90,90,0])	button();
}


//##############################################################################
//##############################################################################
