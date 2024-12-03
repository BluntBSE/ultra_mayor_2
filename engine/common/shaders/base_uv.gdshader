shader_type canvas_item;
uniform bool not_transparent = false;


float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

uniform float displacement_amount = 1.0;
uniform float grid_size = 10.0;
varying vec2 displaced_UV;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;




void vertex () {
}

void fragment() {
  vec2 tex_size = vec2(textureSize(TEXTURE, 0));
  COLOR.a = texture(TEXTURE, UV).a;
COLOR -= vec4(0.8,0.8,0.8,0.0);
  COLOR.g += UV.x;
  COLOR.b += UV.y;
}