

var bgDesat:Bool = false;
var damage:Bool = false;

function postCreate() {
	if(FlxG.save.data.lullabyShaders){
		stage.getSprite("city").shader = desat;
		desat.desaturationAmount = 1;
	}

	FlipIcons = true;
}

function onSongStart() {
	legacy =  new FlxSprite(1380, downscroll ? 0 : 110);
	legacy.frames = Paths.getFrames('stages/glitchy/images/they_took_everything_from_me');
	legacy.animation.addByPrefix('anim', 'GlitchySpeak', 24, false);
	legacy.antialiasing = true;
	legacy.animation.onFinish.add(() -> FlxTween.tween(legacy, {alpha:0}, 1));
	legacy.cameras = [camHUD];
	add(legacy);

	modchart.ease('opponentSwap', 0, 20, 1, FlxEase.cubeInOut);
	modchart.ease('z', 0, 10, -200, FlxEase.cubeInOut, 0);
	modchart.ease('z', 0, 10, 150, FlxEase.cubeInOut, 1);

	modchart.ease('z', 10, 10, 0, FlxEase.cubeInOut, 0);
	modchart.ease('z', 10, 10, 0, FlxEase.cubeInOut, 1);

	modchart.ease('alpha', 58, 2, 0.2, FlxEase.linear);
	modchart.ease('alpha', 64, 1, 0.8, FlxEase.linear, 0);
	modchart.ease('alpha', 79, 1, 1, FlxEase.linear, 1);
	modchart.ease('alpha', 132, 2, 0.2, FlxEase.cubeOut);
	modchart.ease('alpha', 143, 1, 1, FlxEase.cubeOut);
	modchart.ease('alpha', 468, 5, 1, FlxEase.cubeOut);
	modchart.ease('alpha', 468, 5, 0.1, FlxEase.cubeOut);
	modchart.ease('alpha', 500, 2, 0.8, FlxEase.cubeOut, 0);
	modchart.ease('alpha', 514, 2, 1, FlxEase.cubeOut, 1);
}

var bump:Float = 0;
function update() {
	if(bgDesat) desat.desaturationAmount = bump = lerp(bump, inst.amplitude*2, 0.2);
}

function stepHit(step) {
	switch(step){
		case 1100, 1101, 1102, 1103, 1104, 11050: black.alpha = black.alpha == 1 ? 0 : 1; 
	}
}

function beatHit(beat) {
	switch(beat){	
		case 277: 
			damage = true;
			bgDesat = true;
			iconP2.setIcon('icon-glitchy-red-mad1');
			dad.scrollFactor.set(0.6,1);

		case 468: 
			legacy.alpha = 1;
			FlxTween.tween(black, {alpha: 0.8}, 6);
			FlxTween.tween(legacy, {x: 580}, 8, { ease: FlxEase.quintOut });
			legacy.animation.play('anim');

		case 500:
			FlxTween.tween(black, {alpha: 0}, 6);
			FlxTween.tween(vignette, {alpha: 0.9}, 8);
		case 532: FlxTween.tween(vignette, {alpha: 0.2}, 1);
	}
}

function onDadHit() {
	if(health > 0.25 && damage) health -= 0.025;
}