import funkin.game.Splash;

final colors:Array<String> = ["Purple", "Blue", "Green", "Red"];
var generated:Bool = false;
var disableHoldCovers:Bool = false;

public var holds:FlxTypedGroup<HoldCover> = new FlxTypedGroup<HoldCover>();

function postCreate(){
	camera.zoom = defaultCamZoom;

	if(disableHoldCovers) disableScript();
	for(c in colors) graphicCache.cache(Paths.image('holdCover'+c));

	PlayState.instance.splashHandler.grpMap.set('holdCover', holds);
	preGenerateHoldCovers();
	generated = true;
}

function preGenerateHoldCovers() {
	for(i in 0...8) {
		var s = new Splash();
		setHoldCoverStyle(s, 'default', 'Red'); // Adds a default sprite to the hold cover, so funkin modchart doesnt crash.
		s.camera = camHUD;
		s.kill();
		holds.add(s);
	}
	insert(999, holds);
}

function onNoteHit(event){	
	if(event.direction > 3) return;
	if(!event.note.isSustainNote) return; 
	if(event.note.noteType == 'burp') return;

	var d = event.direction;
	var strumLineID:Int = strumLines.members.indexOf(event.note.strumLine);
	var strum = event.note.strumLine.members[event.note.strumID];
	var strumID = event.note.strumID;
	var color = colors[event.direction];
	var milk;
	
	holds.forEach((hold) -> if(hold.strum == strum) milk = hold);
	milk ??= holds.getFirstDead();

	if(milk == null) return;

	milk.strumID = strumID;
	milk.strum = strum;
	milk.visible = true;

	if(!milk.alive || milk.animation.name == 'end') {
		milk.revive();
		setHoldCoverStyle(milk, event.note.noteType, color);
		milk.animation.play('start');
	}

	if(event.note.nextSustain == null && milk.visible) {
		if(!event.player) milk.kill();
		milk.animation.play('end');
	}

	holds.forEachAlive((hold) -> {
		if(hold.strum != null) {
			hold.x = hold.strum.x - hold.width/3;
			hold.y = hold.strum.y - (!Options.downscroll ? hold.height/4 : hold.height/2);
			hold.camera = hold.strum.strumLine.camera;
		}});
	
}

var healthBarValue:Float = 1;
public var smoothness:Float = 0.1;
function update() {
	healthBar.percent = healthBarValue = CoolUtil.fpsLerp(healthBarValue, health*50, smoothness);

	holds.forEachAlive((hold) -> if(hold.strum.animation.name == 'static' && hold.animation.name == 'hold') hold.kill());
}

function postUpdate()
	for(i in 0...4)
		if(Conductor.songPosition - player.members[i].lastHit > 210 && player.members[i].getAnim() == 'confirm')
			player.members[i].playAnim('pressed', true);

function setHoldCoverStyle(milk:HoldCover, style:String, ?color:String) {
	var isDownscroll:Bool = milk.strum?.strumLine?.camera?.downscroll;
	if(curSong == 'brimstone' || curSong == 'mauve-macabre' || curSong == 'shinto' || curSong == 'shitno') {
		style = 'pixel';
	}
	switch(style) {
		case 'Static', 'StaticAlt':
			milk.frames = Paths.getSparrowAtlas('game/splashes/holds/holdCoverStatic');
			milk.animation.addByPrefix('start', 'holdCoverStartRed', 20, false);
			milk.animation.addByPrefix('hold', 'holdCoverRed', 20, true);
			milk.animation.addByPrefix('end', 'holdCoverEndRed', 22, false);
			milk.scale.set(1, 1);
			milk.offset.x = 5;
			milk.offset.y = 0;
			milk.antialiasing = Options.antialiasing;
	
		case 'burp':
	
		case 'pixel':
			milk.frames = Paths.getSparrowAtlas('pixelNoteHoldCover');
			milk.animation.addByPrefix('start', 'loop0000', 24, false);
			milk.animation.addByPrefix('hold', 'loop', 24, true);
			milk.animation.addByPrefix('end', 'explode', 24, false);
			milk.scale.set(7, 7);
			//milk.updateHitbox();
			milk.offset.x = -215;
			milk.offset.y = isDownscroll ? 35 : -35;
			milk.antialiasing = false;
	
		default:
			milk.frames = Paths.getSparrowAtlas('holdCover'+color);
			milk.animation.addByPrefix('start', 'holdCoverStart'+color, 20, false);
			milk.animation.addByPrefix('hold', 'holdCover'+color, 20, true);
			milk.animation.addByPrefix('end', 'holdCoverEnd'+color, 24, false);
			milk.scale.set(1.05, 1.05);
			milk.offset.x = 8;
			milk.offset.y = 0;
			milk.antialiasing = Options.antialiasing;
	}

	milk.animation.onFinish.add((e) -> {
		switch(e){
			case 'start': milk.animation.play('hold');
			case 'end': milk.kill();
		}
	});
}