var bg1;
var bg2;
var placebf;
var placedad;

introLength = 0;

function create(){
    bg1 = stage.getSprite("BG1");
    bg2 = stage.getSprite("BG2");
    placebf = stage.getSprite("place-bf");
    placedad = stage.getSprite("place-dad");

    if(FlxG.save.data.lullabyShaders){
        FlxG.game.addShader(aberration);
        FlxG.game.addShader(heat1);
        aberration.iTime = 6.5;

        bg1.shader = missingno;
        bg2.shader = missingno;
        missingno.GLITCH_THR = 0.0;
        missingno.ENABLE_MODE = 1;
        missingno.MODE = 1;
    }

    bl = new FlxSprite().makeGraphic(FlxG.width*2, FlxG.height, FlxColor.BLACK);
    bl.scrollFactor.set(0);
    insert(8,bl);

    wh = new FlxSprite().makeGraphic(FlxG.width*2, FlxG.height, FlxColor.WHITE);
    wh.scrollFactor.set(0);
    insert(9,wh);

    FlxTween.tween(wh, {alpha: 0}, 0.5, {type:4});
        
    strumLines.members[1].characters[0].colorTransform.color = FlxColor.ORANGE;
    strumLines.members[0].characters[0].colorTransform.color = FlxColor.PURPLE;
        
    bf.x = -500;
    dad.x = 2500;

    if(FlxG.save.data.lullabyMechanics) playAsWiggly();
}

