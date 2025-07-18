#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 jpeg;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

// Taken from https://www.shadertoy.com/view/MdcGzj

const mat3 rgb2ycbcr = mat3(
    0.299, -0.168736, 0.5, 
    0.587, -0.331264, -0.418688,   
    0.114, 0.5, -0.081312
);

const mat3 ycbcr2rgb = mat3(
    1.0, 1.0, 1.0,
    0.0, -0.344136, 1.772, 
    1.402, -0.714136, 0.0
);

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

// simulating 8:4:4 compression ratio (16bit)
vec3 compress_ycbcr_844 (vec3 rgb) {
    vec3 ycbcr = rgb2ycbcr * rgb;
    ycbcr.r = floor(ycbcr.r * 255.0 + 0.25) / 255.0;
    ycbcr.gb += 0.75;
    ycbcr.gb = floor(ycbcr.gb * 15.0 + 0.25) / 15.0;
    ycbcr.gb -= 0.75;    
    return ycbcr2rgb * ycbcr;
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    //vec4 tex = Texel( texture, texture_coords);
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

	vec2 rndcoords = texture_coords;

	float iTime = time+jpeg.r;
	float t = time+jpeg.r;
	
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);

	rndcoords.x += 0.0005 * (rand(vec2(iTime, floored_uv.y)) - rand(vec2(iTime*6., floored_uv.y*0.9)));
	rndcoords.y += 0.001 * (rand(vec2(iTime*2., floored_uv.y*0.9)) - rand(vec2(iTime*5., floored_uv.y*0.8)));
	//rndcoords.z += 0.012 * (rand(vec2(iTime*3., floored_uv.y*0.8)) - rand(vec2(iTime*4., floored_uv.y)));

	vec4 tex = Texel( texture, rndcoords );
	tex = dissolve_mask(tex, rndcoords, uv);
	vec3 col = tex.rgb;

	// https://www.shadertoy.com/view/ttlGDf
	uv.y /= texture_details.b/texture_details.a;
    uv = 4.0*(vec2(0.5) - uv);

    for(float k = 1.0; k < 3.0; k+=1.0){ 
        uv.x += 0.1 * sin(2.0*t+k*1.5 * uv.y)+t*0.5;
        uv.y += 0.1 * cos(2.0*t+k*1.5 * uv.x);
    }

    //Time varying pixel colour
    col += 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0.,2.,4.));
	//col = pow(col, vec3(1.-0.4545));

	tex = vec4(compress_ycbcr_844(col),tex.a);
	return tex;
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0.,0.,0.,scale);
}
#endif