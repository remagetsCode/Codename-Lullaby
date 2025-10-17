#pragma header

uniform float iTime;

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = openfl_TextureCoordv;
    vec3 col = vec3(0.0,0.0,0.0);
    
    

     //zoom in to avoid the edge clipping
     float zoomIn = 0.1;
     uv = (zoomIn/2.0) + (uv * (1.0 - zoomIn));
     
     //customisation variables
     float wiggle_speed = 2.5;
     float vertical_compression = 40.0;
     float effect_intensity = 0.005;
     
     float x_off = sin((iTime * wiggle_speed) + (uv.y * vertical_compression));//offset the x part of the uv based on y and propagate up based on time
     uv.x += effect_intensity * x_off;
     
     
     col = texture2D(bitmap, uv).rgb;
     
     //play with the colours a bit
     col = mix(col, vec3(1.0,1.0,0.5), (1.0 - col.b)/10.0);
     
    
    // Output to screen
    gl_FragColor = vec4(col,1.0);
}