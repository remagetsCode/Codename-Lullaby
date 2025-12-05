import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxBitmapText;
import StringTools;

var fakeCamHUD:HudCamera = new HudCamera();
public var pixelNotesForBF = true;
public var pixelNotesForDad = true;
public var pixelSplashes = true;
public var enablePixelUI = true;
public var daPixelZoom = PlayState.daPixelZoom;
introLength = 0;

function postCreate(){
    FlxG.camera.followLerp = 0;
	FlxG.cameras.add(fakeCamHUD, false);
	fakeCamHUD.bgColor = 0x00000000; // for ratings & sustains

	blackScreen = new FlxSprite(0, 0).makeGraphic(800, 720, FlxColor.BLACK);
	blackScreen.cameras = [fakeCamHUD];
	insert(-1, blackScreen);

    FlxG.scaleMode.width = 800;
	FlxG.camera.width = 800;
	camHUD.width = 800;
    iconP1.visible = iconP2.visible = healthBarBG.visible = scoreTxt.visible =  missesTxt.visible = accuracyTxt.visible = false;
    healthBar.x = 139.5;


		bigBar = new FlxSprite(5, !downscroll ? 5 : 570).loadGraphic(Paths.image('huds/PKMN/bigbar'));
		bigBar.setGraphicSize(Std.int(bigBar.width * 5));
		bigBar.updateHitbox();
		bigBar.antialiasing = false;
		add(bigBar);

		smallBar = new FlxSprite(20, !downscroll ? 625 : 5).loadGraphic(Paths.image('huds/pkmn/smallbar'));
		smallBar.setGraphicSize(Std.int(smallBar.width * 5));
		smallBar.updateHitbox();
		smallBar.antialiasing = false;
		insert(10, smallBar);

    	healthBar2 = new FlxSprite(120, !downscroll ? 660 : 40).loadGraphic(Paths.image('huds/pkmn/healthbar'));
		healthBar2.setGraphicSize(Std.int(healthBar2.width * 5));
		healthBar2.updateHitbox();
		healthBar2.antialiasing = false;
		add(healthBar2);

       healthBar.scale.x = 1.05;
       healthBar.y = 45;
       if (!downscroll){
     healthBar.y = 665;
       }
       healthBar.flipX = true;
	   healthBar.cameras = [camGame];


       //nums//
           add(newScore = new FunkinText(130, !downscroll ? 35 : 600, FlxG.width, "0"));
           newScore.setFormat(Paths.font('PKMN RBYGSC.ttf'), 30, FlxColor.BLACK, 'left');

           add(newMSS = new FunkinText(130, !downscroll ? 80 : 645, FlxG.width, "0"));
           newMSS.setFormat(Paths.font('PKMN RBYGSC.ttf'), 30, FlxColor.BLACK, 'left');


}


function postUpdate(){
    newScore.text = StringTools.lpad(Std.string(songScore), "0", 6);
    newMSS.text   = StringTools.lpad(Std.string(misses),    "0", 3);
}

/////PKMN NOTES/////


function onNoteCreation(event) {
	if ((event.note.strumLine == playerStrums && !pixelNotesForBF) || (event.note.strumLine == cpuStrums && !pixelNotesForDad)) return;
	event.cancel();

	var note = event.note;
	var strumID = event.strumID;
	if (event.note.isSustainNote) {
		note.loadGraphic(Paths.image('game/notes/PKMN_assetsENDS'), true, 7, 6);
		var maxCol = Math.floor(note.graphic.width / 7);
		note.animation.add("hold", [strumID%maxCol]);
		note.animation.add("holdend", [maxCol + strumID%maxCol]);
	} else {
		note.loadGraphic(Paths.image('game/notes/PKMN_assets'), true, 17, 17);
		var maxCol = Math.floor(note.graphic.width / 17);
		note.animation.add("scroll", [maxCol + strumID%maxCol]);
	}
	var strumScale = event.note.strumLine.strumScale;
	note.scale.set(daPixelZoom*strumScale, daPixelZoom*strumScale);
	note.updateHitbox();
	note.antialiasing = false;
}


function onStrumCreation(event) {
	if ((event.player == 1 && !pixelNotesForBF) || (event.player == 0 && !pixelNotesForDad)) return;
	event.cancel();

	var strum = event.strum;
	strum.loadGraphic(Paths.image('game/notes/PKMN_assets'), true, 17, 17);
	var maxCol = Math.floor(strum.graphic.width / 17);
	var strumID = event.strumID % maxCol;

	strum.animation.add("static", [strumID]);
	strum.animation.add("pressed", [maxCol + strumID, (maxCol*2) + strumID], 12, false);
	strum.animation.add("confirm", [(maxCol*3) + strumID, (maxCol*4) + strumID], 24, false);

	var strumScale = strumLines.members[event.player].strumScale;
	strum.scale.set(daPixelZoom*strumScale, daPixelZoom*strumScale);
	strum.updateHitbox();
	strum.antialiasing = false;
}

function onPlayerHit(e) e.showSplash = false;
