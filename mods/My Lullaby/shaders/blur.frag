#pragma header
uniform float Directions; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
uniform float Quality; // BLUR QUALITY (Default 4.0 - More is better but slower)
uniform float Size; // BLUR SIZE (Radius)

void main()
{
    float Pi = 6.28318530718; // Pi*2
    
    // GAUSSIAN BLUR SETTINGS {{{

    // GAUSSIAN BLUR SETTINGS }}}
   
    vec2 Radius = Size/openfl_TextureSize.xy;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = openfl_TextureCoordv;
    // Pixel colour
    vec4 Color = texture2D(bitmap, uv);
    
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
			Color += texture2D(bitmap, uv+vec2(cos(d),sin(d))*Radius*i);		
        }
    }
    
    // Output to screen
    Color /= Quality * Directions - 15.0;
    gl_FragColor =  Color;
}