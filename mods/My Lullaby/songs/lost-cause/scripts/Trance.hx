var maybeShesHypno = false;
var shesHypno = false;
var staticHypno;
var trance;

function postCreate(){
	new FlxTimer().start(1, ()->{
		add(staticHypno);
	});
	
	staticHypno = new FlxSprite();
	staticHypno.frames = Paths.getFrames('UI/base/hypno/StaticHypno_highopacity');
	staticHypno.animation.addByPrefix('idle','StaticHypno',24);
	staticHypno.animation.play('idle');
	staticHypno.setGraphicSize(camHUD.width, camHUD.height);
	staticHypno.screenCenter();
	staticHypno.scrollFactor.set(0);
	staticHypno.cameras = [camHUD];
	staticHypno.antialiasing = true;
	
	trance = FlxG.sound.play(Paths.sound('TranceStatic'), 0, true);
	
}

function stepHit(){
	
	// I think placing this here will improve the performance, than staying in update()
	if(staticHypno != null)	staticHypno.alpha = 0.9-healthHypno;
	if(trance != null) trance.volume = 0.9-healthHypno;
}

function onSongEnd(){
	FlxG.game.setFilters([]);
}
