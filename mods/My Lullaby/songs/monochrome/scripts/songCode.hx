import flixel.tweens.FlxTween.FlxTweenType;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import funkin.backend.utils.NdllUtil;
import funkin.backend.system.framerate.Framerate;

var reverse:Bool = false;
var limit:Float = 0;
var ljBar:FlxBar;

//TODO: time bar in unown func

var data:String = CoolUtil.parseJson(Paths.json("unownTexts"));

introLength = 7;

var curDisplayHeight = window.display.bounds.height;
var curDisplayWidth = window.display.bounds.width;
var curDisplayX = window.display.bounds.x;
var curDisplayY = window.display.bounds.y;

Framerate.codenameBuildField.visible = false;
Framerate.memoryCounter.visible = false;
Framerate.fpsCounter.visible = false;
function create(){
	if(FlxG.save.data.monochromeWindow){
		aspect = getAspectRatio(curDisplayWidth, curDisplayHeight);

		Main.scaleMode.width = aspect[0];
    	Main.scaleMode.height = aspect[1];

		FlxG.width = aspect[0]; 
		FlxG.height = aspect[1];
		
    	for(c in FlxG.cameras.list){
    	    c.width = aspect[0];
    	    c.height = aspect[1];
    	}	

		SET_TRANSPARENT(true, 5, 5, 5);
		camGame.bgColor = FlxColor.fromRGB(5,5,5,255);
	}
	
	if(FlxG.save.data.lullabyShaders){ 
		FlxG.game.addShader(desat);
		FlxG.game.addShader(aberration);
		desat.desaturationAmount = 0.1;
		aberration.iTime = 5;
	}
	dad.alpha = 0;


	nomore = new FlxSprite(dad.x, dad.y);
	nomore.frames = Paths.getFrames('characters/gold/GOLD_NO_MORE');
	nomore.animation.addByPrefix('no', 'No More instance 1', 24, false);
	nomore.antialiasing = true;
	nomore.visible = false;
	nomore.animation.onFinish.add(function(){
		dad.alpha = 0;
		nomore.visible = false;
		rip.visible = true;
		rip.animation.play('rip');
	});
	add(nomore);


	rip = new FlxSprite(dad.x-70, dad.y-110);
	rip.frames = Paths.getFrames('characters/gold/GOLD_HEAD_RIPPING_OFF');
	rip.animation.addByPrefix('rip', 'Head rips_OneLayer instance 1', 24, false);
	rip.antialiasing = true;
	rip.visible = false;
	rip.animation.onFinish.add(function(){
		rip.visible = false;
		dad.alpha = 1;
	});
	add(rip);

	celebi = new FlxSprite(600, 150);
	celebi.frames = Paths.getFrames('characters/gold/Celebi_Assets');
	celebi.animation.addByPrefix('spawn', 'Celebi Spawn Full', 24, false);
	celebi.animation.addByPrefix('idle', 'Celebi Idle', 24, true);
	celebi.animation.onFinish.add(function(event){
		if(event == 'spawn' && !reverse) celebi.animation.play('idle');
		if(event == 'spawn' && reverse) celebi.visible = false;
	});
	celebi.visible = false;
	add(celebi);

	notes = new FlxSprite(0, 2000);
	notes.frames = Paths.getFrames('characters/gold/Note_asset');
	notes.animation.addByPrefix('idle', 'Note Full', 24, true);
	add(notes);

	graphicCache.cache(Paths.image('jumpscares/Gold0'));
	graphicCache.cache(Paths.image('jumpscares/Gold1'));
	graphicCache.cache(Paths.image('UI/base/Unown_Alphabet'));
	
	setMarginColor(0x050505, 0.5);
}

