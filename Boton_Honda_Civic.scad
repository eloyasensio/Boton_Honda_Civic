// -------------------------------------
// Title:        Boton Honda Civic
// Version:      1.0
// Release Date: 2023-05-22
// Author:       Eloy Asensio (eloi.asensio@gmail.com)
// -------------------------------------
//
// Description: Botón del regulador de volumen del Honda Civic
//
// Release Notes:
//
// - Version 1.0:  Versión inicial del Boton Honda Civic
//
 
// -------------------------------------
// Parameters
// -------------------------------------
EPS = 0.01+0;
showButton="Core"; // [External Button, Inner Button, Core]
button_hight = 23; //.1
button_diameter = 40; //.1

inner_button_diameter = 16.09; //.1
inner_button_height = 9; //.1
inner_button_wall=2.54; //.1
inner_button_bottom_height = 2; //.1
inner_button_bottom_diameter = 10; //.1
neck_rad_inner_button = 1; //.1
neck_height_inner_button = 2; //.1

dilatation_margin = 0.6; //.1
inner_dilatation_margin = 1.0; //.1

arc_heigh= 6; //.1
arc_deep= 1; //.1

// -------------------------------------
// Calculated Parameters
// -------------------------------------
l_inner_height = button_hight - neck_height_inner_button + (EPS*2);

// -------------------------------------
// Main
// -------------------------------------
main();

module main(){
    if(showButton=="External Button"){
        externalButton();
    }
    else if(showButton=="Inner Button"){
        innerButton();
    }
    else{
        core();
    }
}

// -------------------------------------
// Modules
// -------------------------------------
module core(){
    customHeight = button_hight+(EPS*2);
    translate([0,0,customHeight/2])
    difference(){
        cylinder(h=button_hight,d=inner_button_diameter+inner_button_wall, center=true);
        cylinder(h=customHeight,d=inner_button_diameter,center=true);
    }
}

module externalButton(){
    l_height = button_hight + (EPS*2);
    angle =  asin(inner_button_wall/inner_button_diameter) ;
    
    union(){
         difference(){
            translate([0,0,button_hight/2])
                cylinder(h=button_hight,d=button_diameter, center= true);
            union(){
                translate([0,0,l_height/2 - EPS ])
                    cylinder(
                        h=l_height,
                        d=inner_button_diameter -  neck_rad_inner_button, 
                        center= true
                    );
                translate([0,0,(l_inner_height/2 - EPS)])
                    cylinder(h=l_inner_height,
                        d=inner_button_diameter + inner_button_wall + dilatation_margin,
                        center= true
                    );   
            }
        }
        
        arc(
            a=angle, 
            r1=(inner_button_diameter/2+inner_button_wall -EPS),
                r2=inner_button_diameter/2 + arc_deep -EPS, 
            h=arc_heigh
        );
        rotate([0,0,360/3])
            arc(
                a=angle, 
                r1=(inner_button_diameter/2+inner_button_wall -EPS), 
                r2=inner_button_diameter/2 + arc_deep -EPS, 
                h=arc_heigh
            );
        rotate([0,0,(360/3)*2])
            arc(
                a=angle, 
                r1=(inner_button_diameter/2+inner_button_wall -EPS), 
                r2=inner_button_diameter/2 + arc_deep -EPS, 
                h=arc_heigh
            );
    }
}

module innerButton(){
    top_cilinder_height = button_hight + (button_hight-l_inner_height);
    union(){
        translate([0,0,inner_button_bottom_height])
            union(){
                translate([0,0,button_hight/2])
                    cylinder(h=button_hight ,d=inner_button_diameter  - inner_dilatation_margin, center= true);
                translate([0,0,top_cilinder_height/2])
                    cylinder(h=top_cilinder_height ,d=inner_button_diameter -  neck_rad_inner_button - dilatation_margin*2, center= true);
                        
            };
         translate([0,0,inner_button_bottom_height/2+EPS])
                    cylinder(h=inner_button_bottom_height+EPS ,d=inner_button_bottom_diameter, center= true);
    }
}


module arc(a, r1, r2, h){
    angles = [0, a];
    points1 = [
        for(a = [angles[0]:1:angles[1]]) [r1 * cos(a), r1 * sin(a)]
    ];
    points2 = [
        for(a = [angles[0]:1:angles[1]]) [r2 * cos(a), r2 * sin(a)]
    ]; 
    
    translate([0,0,h/2])    
    difference(){
        linear_extrude(height = h, center = true, convexity = 10, $fn = 100)
        polygon(concat([[0, 0]], points1));
        cylinder(h= h+(EPS*2),r=r2,center=true);
    }
}
