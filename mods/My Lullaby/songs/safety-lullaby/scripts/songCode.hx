importScript("data/scripts/FeelingTired.hx");

var pressed = false;
var startedTimer = false;
var counter = 1;
var t:Float = 60/Conductor.bpm;
var songStarted = false;
var healthDrain:Float = 0.15;
var reactionTime = 0.5;
var extras:FlxSprite;
var both:Array = [];

public var healthHypno:Float = 1.5;

function postCreate(){
	lil = new FlxSprite();
	lil.frames = Paths.getFrames('UI/base/hypno/Pendelum');
	lil.animation.addByPrefix('idle', 'Pendelum instance 1',24,true);
	lil.animation.play('idle');
	lil.origin.set(lil.width, 0);
	add(lil);
	
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
	pendelum.visible = false;
	

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

	both.push(pendelum);
	both.push(lil);

	if(downscroll){
		pendelum.y += 200;
		extras.y -= 100;
	}
	else{
		pendelum.y -= 200;
		extras.y += 100;
	}
	
}

function onSongStart(){
	if(FlxG.save.data.lullabyMechanics) songStarted = true;
	else lil.visible = false;
	
	for(pend in both){
		FlxTween.angle(pend, 0, -50, t*3, {
			ease: FlxEase.sineOut
		});
	}	
}
function update(){
	//health +=1;
	if(dad.animation.curAnim.name == "idle"){
		lil.x = 350;
		lil.y = 360;
	}
	else if(dad.animation.curAnim.name == "singLEFT"){
		lil.x = 350;
		lil.y = 450;
	}
	else if(dad.animation.curAnim.name == "singUP"){
		lil.x = 260;
		lil.y = 0;
	}
	else if(dad.animation.curAnim.name == "singDOWN"){
		lil.x = 250;
		lil.y = 350;
	}
	else if(dad.animation.curAnim.name == "singRIGHT"){
		lil.x = 380;
		lil.y = 630;
	}
	else if(dad.animation.curAnim.name == "Psyshock"){
		lil.x = 3800;
		lil.y = 6300;
	}
	
	if(!startedTimer && FlxG.keys.justPressed.SPACE){ 
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
	}

function pend(){
	for(pend in both){
		FlxTween.angle(pend, -40, 40, t*2, { 
    	    ease: FlxEase.quadInOut, 
    	    onComplete: function(){
				FlxTween.angle(pend, 40, -40, t*2, { 
    	    		ease: FlxEase.quadInOut, 
    			});
			}
    	});
}

}
function showCheck(){
		extras.alpha = 1;
		extras.animation.play('Check');
}

function showBad(){
		extras.alpha = 1;
		extras.animation.play('Bad');
}

function beatHit(beat){
	switch(beat){
		case 2: extras.animation.play('Spacebar2');
		case 3: extras.animation.play('Spacebar1');
		case 4: extras.animation.play('Spacebar2');
		case 5: extras.animation.play('Spacebar1');
		case 6: extras.animation.play('Spacebar2');
		case 7: extras.animation.play('Spacebar1');
		case 8: extras.animation.play('Spacebar2');
		case 9: extras.animation.play('Spacebar1');
		case 10: extras.animation.play('Spacebar2');
			extras.animation.addByPrefix('Check','Checkmark',24,false);
			extras.animation.addByPrefix('Bad','X finished',24,false);
		case 11: extras.animation.play('Spacebar1');
		case 12: extras.animation.play('Spacebar2');
		case 13:
			extras.animation.play('Spacebar1');
			FlxTween.tween(extras, { alpha: 0 }, 1, {
				ease: FlxTween.cubeOut
			});
		
	}
}

