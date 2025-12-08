// Cleans all the shaders from the game
FlxG.game.setFilters([]);
var i:Float = 0;

public var heat = new CustomShader('heatwave');
heat.intensity = 1;
heat.vel = 1;
public var heat1 = new CustomShader('heatwave1');
heat1.intensity = 0;
heat1.v_comp = 30.0;
public var gameboy = new CustomShader('gameboy');
gameboy.interpolation = 1;
public var desat = new CustomShader('desaturation');
public var shader = new CustomShader('glitch');
public var missingno = new CustomShader('glitch1');
missingno.ENABLE_MODE = 0;
missingno.MODE = 5;
missingno.GLITCH_RECT_DIVISION = 10;
missingno.GLITCH_THR = 0.06;
public var frostbite = new CustomShader('snow');
public var aberration = new CustomShader('aberration');
aberration.amount = 1;
public var fireflies = new CustomShader('fireflies');
public var fireflies1 = new CustomShader('fireflies1');
public var blur = new CustomShader('blur');
blur.Directions = 8.0;
blur.Quality = 4.0;
blur.Size = 15;
public var blurfast = new CustomShader('lightBlur');
blurfast.Strength = 0;
public var crt = new CustomShader('crt');
public var old = new CustomShader('old');
public var mosaic = new CustomShader('mosaic');
public var monitor = new CustomShader('monitor');

function create(){
	if(FlxG.save.data.lullabyShaders) FlxG.game.addShader(shader);

	if(curSong == "missingno"){ 
		FlxG.game.addShader(missingno);
		missingno.ENABLE_MODE = 1;
		missingno.GLITCH_THR = 0.01;

		if(FlxG.save.data.lullabyShaders) FlxG.game.addShader(desat);
	}
}

function stepHit(step){
	shader.iTime = 0-health*0.01;
}

function beatHit(b) if(curSong == "missingno" && b > 70) missingno.MODE = FlxG.random.int(0,5);

function destroy(){
	FlxG.game.setFilters([]);
}
