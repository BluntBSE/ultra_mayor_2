shader_type canvas_item;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float sprite_scale_begin : hint_range(0.0, 5.0) = 1.0;
uniform float sprite_scale_end : hint_range(0.0, 5.0) = 1.0;
uniform float x_displacement : hint_range(0.0,100.0) = 50.0;
uniform float y_displacement: hint_range(0.0,200.0) = 50.0;
uniform float speed : hint_range(0.0,100.0) = 10.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// the fragment UV does not represent the UV of the
// canvas_item rect but some uv of the font texture
// in order to get the canvas item UV the item size
// needs to be passed into the shader.
varying vec2 vertex_pos;
varying float custom_time;
uniform vec4 color_1 = vec4(1.0,1.0,1.0,0.0);
uniform vec4 color_2 = vec4(0.5,0.5,0.0,0.0);

uniform vec2 custom_resolution = vec2(1,500); //Distortion frequency per direction
uniform bool active = false;

float flip_flop(float time) {
    return mod(time, 2.0) > 1.0 ? 1.0 : -1.0;
}

void vertex () {
	if (active){

	custom_time = speed * TIME;
	vertex_pos = VERTEX; //passed to fragment for real_uv
	vec2 within_texture_pixel=vec2(floor(UV * custom_resolution));


	if( (sin(custom_time) > random(within_texture_pixel)) )  {
		VERTEX.y += x_displacement;
		VERTEX.x += y_displacement * flip_flop(custom_time);
		//VERTEX *= mix(sprite_scale_begin, sprite_scale_end, 1.0);

	}

	if ( ( tan(custom_time) > random(within_texture_pixel)) ) {
		VERTEX.y -= x_displacement;
		VERTEX.y -= y_displacement;
	}

	//Close if active
	}

}

void fragment() {
	if(active){
	//COLOR -= vec4(1.0,1.0,1.0,0.0); //Unset the color
	//COLOR += color_1;



	vec2 within_texture_pixel=vec2(floor(UV * custom_resolution));
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	vec2 real_uv = vertex_pos / tex_size;
	if( (sin(custom_time) > random(within_texture_pixel) - 0.3) )  {
	COLOR -= color_1;

}
	if ( ( tan(custom_time) > random(within_texture_pixel)) ) {
		COLOR += color_1;
		COLOR -= color_2; //Unset the color

		VERTEX.y -= x_displacement;
		VERTEX.y -= y_displacement;
	}
	//Close if active
	}

}