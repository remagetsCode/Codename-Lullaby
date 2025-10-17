var pressed = false;
var startedTimer = false;
var counter = 47;
var t:Float = 60/Conductor.bpm;
var songStarted = false;
var healthDrain:Float = 0.15;
var vibration:FlxTween;
var reactionTime = 0.4;

public var healthHypno:Float = 1.5;

function postCreate(){
	
	pendelum = new FlxSprite();
	//pendelum.loadGraphic(Paths.image("UI/base/hypno/Pendelum_Phase2"));
	pendelum.frames = Paths.getFrames('UI/base/hypno/Pendelum_Phase2');
	pendelum.animation.addByPrefix('idle','Pendelum Phase 2',24);
	pendelum.animation.play('idle');
	add(pendelum);
	pendelum.setGraphicSize(pendelum.width * 1.30, pendelum.height * 1.30);
	pendelum.screenCenter();
	pendelum.scrollFactor.set(0);
	pendelum.cameras = [camHUD];
	pendelum.antialiasing = true;
	pendelum.origin.set(pendelum.width/2, 0);
	pendelum.alpha = 0;

	pendelumBr = new FlxSprite();
	pendelumBr.frames = Paths.getFrames('UI/base/hypno/Pendelum_Phase2_BR');
	add(pendelumBr);
	pendelumBr.setGraphicSize(pendelumBr.width * 1.30, pendelumBr.height * 1.30);
	pendelumBr.screenCenter();
	pendelumBr.y -= 180;
	pendelumBr.scrollFactor.set(0);
	pendelumBr.cameras = [camHUD];
	pendelumBr.antialiasing = true;
	pendelumBr.alpha = 0;

	extras = new FlxSprite();
	extras.frames = Paths.getFrames('UI/base/hypno/Extras');
	extras.setGraphicSize(extras.width * 0.75, extras.height * 0.75);
	extras.animation.addByPrefix('Check','Checkmark',24, false);
	extras.animation.addByPrefix('Bad','X finished',24, false);
	extras.screenCenter();
	extras.cameras = [camHUD];
	extras.antialiasing = true;
	extras.alpha = 0;
	add(extras);

	new FlxTimer().start(0.01, ()->{for(i in 0...4) uiStuff.members[i].alpha = 0;});

	pendelum.y += downscroll ? 200 : -200;
	pendelumBr.y = pendelum.y;
	extras.y += downscroll ? -100 : 100;

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
	FlxTween.angle(pendelum, 0, -50, t*3, {
		ease: FlxEase.sineOut
	});
	
}
function update(){	
	//Failed beat
	if(!startedTimer && FlxG.keys.justPressed.SPACE && songStarted){ 
		FlxG.sound.play(Paths.sound('error'), 0.3);
		healthHypno -= healthDrain/2;
		showBad();
	}

	// Pressed beat
	else if(startedTimer && FlxG.keys.justPressed.SPACE && songStarted){
		pressed = true;
		healthHypno += healthDrain/2;
		showCheck();
	}
}

function stepHit(step){
if(songStarted && step == (counter*7)+(counter-1)){
	
		if(counter % 2 == 1) {
			pend();
		}

		counter += 1;
		pressed = false;
		startedTimer = true;

		// Reaction time to hit that spacebar
		new FlxTimer().start(reactionTime, ()->{
			if(!pressed){
				healthHypno -= healthDrain;
				showBad();
			}
			startedTimer = false;
		});
		if(healthHypno <= 0) gameOver();
		if(healthHypno > 2) healthHypno = 2;
	}
	switch(step){
		case 1000: 		
			vibration = FlxTween.shake(pendelum, 0.05, 10, FlxAxes.XY, {
				ease: FlxTween.cubeInOut
			});
		case 1088: FlxG.sound.play(Paths.sound('breaking'),2);
		case 1090:
			pendelum.alpha = 0;
			pendelumBr.alpha = 1;
			songStarted = false;

			vibration = FlxTween.shake(pendelumBr, 0.1, 0.6, FlxAxes.XY, {
				ease: FlxTween.cubeOut
			});

			FlxTween.tween(pendelumBr, { alpha: 0.1 }, 8, {
				ease: FlxEase.quadOut
			});
			healthHypno = 1.5;
	}
}

function pend(){
	FlxTween.angle(pendelum, -40, 40, t*2, { 
        ease: FlxEase.sineOut, 
        onComplete: function(){
			FlxTween.angle(pendelum, 40, -40, t*2, { 
        		ease: FlxEase.sineOut, 
    		});
		}
    });

}

function beatHit(beat){
	if(beat == 90){
		FlxTween.tween(pendelum, { alpha: 0.8 }, 2, {
    		ease: FlxEase.quadOut
		});
		for(i in 0...4) FlxTween.tween(uiStuff.members[i], {alpha: 1}, 3);
		if(FlxG.save.data.lullabyMechanics) songStarted = true;
	}
	//FlxG.sound.play(Paths.sound('editors/charter/metronome'));
}

function showCheck(){
		extras.alpha = 1;
		extras.animation.play('Check');
}

function showBad(){
		extras.alpha = 1;
		extras.animation.play('Bad');
}

function dedBF(){
	dedBF = new FlxSprite().loadGraphic(Paths.image('characters/bf/dead_ass_bitch_LMAOOOO'));
	dedBF.setGraphicSize(dedBF.width/2, dedBF.height/2);
	add(dedBF);
	dedBF.y += 600;
	dedBF.x -= 130;
}