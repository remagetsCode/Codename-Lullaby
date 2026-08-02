importScript("data/scripts/pendulum.hx");
import openfl.display.Sprite;
import openfl.display.Bitmap;

var vibration:FlxTween;

function postCreate(){
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

	FlxG.signals.postUpdate.addOnce(() -> {
		pendelum.alpha = 0;
		extras.alpha = 0;
		for(i in 0...4) uiStuff.members[i].alpha = 0;
	});

	FlipIcons = true;
}

function stepHit(step){
	switch(step){
		case 393:
			FlxTween.tween(pendelum, { alpha: 0.8 }, 0.8, {ease: FlxEase.quadOut});
			for(i in 0...4) FlxTween.tween(uiStuff.members[i], {alpha: 1}, 3);
			if(FlxG.save.data.lullabyMechanics) pendulumStarted = true;
		case 1000: 		
			vibration = FlxTween.shake(pendelum, 0.05, 10, FlxAxes.XY, {
				ease: FlxTween.cubeInOut
			});
		case 1088: 
			FlxG.sound.play(Paths.sound('breaking'),2);
			if(healthHypno != null) FlxTween.num(healthHypno, 2, 2, null, (v) -> healthHypno = v);
		case 1090:
			pendelum.alpha = 0;
			pendelumBr.alpha = 1;
			pendulumStarted = false;

			vibration = FlxTween.shake(pendelumBr, 0.1, 0.6, FlxAxes.XY, {ease: FlxTween.cubeOut});

			FlxTween.tween(pendelumBr, { alpha: 0.1 }, 8, {ease: FlxEase.quadOut});
			healthHypno = 1.5;
	}
}

function dedBF(){
	dedBF = new FlxSprite().loadGraphic(Paths.image('characters/bf/dead_ass_bitch_LMAOOOO'));
	dedBF.setGraphicSize(dedBF.width/2, dedBF.height/2);
	add(dedBF);
	dedBF.y += 600;
	dedBF.x -= 130;
}