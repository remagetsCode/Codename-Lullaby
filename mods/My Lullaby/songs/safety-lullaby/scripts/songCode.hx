importScript("data/scripts/pendulum.hx");

import openfl.display.BlendMode;
import DropShadowShader;

var lil:FlxSprite;
var adjustColor:CustomShader = new CustomShader('adjustColor');
var dropShadowEffects = [];

function postCreate(){
	black = new FlxSprite();
	black.makeGraphic(FlxG.width * 3, FlxG.height * 3, 0x99000000);
	black.screenCenter();
	black.blend = BlendMode.SUBSTRACT;
	//add(black);

	lil = new FlxSprite();
	lil.frames = Paths.getFrames('UI/base/hypno/Pendelum');
	lil.animation.addByPrefix('idle', 'Pendelum instance 1',24,true);
	lil.animation.play('idle');
	lil.origin.set(lil.width, 0);
	add(lil);

	if(FlxG.save.data.lullabyShaders){
		adjustColor.hue = 4;
		adjustColor.saturation = -25;
		adjustColor.brightness = -28;
		adjustColor.contrast = 15;
		dad.shader = adjustColor;

		dropShadow = new DropShadowShader(bf, [100, 85, 90], 45, 25, 1, 0.1);
		dropShadow.setAdjustColor(4, -15, -8, 10);
		dropShadowEffects.push(dropShadow);
	}
}

function postUpdate() {
	for (c in dropShadowEffects) {
		c?.postUpdate(Conductor.songPosition / 1000);
	}
}

function onSongStart(){
	pendelum.destroy();
	pendelum = lil;
	angleOffset = -10;
	if(FlxG.save.data.lullabyMechanics) pendulumStarted = true;
	else lil.visible = false;
}

function update(){
	switch(dad.animation.curAnim.name) {
		case "idle":
			lil.x = 330;
			lil.y = 465;
		case "singLEFT":
			lil.x = 330;
			lil.y = 555;
		case "singUP":
			lil.x = 240;
			lil.y = 0;
		case "singDOWN":
			lil.x = 230;
			lil.y = 455;
		case "singRIGHT":
			lil.x = 360;
			lil.y = 735;
		case "Psyshock":
			lil.x = 3800;
			lil.y = 6300;
	}
}

function beatHit(beat){
	if(beat <= 13) {
		extras.animation.play(beat % 2 == 0 ? 'Spacebar1' : 'Spacebar2');
	}
	else if(beat == 13) {
		extras.animation.play('Spacebar1');
		FlxTween.tween(extras, { alpha: 0 }, 1, { ease: FlxTween.cubeOut });
	}
}
