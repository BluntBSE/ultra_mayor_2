shader_type canvas_item;
uniform bool active = false;
uniform vec4 color : source_color = vec4(1.0);

void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    // Called for every pixel the material is visible on.
	if (active == true){
	    vec4 tex_color = texture(TEXTURE, UV);
	    if (tex_color.a > 0.2) {
			COLOR = color;
	        COLOR.a = tex_color.a; // Set the color to pure white with the original alpha
	    } else {
	        COLOR = tex_color; // Keep the original color for fully transparent pixels
	    }
	}
}