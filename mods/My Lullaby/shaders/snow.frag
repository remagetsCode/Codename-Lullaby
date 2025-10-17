//Remagets: It was so difficult for me porting this, i dont even know how i ended up making this work, goooood!

#pragma header
// Copyright (c) 2013 Andrew Baldwin (twitter: baldand, www: http://thndl.com)
// License = Attribution-NonCommercial-ShareAlike (http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US)

// "Just snow"
// Simple (but not cheap) snow made from multiple parallax layers with randomly positioned 
// flakes and directions. Also includes a DoF effect. Pan around with mouse.

#define LIGHT_SNOW // Comment this out for a blizzard
uniform float iTime; // Comment this out for a blizzard

#ifdef LIGHT_SNOW
	uniform float LAYERS;
	uniform float DEPTH;
	uniform float WIDTH;
	uniform float SPEED;
#else // BLIZZARD
	#define LAYERS 200
	#define DEPTH .1
	#define WIDTH .8
	#define SPEED 1.5
#endif

void main()
{
	const mat3 p = mat3(13.323122,23.5112,21.71123,21.1212,28.7312,11.9312,21.8112,14.7212,61.3934);
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize.xy;
	vec2 uv = openfl_TextureSize.xy + vec2(1.,openfl_TextureSize.y/openfl_TextureSize.x)*fragCoord.xy / openfl_TextureSize.xy;
	vec3 acc = vec3(0.0);
	float dof = 5.*sin(iTime*.1);
	for (int i=0;i<LAYERS;i++) {
		float fi = float(i);
		vec2 q = uv*(1.+fi*DEPTH);
		q += vec2(q.y*(WIDTH*mod(fi*7.238917,1.)-WIDTH*.5),SPEED*iTime/(1.+fi*DEPTH*.03));
		vec3 n = vec3(floor(q),31.189+fi);
		vec3 m = floor(n)*.00001 + fract(n);
		vec3 mp = (31415.9+m)/fract(p*m);
		vec3 r = fract(mp);
		vec2 s = abs(mod(q,1.)-.5+.9*r.xy-.45);
		s += .01*abs(2.*fract(10.*q.yx)-1.); 
		float d = .6*max(s.x-s.y,s.x+s.y)+max(s.x,s.y)-.01;
		float edge = .005+.05*min(.5*abs(fi-5.-dof),1.);
		acc += vec3(smoothstep(edge,-edge,d)*(r.x/(1.+.02*fi*DEPTH)));
	}
	gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv)+vec4(vec3(acc),1.0);
}