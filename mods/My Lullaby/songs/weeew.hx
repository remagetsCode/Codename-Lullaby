import modchart.Manager;
import modchart.engine.modifiers.Modifier;
import openfl.geom.Vector3D;
public var modchart:Manager;

var oldPosX = window.x;
var oldPosY = window.y;

var coolEnabled = true;
var rectUp:FlxSprite;
var rectDown:FlxSprite;
var test;

public var output;
function postCreate(){
	rectUp = new FlxSprite();
	rectUp.makeGraphic(camHUD.width, camHUD.height/4, FlxColor.BLACK);
	rectUp.cameras = [camHUD];
	test = rectUp.y;
	rectUp.y = rectUp.height*4;
	//rectUp.y += camHUD.height;
	add(rectUp);

	rectDown = new FlxSprite();
	rectDown.makeGraphic(camHUD.width, camHUD.height/4, FlxColor.BLACK);
	rectDown.cameras = [camHUD];
	rectDown.y = -rectDown.height;
	add(rectDown);

	modchart = new Manager();
	add(modchart);

	// V-slice sustain anim 
	holds = new FlxTypedGroup<FlxSprite>();
	add(holds);

	
	switch(curSong){ 
		case 'left-unchecked': leftUnchecked();
		case'lost-cause': lostCause();
	}

	modchart.addModifier('transform');
	modchart.addModifier('confusion');
	modchart.addModifier('opponentswap');
	modchart.addModifier('drunk');
	modchart.addModifier('tipsy');
	modchart.addModifier('wiggle');
	modchart.addModifier('vibrate');
	modchart.addModifier('beat');
	modchart.addModifier('reverse');
}

function coolThing(d){
	//if(coolEnabled){
	//	modchart.ease('confusionOffset' + d, curBeatFloat, 0.2, FlxG.random.int(-30,30,0), FlxEase.smootherStepInOut, 1);
	//	modchart.ease('y' + d, curBeatFloat, 0.2, downscroll ? 40 : -40, FlxEase.quintInOut, 1);
	//	
	//	modchart.ease('confusionOffset' + d, curBeatFloat, 0.5, 0, FlxEase.smootherStepInOut, 1);
	//	modchart.ease('y' + d, curBeatFloat, 0.5, 0, FlxEase.quintOut, 1);
	//}

}
function onPlayerHit(note){
	coolThing(note.direction);
}

function lostCause(){
	modchart.ease('wiggle', 1, 1, 1, FlxEase.bounceIn, 0);
	for(i in 1...74){
		modchart.ease('alpha', i, 1, FlxG.random.float(0,1), FlxEase.bounceIn, 0);
	}
	modchart.ease('wiggle', 74, 2, 0, FlxEase.cubeOut, 0);

	modchart.ease('alpha', 75, 1, 0.8, FlxEase.cubeOut, 0);
	modchart.ease('drunk', 75, 8, 1.5, FlxEase.cubeOut, 0);
	modchart.ease('confusion', 82, 2, 10, FlxEase.smootherStepInOut);
	modchart.ease('confusion', 83, 2, 0, FlxEase.smootherStepInOut);
	modchart.ease('opponentswap', 82, 4, 1, FlxEase.cubeOut);
	modchart.ease('tipsy', 85, 4, 0.15, FlxEase.cubeOut, 1);
	modchart.ease('vibrate', 277, 4, 0.45, FlxEase.cubeOut, 1);
	modchart.ease('vibrate', 327, 8, 0.2, FlxEase.cubeOut, 1);
	modchart.ease('vibrate', 347, 8, 0, FlxEase.cubeOut, 1);
	modchart.ease('drunk', 340, 4, 0.4, FlxEase.cubeOut, 1);
	modchart.ease('drunk', 390, 4, 0.15, FlxEase.cubeOut, 1);
	for(i in 0...4){
		var n = i % 2 == 0 ? -1 : 1;
		modchart.ease('beat' + i, 340, 4, n*0.4, FlxEase.cubeOut, 1);
		modchart.ease('beat' + i, 390, 4, n, FlxEase.cubeOut, 1);
		modchart.ease('beat' + i, 505, 10, 0, FlxEase.cubeOut, 1);
	}
	modchart.ease('tipsy', 500, 10, 0, FlxEase.cubeOut, 1);
	
	
}

function beatHit(beat){
	if(curSong == 'lost-cause'){
		switch(beat){
			case 1: trace('if ur reading this, you are uhhh (insert any sex orientation u dont like)');

			case 75: coolEnabled = false;
		}
	}

	if(curSong == 'missingno'){
		switch(beat){
			case 100: coolEnabled = false;
		}
	}
}

function leftUnchecked(){
	modchart.set('drunk',1,1.5,0);
	modchart.ease('tipsy', 85, 4, 0.35, FlxEase.cubeOut, 1);
	modchart.ease('tipsy', 160, 4, 0, FlxEase.cubeOut, 1);
	modchart.ease('beat', 85, 4, 0.6, FlxEase.cubeOut, 1);
	modchart.ease('beat', 160, 4, 0, FlxEase.cubeOut, 1);
	modchart.ease('drunk', 200, 4, 1, FlxEase.cubeOut, 1);
	modchart.ease('drunk', 215, 4, 0, FlxEase.cubeOut, 1);
	modchart.ease('beat', 216, 4, 0.6, FlxEase.cubeOut, 1);
	modchart.ease('tipsy', 216, 4, 0.35, FlxEase.cubeOut, 1);
	
}

function showCineBorders(length){
	FlxTween.tween(rectDown, { y: 0 }, length, {
		ease:FlxEase.smootherStepOut
	});
	FlxTween.tween(rectUp, { y: rectUp.height*3 }, length, {
		ease:FlxEase.smootherStepOut
	});
}

function hideCineBorders(length){
	FlxTween.tween(rectDown, { y: -rectDown.height }, length, {
		ease:FlxEase.smootherStepOut
	});
	FlxTween.tween(rectUp, { y: rectUp.height*4 }, length, {
		ease:FlxEase.smootherStepOut
	});
}

function missingnoEffect(){
	//modchart.set('y', curBeat, FlxG.random.int(0,550), 1);
	if(FlxG.save.data.lullabyMechanics){
		downscroll = FlxG.random.bool();
		modchart.set('x', curBeat, -750, 1);
		modchart.set('y', curBeat, downscroll == false ? FlxG.random.int(-50, 240) : FlxG.random.int(-240, 50), 1);

		for(i in 0...4){	
			if(i == 0) modchart.set('x'+0, curBeat, FlxG.random.int(0, 250), 1);
			else modchart.set('x'+i, curBeat, modchart.getPercent('x' + (i-1), 1) + FlxG.random.int(70, 250), 1);
		}

		window.x = oldPosX;
		window.y = oldPosY;
		window.x += FlxG.random.int(-100,100);
		window.y += FlxG.random.int(-65,65);

		missingno.iTime = FlxG.random.float(0,5);
	}
	
}