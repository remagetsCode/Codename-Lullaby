PauseSubState.script = 'data/scripts/pause';
GameOverSubstate.script = "data/scripts/gameover";
import funkin.backend.utils.DiscordUtil;

function create(){
	camera.zoom = defaultCamZoom;
	if(gf != null) gf.alpha = 0;
}

public var uiStuff:FlxTypedGroup;

function postCreate(){
	camera.zoom = defaultCamZoom;
	uiStuff = new FlxTypedGroup();
	uiStuff.add(customHealthBarBG);
	uiStuff.add(customHealthBar);
	uiStuff.add(iconBF);
	uiStuff.add(iconDAD);
	uiStuff.add(accuracyTxt);
	uiStuff.add(missesTxt);
	uiStuff.add(scoreTxt);

	setMarginColor(0x000000, 0.5);
	DiscordUtil.config.clientID = "1433852304745824318";
}

public var smooth;
function update() healthBar.percent = smooth = lerp(smooth, health*50, 0.1);

function onSongEnd(){
	var exists:Bool = FlxG.save.data.unlockedSongs.exists(curSong);
	
	if(!exists && curSong != "shinte"){ 
		FlxG.save.data.unlockedSongs.set(curSong, "unlocking");
		FlxG.save.flush();
	}

	trace(FlxG.save.data.unlockedSongs);
}

public function pattern1(){
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

public function pattern2(){
	for(i in 0...4){
		switch(i){
			case 0, 3: modchart.ease('z'+i, curBeatFloat, 0.1, 35, FlxEase.linear, 1);
			case 1, 2: modchart.ease('z'+i, curBeatFloat, 0.1, -35, FlxEase.linear, 1);
		}
		modchart.ease('z'+i, curBeatFloat, 0.4, 0, FlxEase.linear, 1);
	}
}

public function pattern3(){
	for(i in 0...4){
		switch(i){
			case 1, 2: modchart.ease('z'+i, curBeatFloat, 0.1, 35, FlxEase.linear, 1);
			case 0, 3: modchart.ease('z'+i, curBeatFloat, 0.1, -35, FlxEase.linear, 1);
		}
		modchart.ease('z'+i, curBeatFloat, 0.4, 0, FlxEase.linear, 1);
	}
}