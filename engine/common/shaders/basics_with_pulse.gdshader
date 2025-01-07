shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;
uniform bool b_pulse = false;
uniform bool c_pulse = false;
uniform bool s_pulse = false;
uniform float c_speed = 1.0;
uniform float b_speed = 1.0;
uniform float s_speed = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
    vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	
	if (b_pulse == true){
		c.rgb = mix(vec3(0.0), c.rgb, brightness * sin(TIME * b_speed));	
	}
	else{
				c.rgb = mix(vec3(0.0), c.rgb, brightness);	
	}

	if (c_pulse == true){
	    c.rgb = mix(vec3(0.5), c.rgb, contrast * sin(TIME * c_speed));	
	}
	else{
		    c.rgb = mix(vec3(0.5), c.rgb, contrast);		
	}
	if(s_pulse == true){
	    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, (saturation*sin(TIME*s_speed)));	
	}
	else{
		    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);	
	
	}

    COLOR.rgb = c;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
