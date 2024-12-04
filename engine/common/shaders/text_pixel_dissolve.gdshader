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

uniform vec2 custom_resolution = vec2(500,500); //Bigger == more dissolve pixels? Why?

void vertex () {
	vertex_pos = VERTEX;
}

void fragment() {
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	vec2 real_uv = vertex_pos / tex_size;
	//////

	vec2 within_texture_pixel=vec2(floor(real_uv * custom_resolution));
	vec4 base_color = texture(TEXTURE,UV); //Captures texture, including alpha
	if(sin(TIME) > random(within_texture_pixel))
		COLOR = base_color;
	else
		COLOR = vec4(0.0,0.0,0.0,0.0);

	//COLOR.a = texture(TEXTURE, UV).a;
	//COLOR.g = real_uv.x;
	//COLOR.b = real_uv.y;
}