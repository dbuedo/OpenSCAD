$fn=100;

DEGREES_IN_CIRCLE = 360;

module trunk() {
	height = 23;
   radius = 3; 
   z_position = -20;

	translate([0,0,z_position])
  		cylinder(h=height, r=radius);
}

module base() {
	height = 2;
	radius = 16;
	z_position = -20;

	translate([0,0,z_position])
  		linear_extrude(height)
    		circle(radius);
}

module star_tip_base() {
	polyhedron(
		points=[
			[0,0,0],[3,0,0],[3,0.5,0],[0,3,0],
			[0,0,5],[0.5,0,5],[0.5,0.5,5],[0,0.5,5]
		],
		triangles=[
			[0,1,2],[2,3,0],[4,6,5],[4,7,6],
			[1,5,2],[5,6,2],[6,3,2],[3,6,7],
			[5,1,0],[4,5,0],[4,0,3],[7,4,3]
		]
	);
}

module mirror_x() {
	for(x=[0:1])
		mirror([x,0,0])
			children();
}

module mirror_y() {
	for(y=[0:1])
		mirror([0,y,0])
			children();
}

module star_tip() {
	mirror_y()
 		mirror_x()
			star_tip_base();
}

module star(number_of_tips) {
	rotation_angle = DEGREES_IN_CIRCLE / number_of_tips;

	for( k = [0:number_of_tips-1] )
		rotate( [0, k * rotation_angle] )
			star_tip();
}

module star_on_top() {
	z_position = 57;
	number_of_tips = 5;

	translate( [0, 0, z_position] )
		star(number_of_tips);
}


module leaf(height, radius) {
	back_reduction_ratio = 0.1;
	back_position = height * back_reduction_ratio;
	half_back_width = 2;
	half_front_width = 0.5;

	polyhedron(
		points=[
      		[0, -half_back_width, back_position],
			[0, half_back_width, back_position],
			[radius, half_front_width, 0],
			[radius, -half_front_width, 0],
			[0, -half_front_width, height],
			[0, half_front_width, height]
			],
		triangles=[
      		[0,2,1], [0,3,2], [0,1,4], [1,5,4],
      		[2,3,4], [2,4,5], [0,4,3], [1,2,5]
      	]
	);
}

module crown_level(z_position, height, radius, rotation){
	translate([0, 0, z_position])
		for(i=[0:29])
  			rotate([0,0,i*20+rotation])
  				leaf(height, radius);
}

module crown() {
	crown_level(0,30,30,0);
	crown_level(20,20,20,10);
	crown_level(35,20,15,0);
}

module christmas_tree() {

	base();
	trunk();
	crown();
	star_on_top();
	
translate([-5,6,45]) sphere(r=3);
translate([10,3,42]) sphere(r=3);
translate([-2,-12,40]) sphere(r=3);

translate([5,15,25]) sphere(r=3);
translate([-16,-2,26]) sphere(r=3);
translate([8,-10,28]) sphere(r=3);

translate([19,-7,12]) sphere(r=3);
translate([19,15,7]) sphere(r=3);
translate([-3,18,13]) sphere(r=3);
translate([-24,9,6]) sphere(r=3);
translate([-15,-14,11]) sphere(r=3);
translate([4,-23,7]) sphere(r=3);
}

christmas_tree();




