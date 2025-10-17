var bgDesat:Bool = false;
var damage:Bool = false;

function create(){
	coolEnabled = false;
	if(FlxG.save.data.lullabyShaders){
		var bg = stage.getSprite("city");
		bg.shader = desat;
		desat.desaturationAmount = 1;
	}
}

function postCreate(){
	// Thanks to BASHIR for flipping the healthbar
	healthBar.flipX = iconP1.flipX = iconP2.flipX = true;
	updateIconPositions = function(){
		var iconOffset:Int = 26;

		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(100-healthBar.percent, 0, 100, 1, 0);

		iconP2.x = center - iconOffset;
		iconP1.x = center - (iconP1.width - iconOffset);

		health = FlxMath.bound(health, 0, maxHealth);

		iconP1.health = healthBar.percent / 100;
		iconP2.health = 1 - (healthBar.percent / 100);
	}
}

function onSongStart(){
	legacy =  new FlxSprite(1380,downscroll ? 0 : 110);
	legacy.frames = Paths.getFrames('stages/glitchy/images/they_took_everything_from_me');
	legacy.animation.addByPrefix('anim', 'GlitchySpeak', 24, false);
	legacy.antialiasing = true;
	//legacy.animation.play('anim');
	legacy.animation.onFinish.add(function(){
		FlxTween.tween(legacy, {alpha:0}, 1);
	});
	//legacy.animation.play('anim');
	legacy.cameras = [camHUD];
	add(legacy);

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
function update(){
	if(bgDesat) desat.desaturationAmount = bump = lerp(bump, inst.amplitude*2, 0.2);
}

function stepHit(step){
	switch(step){
		case 1100: black.alpha = 1; 
		case 1101: black.alpha = 0; 
		case 1102: black.alpha = 1; 
		case 1103: black.alpha = 0; 
		case 1104: black.alpha = 1; 
		case 1105: black.alpha = 0; 
	}
}

function beatHit(beat){
	switch(beat){
		case 0: modchart.ease('opponentSwap', beat, 20, 1, FlxEase.cubeInOut);
		
		case 277: 
			damage = true;
			iconP2.setIcon('icon-glitchy-red-mad1');
			bgDesat = true;
			dad.scrollFactor.set(0.6,1);

		case 468: 
			legacy.alpha = 1;
			FlxTween.tween(black, {alpha: 0.8}, 6);
			FlxTween.tween(legacy, {x: 580}, 8, {
				ease: FlxEase.quintOut
			});
			legacy.animation.play('anim');

		case 500:
			FlxTween.tween(black, {alpha: 0}, 6);
			FlxTween.tween(vignette, {alpha: 0.9}, 8);
		case 532: FlxTween.tween(vignette, {alpha: 0.2}, 1);
	}
}

function onDadHit(){
	if(health > 0.5 && damage) FlxTween.num(health, health-0.025, 0.5, {
		ease: FlxEase.cubeOut,
		onUpdate: (v)->{
			health = v.value;
		}
	});
}