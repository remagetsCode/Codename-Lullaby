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
        aberration.iTime = 6.5;

        bg1.shader = missingno;
        bg2.shader = missingno;
        missingno.GLITCH_THR = 0.0;
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
        
    dad.x = -500;
    bf.x = 2500;
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

    modchart.set('alpha', 8, 1);
    modchart.set('tipsy', 136, 0.2);
    modchart.ease('alpha', 173, 2, 0.1, FlxEase.cubeOut);
    modchart.ease('alpha', 176, 2, 1, FlxEase.cubeOut);
    modchart.ease('alpha', 200, 2, 0.2, FlxEase.cubeOut, 0);
    modchart.ease('opponentSwap', 200, 8, 0.5, FlxEase.cubeInOut);
    modchart.ease('opponentSwap', 264, 8, 1, FlxEase.cubeInOut);
    modchart.ease('alpha', 264, 2, 0.9, FlxEase.cubeOut, 0);
    modchart.ease('z', 200, 8, 70, FlxEase.cubeInOut, 1);
    modchart.ease('z', 200, 8, -70, FlxEase.cubeInOut, 0);
    modchart.set('tipsy', 201, 0.5);
    modchart.set('tipsy', 328, 0.4);
    modchart.set('wiggle', 328, 1);

    modchart.ease('alpha', 384, 1, 0, FlxEase.cubeOut);
    modchart.ease('alpha', 392, 1, 1, FlxEase.cubeOut);
    modchart.set('confusionoffset', 364, 0);

    modchart.ease('alpha', 415, 2, 0.2, FlxEase.cubeOut, 0);
    modchart.ease('opponentSwap', 415, 2, 0.5, FlxEase.cubeOut);
    modchart.ease('opponentSwap', 424, 4, 1, FlxEase.cubeOut);
    modchart.ease('alpha', 424, 2, 0.9, FlxEase.cubeOut, 0);

    modchart.ease('y', 500, 10, downscroll ? 300 : -300, FlxEase.cubeInOut);


    new FlxTimer().start(0.01, ()->{
        holds.visible = false;
        for(a in uiStuff) a.alpha = 0;
    });
}

function update(elapsed){
    
    if(curStep < 800)
    {
        switch(iconP2.curCharacter){
            case "icon-wigglytuff": vignette.alpha = lerp(vignette.alpha, 0, 0.05);
            case "icon-wigglytuff1": vignette.alpha = lerp(vignette.alpha, 0.3, 0.05);
            case "icon-wigglytuff2": vignette.alpha = lerp(vignette.alpha, 0.6, 0.05);
            case "icon-wigglytuff3": vignette.alpha = lerp(vignette.alpha, 0.9, 0.05);
        }
    }

    if(curCameraTarget == 1 && curStep < 790) camera.zoom = lerp(camera.zoom, 1.25, 0.05);
    else if(curStep < 540) camera.zoom = lerp(camera.zoom, 1, 0.1);
}

function onDadHit(e){
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

function stepHit(s){
    missingno.iTime = FlxG.random.float(1,10);
    switch(s){
        case 9: FlxTween.tween(dad, {x: 300}, 2, {ease: FlxEase.cubeOut});
    
        case 11: FlxTween.tween(bf, {x: 1048}, 2, {ease: FlxEase.cubeOut});

        case 32: 
            for(a in uiStuff) a.alpha = 1;
            strumLines.members[1].characters[0].setColorTransform();
            strumLines.members[0].characters[0].setColorTransform();
            bl.destroy();
            wh.destroy();
        case 128: missingno.GLITCH_THR = 0.0001;
        case 140: missingno.GLITCH_THR = 0.00001;
        case 272: missingno.GLITCH_THR = 0.0001;
        case 274: missingno.GLITCH_THR = 0.001;
        case 278: missingno.GLITCH_THR = 0.004;
        case 278: missingno.GLITCH_THR = 0.008;
        case 278: missingno.GLITCH_THR = 0.01;
        case 285: missingno.GLITCH_THR = 0.15;
        case 288: missingno.GLITCH_THR = 0.0;

        case 416: missingno.GLITCH_THR = 0.001;

        case 544: 
            bg1.destroy();
            missingno.GLITCH_THR = 0.15;
            missingno.GLITCH_RECT_DIVISION = 20;

        case 697: dad.playAnim("idle1");
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

        case 1309:
            dad.scrollFactor.set(0.59, 0.59);
        
        case 1312: FlxTween.tween(vignette, {alpha: 0.4}, 1);
    }

    
}

cpu.onNoteUpdate.add(function(e){       // Sorry cpu.onNoteUpdate.add(function(e){ the lag wasnt your fault :)
    if(e.note.isSustainNote) e.note.avoid = true;
    e.cancelPositionUpdate();
});