function postCreate(){
	FlxG.sound.play(Paths.sound('gold/ImDead'+FlxG.random.int(1,7)));

	unownCam = new FlxCamera(0, 0);
    unownCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(unownCam, false);

	ljBar = new FlxBar(
		FlxG.width*0.25, healthBar.y-2,
		FlxBarFillDirection.RIGHT_TO_LEFT,
		623, 15
	);

	ljBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.BLACK);
    ljBar.cameras = [camHUD];
	ljBar.numDivisions = 200;
	add(ljBar);

	FlxTween.color(ljBar, 0.5, FlxColor.fromRGB(0, 0, 0, 80), FlxColor.BLACK, {
		ease: FlxEase.quadInOut,
		type: FlxTweenType.PINGPONG
	});
	
	new FlxTimer().start(0.01, ()->{
		modchart.setPercent('alpha', 0);
		for(u in uiStuff.members) {u.alpha = 0; u.y -= 50;}
		ljBar.y -= 50;
	});

	modchart.setPercent('y', downscroll ? -30 : 30);
}

function onCountdown(event) event.cancel();

function onSongStart(){
	//window.borderless = true;
	//window.fullscreen = true;
	modchart.ease('alpha', 44, 1, 1, FlxEase.cubeOut, 1);
	modchart.ease('wiggle', 92, 3, 0.8, FlxEase.smoothStep, 1);
	modchart.ease('tipsyX', 92, 3, 0.2, FlxEase.smoothStep, 1);
	modchart.ease('tipsy', 92, 3, 0.1, 	FlxEase.smoothStep, 1);
	modchart.ease('tipsyZ', 92, 3, 0.2, FlxEase.smoothStep, 1);

	modchart.ease('alpha', 385, 2, 0, FlxEase.cubeOut, 1);
	modchart.ease('alpha', 444, 2, 1, FlxEase.cubeOut, 1);

	modchart.ease('wiggle', 400, 1, 1.2, FlxEase.cubeOut, 1);
	modchart.ease('tipsyX', 400, 1, 0.7, FlxEase.cubeOut, 1);
	modchart.ease('tipsy', 400, 1, 0.2,  FlxEase.cubeOut, 1);
	modchart.ease('tipsyZ', 400, 1, 0.5, FlxEase.cubeOut, 1);

	modchart.ease('wiggle', 544, 1, 2.5, FlxEase.cubeOut, 1);

	modchart.ease('y', 681, 1, downscroll ? 300 : -300, FlxEase.cubeIn, 1);
}

function update(){
	if(health < limit) gameOver();
	ljBar.percent = limit*50;

	user = CoolUtil.keyToString(FlxG.keys.firstJustPressed());

	if(FlxG.keys.pressed.SHIFT)
	{
		trace('shift pressed');
		switch(user){
			case 'SLASH': user = '?';
			case 'MINUS': user = '?';
			case '1': user = '!';
		}
	}
	
	if(unown){
		if(user == curWord.charAt(counter)){
			counter++;

			linesGrp.members[counter2ndcoming].visible = false;
			counter2ndcoming++;

			if(curWord.charAt(counter) == " ") counter++;

			if(counter >= curWord.length){ 
				bg.kill();
				unownGrp.kill();
				linesGrp.kill();
				timer.kill(); 
				timeBar.kill(); 
				anotherTimer.cancel();
				unownTimer.cancel();
			}
		}
	}
	if (FlxG.keys.justPressed.R){
        FlxG.keys.reset();
    }
}

function stepHit(step){
	switch(step){
		case 0: dad.alpha = 1;

		case 1: 
			marginTween(false);
			holds.visible = false;

		case 128: for(i=>u in uiStuff.members) FlxTween.tween(u, {alpha: 0.9}, 1+i*0.3);

		case 368: FlxTween.num(0, 0.25, 1, {onUpdate: function(v){desat.desaturationAmount = v.value;}});

		case 419: coolEnabled = true;

		case 1608: 
			nomore.visible = true;
			nomore.animation.play('no');

		case 1640:
			FlxTween.num(5, 6.5, 5, {onUpdate: function(v){aberration.iTime = v.value;}});
			FlxTween.num(0.25, 0.5, 1, {onUpdate: function(v){desat.desaturationAmount = v.value;}});
	}
	
}

