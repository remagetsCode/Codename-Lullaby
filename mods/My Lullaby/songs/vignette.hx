var availableSongs = ['left-unchecked', 'lost-cause'];
public var vignette:FlxSprite;
public var black:FlxSprite;

function postCreate(){
	new FlxTimer().start(0.01, ()->{
		vignette = new FlxSprite().loadGraphic(Paths.image('UI/base/vignette2'));
		vignette.screenCenter();
		vignette.setGraphicSize(FlxG.width, FlxG.height);
		vignette.cameras = [camHUD];
		vignette.alpha = 0;
		add(vignette);

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.cameras = [camHUD];
		black.alpha = 0;
		add(black);
		if(availableSongs.contains(curSong))
			new FlxTimer().start(0.7, ()->{
				vignetteIdk();
			});
	});
}

function vignetteIdk(){
	FlxTween.tween(vignette, { alpha: 1 }, 4, {
			ease:FlxEase.smootherStepOut,
			type: FlxTween.PINGPONG
		});
}