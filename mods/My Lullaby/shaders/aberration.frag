#pragma header

/////////////////////////////////////////////////////
//
//	 CHROMATIC ABBERATION
//
//	 by Tech_
//
//	 Pincushion Distortion (by parameterized): https://www.shadertoy.com/view/lttXD4
//
/////////////////////////////////////////////////////

uniform float iTime;

/////////////////////////////////////////////////////

#define DISTORTION_AMOUNT (sin(iTime * 0.8) + 1.0) / 2.0

/////////////////////////////////////////////////////

vec2 PincushionDistortion(in vec2 uv, float strength) 
{
	vec2 st = uv - 0.5;
    float uvA = atan(st.x, st.y);
    float uvD = dot(st, st);
    return 0.5 + vec2(sin(uvA), cos(uvA)) * sqrt(uvD) * (1.0 - strength * uvD);
}

vec3 ChromaticAbberation(sampler2D tex, in vec2 uv) 
{
	float rChannel = texture2D(tex, PincushionDistortion(uv, 0.3 * DISTORTION_AMOUNT)).r;
    float gChannel = texture2D(tex, PincushionDistortion(uv, 0.15 * DISTORTION_AMOUNT)).g;
    float bChannel = texture2D(tex, PincushionDistortion(uv, 0.075 * DISTORTION_AMOUNT)).b;
    vec3 retColor = vec3(rChannel, gChannel, bChannel);
    return retColor;
}

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec3 col = ChromaticAbberation(bitmap, uv);
    
    gl_FragColor = vec4(col, 1.0);
}