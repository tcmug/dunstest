shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform vec3 blur = vec3(.0, .0, .0);
const float noise_scale = 320.0;

float random_f(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float random_t(vec2 st, float time) {
    return fract(sin(dot(st.xy * vec2(time * 32.0, time * 12.523), vec2(12.9898,78.233))) * 43758.5453123);
}

vec4 screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

const float PI = 3.14159;
const float HALF_PI = 3.14159 / 2.0;

vec2 distort(vec2 uv) {
	float lense_distortion = 0.2;
	vec2 temp = (uv - vec2(0.5, 0.5)) * 2.0;
	temp *= (1.0 - lense_distortion) + ((length(temp) / sqrt(2.0)) * lense_distortion);
	return (temp + vec2(1.0)) * 0.5;
}

vec3 adjust(vec3 color, vec3 adjust, float point, float steepness) {
	float v = smoothstep(-steepness, 0, length(color.rgb - vec3(point) / sqrt(3))) - 
		smoothstep(0, steepness, length(color.rgb - vec3(point) / sqrt(3)));
	return mix(color.rgb, adjust, v * 0.05);
}

vec4 sample(sampler2D source, vec2 uv, vec3 blur_specs) {
	//if (blur.z == 0.0)
	return texture(source, uv);
//	vec4 blurred;
//	// vec2 blur_vector = (uv - blur_specs.xy);
//	vec2 blur_vector = blur_specs.xy;
//	int i = -5;
//	while (i <= 5) {
//		blurred += texture(source, uv + (blur_vector * float(i)));
//		i++;
//	}
//	blurred = blurred / float(i * 2);
//	blurred.a = 1.0;
//	return blurred;
}

void fragment() {
	float aspect = 0.6;
	vec2 scaler = vec2(noise_scale, noise_scale * aspect);
	vec2 uv = SCREEN_UV;
	uv = distort(uv);
	vec4 frag_in = sample(SCREEN_TEXTURE, uv, blur);
	vec2 stepped_uv = vec2(
		(floor(UV.x * scaler.x) / scaler.x),
		(floor(UV.y * scaler.y) / scaler.y)
	);
	//vec4 noise_in = vec4(random_t(stepped_uv, TIME));
	//float lightness = max(frag_in.r, max(frag_in.g, frag_in.b));
	//COLOR.rgb = mix(noise_in, frag_in, 0.8).rgb;
	COLOR.rgb = frag_in.rgb;
}