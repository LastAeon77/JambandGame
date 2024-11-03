shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
void vertex() {
	// Called for every vertex the material is visible on.
}
uniform float fade_amount;
void fragment() {
	float visibility = float(UV.y < 1.0 - fade_amount);
	COLOR = texture(TEXTURE,UV);
	COLOR.a *= visibility; 
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