var counter:Int = 0;
var counter2ndcoming:Int = 0;
var unown:Bool = false;
var unownGrp:FlxTypedGroup<FlxSprite>;
var linesGrp:FlxTypedGroup<FlxSprite>;
var curWord:String;
var time:Int = 0;

var unownTimer:FlxTimer;
var anotherTimer:FlxTimer;
var timer:FlxText;
var timeBar:FlxBar;
function unownMechanic(?word:String){

	//IF TRYING TO PORT THIS TO MOBILE, JUST COMMENT ALL THIS CHUNK OR DISABLE THE MECHANICS.
	if(FlxG.save.data.lullabyMechanics){
		unownGrp = new FlxTypedGroup<FlxSprite>();
		linesGrp = new FlxTypedGroup<FlxSprite>();
		counter = 0;
		counter2ndcoming = 0;
		unown = true;

		if(word == "") curWord = data.monochromeTexts.words[FlxG.random.int(0, data.monochromeTexts.words.length-1)];
		else curWord = word;

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(255, 20, 20, 150));
		bg.scrollFactor.set(0);
		bg.camera = unownCam;
		add(bg);

		var test = 1-curWord.length*0.055;

		for(i in 0...curWord.length){
			var char = curWord.charAt(i);
			if(char != " "){
				var uAlpha = new FlxSprite();
				uAlpha.frames = Paths.getFrames('UI/base/Unown_Alphabet');
				uAlpha.animation.addByPrefix('this', char, 24, true);
				uAlpha.animation.play('this');
				uAlpha.setGraphicSize((uAlpha.width*test)+20, uAlpha.height*test);
				uAlpha.updateHitbox();
				uAlpha.setPosition((420-curWord.length*26)+(uAlpha.width*1.5)*i, 150);
				uAlpha.scrollFactor.set(0);
				uAlpha.antialiasing = true;
				uAlpha.camera = unownCam;
				unownGrp.add(uAlpha);

				var line = new FlxSprite().loadGraphic(Paths.image('UI/base/line'));
				line.scrollFactor.set(0);
				line.setGraphicSize(line.width*test, line.height*test);
				line.setPosition(uAlpha.x-line.width/4, uAlpha.y+450);
				line.camera = unownCam;
				linesGrp.add(line);
			}
		}
		add(unownGrp);
		add(linesGrp);

		unownTimer = new FlxTimer().start(6, ()->{
			FlxTween.num(health, health - (curWord.length - counter)*0.3, 0.75, {
				ease: FlxEase.quintOut,
				onUpdate: (v)->{health = v.value;}
			});
			if(bg.alive || unownGrp.alive) {bg.kill(); unownGrp.kill(); linesGrp.kill(); timer.kill(); timeBar.kill(); anotherTimer.kill();}
		});
		
		timer = new FlxText(0, 0, 0, "6", 34, false);
		timer.screenCenter();
		timer.y += 100;
		timer.camera = unownCam;
		add(timer);

		timeBar = new FlxBar(
			FlxG.width*0.06, FlxG.height*0.7,
			FlxBarFillDirection.LEFT_TO_RIGHT,
			1123, 15
		);

		timeBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.WHITE);
    	timeBar.cameras = [camHUD];
		timeBar.numDivisions = 200;
		timeBar.camera = unownCam;
		add(timeBar);

		anotherTimer = new FlxTimer().start(0.03, ()->{
			if(unownTimer.active) {
				timer.text = 6-Std.int(unownTimer.elapsedTime);
				timeBar.percent = (6-unownTimer.elapsedTime)*(100/6);
				timeBar.updateBar();
			}
		}, 0);
	}
}

