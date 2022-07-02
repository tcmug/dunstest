shader_type spatial;
render_mode cull_disabled;

uniform vec4 base_color: hint_color;
uniform sampler2D noise_texture;
uniform vec4 checker_a: hint_color;
uniform vec4 checker_b: hint_color;

varying vec3 world_pos;
varying vec3 world_normal;
varying vec3 world_tangent;
varying float wall;

const float line_width = 0.025;
const float area_scale = 0.013;

float random_f(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float random_t(vec2 st, float time) {
    return fract(sin(dot(st.xy * vec2(time * 32.0, time * 12.523), vec2(12.9898,78.233))) * 43758.5453123);
}

vec3 noise(vec3 p, vec3 normal, sampler2D text) {
	if (abs(normal.y) > 0.8)
		return texture(text, p.xz + vec2(p.y * 0.23, p.y * 0.873)).rgb;
	if (abs(normal.x) > 0.8)
		return texture(text, p.yz).rgb;
	return texture(text, p.xy).rgb;
}

float map_range(float v, float smin, float smax, float tmin, float tmax) {
	return (((clamp(v, smin, smax) - smin) / (smax - smin)) * (tmax - tmin)) + tmin;
}


float concrete_bumps(vec3 pos, vec3 normal, sampler2D source) {
	float depth = map_range(noise(pos, normal, source).x, 0.0, 0.4, 0.0, 1.0);
	float area = map_range(noise(pos  area_scale, normal, source).x, 0.5, 0.6, 0.0, 1.0);
	return (depth * area) + (1.0 - area);
}

float concrete_detail_bumps(vec3 pos, vec3 normal, sampler2D source) {
	float depth = map_range(noise(pos, normal, source).x, 0.0, 0.4, 0.0, 1.0);
	float area = map_range(noise(pos * area_scale, normal, source).x, 0.49, 0.5, 0.0, 1.0);
	float detail = map_range(noise(pos * 4.0, normal, source).x, 0.5, 0.6, 0.8, 1.0);
	if (wall < 0.5)
		return (((depth * area) + (1.0 - area)) * detail);
	return (((depth * area) + (1.0 - area)) * detail) * map_range(area, 0.0, 1.0, 1.0, 0.1);
}


float checker(vec3 pos) {
	int x = int(abs(floor(world_pos.x))) % 2;
	int y = int(abs(floor(world_pos.y))) % 2;
	int z = int(abs(floor(world_pos.z))) % 2;

	if ((x == 1 && y == 1 && z == 0)) {
		return .0;
	}
	else if ((x == 0 && y == 1 && z == 1)) {
		return .0;
	}
	else if ((x == 1 && y == 0 && z == 1)) {
		return .0;
	}
	else if ((x == 0 && y == 0 && z == 0)) {
		return .0;
	}
	return 1.0;
}


void vertex() {
	world_pos = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	mat4 w = WORLD_MATRIX;
	//w[3] = vec4(.0, .0, .0, 1.0);
	world_normal = (w * vec4(NORMAL, 0.0)).xyz;
	world_tangent = (w * vec4(TANGENT, 0.0)).xyz;
	wall = 1.0 - abs(world_normal.y);
}

void fragment() {

	if (!FRONT_FACING) {
		ALBEDO = vec3(1.0, 1.0, 1.0);
		return;
	}

	float scale = 0.4;
	vec3 color = vec3(0.0);
	vec3 normal = vec3(0.0);
	float roughness = 0.0;

	vec3 sample_pos = world_pos;
	float deep = concrete_bumps(sample_pos * scale, world_normal, noise_texture);
	float colouring = map_range(noise(sample_pos * 0.03, world_normal, noise_texture).x, 0.0, 1.0, .0, 1.0);
	color = vec3(104.0 / 255.0, 101.0 / 255.0, 89.0 / 255.0);
	
	roughness = map_range(noise(sample_pos * 0.02, world_normal, noise_texture).r, 0.4, 0.7, 0.0, 1.0);
	float area = map_range(noise(sample_pos * scale * area_scale, world_normal, noise_texture).x, 0.499, 0.5, 1.0, 0.0);
	if (wall > 0.5)
		roughness = (((roughness * area) + (1.0 - area)) * .2) + .5;
	else
		roughness = roughness * 0.2 + 0.5;

	float checker = checker(world_pos) * map_range(noise(sample_pos * 0.03, world_normal, noise_texture).x, 0.3, 0.7, 0.7, 1.0);
	checker *= area;
	if (wall > 0.5)
		color = mix(base_color, mix(checker_a, checker_b, checker), area).rgb;
	else
		color = base_color.rgb;

	vec3 b = world_tangent;
	vec3 c = cross(b, world_normal);
	float vscale = 0.003;
//	b *= 0.013;
//	c *= 0.013;
	float av = concrete_detail_bumps((sample_pos * scale) - ((vscale * (b - c)) * 0.5), world_normal, noise_texture);
	float bf = av - concrete_detail_bumps((sample_pos * scale) + (vscale * b), world_normal, noise_texture);
	float cf = av - concrete_detail_bumps((sample_pos * scale) + (vscale * c), world_normal, noise_texture);
	//bf *= 0.3;
	//cf *= 0.3;
	// NORMAL = (INV_CAMERA_MATRIX * vec4(world_normal, 0.0)).xyz;
	NORMAL = (INV_CAMERA_MATRIX * vec4(normalize(world_normal + (b * bf) + (c * cf)), 0.0)).xyz;
	ALBEDO = color;
	ROUGHNESS = roughness;
	// ALBEDO = vec3(av);
}
