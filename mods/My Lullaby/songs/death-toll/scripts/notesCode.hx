function postCreate(){
	modchart.setPercent('opponentSwap', 1);
	modchart.setPercent('x', 100);
	modchart.setPercent('x', 250,0);
	modchart.setPercent('z', -300,0);
	modchart.setPercent('x0', -85,1);
    modchart.setPercent('x1', -85,1);
    modchart.setPercent('x4', -260,1);
    modchart.setPercent('x2', 135,1);
    modchart.setPercent('x3', 135,1);

    for(i in 328...451){
        modchart.ease('alpha', i, 0.3, i%2 ==0 ? 0.8 : 1, FlxEase.cubeInOut, 1);
    }
    
    playerStrums.members[0].getPressed = () -> { return controls.NOTE_LEFT; }
    playerStrums.members[0].getJustPressed = () -> { return controls.NOTE_LEFT_P; }
    playerStrums.members[0].getJustReleased = () -> { return controls.NOTE_LEFT_R; }

    playerStrums.members[1].getPressed = () -> { return controls.NOTE_DOWN; }
    playerStrums.members[1].getJustPressed = () -> { return controls.NOTE_DOWN_P; }
    playerStrums.members[1].getJustReleased = () -> { return controls.NOTE_DOWN_R; }

    playerStrums.members[2].getPressed = () -> { return controls.NOTE_UP; }
    playerStrums.members[2].getJustPressed = () -> { return controls.NOTE_UP_P; }
    playerStrums.members[2].getJustReleased = () -> { return controls.NOTE_UP_R; }

    playerStrums.members[3].getPressed = () -> { return controls.NOTE_RIGHT; }
    playerStrums.members[3].getJustPressed = () -> { return controls.NOTE_RIGHT_P; }
    playerStrums.members[3].getJustReleased = () -> { return controls.NOTE_RIGHT_R; }

    playerStrums.members[4].getPressed = () -> { return controls.getPressed("mechanic"); }
    playerStrums.members[4].getJustPressed = () -> { return controls.getJustPressed("mechanic"); }
    playerStrums.members[4].getJustReleased = () -> { return controls.getJustReleased("mechanic"); }

    modchart.ease('z', 313, 2, -100, FlxEase.backIn, 0);
    if(!FlxG.save.data.lullabyMechanics){
        modchart.setPercent('vibrate', 0.5, 1);
        modchart.ease('vibrate', 5, 5, 0, FlxEase.smoothStep, 1);
        modchart.ease('y4', 5, 2, downscroll ? 300 : -300, FlxEase.backIn, 1);
        modchart.ease('x0', 5, 3, 0, FlxEase.backInOut, 1);
        modchart.ease('x1', 5, 3, 0, FlxEase.backInOut, 1);
        modchart.ease('x2', 5, 3, 0, FlxEase.backInOut, 1);
        modchart.ease('x3', 5, 3, 0, FlxEase.backInOut, 1);
    }
}


function onStrumCreation(e){
    if(e.strumID == 4){
        e.cancel();
        var strum = e.strum;
		strum.frames = Paths.getFrames("UI/base/hellbell/Bronzong_Gong_mechanic");
		strum.animation.addByPrefix("static", "spacebar0", 24, false);
		strum.animation.addByPrefix("pressed", "spacebar press", 24, false);
		strum.animation.addByPrefix("confirm", "spacebar confirm", 24, false);
		strum.scale.set(0.6, 0.6);
        strum.antialiasing = true;
		strum.updateHitbox();
    }
}

function onNoteCreation(event) {
	if ((event.strumID != 4)) return;
	event.cancel();

	var note = event.note;
	var strumID = event.strumID;
	if (event.note.isSustainNote) {
		note.frames = Paths.getFrames('UI/base/hellbell/Bronzong_Gong_mechanic');
		note.animation.addByPrefix("hold", "spacebar hold piece");
		note.animation.addByPrefix("holdend", "spacebar hold end");
	} else {
		note.frames = Paths.getFrames('UI/base/hellbell/Bronzong_Gong_mechanic');
		note.animation.addByPrefix("scroll", "spacebar0");
	}
	var strumScale = event.note.strumLine.strumScale;
	note.scale.set(0.6, 0.6);
	note.updateHitbox();
	note.antialiasing = true;

    if(!FlxG.save.data.lullabyMechanics) note.kill();
}

function onPlayerHit(e){
    if(e.note.strumID == 4) {
		e.showSplash = false;	
		e.healthGain = 0;
	}
}

function onNoteHit(e){
    //trace(e.character);
    if(e.character == bell && !FlxG.save.data.lullabyMechanics) modchart.setPercent('vibrate', 0.4, 1);
    if(e.character == bell && !e.note.isSustainNote) {
        heat1.intensity = 0.3;
        FlxTween.num(0.3, 0.02, 0.3, null, (v) -> heat1.intensity = v);
        
    }
    
}