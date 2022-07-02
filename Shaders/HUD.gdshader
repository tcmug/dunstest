// NOTE: Shader automatically converted from Godot Engine 3.4.4.stable's SpatialMaterial.

shader_type spatial;
render_mode blend_mix,depth_draw_never,cull_back,diffuse_burley,specular_schlick_ggx,depth_test_disable,unshaded;

uniform float flicker;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

vec2 glitch(vec2 in_uv, float mult, int s, vec2 amount) {
	int v_flicker2 = int(TIME * mult) % 44; 
	if (int(in_uv.y * 10.0) == v_flicker2)
		return in_uv + amount;
	return in_uv;
}

void fragment() {
	vec2 base_uv = UV;

	base_uv = glitch(base_uv, 200.0, 20, flicker * 4.0 * vec2(-0.003, .0));
	base_uv = glitch(base_uv, 605.0, 44, flicker * 4.0 * vec2(-0.006, .0));
	base_uv = glitch(base_uv, 400.0, 20, flicker * 4.0 * vec2(0.00366, .023));
	base_uv = glitch(base_uv, 303.0, 50, flicker * 4.0 * vec2(-0.002, -.03));

	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo_tex.rgb;
	ALPHA = 0.0;
	if (albedo_tex.r > 0.0)
		ALPHA = 0.95 + (sin(TIME * 10.0) * 0.05);
		
	if (int((UV.y * 768.0) + TIME * 50.0) % 5 == 1)
		ALPHA = 0.0;
}
