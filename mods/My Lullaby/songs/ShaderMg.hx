// Cleans all the shaders from the game
FlxG.game.setFilters([]);
var i:Float = 0;

public var heat = new CustomShader('heatwave');
public var heat1 = new CustomShader('heatwave1');
public var desat = new CustomShader('desaturation');
public var shader = new CustomShader('glitch');
public var missingno = new CustomShader('glitch1');
public var frostbite = new CustomShader('snow');
public var aberration = new CustomShader('aberration');
public var fireflies = new CustomShader('fireflies');
public var fireflies1 = new CustomShader('fireflies1');
public var blur = new CustomShader('blur');
blur.Directions = 8.0;
blur.Quality = 4.0;
blur.Size = 0;
public var blurfast = new CustomShader('lightBlur');
blurfast.Strength = 0;

function create(){
	if(FlxG.save.data.lullabyShaders) FlxG.game.addShader(shader);

	if(curSong == "missingno"){ 
		FlxG.game.addShader(missingno);
		if(FlxG.save.data.lullabyShaders) FlxG.game.addShader(desat);
	}
}

function stepHit(step){
	shader.iTime = 0-health*0.01;
}

function update(elapsed){
	i += elapsed;
	//heat1.iTime = i;
}

function destroy(){
	FlxG.game.setFilters([]);
}
