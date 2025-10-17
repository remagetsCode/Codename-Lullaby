import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

FlxG.game.setFilters([]);
var freezeBar:FlxBar;
var a:Float = 1;
public var freezeVal:Float = 30; 
var uses:Int = 0;
var ty:Bool = true;
var extraSound:FlxSound;

function create(){
	graphicCache.cache(Paths.image('characters/red/freakachu_entrance'));
	graphicCache.cache(Paths.image('characters/red/Freakachu'));
	graphicCache.cache(Paths.image('characters/mt_silver_red_dead'));

	if(FlxG.save.data.lullabyShaders){
		FlxG.game.addShader(frostbite);
		FlxG.game.addShader(aberration);
	}
	aberration.iTime = 5;
	frostbite.SPEED = 1.4;
	frostbite.LAYERS = 25;
	frostbite.WIDTH = .8;
	frostbite.DEPTH = 0.6;

	health = 2;

	redAnim = new FlxSprite(690,330);
	redAnim.frames = Paths.getFrames('characters/red/freakachu_entrance');
	redAnim.animation.addByPrefix('1', 'Freakachu entrance instance 1', 24, false);
	redAnim.setGraphicSize(redAnim.width*1.1, redAnim.height*1.1);
	//redAnim.scrollFactor.set(0.95);
	redAnim.antialiasing = true;
	redAnim.visible = false;
	insert(7, redAnim);

	freakachu = new FlxSprite(760,620);
	freakachu.frames = Paths.getFrames('characters/red/Freakachu');
	freakachu.animation.addByPrefix('idle', 'Freakachu IDLE',24,true);
	freakachu.animation.addByPrefix('bite', 'Freakachu PAIN SPLIT',24,false);
	freakachu.animation.play('idle');
	freakachu.setGraphicSize(freakachu.width*1.7, freakachu.height*1.7);
	freakachu.antialiasing = true;
	//freakachu.scrollFactor(0.93);
	freakachu.visible = false;
	insert(7, freakachu);
	
	fog = new FlxSprite().loadGraphic(Paths.image('fog'));
	fog.setGraphicSize(fog.width, fog.height*0.65);
	fog.alpha = 0.995;
	insert(7, fog);

	freezeBar = new FlxBar(
		50, downscroll ? FlxG.height*0.26 : FlxG.height*0.2,
		FlxBarFillDirection.BOTTOM_TO_TOP,
		20, 420
	);

	freezeBar.createFilledBar(FlxColor.GRAY, FlxColor.CYAN);
	freezeBar.cameras = [camHUD];
	freezeBar.numDivisions = 200;
	add(freezeBar);

	lilTy = new FlxSprite(freezeBar.x-30, downscroll ? 605 : 75);
	lilTy.frames = Paths.getFrames('UI/base/TyphlosionVit');
	lilTy.animation.addByPrefix('a1', 'Typh1 instance 1', 24, true);
	lilTy.animation.addByPrefix('a2', 'Typh2 instance 1', 24, true);
	lilTy.animation.addByPrefix('a3', 'Typh3 instance 1', 24, true);
	lilTy.animation.addByPrefix('a4', 'Typh4 instance 1', 24, true);
	lilTy.animation.addByPrefix('a5', 'Typh5 instance 1', 24, true);
	lilTy.animation.play('a1');
	lilTy.cameras = [camHUD];
	add(lilTy);

	thermo = new FlxSprite();
	thermo.frames = Paths.getFrames('UI/base/Thermometer');
	thermo.animation.addByPrefix('t1', 'Therm1', 24);
	thermo.animation.addByPrefix('t2', 'Therm2', 24);
	thermo.animation.addByPrefix('t3', 'Therm3', 24);
	thermo.animation.play('t1');
	thermo.setGraphicSize(thermo.width*1.25, thermo.height*1.25);
	thermo.cameras = [camHUD];
	thermo.y = FlxG.height/4;
	thermo.x = freezeBar.x-35;
	thermo.antialiasing = true;
	add(thermo);

	//black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	//black.cameras = [camHUD];
	//black.alpha = 0;
	//add(black);

	scare = new FlxSprite().loadGraphic(Paths.image('jumpscares/Pikachu'));
	scare.setGraphicSize(FlxG.width, FlxG.height);
	//scare.cameras = [camHUD];
	scare.visible = false;
	scare.updateHitbox();
	scare.setPosition(0,0);
	add(scare);

	scare1 = new FlxSprite().loadGraphic(Paths.image('jumpscares/Pikachu-variant'));
	scare1.setGraphicSize(FlxG.width, FlxG.height);
	scare1.updateHitbox();
	//scare1.cameras = [camHUD];
	scare1.visible = false;
	scare1.setPosition(0,0);
	add(scare1);
}
function postCreate(){
	canDie = false;
	gf.alpha = 1;
	gf.y = 900;
	

	new FlxTimer().start(0.02, ()->{for(o in uiStuff) o.y += 500;});

	// Thanks to BASHIR for flipping the healthbar
	healthBar.flipX = iconP1.flipX = iconP2.flipX = true;
	updateIconPositions = function(){
		var iconOffset:Int = 26;

		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(100-healthBar.percent, 0, 100, 1, 0);

		iconP2.x = center - iconOffset;
		iconP1.x = center - (iconP1.width - iconOffset);

		health = FlxMath.bound(health, 0, maxHealth);

		iconP1.health = healthBar.percent / 100;
		iconP2.health = 1 - (healthBar.percent / 100);
	}
}

