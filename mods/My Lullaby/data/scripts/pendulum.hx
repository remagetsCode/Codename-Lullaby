public var pendelum:FlxSprite;
public var extras:FlxSprite;

public var pendulumStarted = false;
public var angleOffset:Float = 0;
var pressed:Bool = false;
var staticHypno:FlxSprite;
var trance:FlxSound;

var healthDrain:Float = 0.15;
var hitWindow:Float = 0.2; //0.4 in total
var prevCanHit:Bool = false;
var alreadyHitted:Bool = false;

function create(){
	pendelum = new FlxSprite();
	pendelum.frames = Paths.getFrames('UI/base/hypno/Pendelum_Phase2');
	pendelum.animation.addByPrefix('idle','Pendelum Phase 2',24);
	pendelum.animation.play('idle');
	pendelum.setGraphicSize(pendelum.width * 1.30, pendelum.height * 1.30);
	pendelum.screenCenter();
	pendelum.scrollFactor.set(0);
	pendelum.cameras = [camHUD];
	pendelum.antialiasing = true;
	pendelum.origin.set(pendelum.width/2 - 7, 5);
	pendelum.alpha = 0.8;

	pendelumGhost = new FlxSprite();
	pendelumGhost.frames = Paths.getFrames('UI/base/hypno/Pendelum_Phase2');
	pendelumGhost.animation.addByPrefix('idle','Pendelum Phase 2',24);
	pendelumGhost.animation.play('idle');
	pendelumGhost.setGraphicSize(pendelumGhost.width * 1.30, pendelumGhost.height * 1.30);
	pendelumGhost.screenCenter();
	pendelumGhost.scrollFactor.set(0);
	pendelumGhost.cameras = [camHUD];
	pendelumGhost.antialiasing = true;
	pendelumGhost.origin.set(pendelum.width/2 - 7, 0);
	pendelumGhost.alpha = 0.8;

	add(pendelumGhost);
	add(pendelum);

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

	staticHypno = new FlxSprite();
	staticHypno.frames = Paths.getFrames('UI/base/hypno/StaticHypno_highopacity');
	staticHypno.animation.addByPrefix('idle','StaticHypno',24);
	staticHypno.animation.play('idle');
	staticHypno.setGraphicSize(camHUD.width, camHUD.height);
	staticHypno.screenCenter();
	staticHypno.scrollFactor.set(0);
	staticHypno.cameras = [camHUD];
	staticHypno.antialiasing = true;
    staticHypno.alpha = 0;
	
	trance = FlxG.sound.play(Paths.sound('TranceStatic'), 0, true);

	pendelum.y += downscroll ? 200 : -200;
	pendelumGhost.y += downscroll ? 200 : -200;
	extras.y += downscroll ? -100 : 100;

    healthHypno = 1.5;
}

function onSongStart(){
    add(staticHypno);
}

function update(){	
    if(!pendulumStarted || !FlxG.save.data.lullabyMechanics) return;

	staticHypno?.alpha = Math.min(0.95-healthHypno, 0.95);
	trance?.volume = 0.9-healthHypno;

	var halfBeatFloat = curBeatFloat/2;
	pendelum.angle = Math.sin(curBeatFloat/2 * Math.PI) * 32 + angleOffset;

	var canHit:Bool = halfBeatFloat >= Math.ceil(halfBeatFloat) - hitWindow || halfBeatFloat <= Math.floor(halfBeatFloat) + hitWindow;

	pendelumGhost.alpha = lerp(pendelumGhost.alpha, 0, 0.1);

	if(prevCanHit != canHit && pendulumStarted) {
		alreadyHitted = false;
		if(!canHit) {
			if(!pressed){
				healthHypno -= healthDrain;
				showBad();
			}
			pressed = false;
		}
	}

    if(FlxG.keys.justPressed.SPACE) {
		pendelumGhost.alpha = 0.75;
		pendelumGhost.angle = pendelum.angle;

        if(!canHit || alreadyHitted){ 
            FlxG.sound.play(Paths.sound('error'), 0.3);
			pendelumGhost.color = FlxColor.RED;
            healthHypno -= healthDrain/2;
            showBad();
        }
        else if(canHit && !alreadyHitted){
            pressed = true;
            alreadyHitted = true;
			pendelumGhost.color = FlxColor.WHITE;
            healthHypno += healthDrain/2;
            showCheck();
        }
    }

	prevCanHit = canHit;
}

function stepHit(step){
	if(healthHypno <= 0) gameOver();
	if(healthHypno > 2) healthHypno = 2;	
}

function showCheck(){
		extras.alpha = 1;
		extras.animation.play('Check');
}

function showBad(){
		extras.alpha = 1;
		extras.animation.play('Bad');
}
