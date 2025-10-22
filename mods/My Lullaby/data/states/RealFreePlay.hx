import funkin.menus.FreeplayState.FreeplaySonglist;
import flixel.math.FlxPoint;

var songList:FreeplaySonglist;//= CoolUtil.coolTextFile(Paths.txt("shop/songsList"));
var curSelected = -1;

var canChange:Bool = false;

var txtfile = CoolUtil.coolTextFile(Paths.txt("shop/songsList"));
public var songs:Array<ChartMetaData> = [];
public var grpSongs:FlxTypedGroup<Alphabet>;
public var locks:FlxTypedGroup<FlxSprite>;
var status:Array = [];

var camera;

var positions:Array<Int> = [-300, 150, 320, 490, 900];
var targetPos:Int;

public var portraitOffset:Map<String, FlxPoint> = [
	'frostbite' => FlxPoint.get(20, 1),
	'safety-lullaby' => FlxPoint.get(85, 26),
	'left-unchecked' => FlxPoint.get(29, 10),
	'lost-cause' => FlxPoint.get(0, -15),
	'monochrome' => FlxPoint.get(1),
	'missingno' => FlxPoint.get(12),
	'brimstone' => FlxPoint.get(0, 115),
	'death-toll' => FlxPoint.get(160, 165),
	'isotope' => FlxPoint.get(12, 1),
	'shitno' => FlxPoint.get(72, 90)
];

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

	for (i => song in songs){
		var songText:Alphabet = new Alphabet(FlxG.width, 110, song.displayName, "bold");
		songText.ID = i;
		grpSongs.add(songText);

		var lock = new FlxSprite();
		lock.frames = Paths.getFrames('UI/base/unlocked');
		lock.animation.addByPrefix('locked', 'lock', 24, true);
		lock.animation.addByPrefix('unlocked', 'unlock', 24, false);
		lock.animation.play('locked');
		lock.ID = i;
		locks.add(lock);

		if(status.exists(song.name) && status.get(song.name) == 'unlocked') lock.visible = false;
	}

	miniBG = new FunkinSprite().loadGraphic(Paths.image('menus/freeplay/blank'));
	miniBG.setGraphicSize(miniBG.width*0.8, miniBG.height*0.8);
	miniBG.updateHitbox();
	miniBG.y = 155;
	miniBG.alpha = 0;
	add(miniBG);
	add(mini);

	FlxTween.tween(bg, {x:0},1.5, {
		ease: FlxEase.quintOut,
		onStart: ()->{
			startEverything();	
			changeItem(1);	
			mini.x += 1000;
			miniBG.x += 1000;
			trace(mini.name);
			FlxTween.tween(mini, {x: status.exists('safety-lullaby') ? 768 : 853}, 1.5, {
				ease: FlxEase.quintOut
			});
			FlxTween.tween(miniBG, {x: 850}, 1.5, {
				ease: FlxEase.quintOut,
				onComplete: ()->{miniBG.alpha = 1;}
			});
	
		},
		onComplete: ()->{canChange = true;}
	});

	var unlockQueue = 0;
	for(k => song in FlxG.save.data.unlockedSongs) if(song == 'unlocking') unlockQueue++;

	if(unlockQueue > 0)
		new FlxTimer().start(2, ()->{
			for(k => song in FlxG.save.data.unlockedSongs) 
				if(song == 'unlocking'){
					unlockAnim(k);

					FlxG.save.data.unlockedSongs.set(k, 'unlocked');
					FlxG.save.flush();
					break;
				}
		}, unlockQueue);
}

function startEverything(){
	for(a in grpSongs){
		FlxTween.tween(a, {x: 120}, 2+(a.ID/4), {
			ease: FlxEase.quintOut
		});
	}

	FlxTween.tween(left, {x:5},1.5, {ease: FlxEase.quintOut});
}

function update(){
	//trace(mini.x, mini.y);
	status = FlxG.save.data.unlockedSongs;
	
	if(canChange){
		var leftP = controls.LEFT_P;
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var scroll = FlxG.mouse.wheel;

		if(leftP) preClose();

		if (upP || downP || scroll != 0)
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

var mini:FunkinSprite = new FunkinSprite();
var twn:FlxTween = new FlxTween();
function changeItem(huh:Int = 0, ?mouse:Bool = false){		
	//if(mini != null) mini.visible = false;

	FlxG.sound.play(Paths.sound("menu/scroll"),0.5);
			
	if(mouse) curSelected = huh;
	else{
		switch(huh){
			case -1: curSelected-1 >= 0 ? curSelected-- : curSelected = grpSongs.length-1;
			case 1: curSelected+1 <= grpSongs.length-1 ? curSelected++ : curSelected = 0;
		}
	}

	if(twn.active) twn.cancel();
	twn = FlxTween.tween(mini, {alpha: 0}, 0.15, {
		ease: FlxEase.cubeIn,
		onComplete: ()->{
			
			if(status.exists(songs[curSelected].name) && status.get(songs[curSelected].name) == 'unlocked' || status.get(songs[curSelected].name) == 'unlocking') {
				mini.name = songs[curSelected].name;
				mini.frames = Paths.getFrames('menus/freeplay/' + songs[curSelected].name);
				mini.animation.addByPrefix('idle', songs[curSelected].name ,24,true);
			}
			else{
				mini.name = '';
				mini.frames = Paths.getFrames('menus/freeplay/unknown');
				mini.animation.addByPrefix('idle', 'unknown' ,24,true);
			}
			var offs = portraitOffset.get(mini.name);
			mini.animation.play('idle');
			mini.setGraphicSize(mini.width*0.8, mini.height*0.8);
			mini.updateHitbox();
			mini.screenCenter();
			mini.x = FlxG.width/1.5;
			if(offs != null) mini.setPosition(mini.x-offs.x, mini.y-offs.y);
			

			twn = FlxTween.tween(mini, {alpha: 1}, 0.3, {ease: FlxEase.cubeIn});
		}
	});


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
	timer = new FlxTimer().start(0.14, ()->{
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
	FlxTween.tween(miniBG, {x: FlxG.width}, 0.5, {
		ease: FlxEase.quintOut
	});

	for(a in grpSongs){
		FlxTween.tween(a, {x: FlxG.width}, 1.5, {
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