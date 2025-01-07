shader_type canvas_item;
uniform bool active = false;

void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    // Called for every pixel the material is visible on.
	if (active == true){
	    vec4 tex_color = texture(TEXTURE, UV);
	    if (tex_color.a > 0.2) {
	        COLOR = vec4(1.0, 1.0, 1.0, tex_color.a); // Set the color to pure white with the original alpha
	    } else {
	        COLOR = tex_color; // Keep the original color for fully transparent pixels
	    }
	}
}