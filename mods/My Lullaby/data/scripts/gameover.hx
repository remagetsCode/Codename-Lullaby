import funkin.game.GameOverSubstate;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;

function create(event){
	switch(game.curSong){
		case 'safety-lullaby': safeOver(event);
		case 'left-unchecked': safeOver(event);
		case 'lost-cause': lostOver(event);
		case 'missingno': missingno(event);
		case 'insomnia': insomnia(event);
	}
}

function safeOver(event){
	event.cancel();

	camera = pauseCam = new FlxCamera(0, 0);
    pauseCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(pauseCam, false);

	lossSfX = FlxG.sound.play(Paths.sound('DT_Loss_SFX'));
	gameOverSong = 'gameOver';

	bg1 = new FlxSprite().loadGraphic(Paths.image('characters/death/gf/sky'));
	bg1.setGraphicSize(FlxG.width, FlxG.height);
	bg1.screenCenter();
	//bg1.x -= 400;
	//bg1.y -= 100;
	add(bg1);

	trees = new FlxSprite().loadGraphic(Paths.image('characters/death/gf/trees'));
	trees.setGraphicSize(FlxG.width, trees.height);
	trees.screenCenter();
	trees.y += 100;
	add(trees);

	trunk = new FlxSprite().loadGraphic(Paths.image('characters/death/gf/trunk'));
	trunk.setGraphicSize(trunk.width*1.5, trunk.height*1.5);
	trunk.screenCenter();
	trunk.x += 500;
	trunk.antialiasing = true;
	add(trunk);

	claw = new FlxSprite();
	claw.frames = Paths.getFrames('characters/death/gf/claw');
	claw.animation.addByPrefix('idle','claw',24,true);
	claw.animation.play('idle');
	claw.x = -200;
	claw.y = 100;
	claw.antialiasing = true;
	add(claw);

	gf = new FlxSprite();
	gf.frames = Paths.getFrames('characters/death/gf/gf');
	gf.animation.addByPrefix('op','GF_DIZZLE_OPENING instance 1',24,false);
	gf.animation.addByPrefix('loop','GF_DIZZLE_LOOP instance 1',24,true);
	gf.animation.addByPrefix('wake','GF_WAKEUP instance 1',24,false);
	gf.screenCenter();
	gf.x += 300;
	gf.y += 100;
	gf.antialiasing = true;

	gf.animation.onFinish.addOnce(function(){
		gf.animation.play('loop');
	});
	gf.animation.play('op');
	add(gf);


	CoolUtil.playMusic(Paths.music(gameOverSong), false, 1, true);
}

function lostOver(event){
	event.cancel();

	camera = deathCam = new FlxCamera(0, 0);
    deathCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(deathCam, false);

	gameOverSong = 'gameOver';
	CoolUtil.playMusic(Paths.music(gameOverSong), false, 1, true);

	gf = new FlxSprite();
	gf.frames = Paths.getFrames('characters/death/gf/gameover');
	gf.animation.addByPrefix('op', 'firstDeath', 24, false);
	gf.animation.addByPrefix('loop', 'loop', 24, true);
	gf.animation.addByPrefix('wake', 'confirm', 24, false);
	gf.screenCenter();
	gf.setGraphicSize(gf.width/2, gf.height/2);
	add(gf);

	gf.animation.onFinish.addOnce(function(){
		gf.animation.play('loop');
	});

	gf.animation.play('op');
	FlxG.sound.play(Paths.sound('GF_dies'));
}

function missingno(event){
	event.cancel();
	FlxG.sound.play(Paths.sound('fnf_loss_sfx-pixel'));

	camera = deathCam = new FlxCamera(0, 0);
    deathCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(deathCam, false);

	//gameOverSong = 'gameOver';
	//CoolUtil.playMusic(Paths.music(gameOverSong), false, 1, true);

	gf = new FlxSprite();
	gf.frames = Paths.getFrames('characters/death/BF_Death_Missingno');
	gf.animation.addByPrefix('op', 'bf_misngno_death', 24, false);
	gf.screenCenter();
	gf.setGraphicSize(gf.width*4, gf.height*4);
	add(gf);

	gf.animation.play('op');
	
}

function insomnia(event){
	event.cancel();

	camera = deathCam = new FlxCamera(0, 0);
    deathCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(deathCam, false);

	var video:FlxVideoSprite = new FlxVideoSprite(0, 0);
	video.antialiasing = true;
	video.bitmap.onFormatSetup.add(function():Void
	{
	    if (video.bitmap != null && video.bitmap.bitmapData != null)
	    {
	        final scale:Float = Math.min(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);

	        video.setGraphicSize(FlxG.width, FlxG.height);
	        video.updateHitbox();
	        video.screenCenter();
	    }
	});
	//video.bitmap.onEndReached.add();
	add(video);

if (video.load(Paths.video("feraligatr")))
    new FlxTimer().start(0.001, (_) -> video.play());
}

function update(){
	if (controls.ACCEPT && !ending) endBullshit();
	if (controls.BACK) exit();
}

var ending:Bool = false;
function endBullshit():Void
	{
		ending = true;
		if(game.curSong == 'lost-cause') gf.y -= 180;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.music = null;

		var sound = FlxG.sound.play(Paths.sound(retrySFX), 0.5);

		var waitTime = 0.7;

		new FlxTimer().start(waitTime, function(tmr:FlxTimer)
		{
			camera.fade(FlxColor.BLACK, 2, false, function()
			{
				skipTransOut = true;
				FlxG.switchState(new PlayState());
			});
		});
		if(gf) gf.animation.play('wake');
	}



function exit(){
		//if (PlayState.chartingMode && Charter.undos.unsaved) game.saveWarn(false);
		//else {

			//if (FlxG.sound.music != null) FlxG.sound.music.stop();
			//FlxG.sound.music = null;
			FlxG.switchState(new FreeplayState());
		//}
	}

