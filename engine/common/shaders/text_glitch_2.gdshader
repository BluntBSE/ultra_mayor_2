shader_type canvas_item;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}


varying vec2 full_UV;
varying vec2 displaced_UV;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// the fragment UV does not represent the UV of the
// canvas_item rect but some uv of the font texture
// in order to get the canvas item UV the item size
// needs to be passed into the shader.
uniform vec2 size;
varying vec2 vertex_pos;
uniform float speed;
varying float custom_time;

uniform vec2 custom_resolution = vec2(500,500); //Bigger == more dissolve pixels? Why?
float flip_flop(float time) {
    return mod(time, 2.0) > 1.0 ? 1.0 : -1.0;
}

void vertex () {
	custom_time = 5.0 * TIME;
	vertex_pos = VERTEX; //passed to fragment for real_uv
	vec2 within_texture_pixel=vec2(floor(UV * custom_resolution));


	if(sin(custom_time) > random(within_texture_pixel)){
		VERTEX.y += 50.0;
		VERTEX.x += 50.0 * flip_flop(custom_time);
	}

}

void fragment() {

}