function onSongStart(){
	scare = new FlxSprite().loadGraphic(Paths.image('jumpscares/Pikachu'));
	scare.setGraphicSize(FlxG.width, FlxG.height);
	scare.cameras = [camHUD];
	scare.visible = false;
	scare.updateHitbox();
	scare.setPosition(0,0);
	add(scare);

	scare1 = new FlxSprite().loadGraphic(Paths.image('jumpscares/Pikachu-variant'));
	scare1.setGraphicSize(FlxG.width, FlxG.height);
	scare1.updateHitbox();
	scare1.cameras = [camHUD];
	scare1.visible = false;
	scare1.setPosition(0,0);
	add(scare1);

	modchart.ease('alpha', 0, 1, 0.15, FlxEase.cubeOut, 0);

	modchart.ease('x', 16, 4, -610, FlxEase.cubeOut, 1);
	modchart.ease('confusionOffset', 16, 4, 360, FlxEase.cubeOut, 1);
	modchart.ease('x', 16, 4, 610, FlxEase.cubeOut, 0);
	modchart.ease('confusionOffset', 16, 4, -360, FlxEase.cubeOut, 0);

	modchart.ease('alpha', 47, 4, 0.8, FlxEase.cubeOut, 0);

	modchart.ease('alpha', 320, 6, 0, FlxEase.cubeOut, 0);
	modchart.ease('alpha', 335, 10, 0, FlxEase.cubeOut, 1);

}

function update(elapsed){
	a -= elapsed;
	frostbite.iTime = a;

	if(FlxG.save.data.lullabyMechanics) typhlosionMechanic(elapsed);
	else{ 
		// If u are not using the mechanics then i won't mechanically unuse the freeze bar.

		var g = 0.1;
		var r = inst.amplitude * 0.8;
		var b = 1-r;

		freezeBar.createFilledBar(FlxColor.GRAY, FlxColor.fromRGB(
        	Std.int(r * 255),
        	Std.int(g * 255),
        	Std.int(b * 255)
    		)
		);
		freezeVal = lerp(freezeVal, inst.amplitude * 65, 0.15);
		freezeBar.percent = freezeVal;

	}

	if (extraSound != null && extraSound.playing) {
		inst.pitch = 0.2;
        extraSound.onComplete = function() {
            endSong(); // manually ends the song
        }
    }
}

