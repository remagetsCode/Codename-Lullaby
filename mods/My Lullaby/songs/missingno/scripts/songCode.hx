var sc:Float = 6;
var healthStuff:FlxTypedGroup; 
var wiggle:Bool = false;
function create(){
	healthStuff = new FlxTypedGroup();

	bgSky = new FlxSprite();
	bgSky.frames = Paths.getFrames('stages/missingno/images/BG_Assets');
	bgSky.animation.addByPrefix('idle', 'Bg Ocean', 24, true);
	bgSky.animation.play('idle');
	bgSky.setGraphicSize(bgSky.width*sc, bgSky.height*sc);
	bgSky.screenCenter();
	bgSky.y += 150;
	insert(5, bgSky);

	bgWave = new FlxSprite();
	bgWave.frames = Paths.getFrames('stages/missingno/images/BG_Assets');
	bgWave.animation.addByPrefix('idle', 'Bg Wave', 24, true);
	bgWave.animation.play('idle');
	bgWave.setGraphicSize(bgSky.width*sc, bgSky.height*sc);
	bgWave.screenCenter();
	bgWave.y += 300;
	insert(6, bgWave);

	bg = new FlxSprite().loadGraphic(Paths.image('stages/missingno/images/bg'));
	bg.setGraphicSize(bg.width*sc, bg.height*sc);
	bg.screenCenter();
	bg.y += 300;
	bg.x += 360;
	insert(4, bg);

	dad.alpha = 0;
	bf.x -= 200;
	
	window.borderless = true;
	
}

function postCreate(){
	camera.zoom = 1.6;
	
	new FlxTimer().start(0.1, ()->{for(obj in uiStuff) obj.alpha = 0;});
}

function stepHit(step){
	switch(step){
		case 0: modchart.ease('x', curBeat, 4, -300, FlxEase.backOut, 1);
			modchart.ease('alpha', curBeat, 4, 0.05, FlxEase.cubeOut, 1);
			modchart.set('alpha', 0, 0, 0);
			modchart.set('vibrate', curBeat, 1, 0);
		
		case 122: modchart.ease('alpha', curBeat, 12, 0.95, FlxEase.cubeOut, 1);
		
		case 250: FlxTween.num(0, 1, 35, {
			ease: FlxEase.quadOut,
			onUpdate: (n)->{
				desat.desaturationAmount = n.value;
			}});

		case 371:
			modchart.set('vibrate', curBeat, 40, 1);
			modchart.set('confusion', curBeat, 30, 1);
		case 382:
			modchart.ease('vibrate', curBeat, 2, 0, FlxEase.quintOut, 1);
			modchart.ease('confusion', curBeat, 4, 0, FlxEase.cubeOut, 1);

		case 640:
			wiggle = true;
			modchart.set('vibrate', curBeat, 90, 1);
			modchart.set('confusion', curBeat, 30, 1);
		case 648:
			modchart.ease('vibrate', curBeat, 2, 0, FlxEase.quintOut, 1);
			modchart.ease('confusion', curBeat, 4, 0, FlxEase.cubeOut, 1);


		case 389: 
			for(obj in uiStuff) obj.alpha = 0.8;
			dad.alpha = 1;
			modchart.set('alpha', curBeat, 0.5, 0);

		case 1174: wiggle = false;
			

		case 1431: FlxTween.num(1, 0.1, 3, {
			ease: FlxEase.quadOut,
			onUpdate: (n)->{
				desat.desaturationAmount = n.value;
			}});
		case 1696: FlxTween.num(0, 1, 3, {
			ease: FlxEase.quadOut,
			onUpdate: (n)->{
				desat.desaturationAmount = n.value;
			}});
		case 1940: FlxTween.num(1, 0.32, 10, {
			ease: FlxEase.quadOut,
			onUpdate: (n)->{
				desat.desaturationAmount = n.value;
			}});
		
	}
	for(i in 0...4){
		modchart.set('x'+i, curBeat, FlxG.random.int(-2000, 2000), 0);
		modchart.set('y'+i, curBeat, FlxG.random.int(-1500, 1500), 0);
	}
	songScore = FlxG.random.int(-9999, 99999);
}

function beatHit(beat){
	if(wiggle) modchart.ease('confusionOffset', curBeat, 5, beat%2 == 0 ? 25 : -25, FlxEase.cubeOut, 1);
	else modchart.ease('confusionOffset', curBeat, 4, 0, FlxEase.cubeOut, 1);
}

function glitch(){
	missingno.iTime = FlxG.random.float(0,2);
}

function destroy(){
	window.borderless = false;
}