function postCreate(){
    modchart.ease('confusionoffset', 136, 1.5, 360, FlxEase.cubeOut);
    modchart.set('confusionoffset', 138, 0);

    for(i in 0...20){
        modchart.ease('confusionoffset', 328+(8*i), 1, 360, FlxEase.cubeOut);
        modchart.set('confusionoffset', 329+(8*i), 0);
    }

    modchart.setPercent('alpha', 0);
    modchart.setPercent('x', 50);
    modchart.setPercent('z', 70, 0);
    modchart.setPercent('z', -70, 1);

    modchart.ease('alpha', 5, 2, cpu.cpu ? 1 : 0.05, FlxEase.cubeOut, 1);
    modchart.ease('alpha', 5, 2, player.cpu ? 1 : 0.05, FlxEase.cubeOut, 0);
    modchart.ease('alpha', 30, 2, 1, FlxEase.cubeOut);

    modchart.set('tipsy', 136, 0.2);
    modchart.ease('alpha', 173, 2, 0.1, FlxEase.cubeOut);
    modchart.ease('alpha', 174, 2, 0.9, FlxEase.cubeOut);
    modchart.ease('alpha', 200, 2, !cpu.cpu ? 1 : 0.2, FlxEase.cubeOut, 0);
    modchart.ease('alpha', 200, 2, !player.cpu ? 1 : 0.2, FlxEase.cubeOut, 1);
    modchart.ease('opponentSwap', 200, 8, 0.5, FlxEase.cubeInOut);
    modchart.ease('opponentSwap', 264, 8, 1, FlxEase.cubeInOut);
    modchart.ease('alpha', 266, 2, 0.9, FlxEase.cubeOut, 0);
    modchart.ease('alpha', 266, 2, 0.9, FlxEase.cubeOut, 1);
    modchart.ease('z', 200, 8, 70, FlxEase.cubeInOut, 1);
    modchart.ease('z', 200, 8, -70, FlxEase.cubeInOut, 0);
    modchart.set('tipsy', 201, 0.5);
    modchart.set('tipsy', 328, 0.4);
    modchart.set('wiggle', 328, 1);

    modchart.ease('alpha', 384, 1, 0, FlxEase.cubeOut);
    modchart.ease('alpha', 390, 1, 1, FlxEase.cubeOut);
    modchart.set('confusionoffset', 364, 0);

    modchart.set('tipsy', 415, 0);
    modchart.ease('alpha', 413, 2, !cpu.cpu ? 1 : 0.1, FlxEase.cubeOut, 0);
    modchart.ease('alpha', 413, 2, !player.cpu ? 1 : 0.1, FlxEase.cubeOut, 1);
    modchart.ease('opponentSwap', 415, 2, 0.5, FlxEase.cubeOut);
    modchart.ease('opponentSwap', 424, 4, 1, FlxEase.cubeOut);
    modchart.ease('alpha', 425, 2, 0.9, FlxEase.cubeOut, 0);
    modchart.ease('alpha', 425, 2, 0.9, FlxEase.cubeOut, 1);
    modchart.set('tipsy', 424, 0.4);


    modchart.ease('y', 500, 10, downscroll ? 300 : -300, FlxEase.cubeInOut);


    new FlxTimer().start(0.01, ()->{
        holds.visible = false;
        for(a in uiStuff) a.alpha = 0;

        redStatic = new FlxSprite();
        redStatic.frames = Paths.getFrames("stages/disabled/images/static-overlay");
        redStatic.animation.addByPrefix('xd', 'static', 24, true);
        redStatic.animation.play('xd');
        redStatic.cameras = [camHUD];
        redStatic.alpha = 0;
        add(redStatic);

        bStatic = new FlxSprite();
        bStatic.frames = Paths.getFrames("stages/disabled/images/static");
        bStatic.animation.addByPrefix('xd', 'static', 24, true);
        bStatic.animation.play('xd');
        bStatic.cameras = [camHUD];
        bStatic.setGraphicSize(FlxG.width+50, FlxG.height+35);
        bStatic.updateHitbox();
        bStatic.screenCenter();
        bStatic.alpha = 0;
        add(bStatic);
        
    });

    blackbg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackbg.visible = false;
    blackbg.scrollFactor.set(0,0);
    add(blackbg);

    scare = new FlxSprite().loadGraphic(Paths.image("stages/disabled/images/jumpscare"));
    scare.setGraphicSize(FlxG.width, FlxG.height);
    scare.visible = false;
    scare.scrollFactor.set(0,0);
    scare.screenCenter();
    scare.antialiasing = true;
    add(scare);

    qu = new FlxSprite().loadGraphic(Paths.image("stages/disabled/images/questionare"));
    qu.setGraphicSize(FlxG.width, FlxG.height);
    qu.screenCenter();
    qu.visible = false;
    qu.y -= 100;
    qu.scrollFactor.set(0,0);
    add(qu);

    wig = new FlxSprite();
    wig.frames = Paths.getFrames("stages/disabled/images/wiggles_questionare");
    wig.animation.addByPrefix('anim1', 'ques', 24, true);
    wig.animation.addByPrefix('ang', 'angry', 24, true);
    wig.animation.addByPrefix('giv', 'Give', 24, false);
    wig.animation.play('anim1');
    wig.scrollFactor.set(0,0);
    wig.screenCenter();
    wig.visible = false;
    wig.antialiasing = true;
    add(wig);

    gimiursing = new FlxSprite();
    gimiursing.frames = Paths.getFrames("stages/disabled/images/Givemeyoursing");
    gimiursing.animation.addByPrefix('up', 'Upfront', 24, false);
    gimiursing.animation.addByPrefix('idle', 'stare', 24, true);
    gimiursing.screenCenter();
    gimiursing.scrollFactor.set(0,0);
    gimiursing.y -= 100;
    gimiursing.x += 50;
    gimiursing.visible = false;
    gimiursing.antialiasing = true;
    add(gimiursing);
    gimiursing.animation.onFinish.addOnce(function(e){
        gimiursing.animation.play('idle', true);
    });

    dialogBox = new FlxSprite().loadGraphic(Paths.image("UI/base/amusia/questionareTextBox"));
    dialogBox.screenCenter();
    dialogBox.y += 250;
    dialogBox.x -= 100;
    dialogBox.scrollFactor.set(0,0);
    dialogBox.visible = false;
    add(dialogBox);

    dialogBox2 = new FlxSprite().loadGraphic(Paths.image("UI/base/amusia/questionareAnswerBox"));
    dialogBox2.screenCenter();
    dialogBox2.scrollFactor.set(0,0);
    dialogBox2.x += 350;
    dialogBox2.y += 250;
    dialogBox2.visible = false;

    add(dialogBox2);

    sel = new FlxSprite(dialogBox2.x, dialogBox2.y).loadGraphic(Paths.image("UI/pixel/selector"));
    sel.scale.set(2,2);
    sel.x += 25;
    sel.y += 40;
    sel.scrollFactor.set(0,0);
    sel.visible = false;
    add(sel);

    talk = new FunkinText(dialogBox.x+30, dialogBox.y+30, 680, "", 28, false);
	talk.wordWrap = true;
	talk.setFormat(Paths.font("pokefont.ttf"), 24, 0x000000);
    talk.scrollFactor.set(0,0);
	add(talk);
}

function update(elapsed){
    
    if(curStep < 800)
    {
        switch(iconP2.curCharacter){
            case "icon-wigglytuff": vignette.alpha = lerp(vignette.alpha, 0, 0.05);
            case "icon-wigglytuff1": vignette.alpha = lerp(vignette.alpha, 0.3, 0.05);
            case "icon-wigglytuff2": vignette.alpha = lerp(vignette.alpha, 0.6, 0.05);
            case "icon-wigglytuff3": vignette.alpha = lerp(vignette.alpha, 0.8, 0.05);
        }
    }

    if(curCameraTarget == 1 && curStep < 790) camera.zoom = lerp(camera.zoom, 1.25, 0.05);
    else if(curStep < 540) camera.zoom = lerp(camera.zoom, 1, 0.1);
}

