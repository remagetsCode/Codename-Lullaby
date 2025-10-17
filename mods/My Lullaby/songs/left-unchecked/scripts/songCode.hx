importScript("data/scripts/FeelingTired.hx");

var pressed = false;
var startedTimer = false;
var counter = 1;
var t:Float = 60/Conductor.bpm;
var songStarted = false;
var healthDrain:Float = 0.15;
var reactionTime = 0.35;
var extras:FlxSprite;

public var healthHypno:Float = 1.5;

function postCreate(){
	
	pendelum = new FlxSprite();
	//pendelum.loadGraphic(Paths.image("UI/base/hypno/Pendelum_Phase2"));
	pendelum.frames = Paths.getFrames('UI/base/hypno/Pendelum_Phase2');
	pendelum.animation.addByPrefix('idle','Pendelum Phase 2',24);
	pendelum.animation.play('idle');
	add(pendelum);
	pendelum.setGraphicSize(pendelum.width * 1.30, pendelum.height * 1.30);
	pendelum.screenCenter();
	pendelum.scrollFactor.set(0);
	pendelum.cameras = [camHUD];
	pendelum.antialiasing = true;
	pendelum.origin.set(pendelum.width/2, 0);
	pendelum.alpha = 0.8;

	extras = new FlxSprite();
	extras.frames = Paths.getFrames('UI/base/hypno/Extras');
	extras.setGraphicSize(extras.width * 0.75, extras.height * 0.75);
	extras.animation.addByPrefix('Check','Checkmark',24,false);
	extras.animation.addByPrefix('Bad','X finished',24,false);
	extras.animation.addByPrefix('Spacebar1','SpacebarIdle',3);
	extras.animation.addByPrefix('Spacebar2','Spacebar',3);
	extras.animation.play('Spacebar1');
	extras.screenCenter();
	extras.cameras = [camHUD];
	extras.antialiasing = true;
	add(extras);

	if(downscroll){
		pendelum.y += 200;
		extras.y -= 100;
	}
	else{
		pendelum.y -= 200;
		extras.y += 100;
	}
	new FlxTimer().start(0.02, ()->{
		for(o in uiStuff) o.y += 500;
	});
	
}

function onSongStart(){
	if(FlxG.save.data.lullabyMechanics) songStarted = true;
	modchart.ease('alpha', 1, 4, 0.6, FlxEase.cubeOut, 0);
	
}

function update(){	
	if(!startedTimer && FlxG.keys.justPressed.SPACE && songStarted){ 
		FlxG.sound.play(Paths.sound('error'), 0.3);
		healthHypno -= healthDrain/2;
		showBad();
	}
	else if(startedTimer && FlxG.keys.justPressed.SPACE){
		pressed = true;
		healthHypno += healthDrain/2;
		showCheck();
	}
}

var aa:Int = 0;
function stepHit(step){
if(songStarted && step == (counter*7)+(counter-1)){
	
		if(counter % 2 == 1) {
			pend();
		}
		counter += 1;
		pressed = false;
		startedTimer = true;
		

		// Reaction time to hit that spacebar
		new FlxTimer().start(reactionTime, ()->{
			if(!pressed){
				healthHypno -= healthDrain;
				showBad();
			}
			startedTimer = false;
		});
		
	}
	if(healthHypno <= 0) gameOver();
	if(healthHypno > 2) healthHypno = 2;

	if(step == 258) for(o in uiStuff){ 
		FlxTween.tween(o, {y: o.y-500}, 1+(aa*0.5), {
			ease: FlxEase.cubeOut
		});
		aa++;
	}
}

function pend(){
	FlxTween.angle(pendelum, -40, 40, t*2, { 
        ease: FlxEase.sineOut, 
        onComplete: function(){
			FlxTween.angle(pendelum, 40, -40, t*2, { 
        		ease: FlxEase.sineOut, 
    		});
		}
    });

}
function showCheck(){
		extras.alpha = 1;
		extras.animation.play('Check');
}

function showBad(){
		extras.alpha = 1;
		extras.animation.play('Bad');
}
