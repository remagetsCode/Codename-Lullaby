var maybeShesHypno = false;
var shesHypno = false;
var staticHypno;
var trance;


function postCreate(){
	new FlxTimer().start(0.5, ()->{
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

function update(){
	
	if(healthHypno < 1 && healthHypno > 0.3 && (shesHypno || !maybeShesHypno)){
	// Cambiar el 'idle' del personaje en tiempo real
		shesHypno = false;
		maybeShesHypno = true;
		bf.animation.addByPrefix("idle", "gf_idle_ok_maybe_shes_hypno_2s", 24, false);
		bf.playAnim("idle");
		
	}
	else if(healthHypno <= 0.3 && !shesHypno && maybeShesHypno){
		shesHypno = true;
		maybeShesHypno = false;
		bf.animation.addByPrefix("idle", "gf_idle_ok_shes_hypno_2s instance 1", 24, false);
		bf.playAnim("idle");
		
	}
	else if(healthHypno >= 1 && (shesHypno || maybeShesHypno)){
		shesHypno = false;
		maybeShesHypno = false;
		bf.animation.addByPrefix("idle", "gf_idle_not_hypno_2s", 24, false);
		bf.playAnim("idle");
		staticHypno.alpha = 0;
		
	}
}
function stepHit(){
	// I think placing this here will improve the performance, than staying in update()
	if(staticHypno != null)	staticHypno.alpha = 1-healthHypno;
	if(trance != null) trance.volume = 1-healthHypno;
}