function beatHit(beat){
	if(freezeVal < 30) thermo.animation.play('t1');
	else if(freezeVal >= 30 && freezeVal < 70) thermo.animation.play('t2');
	else if(freezeVal >= 70) thermo.animation.play('t3');

	if(uses == 2) lilTy.animation.play('a2');
	if(uses == 4) lilTy.animation.play('a3');
	if(uses == 6) lilTy.animation.play('a4');
	if(uses == 8) lilTy.animation.play('a5');

	switch(beat){
		case 6: 
			FlxTween.tween(gf, {y: 581}, 1, {
				ease: FlxEase.cubeOut
			});
			for(i in 0...4) FlxTween.tween(uiStuff.members[i], {y: uiStuff.members[i].y-525}, 2,{ease:FlxEase.cubeOut});

		case 9:
			uses++;
			FlxTween.num(freezeVal, freezeVal-50, 1.5,{
				ease: FlxEase.smootherStepInOut,
				onUpdate: function(val) {freezeVal = val.value;}
			});

		case 12: FlxTween.num(5.0, 11.0, 2, {
			onUpdate: (v)->{aberration.iTime = v.value;},
			onComplete: ()->{aberration.iTime = 5;}
		});

		case 49: FlxTween.tween(fog, {x: 1400, alpha: 0}, 5, {
			ease: FlxEase.quintOut
		});
		for(i in 4...uiStuff.length) FlxTween.tween(uiStuff.members[i], {y: uiStuff.members[i].y-500}, 2+i*0.5,{ease:FlxEase.cubeOut});

		case 173: 
			dad.visible = false;
			redAnim.visible = true;
			redAnim.animation.play('1');
			redAnim.animation.onFinish.addOnce(function(){
				redAnim.visible = false;
				freakachu.visible = true;
			});
		case 176: 	
			FlxTween.num(1,2.5,5,{
				onUpdate:function(val){frostbite.SPEED = val.value;}
			});
			FlxTween.num(25,35,5,{
				onUpdate:function(val){frostbite.LAYERS = val.value;}
			});
			frostbite.WIDTH = 1.2;
			frostbite.DEPTH = 0.6;
			freakachu.scrollFactor(0.96);
			iconP2.setIcon('icon-red-dead');
		case 340:
			FlxTween.tween(black, {alpha: 1}, 3);
		
		case 344:
			canDie = false;
			extraSound = FlxG.sound.play(Paths.sound('Frostbite_ending'));
			new FlxTimer().start(0.1,()->{health += 0.01;}, 100);
			new FlxTimer().start(10, ()->{
				scare.visible = true;
				scare1.visible = true;
				new FlxTimer().start(0.3, ()->{
					health -= 0.15;
					scare1.visible = !scare1.visible;
				},10);
			});
		}
		
}

//! Mechanics 
function typhlosionMechanic(elapsed){
	if (freezeVal < 100) freezeVal += elapsed*1.35;
	if(freezeVal < 0) freezeVal = 0;
	
	if(freezeBar.percent < 50){ health -= freezeVal*(elapsed*0.0016); 	modchart.setPercent('vibrate', freezeVal*0.0045, 1);}
	else{ 						health -= freezeVal*(elapsed*0.0025); 	modchart.setPercent('vibrate', freezeVal*0.0065, 1);}
	
	freezeBar.percent = freezeVal;

	if(FlxG.keys.justPressed.SPACE && ty){
		health += 0.1;
		FlxTween.num(freezeVal, freezeVal-33, 1.5,{
			ease: FlxEase.smootherStepInOut,
			onUpdate: function(val) {freezeVal = val.value;}
		});
		FlxG.sound.play(Paths.sound('TyphlosionUse'), 0.8);
		gf.animation.play('mechanic');
		uses++;
	}

	else if(uses >= 8 && ty){
		ty = false;
		FlxG.sound.play(Paths.sound('TyphlosionDeath'));
		FlxTween.tween(gf, {y: 900}, 4, {
			ease: FlxEase.cubeOut,
			onComplete:()->{
				gf.visible = false;
				gf.y = 580;
			}
		});

	}
}

function freakachuBite(){
	freakachu.animation.play('bite');
	freakachu.animation.onFinish.addOnce(function(){ freakachu.animation.play('idle'); });
	new FlxTimer().start(0.3, ()->{
		FlxG.sound.play(Paths.sound('Frostbite_bite'));
		health -= 0.4;
	});
}