function celebiMechanic(){
	// IF TRYING TO PORT TO MOBILE, THIS MECHANIC CAN BE USED BUT IF ITS TOO DIFFICULT YOU CAN ADJUST IT WITH THE FOLLOWING VARIABLE
	var much:Float = 0.35;
	if(FlxG.save.data.lullabyMechanics){
		reverse = false;
		celebi.visible = true;
		celebi.animation.play('spawn');
		celebi.setPosition(600, FlxG.random.int(50,300));

		new FlxTimer().start(0.7, ()->{
			notes.setPosition(celebi.x, celebi.y-50);
			notes.animation.play('idle');
			FlxTween.quadPath(notes, [
				FlxPoint.get(notes.x, notes.y), 
				FlxPoint.get(notes.x-100, notes.y-50), 
				FlxPoint.get(notes.x-100, notes.y-100), 
				FlxPoint.get(notes.x-250, notes.y-150),
				FlxPoint.get(notes.x-100, notes.y-650)],
			2, true, { ease: FlxEase.smootherStepOut});

			FlxTween.num(limit, limit+much, 1, {
				ease: FlxEase.cubeOut,
				onUpdate: (v)->{limit = v.value;}
			});
		});

		new FlxTimer().start(1.5, ()->{
			celebi.animation.play('spawn', false, true);
			reverse = true;
		});
	}
}

// I was lazy so i just duped the function dont kill me :'(
function jumpscare(){
	jemp = new FlxSprite().loadGraphic(Paths.image('jumpscares/Gold'+FlxG.random.int(0,1)));
	jemp.setGraphicSize(FlxG.width, FlxG.height);
	jemp.updateHitbox();
	jemp.cameras = [camHUD];
	jemp.alpha = 0;
	add(jemp);

	FlxTween.tween(jemp, {alpha: 0.95}, 0.2, {
		ease: FlxEase.expoOut,
		onComplete: ()->{
			FlxTween.tween(jemp, {alpha: 0}, 0.4, {
				ease: FlxEase.expoIn
			});
		}
	});
}

function jumpscare1(){
	jump = new FlxSprite().loadGraphic(Paths.image('jumpscares/Gold'+FlxG.random.int(0,1)));
	jump.setGraphicSize(FlxG.width, FlxG.height);
	jump.updateHitbox();
	jump.cameras = [camHUD];
	jump.alpha = 0;
	add(jump);

	FlxTween.tween(jump, {alpha: 0.95}, 0.05, {
		ease: FlxEase.expoOut,
		onComplete: ()->{
			FlxTween.tween(jump, {alpha: 0}, 0.07, {
				ease: FlxEase.expoIn
			});
		}
	});
}

function onGameOver(event){
	//event.cancel();
	//dad.animation.play('spawn',true,true);
}

function destroy(){
	window.fullscreen = false;
	window.borderless = false;

	if(FlxG.save.data.monochromeWindow)
	{
		SET_TRANSPARENT(false, 5, 5, 5);

		Main.scaleMode.width = 1280;
    	Main.scaleMode.height = 720;

		FlxG.width = 1280; 
		FlxG.height = 720;
		
    	for(c in FlxG.cameras.list){
    	    c.width = 1280;
    	    c.height = 720;
    	}
	}

	Framerate.memoryCounter.visible = true;
	Framerate.fpsCounter.visible = true;
	marginTween(true);
	
}


function getAspectRatio(?width, ?height){
	var ratio:Float = width/height; 
	var mulWidth = 1280/16;
	var mulHeight = 720/9;
	trace("screen width: " + width + ", screen height: " + height);
	trace("ratio: " + ratio);
	var result:Array;

	if(Math.abs(ratio - 16/9) < 0.01) result = [1280, 720, 1];
	
	else if(Math.abs(ratio - 4/3) < 0.01) result = [1280, 960];
	
	else if(Math.abs(ratio - 21/9) < 0.01) result = [1281,549];

	else if(Math.abs(ratio - 3/2) < 0.01) result = [1281, 854];

	else if(Math.abs(ratio - 3/4) < 0.01) result = [1200, 1600];

	else if(Math.abs(ratio - 16/10) < 0.01) result = [1280, 800];

	else result = [1280, 720, 2];
	trace("output: " + result);
	return result;	
}