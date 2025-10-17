import funkin.menus.FreeplayState.FreeplaySonglist;

var songList:FreeplaySonglist;//= CoolUtil.coolTextFile(Paths.txt("shop/songsList"));
var curSelected = -1;
var mini:FlxSprite;
var canChange:Bool = false;

var txtfile = CoolUtil.coolTextFile(Paths.txt("shop/songsList"));
public var songs:Array<ChartMetaData> = [];
public var grpSongs:FlxTypedGroup<Alphabet>;
public var locks:FlxTypedGroup<FlxSprite>;
var status:Array = [];

var camera;

var positions:Array<Int> = [-300, 150, 320, 490, 900];
var targetPos:Int;

function create(){
	status = FlxG.save.data.unlockedSongs;
	songList = FreeplaySonglist.get();

	// Sorting the song names
	for(s in txtfile){
		for(song in songList.songs){
			if(song.name == s) songs.push(song);
		}
	}

	bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	bg.x = FlxG.width;
	add(bg);

	left = new FlxSprite();
	left.frames = Paths.getFrames('UI/base/assets');
	left.animation.addByPrefix('idle', 'arrow push left',24,true);
	left.animation.addByPrefix('push', 'arrow left',24,true);
	left.animation.play('idle');
	left.screenCenter();
	left.x = FlxG.width;
	left.alpha = 0.5;
	add(left);

	grpSongs = new FlxTypedGroup<Alphabet>();
	add(grpSongs);

	locks = new FlxTypedGroup<FlxSprite>();
	add(locks);

	for (i in 0...songs.length){
		var songText:Alphabet = new Alphabet(FlxG.width, 110, songs[i].displayName, "bold");
		songText.ID = i;
		grpSongs.add(songText);

		var lock = new FlxSprite();
		lock.frames = Paths.getFrames('UI/base/unlocked');
		lock.animation.addByPrefix('locked', 'lock', 24, true);
		lock.animation.addByPrefix('unlocked', 'unlock', 24, false);
		lock.animation.play('locked');
		lock.ID = i;
		locks.add(lock);

		if(status.exists(songs[i].name) && status.get(songs[i].name) == 'unlocked') lock.visible = false;
	}

		
	FlxTween.tween(bg, {x:0},1.5, {
		ease: FlxEase.quintOut,
		onStart: ()->{
			startEverything();	
			changeItem(1);	
			mini.x += 1000;

			FlxTween.tween(mini, {x: FlxG.width/1.6}, 1.5, {
				ease: FlxEase.quintOut
			});
	
		},
		onComplete: ()->{
			canChange = true;
		}
	});
		FlxTween.tween(left, {x:5},1.5, {
		ease: FlxEase.quintOut,
	});

	new FlxTimer().start(2.5, ()->{
		for(k => song in FlxG.save.data.unlockedSongs) 
			if(song == 'unlocking'){
				//trace(k);
				unlockAnim(k);
				
				FlxG.save.data.unlockedSongs.set(k, 'unlocked');
				FlxG.save.flush();
				break;
			}
	}, songs.length);
}

function startEverything(){
	for(a in grpSongs){
		FlxTween.tween(a, {x: 120}, 2+(a.ID/2), {
			ease: FlxEase.quintOut
		});
	}
	
}

function update(){
	
	status = FlxG.save.data.unlockedSongs;
	
	if(canChange){
	var leftP = controls.LEFT_P;
	if(leftP) preClose();

	var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var scroll = FlxG.mouse.wheel;

		if (upP || downP || scroll != 0)  // like this we wont break mods that expect a 0 change event when calling sometimes  - Nex
			changeItem((upP ? -1 : 0) + (downP ? 1 : 0) - scroll);

		if(controls.ACCEPT) selectItem();
		if (controls.BACK) FlxG.switchState(new MainMenuState());

	}
		
	for (a in grpSongs) {
        var s = 0.9 + (a.ID == curSelected ? 0.1 : 0);
        a.scale.x = lerp(a.scale.x, s, 0.2);
        a.scale.y = lerp(a.scale.y, s, 0.2);
        a.updateHitbox();
		a.color = a.ID == curSelected ? 0xFFFFFF : 0x666666;
    }
	for(i in 0...songs.length){
		locks.members[i].x = grpSongs.members[i].x+grpSongs.members[i].width/3;
		locks.members[i].y = grpSongs.members[i].y-30;
	}
}

