shader_type canvas_item;

uniform sampler2D noise;

void fragment() {
	COLOR *= texture(noise, UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
