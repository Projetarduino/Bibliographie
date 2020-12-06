include <gears.scad>;

// in cm

//$fs = 0.1;

plywoodThickness = 0.5;
baseSize = 30;

bearingThickness = 2;
bearingSizeHole = 14.2;
bearingSize = 20;

supportHeight = 30;
supportWidthBase = 15;
supportWidthTop = 5;
supportSpacing = 1/4 * baseSize;

rodDiameter = 1;

numSpeakersRow = 7;
numSpeakersColumn = 7;
transducerDiameter = 1.6;
transducerHeight = 1.2;
totSpeakerWidth = (numSpeakersRow+1)*transducerDiameter;
totSpeakerHeight = (numSpeakersColumn+1)*transducerDiameter;
perfboardThickness = 0.1;

servoWidth = 3.5;
servoHeight = 4.5;
servoThickness = 1;

// base top and bottom + bearing
cylinder(plywoodThickness, d=baseSize);

translate([0, 0, plywoodThickness+0.01]){
	spur_gear(0.2, 20, 2*plywoodThickness, 0.1, pressure_angle=20, helix_angle=0, optimized=true);
	
	color("pink")
    difference(){
        cylinder(bearingThickness, d=bearingSize);
        translate([0,0,- 0.1])
        cylinder(bearingThickness+0.2, d=bearingSizeHole);
    }
    
    translate([0, 0, bearingThickness]){
        cylinder(plywoodThickness, d=baseSize);
        
        translate([-supportSpacing, 0, plywoodThickness])
            support();
		translate([supportSpacing, 0, plywoodThickness])
            support();
		
		translate([0, 0, supportHeight + plywoodThickness])
		rotate(90, [0,1,0])
		cylinder(2*supportSpacing, d=rodDiameter, center=true);
		
		translate([0, -rodDiameter/2, supportHeight])
		speakerArray();
		
		// servomotor
		color("purple")
		translate([supportSpacing+plywoodThickness/2, -servoWidth/2, plywoodThickness + supportHeight+supportWidthTop/4 - 3/4*servoHeight])
		cube([servoThickness, servoWidth, servoHeight], center=false);
		
		translate([-4, 0, plywoodThickness])
		nema17_gear();
		
		// electronics
		color("red")
		translate([11, 0, plywoodThickness + 2 /2])
		cube([5, 8, 2], center=true);
    }
}

module support(){
	union(){
		translate([0, 0, supportHeight])
		rotate(90, [0,1,0])
		cylinder(plywoodThickness, d=supportWidthTop,center=true);
		
		polyhedron(
			points = [
				[-plywoodThickness/2, supportWidthBase/2, 0],
				[plywoodThickness/2, supportWidthBase/2, 0],
				[plywoodThickness/2, supportWidthTop/2, supportHeight],
				[-plywoodThickness/2, supportWidthTop/2, supportHeight],
				
				[-plywoodThickness/2, -supportWidthTop/2, supportHeight],
				[plywoodThickness/2, -supportWidthTop/2, supportHeight],
				
				[plywoodThickness/2, -supportWidthBase/2, 0],
				[-plywoodThickness/2, -supportWidthBase/2, 0]
			],
			faces=[
				[0, 3, 2, 1], // back face
				[4, 3, 2, 5], // top face
				[7, 4, 5, 6], // front face
				[7, 0, 1, 6], // bottom face
				[7, 0, 3, 4], // left face
				[6, 5, 2, 1] // right face
			]
		);
	}
}

module speakerArray(){
	incrWidth = 1;
	incrHeight = 6;
	
	translate([ (transducerDiameter-totSpeakerWidth)/2, 0, (transducerDiameter-totSpeakerHeight)/2 ])
	union(){
		color("green")
		translate([-(transducerDiameter+incrWidth)/2, 0, -(transducerDiameter+incrHeight)/2])
		cube([totSpeakerWidth+incrWidth, perfboardThickness, totSpeakerHeight+incrHeight], center=false);
		
		color("grey")
		for (i=[0:numSpeakersRow]){
			for (n=[0:numSpeakersColumn]){
				translate([n*transducerDiameter, -transducerHeight/2, i*transducerDiameter])
				rotate(90, [1,0,0])
				cylinder(transducerHeight, d=transducerDiameter, center=true);
			}
		}
	}
	
	// camera
	color("yellow")
	translate([0, -1 /2, (3 + totSpeakerHeight) /2])
	cube([3, 1, 3], center=true);
}

module nema17_gear(){
	faceSize = 4.23;
	length = 6;
	facePlateD = 2.2;
	facePlateT = 0.2;
	shaftL = 2.4;
	shaftD = 0.5;
	
	color("blue"){
		translate([0, 0, length/2 + facePlateT])
		cube([faceSize, faceSize, length], center=true);
		cylinder(facePlateT, d=facePlateD);
	}
	color("grey")
	translate([0, 0, -shaftL])
	cylinder(shaftL, d=shaftD);
	
	translate([0, 0, -shaftL])
	spur_gear(0.2, 20, 2*plywoodThickness, 0.1, pressure_angle=20, helix_angle=0, optimized=true);
	//spur_gear(module, tooth_number, width, bore, pressure_angle=20, helix_angle=0, //optimized=true)
}

