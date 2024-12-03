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
varying vec2 modified_uv;
uniform float horizontal_interval = 1.0;
uniform float vertical_displacement = 50.0;
uniform vec2 pixel_size = vec2(30.0, 30.0);


uniform vec2 custom_resolution = vec2(500,500); //Bigger == more dissolve pixels? Why?
float flip_flop(float time) {
    return mod(floor(time), 2.0) == 0.0 ? 1.0 : -1.0;
}

void vertex () {
	vec2 within_texture_pixel=vec2(floor(UV * custom_resolution));
    float interval_position = mod(VERTEX.x, horizontal_interval * 2.0);
	modified_uv = VERTEX;
	float modified_time = TIME * 1.0;
	//if(sin(modified_time) > random(within_texture_pixel)){
		//VERTEX.y += 50.0;
		//VERTEX.x += 50.0 * flip_flop(modified_time);
	//}
	// Apply vertical displacement if within the first interval
	if (interval_position < horizontal_interval) {
	    VERTEX.y += vertical_displacement;
		// Adjust the UV coordinates to account for the displacement
		modified_uv.y -= vertical_displacement / TEXTURE_PIXEL_SIZE.y;
	}
	//vertex_pos = VERTEX; //passed to fragment for real_uv

}

void fragment() {
  vec2 tex_size = vec2(textureSize(TEXTURE, 0));
  vec2 real_uv = modified_uv / tex_size;
  COLOR.a = texture(TEXTURE, UV).a;
if (COLOR.a ==1.0){
  COLOR.g = texture(TEXTURE, real_uv).x;
  COLOR.b = real_uv.y;
}

}