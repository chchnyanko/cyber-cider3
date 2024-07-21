shader_type canvas_item;

uniform vec2 centre;
uniform float radius;
uniform vec2 player_pos;
uniform vec4 background_colour;
uniform sampler2D player_indicator;

varying bool in_circle;

void fragment(){
	if(length(UV - centre) > radius){
		in_circle = false;
	}
	else{
		in_circle = true;
	}
	if(in_circle){
		COLOR = texture(TEXTURE, UV);
		if(COLOR.a == 0.0) {
			COLOR = vec4(1.0, 1.0, 1.0, 1.0);
		}
	}
	else{
		COLOR.a = 0.0;
	}
	if(length(UV - player_pos) < 0.05) {
		COLOR = vec4(0.5, 0.5, 0.5, 1.0);
	}
}