function create(){
    placebf = stage.getSprite("place-bf");
    placedad = stage.getSprite("place-dad");
}

function onDadHit(e){
    e.preventDeletion();
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
}

function stepHit(s){
    switch(s){
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

        case 1309:
            dad.scrollFactor.set(0.59, 0.59);
    }

    
}

cpu.onNoteUpdate.add(function(e){
    if(e.note.isSustainNote) e.note.avoid = true;
    e.cancelPositionUpdate();
});


