PauseSubState.script = 'data/scripts/pause';
GameOverSubstate.script = "data/scripts/gameover";

function create(){
	if(gf != null) gf.alpha = 0;
}

public var uiStuff:FlxTypedGroup;

function postCreate(){
	camera.zoom = defaultCamZoom;
	uiStuff = new FlxTypedGroup();
	uiStuff.add(healthBarBG);
	uiStuff.add(healthBar);
	uiStuff.add(iconP1);
	uiStuff.add(iconP2);
	uiStuff.add(accuracyTxt);
	uiStuff.add(missesTxt);
	uiStuff.add(scoreTxt);
}

function onSongEnd(){
	var exists:Bool = FlxG.save.data.unlockedSongs.exists(curSong);
	
	if(!exists){ 
		FlxG.save.data.unlockedSongs.set(curSong, "unlocking");
		FlxG.save.flush();
	}

	trace(FlxG.save.data.unlockedSongs);
}

function pattern1(){
	for(i in 0...4){
		var arrPosX = modchart.getPercent('x'+i, 1);
		var arrPosY = modchart.getPercent('y'+i, 1);
		modchart.ease('x'+i, curBeatFloat, 0.1, FlxG.random.int(arrPosX-15,arrPosX+15), FlxEase.linear, 1);
		modchart.ease('y'+i, curBeatFloat, 0.1, FlxG.random.int(arrPosY-15,arrPosY+15), FlxEase.linear, 1);
		//modchart.ease('y'+i, curBeatFloat, 0, FlxG.random.int(-20,20), FlxEase.linear);
		modchart.ease('x'+i, curBeatFloat, 0.3, arrPosY, FlxEase.linear, 1);
		modchart.ease('y'+i, curBeatFloat, 0.3, arrPosY, FlxEase.linear, 1);
	}
}

function pattern2(){
	for(i in 0...4){
		switch(i){
			case 0, 3: modchart.ease('z'+i, curBeatFloat, 0.1, 35, FlxEase.linear, 1);
			case 1, 2: modchart.ease('z'+i, curBeatFloat, 0.1, -35, FlxEase.linear, 1);
		}
		modchart.ease('z'+i, curBeatFloat, 0.4, 0, FlxEase.linear, 1);
	}
}

function pattern3(){
	for(i in 0...4){
		switch(i){
			case 1, 2: modchart.ease('z'+i, curBeatFloat, 0.1, 35, FlxEase.linear, 1);
			case 0, 3: modchart.ease('z'+i, curBeatFloat, 0.1, -35, FlxEase.linear, 1);
		}
		modchart.ease('z'+i, curBeatFloat, 0.4, 0, FlxEase.linear, 1);
	}
}