function onNoteHit(e){
    
    if(e.note.strumLine.opponentSide == true){
    var n = e.note;
    e.preventDeletion();    // This is so fucking laggy :sob:
    if(curBeat < 196){
        switch(e.noteType){
            case null: 
                e.character.idleSuffix = "";
                e.animSuffix = "";
                iconP2.setIcon("icon-wigglytuff");
            case "1", "2", "3": 
                e.character.idleSuffix = e.noteType;
                e.animSuffix = e.noteType;
                iconP2.setIcon("icon-wigglytuff"+e.noteType);
            default: return;
        }
    }
    else iconP2.setIcon("icon-wigglytuff3");

    modchart.setPercent('vibrate', 0.5, 0);
    new FlxTimer().start(0.05, ()->{modchart.setPercent('vibrate', 0, 0);});
    new FlxTimer().start(0.3, ()->{n.destroy();}); // Idk if this solves the lag, I hope yes
}
}

function stepHit(s){
    missingno.iTime = FlxG.random.float(1,10);
    switch(s){
        case 11: FlxTween.tween(dad, {x: 300}, 1, {ease: FlxEase.cubeOut});
    
        case 21: FlxTween.tween(bf, {x: 1048}, 1, {ease: FlxEase.cubeOut});

        case 28: 
            for(a in uiStuff) a.alpha = 1;
            strumLines.members[1].characters[0].setColorTransform();
            strumLines.members[0].characters[0].setColorTransform();
            bl.destroy();
            wh.destroy();
        case 128: missingno.GLITCH_THR = 0.0001;
        case 140: missingno.GLITCH_THR = 0.00001;
        case 272: 
            FlxTween.num(0, 0.3, 1, {onUpdate: (v)->{heat1.intensity = v.value;}});
            FlxTween.tween(redStatic, {alpha: 0.7}, 1);
            FlxTween.tween(bStatic, {alpha: 0.1}, 1);
            missingno.GLITCH_THR = 0.0001;
        case 274: missingno.GLITCH_THR = 0.001;
        case 276: missingno.GLITCH_THR = 0.004;
        case 279: missingno.GLITCH_THR = 0.008;
        case 282: missingno.GLITCH_THR = 0.01;
        case 285: missingno.GLITCH_THR = 0.15;

        case 288: 
            FlxTween.num(0.3, 0, 0.2, {onUpdate: (v)->{heat1.intensity = v.value;}});
            FlxTween.tween(redStatic, {alpha: 0.05}, 0.5);
            FlxTween.tween(bStatic, {alpha: 0.05}, 0.5);
            missingno.GLITCH_THR = 0.0;

        case 416: missingno.GLITCH_THR = 0.001;

        case 540: FlxTween.tween(bStatic, {alpha: 0.7}, 0.5);
        case 545: 
            FlxTween.tween(redStatic, {alpha: 0.2}, 1);
            FlxTween.tween(bStatic, {alpha: 0.1}, 1);
            bg1.destroy();
            missingno.GLITCH_THR = 0.08;
            missingno.GLITCH_RECT_DIVISION = 20;

        case 697: 
            FlxTween.tween(redStatic, {alpha: 0.3}, 1);
            FlxTween.tween(bStatic, {alpha: 0.2}, 1);
            dad.playAnim("idle1");
        case 698: dad.playAnim("idle2");
        case 699: dad.playAnim("idle3");

        case 792: 
            FlxTween.tween(placebf, {x: 1500}, 2, {ease: FlxEase.cubeIn});
            FlxTween.tween(bf, {x: 1500}, 2, {ease: FlxEase.cubeIn});
            FlxTween.tween(placedad, {x: -1500}, 2, {ease: FlxEase.cubeIn});
            FlxTween.tween(dad, {x: -1500}, 2, {ease: FlxEase.cubeIn});

        case 813:
            FlxTween.tween(placebf, {x: 568}, 2, {ease: FlxEase.cubeOut});
            FlxTween.tween(placedad, {x: -80}, 2, {ease: FlxEase.cubeOut});

            FlxTween.num(6.5, 8, 2, {onUpdate: (v)->{aberration.iTime = v.value;}});

            bf.y = 300;
            bf.x = -1000;
            bf.scrollFactor.set(1, 1);
            bf.flipX = false;
            FlxTween.tween(bf, {x: 200}, 2, {ease: FlxEase.cubeOut});

            dad.y = -579;
            dad.x = 2000;
            dad.scale.set(0.6, 0.6);
            dad.scrollFactor.set(0.59, 0.59);
            FlxTween.tween(dad, {x: 908}, 2, {ease: FlxEase.cubeOut});

        case 805: for(i in uiStuff) FlxTween.tween(i, {alpha: 0}, 0.5);
        case 815:
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
        case 825: for(i in uiStuff) FlxTween.tween(i, {alpha: 1}, 1);

        case 1296:
            FlxTween.num(0, 1, 0.6, {onUpdate: (v)->{heat1.intensity = v.value;}});
            FlxTween.tween(redStatic, {alpha: 0.7}, 0.8);
        case 1309:
            FlxTween.tween(redStatic, {alpha: 0.1}, 0.5);
            FlxTween.num(1, 0, 0.2, {onUpdate: (v)->{heat1.intensity = v.value;}});
            FlxTween.num(8, 6.5, 2, {onUpdate: (v)->{aberration.iTime = v.value;}});
            dad.scrollFactor.set(0.59, 0.59);
        
        case 1312: FlxTween.tween(vignette, {alpha: 0.4}, 1);

        case 1534: 
            FlxTween.tween(redStatic, {alpha: 0.1}, 1);
            FlxTween.tween(bStatic, {alpha: 0.05}, 1);
        case 1568:
            FlxTween.tween(redStatic, {alpha: 0.25}, 1);
            FlxTween.tween(bStatic, {alpha: 0.15}, 1);
        case 2016:
            FlxTween.tween(bStatic, {alpha: 1}, 1, {onComplete: ()->{FlxTween.tween(bStatic, {alpha: 0}, 5);}});
            FlxTween.tween(redStatic, {alpha: 0}, 5);

        case 2030:
            for(a in uiStuff) a.alpha = 0;
            dialogBox.visible = true;    
            talk.visible = true;      
            wig.visible = true;      
            qu.visible = true;  
            blackbg.visible = true;      

        case 2080: dialogue("I just wanted to sing...");
        case 2105: dialogue("Why... why... why... can't I sing?");
        case 2135: dialogue("Just... Sing... Sing...");
        case 2165: dialogue("Why can't I sing? Why? WHY?");
        case 2200: 
            dialogBox2.visible = true;
            sel.visible = true;
            dialogue("Can you sing?");
        case 2210:
            sel.y += 30;
        case 2235: 
            wig.animation.play('giv');
            FlxG.sound.play(Paths.sound("confirmMenu"));
            dialogue("You're lying.");
        case 2265: 
            wig.animation.play('ang');
            FlxG.sound.play(Paths.sound("confirmMenu"));
            dialogue("You... can sing.");
        case 2300:
            wig.visible = false;
            gimiursing.visible = true;
            gimiursing.animation.play('up');
            FlxG.sound.play(Paths.sound("confirmMenu"));
            dialogue("Give me your sing.");
        case 2330:
            FlxG.sound.play(Paths.sound("confirmMenu"));
            dialogue("Give me your sing.");
        case 2360:
            FlxG.sound.play(Paths.sound("confirmMenu"));
            dialogue("Give me your sing.");
        case 2390:
            FlxG.sound.play(Paths.sound("confirmMenu"));
            dialogue("Sing.");
        case 2420:
            FlxG.sound.play(Paths.sound("confirmMenu"));
            dialogue("Sing.");
        case 2450:
            FlxG.sound.play(Paths.sound("confirmMenu"));
            dialogBox2.visible = false;
            dialogBox.visible = false;
            sel.visible = false;      
            talk.visible = false;      
            wig.visible = false;      
            qu.visible = false;      
            gimiursing.visible = false;  
        
        case 2540:
            FlxG.sound.play(Paths.sound("WigglyTuffJumpscare"));
            scare.visible = true;
    }

    
}

function playAsWiggly(){
    player.cpu = true;
    cpu.cpu = false;
    canDie = false;
    canDadDie = true;
}

cpu.onNoteUpdate.add(function(e){       // Sorry cpu.onNoteUpdate.add(function(e){ the lag wasnt your fault :)
    if(e.note.isSustainNote) e.note.avoid = true;
    e.cancelPositionUpdate();
});

var typeTimer:FlxTimer;
var fullText:String;
var currentIndex:Int = 0;
function dialogue(target:String){
	//trace('a');
	fullText = target;
	currentIndex = 0;
	talk.text = "";

	if(typeTimer == null){
		typeTimer = new FlxTimer();
		typeTimer.start(0.04, showNextLetter, 0);
	}
	
}


function showNextLetter(timer:FlxTimer){
    talk.text += fullText.charAt(currentIndex);
    currentIndex++;

    if (currentIndex >= fullText.length){
		//trace('e');
        isTyping = false;
		typeTimer.cancel();
		typeTimer = null;
    }
}