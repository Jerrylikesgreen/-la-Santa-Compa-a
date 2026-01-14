shader_type canvas_item;

uniform sampler2D noise_tex : source_color, repeat_enable;
uniform vec2 tiling = vec2(4.0, 4.0);
uniform vec2 scroll_speed = vec2(0.02, 0.01);
uniform float density = 0.6;
uniform float softness = 0.4;
uniform vec4 fog_color : source_color = vec4(0.85, 0.85, 0.85, 1.0);

void fragment() {
	vec2 uv = UV * tiling;
	vec2 scroll_uv = uv + TIME * scroll_speed;

	float noise = texture(noise_tex, scroll_uv).r;
	float fog = smoothstep(density - softness, density + softness, noise);

	COLOR = vec4(fog_color.rgb, fog * fog_color.a);
}
