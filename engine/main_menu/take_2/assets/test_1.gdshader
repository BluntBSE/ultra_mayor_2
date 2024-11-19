shader_type canvas_item;

uniform vec2 direction = vec2(1.0,0.0);
uniform float speed_scale = 0.0;


void fragment() {
    vec2 move = direction * TIME * speed_scale;

    // Sample the texture with the modified UV coordinates
    vec4 tex_color = texture(TEXTURE, UV + move);

    // Define a purple tint color
    vec4 purple_tint = vec4(0.15, 0.05, 0.15, 1.0); // Adjust the values as needed

    // Apply the purple tint and darken the color
    vec4 tinted_color = tex_color * purple_tint;

    // Reduce the brightness (darken the color)
    float brightness_factor = 0.8; // Adjust the value to control the darkness
    tinted_color.rgb *= brightness_factor;

    // Set the final color
    COLOR = tinted_color;
}