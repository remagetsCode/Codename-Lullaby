package lime.ui;

import funkin.backend.MusicBeatTransition;
MusicBeatTransition.script = 'data/scripts/customTransition';

import funkin.backend.system.framerate.Framerate;
Framerate.codenameBuildField.visible = false;
//Framerate.memoryCounter.visible = false;

if(FlxG.save.data.unlockedSongs == null) FlxG.save.data.unlockedSongs = ["u" => "stoopid", "frostbite" => "unlocking", "insomnia" => "unlocking"];
//FlxG.save.data.unlockedSongs = ["u" => "stoopid", "frostbite" => "unlocking", 'lost-cause' => 'unlocking', 'left-unchecked' => 'unlocking', 'safety-lullaby' => 'unlocking', 'missingno' => 'unlocking', 'insomnia' => 'unlocking'];

var curDisplayHeight = window.display.bounds.height;
var curDisplayWidth = window.display.bounds.width;
var curDisplayX = window.display.bounds.x;
var curDisplayY = window.display.bounds.y;

var windowTitle = "Friday Night Funkin' Lullaby";
FlxG.game.setFilters([]);

function create(){
	bgGrass = new FlxSprite().loadGraphic(Paths.image('menus/title/bgGrass'));
	add(bgGrass);

	bgTreesFar = new FlxSprite().loadGraphic(Paths.image('menus/title/bgTreesfar'));
	add(bgTreesFar);

	bgTrees = new FlxSprite().loadGraphic(Paths.image('menus/title/bgTrees'));
	add(bgTrees);

	staticBG = new FlxSprite().loadGraphic(Paths.image('menus/title/staticBG'));
	staticBG.alpha = 0.6;
	add(staticBG);

	startScreen = new FlxSprite();
	startScreen.frames = Paths.getFrames('menus/title/Start_Screen_Assets');
	startScreen.animation.addByPrefix('idle', 'logo bumpin', 24);
	startScreen.animation.play('idle');
	startScreen.setGraphicSize(startScreen.width/1.5, startScreen.height/1.5);
	startScreen.screenCenter();
	startScreen.y -= 50;
	startScreen.antialiasing = true;
	add(startScreen);

	pressedStart = new FlxSprite().loadGraphic(Paths.image('menus/title/pressStartSelected'));
	pressedStart.alpha = 0;
	add(pressedStart);

	dark = new FlxSprite().loadGraphic(Paths.image('menus/title/darknessOverlay'));
	add(dark);

	new FlxTimer().start(2,()->{
		floatingLogo();
	});
	
	window.title = windowTitle;
	
}
function postCreate(){
	bgMusic = FlxG.sound.playMusic(Paths.music('freakyMenu'), 1.5, true);
	
	//Better way to do this :)

	if(!window.fullscreen){
		window.maximized = false;
		alo = FlxTween.num(window.width, curDisplayWidth/2, 0.75, { 
			ease: FlxEase.quadInOut,
			onUpdate: function(num){
				window.x = lerp(window.x, curDisplayX + curDisplayWidth/3, 0.03);
				window.width = num.value;
			}
		});
		
		alo = FlxTween.num(window.height, curDisplayHeight/2, 0.75, { 
			ease: FlxEase.quadInOut,
			onUpdate: function(num){
				window.y = lerp(window.y, curDisplayY + curDisplayHeight/5, 0.03);
				window.height = num.value;
			}
		});
	}
	
}
function update(){
	if(FlxG.mouse.justPressed || controls.ACCEPT) {
		FlxG.sound.play(Paths.sound("confirmMenu"));
		FlxG.camera.flash(FlxColor.RED, 1);
		new FlxTimer().start(1, (_) -> {
			FlxG.switchState(new MainMenuState());
		});
		
	}
	//trace(window.width);
}

function floatingLogo(){
	FlxTween.tween(startScreen, {y: startScreen.y + 125}, 4, {
		ease: FlxEase.smoothStepInOut,
		type: FlxTween.PINGPONG
	});
	FlxTween.num(window.y, window.y+100, 4, {
		ease: FlxEase.smootherStepInOut,
		type: FlxTween.PINGPONG,
		onUpdate: function(num){
			window.y = num.value;
		}
	});
}