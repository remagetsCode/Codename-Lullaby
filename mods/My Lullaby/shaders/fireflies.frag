#pragma header

uniform float iTime;

# define radius 0.001
# define sphere_Counts 30.0

float N21(vec2 p) {
	vec3 a = fract(vec3(p.xyx) * vec3(213.897, 653.453, 253.098));
    a += dot(a, a.yzx + 79.76);
    return fract((a.x + a.y) * a.z);
}

vec2 N22(vec2 p){
    float n = N21(p);
    return vec2(n,N21(n+p));
}


void main()
{
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize.xy;
    vec2 uv = fragCoord/(openfl_TextureSize.xy /2.0)-1.0;
	uv.x *= openfl_TextureSize.x/openfl_TextureSize.y;
    
    vec3 pointLight;
    for (float i=0.0; i<sphere_Counts; i+=1.0)
    {
        vec2 rnd = N22(vec2(i,i*2.0));
    	vec2 point = vec2(cos(iTime*rnd.x+i)*2.0,sin(iTime*rnd.y+i));
    	float distanceToPoint = distance(uv, point);
    	pointLight += vec3(radius/distanceToPoint)*vec3(sin(iTime+i)/2.5+0.7);
    }
    pointLight *= vec3(0.5,0.6,0.2);
    
    /*
    vec3 pointLight2;
    for (float i=60.0; i<80.0;i+=1.0)
    {
        vec2 rnd = N22(vec2(i,i+2.0));
    	vec2 point = vec2(cos(iTime*rnd.x+i)*1.5,sin(iTime*rnd.y+i));
    	float distanceToPoint = distance(uv, point);
    	pointLight2 += vec3(radius/distanceToPoint) * vec3(clamp(sin(iTime+i)/2.0+0.6,0.1,1.0));
    }
    pointLight2 *= vec3(0.5,0.8,0.5);
   	pointLight += pointLight2;
    */
    
    gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv)+vec4(pointLight,1.0);
}

