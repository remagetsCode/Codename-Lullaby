#pragma header

uniform float iTime;
uniform float intensity;
uniform float vel;

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = openfl_TextureCoordv;

    // Time varying pixel color
    float jacked_time = 5.5*iTime;
    vec2 scale = vec2(0.5*vel);
   	
    uv += 0.01*sin(scale*jacked_time + length( uv )*(10.0*intensity));
    gl_FragColor = texture2D(bitmap, uv).rgba;
}