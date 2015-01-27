
RENDER_RESOLUTION = 100;
$fn = RENDER_RESOLUTION;

DEGREES_IN_CIRCLE = 360;

module mirror_x() {
	for(x = [0 : 1])
		mirror([x, 0, 0])
			children();
}

module mirror_y() {
	for( y = [0 : 1])
		mirror([0, y, 0])
			children();
}

module trunk() {
	height = 23;
   radius = 3; 
   z_position = -20;

	translate([0, 0, z_position])
  		cylinder(h = height, r = radius);
}

module base() {
	height = 2;
	radius = 16;
	z_position = -20;

	translate([0, 0, z_position])
  		linear_extrude(height)
    		circle(radius);
}

module star_tip_base() {
	height = 5;
	side_length = 3;
	side_width = 3;
	bezel = 0.5;
	polyhedron(
		points=[
			[0, 0, 0], [side_length, 0, 0], 
			[side_length, bezel, 0], [0, side_width, 0],
			[0, 0, height], [bezel, 0, height], 
			[bezel, bezel, height], [0, bezel, height]
		],
		triangles=[
			[0,1,2], [2,3,0], [4,6,5], [4,7,6],
			[1,5,2], [5,6,2], [6,3,2], [3,6,7],
			[5,1,0], [4,5,0], [4,0,3], [7,4,3]
		]
	);
}

module star_tip() {
	mirror_y()
 		mirror_x()
			star_tip_base();
}

module star(number_of_tips) {
	rotation_angle = DEGREES_IN_CIRCLE / number_of_tips;

	for( k = [0 : number_of_tips - 1] )
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

module repeat_rotating_z(times) {
	rotation_angle = DEGREES_IN_CIRCLE / times;
	for(i = [0 : times-1])
  		rotate([0, 0, i * rotation_angle])
  			children();
}

module leaves(height, radius) {
	number_of_leaves = 18;
	repeat_rotating_z(number_of_leaves)
		leaf(height, radius);
}

module crown_level(z_position, height, radius, start_rotation){
	translate([0, 0, z_position])
		rotate([0, 0, start_rotation])
		   leaves(height, radius);
}

module crown() {
	crown_level(0, 30, 30, 0);
	crown_level(20, 20, 20, 10);
	crown_level(35, 20, 15, 0);
}

module christmas_ball() {
	radius = 3;
	sphere(r=radius);
}

module christmas_balls() {
	balls = [
				[-5,6, 45], [10,3,42], [-2,-12,40],
				[5,15,25], [-16,-2,26], [8,-10,28],
				[19,-7,12], [19,15,7], [-3,18,13],
				[-24,9,6], [-15,-14,11], [4,-23,7]
			];
	for(i = [0 : len(balls) - 1])
		translate(balls[i])
			christmas_ball();
}

module christmas_tree() {
	base();
	trunk();
	crown();
	christmas_balls();
	star_on_top();
}

christmas_tree();
