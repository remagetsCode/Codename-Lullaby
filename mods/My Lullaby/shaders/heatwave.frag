#pragma header

uniform float iTime;

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = openfl_TextureCoordv;

    // Time varying pixel color
    float jacked_time = 5.5*iTime;
    const vec2 scale = vec2(.5);
   	
    uv += 0.01*sin(scale*jacked_time + length( uv )*10.0);
    gl_FragColor = texture2D(bitmap, uv).rgba;
}