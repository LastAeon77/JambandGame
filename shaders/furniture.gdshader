shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}
uniform vec2 p1_pos;
uniform vec2 p2_pos;
void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = vec3(1,1,1);
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
