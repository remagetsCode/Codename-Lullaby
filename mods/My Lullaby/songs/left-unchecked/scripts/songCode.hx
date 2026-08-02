importScript("data/scripts/pendulum.hx");
import DropShadowShader;

var dropShadowEffects:Array = [];

function onSongStart() {
	if(FlxG.save.data.lullabyMechanics) pendulumStarted = true;
}

function postCreate() {
	modchart.ease('alpha', 1, 4, 0.6, FlxEase.cubeOut, 0);
	FlxG.signals.postUpdate.addOnce(() -> for(o in uiStuff) o.y += 500);

	if(FlxG.save.data.lullabyShaders){
		adjustColorShader = new CustomShader('adjustColor');
		adjustColorShader.hue = 4;
		adjustColorShader.saturation = -25;
		adjustColorShader.brightness = -28;
		adjustColorShader.contrast = 15;
		dad.shader = adjustColorShader;

		dropShadow = new DropShadowShader(bf, [100, 85, 90], 45, 25, 1, 0.1);
		dropShadow.setAdjustColor(4, -15, -8, 10);
		add(dropShadow);
		dropShadowEffects.push(dropShadow);
	}
}

function postUpdate() {
	for (c in dropShadowEffects) {
		c?.postUpdate(Conductor.songPosition / 1000);
	}
}

function stepHit(step){
	if(step == 258) 
		for(i => o in uiStuff.members)
			FlxTween.tween(o, {y: o.y-500}, 1+(i*0.5), {ease: FlxEase.cubeOut});
	
}