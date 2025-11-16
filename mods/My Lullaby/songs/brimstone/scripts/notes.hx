//
import funkin.game.HudCamera;
import funkin.backend.scripting.events.NoteHitEvent;

public var pixelNotesForBF = true;
public var pixelNotesForDad = true;
public var pixelSplashes = true;
public var enablePixelUI = true;
public var enablePixelGameOver = true;
public var enableCameraHacks = Options.week6PixelPerfect;
public var enablePauseMenu = true;
public var isSpooky = false;

var oldStageQuality = FlxG.game.stage.quality;
public var daPixelZoom = PlayState.daPixelZoom;

/**
 * UI
 */
function onNoteCreation(event) {
    if(event.note.noteType == "missingno-bf") event.note.shader = missingno;
	if ((event.note.strumLine == playerStrums && !pixelNotesForBF) || (event.note.strumLine == cpuStrums && !pixelNotesForDad)) return;
	event.cancel();

	var note = event.note;
	var strumID = event.strumID;
	if (event.note.isSustainNote) {
		note.loadGraphic(Paths.image('UI/pixel/HOLDS_buried'), true, 12, 10);
		var maxCol = Math.floor(note.graphic.width / 12);
		note.animation.add("hold", [strumID%maxCol]);
		note.animation.add("holdend", [maxCol + strumID%maxCol]);
	} else {
		note.loadGraphic(Paths.image('UI/pixel/NOTES_buried'), true, 32, 32);
		var maxCol = Math.floor(note.graphic.width / 32);
		note.animation.add("scroll", [maxCol + strumID%maxCol]);
	}
	var strumScale = event.note.strumLine.strumScale;
	note.scale.set(3.5, 3.5);
	note.updateHitbox();
	note.antialiasing = false;

	if((note.noteType == "geng note" || note.noteType == "gengar") && !event.note.isSustainNote){
		note.loadGraphic(Paths.image('UI/pixel/genga'), true, 32, 32);
		var maxCol = Math.floor(note.graphic.width / 17);
		note.animation.add("scroll", [0 + strumID%maxCol]);
		if(!FlxG.save.data.lullabyMechanics && note.noteType == "geng note") note.kill();
		
	}	
}

function onPostNoteCreation(event) if (pixelSplashes)
	event.note.splash = "pixel-default";

function onStrumCreation(event) {
	if ((event.player == 1 && !pixelNotesForBF) || (event.player == 0 && !pixelNotesForDad)) return;
	event.cancel();

	var strum = event.strum;
	strum.loadGraphic(Paths.image('UI/pixel/NOTES_buried'), true, 32, 32);
	var maxCol = Math.floor(strum.graphic.width / 32);
	var strumID = event.strumID % maxCol;

	strum.animation.add("static", [strumID]);
	strum.animation.add("pressed", [maxCol + strumID, (maxCol*2) + strumID], 12, false);
	strum.animation.add("confirm", [(maxCol*3) + strumID, (maxCol*4) + strumID], 24, false);

	var strumScale = strumLines.members[event.player].strumScale;
	strum.scale.set(3.5, 3.5);
	strum.updateHitbox();
	strum.antialiasing = false;
}

function onPlayerHit(event:NoteHitEvent) {
	if (!enablePixelUI) return;
	event.ratingPrefix = "stages/school/ui/";
	event.ratingScale = daPixelZoom * 0.7;
	event.ratingAntialiasing = false;

	event.numScale = daPixelZoom;
	event.numAntialiasing = false;
}

/**
 * CAMERA HACKS!!
 */

/*function onStartCountdown() {
	var newNoteCamera = new HudCamera();
	newNoteCamera.bgColor = 0; // transparent
	FlxG.cameras.add(newNoteCamera, false);

	var pixelSwagWidth = Note.swagWidth + (daPixelZoom - (Note.swagWidth % daPixelZoom));

	for(p in strumLines) {
		var i = 0;
		for(str in p.members) {
			str.x = (FlxG.width * strumOffset) + (pixelSwagWidth * (i - 2));
			str.x -= str.x % daPixelZoom;
			i++;
		}
	}
	makeCameraPixely(newNoteCamera);
}*/



function destroy() {
	// resets the stage quality
	FlxG.game.stage.quality = oldStageQuality;
}

function pixelCam(cam)
	makeCameraPixely(cam);

var pixellyCameras = [];
var pixellyShaders = [];

function postUpdate() {
	//for (e in pixellyCameras) if (Std.isOfType(e, HudCamera))
	//	e.downscroll = camHUD.downscroll;
//
	//if (enableCameraHacks) for (p in strumLines) {
	//	p.notes.forEach(function(n) {
	//		if(n.isSustainNote) return; // hacky fix for hold
	//		n.y -= n.y % daPixelZoom;
	//		n.x -= n.x % daPixelZoom;
	//	});
	//}
//
	//var zoom = 1 / daPixelZoom / Math.min(FlxG.scaleMode.scale.x, FlxG.scaleMode.scale.y);
	//for (e in pixellyCameras) {
	//	if (!e.exists) continue;
	//	e.zoom = zoom;
	//}
	//for (e in pixellyShaders)
	//	e.pixelZoom = zoom;
}