function changeItem(huh:Int = 0, ?mouse:Bool = false){		
	if(mini != null) mini.visible = false;

	FlxG.sound.play(Paths.sound("menu/scroll"),0.5);
			
	if(mouse) curSelected = huh;
	else{
		switch(huh){
			case -1: curSelected-1 >= 0 ? curSelected-- : curSelected = grpSongs.length-1;
			case 1: curSelected+1 <= grpSongs.length-1 ? curSelected++ : curSelected = 0;
		}
	}

	if(status.exists(songs[curSelected].name) && status.get(songs[curSelected].name) == 'unlocked' || status.get(songs[curSelected].name) == 'unlocking') {
		mini = new FlxSprite();
		mini.frames = Paths.getFrames('menus/freeplay/' + songs[curSelected].name);
		mini.animation.addByPrefix('idle', songs[curSelected].name ,24,true);
		mini.animation.play('idle');
		mini.setGraphicSize(mini.width*0.8, mini.height*0.8);
		mini.screenCenter();
		mini.x = FlxG.width/1.5;
		add(mini);
	}
	else{
		mini = new FlxSprite();
		mini.frames = Paths.getFrames('menus/freeplay/unknown');
		mini.animation.addByPrefix('idle', 'unknown' ,24,true);
		mini.animation.play('idle');
		mini.setGraphicSize(mini.width*0.8, mini.height*0.8);
		mini.screenCenter();
		mini.x = FlxG.width/1.5;
		add(mini);
	}

	for(a in grpSongs){
		if(a.ID - curSelected < -1) targetPos = 0;
		else if(a.ID - curSelected == -1) targetPos = 1;
		else if(a.ID - curSelected == 0) targetPos = 2;
		else if(a.ID - curSelected == 1) targetPos = 3;
		else if(a.ID - curSelected > 1) targetPos = 4;
		FlxTween.tween(a, {y: positions[targetPos]}, 0.15, {
			ease: FlxEase.cubeOut
		});
	}
}

function selectItem(){
	var isUnlocked:Bool;
	if(status.exists(songs[curSelected].name)) isUnlocked = true;
	if(curSelected != null && isUnlocked){
		var selected = curSelected;

		FlxG.sound.play(Paths.sound("confirmMenu"));

		new FlxTimer().start(0.3, ()->{
			FlxG.switchState(PlayState.loadSong(songs[selected].name, 'hard'));
			FlxG.switchState(new PlayState());
		});

	}
	else if (!isUnlocked){
		FlxTween.shake(locks.members[curSelected], 0.1, 0.5, FlxAxes.XY);
		FlxG.sound.play(Paths.sound('errorMenu'));
	}
}

function unlockAnim(?songName:String){
	canChange = false;
	timer = new FlxTimer().start(0.3, ()->{
		if(songs[curSelected].name == songName){
			l = locks.members[curSelected];
			l.animation.play('unlocked');
			l.animation.onFinish.addOnce(function(){
				FlxTween.tween(l, {alpha: 0, }, 1);
				FlxG.sound.play(Paths.sound('errorMenu'));
			});
			canChange = true;
			timer.cancel();
		}
		else changeItem(1);
	}, 0);
}

function preClose(){
	left.animation.play('push');
	canChange = false;

	FlxTween.tween(left, {x: FlxG.width}, 2, {
		ease: FlxEase.quintOut
	});

	FlxTween.tween(mini, {x: FlxG.width}, 0.5, {
		ease: FlxEase.quintOut
	});

	for(a in grpSongs){
		FlxTween.tween(a, {x: FlxG.width}, 1+(a.ID/4), {
			ease: FlxEase.quintOut
		});
	}
	FlxTween.tween(bg, {x:FlxG.width},2, {
		ease: FlxEase.quintOut,
		onComplete: ()->{
			close();
		}
	});

}




