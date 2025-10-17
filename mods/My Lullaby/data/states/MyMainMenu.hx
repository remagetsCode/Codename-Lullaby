import flixel.tile.FlxTilemap;
import flixel.util.FlxDirectionFlags;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;

import flixel.addons.util.FlxSimplex;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;

var player:FlxSprite;
var speed:Int;

var curMusic = FlxG.sound.music;

FlxG.game.setFilters([]);

var curDisplayHeight = window.display.bounds.height;
var curDisplayWidth = window.display.bounds.width;
var curDisplayX = window.display.bounds.x;
var curDisplayY = window.display.bounds.y;


var windowTitle = "Friday Night Funkin' Lullaby - Main Menu";
window.borderless = false;

//https://www.youtube.com/watch?v=08OMWjoCEXY&list=PLkTxsDc9_MX6p6tkjuzQVb2RfCav8Hfrg&index=64
//!------- Playstate code -----------
function create(){
	Main.scaleMode.width = 1280;
    Main.scaleMode.height = 960;

	FlxG.width = 1280; 
	FlxG.height = 960;
    
    for (c in FlxG.cameras.list) {
        c.width = 1280;
        c.height = 960;
    }

	camera.zoom = 5;
	camera.minScrollY = 35;
	camera.maxScrollY = 320;
	camera.minScrollX = 16;
	camera.maxScrollX = 400;

	loadMap();

	player = new Player();
	add(player);

}

function postCreate(){
	if(curMusic != null){
		FlxTween.tween(curMusic, {volume: 0}, 1, {
		onComplete: ()->{
			FlxG.sound.playMusic(Paths.music('CinnabarOverworld'),0);
			curMusic = FlxG.sound.music;
			FlxTween.tween(curMusic, {volume:0.6},1);
		}
	});
	}
	else{
		FlxG.sound.playMusic(Paths.music('CinnabarOverworld'), 0.6, true);
		curMusic = FlxG.sound.music;
	}

	if(!window.fullscreen){
		window.maximized = false;
		alo = FlxTween.num(window.width, 4*curDisplayHeight/3.5, 1.2, { 
			ease: FlxEase.quadInOut,
			onUpdate: function(num){
				window.x = lerp(window.x, curDisplayX + curDisplayWidth/5, 0.04);
				window.width = num.value;
			}
		});
		
		alo = FlxTween.num(window.height, 3*curDisplayHeight/3.5, 1.2, { 
			ease: FlxEase.quadInOut,
			onUpdate: function(num){
				window.y = lerp(window.y, curDisplayY + curDisplayHeight/16, 0.04);
				window.height = num.value;
			}
		});
	}

	window.title = windowTitle;

	extraObjects = new FlxTypedGroup<FlxSprite>();
	for(i => obj in extraLayer.objects){
		if(obj.name == "playerSpawn") player.setPosition(obj.x, obj.y);
		else{
			objSpr = new FlxSprite(obj.x, obj.y).makeGraphic(obj.width, obj.height, FlxColor.WHITE);
			objSpr.ID = i;
			//trace(obj.name + "'s ID: " + objSpr.ID);
			objSpr.visible = false;
			objSpr.immovable = true;
			extraObjects.add(objSpr);
		}
	}
	add(extraObjects);


	
}

function update(){
	player.updateMovement();
	FlxG.camera.follow(player);

	FlxG.collide(player, walls);

	if (controls.BACK) FlxG.switchState(new TitleState());
	//if (controls.SWITCHMOD) openSubState(new ModSwitchMenu());

	if((inDialog && isTyping) && controls.ACCEPT) skipDialog();
	else if((inDialog && !isTyping) && controls.ACCEPT) finishDialog();

	//! DEV ACCESS
	if (controls.DEV_ACCESS) {
		FlxG.game.setFilters([]);
		persistentUpdate = false;
		persistentDraw = true;
		openSubState(new EditorPicker());
	}

	/*
	IDs:
		next = 1
		shop = 2
		options = 3
		credits = 4
		error = 5
		missingno = 6
	*/
	FlxG.overlap(player, extraObjects, (c1, c2)->{
		switch(c2.ID){
			case 1: nextRoom();
			case 2: FlxG.switchState(new FreeplayState());
			case 3: FlxG.switchState(new OptionsMenu());
			case 4: FlxG.switchState(new CreditsMain());
			case 5: FlxG.sound.play(Paths.sound('errorMenu')); 
			case 6: missingnoSong();
			case 7: if(controls.ACCEPT && !inDialog) startDialog("North: Story \n\nSouth: Menu houses\n\nEast: ???");
			case 8: if(controls.ACCEPT && !inDialog) startDialog("Why is this sign even here? ");
			case 9: if(controls.ACCEPT && !inDialog) startDialog("Left house: Credits Menu \n\nMiddle house: Options Menu \n\nRight house: Shop");
		}
	});
}

function destroy(){
	var curDisplayHeight = window.display.bounds.height;
	var curDisplayWidth = window.display.bounds.width;	
	//trace('y ya');
	Main.scaleMode.width = 1280;
    Main.scaleMode.height = 720;

	FlxG.width = 1280; 
	FlxG.height = 720;
    
    for (c in FlxG.cameras.list) {
        c.width = 1280;
        c.height = 720;
    }
		if(!window.fullscreen && !window.maximized){
		window.x = window.x + (window.width - 16*curDisplayHeight/11)*0.5;
		window.width = 16*curDisplayHeight/11;

		window.y = window.y + (window.height - 9*curDisplayHeight/11)*0.5;
		window.height = 9*curDisplayHeight/11;
	}
}



//! ------- Map code ---------
var map;

var tilemap = new TiledMap(Paths.file('data/town.tmx'));
var imgLayer:TiledTileLayer = cast tilemap.getLayer("img");
var objLayer:TiledObjectLayer = cast tilemap.getLayer("obj");
var extraLayer:TiledObjectLayer = cast tilemap.getLayer("extra");
var walls:FlxTypedGroup<FlxSprite>;

var extraObjects:FlxTypedGroup<FlxSprite>;

function loadMap(){
	walls = new FlxTypedGroup<FlxSprite>();

	var bg = new FlxSprite(imgLayer.x, imgLayer.y, "images/" + imgLayer.imagePath);
    add(bg);

	for(obj in objLayer.objects){
		
		objSprite = new FlxSprite(obj.x, obj.y).makeGraphic(obj.width, obj.height, FlxColor.WHITE);
		objSprite.visible = false;
		objSprite.immovable = true;
		walls.add(objSprite);
	}

	add(walls);

}

function nextRoom(){
	FlxG.switchState(PlayState.loadWeek({
		name: 'Lullaby',
		id: '1',
		songs: [{name: 'safety-lullaby'}, {name: 'left-unchecked'}, {name: 'lost-cause'}],
		difficulties: ['hard']
	}, 'hard'));

	FlxG.switchState(new PlayState());
} 

function missingnoSong(){
	curMusic.volume = 0;
	FlxG.sound.play(Paths.sound('StartupBroke'), 0.5);
	new FlxTimer().start(5, ()->{
		FlxG.switchState(PlayState.loadSong('missingno', 'hard'));
		FlxG.switchState(new PlayState()); 
	});
	for(obj in extraObjects){
		if(obj.ID == 6) obj.destroy();
	}
	player.canMove = false;

}





//! Dialog code
var textBox:FlxSprite;
var dialogText:FunkinText;         // El cuadro de texto
var fullText:String;
var currentIndex:Int = 0;
var typeTimer:FlxTimer;         // Timer para mostrar letra por letra
var isTyping:Bool = true;
var inDialog:Bool = false;

function startDialog(text){
	
	player.canMove = false;
	inDialog = true;
	isTyping = true;
	fullText = text;

	textBox = new FlxSprite().loadGraphic(Paths.image('UI/pixel/textBox'));
	textBox.setGraphicSize(textBox.width*0.35, textBox.height*0.4);
	textBox.updateHitbox();
	textBox.screenCenter();
	textBox.y += 46;
	textBox.scrollFactor.set(0);
	add(textBox);

    dialogText = new FunkinText(510, 380, 260, "");
	dialogText.setFormat(Paths.font("pokefont.ttf"), 8, 0x333333);
	dialogText.updateHitbox();
	dialogText.scrollFactor.set(0);
    add(dialogText);

    // Iniciar el efecto de "typewriter"
	if(typeTimer == null){
    	typeTimer = new FlxTimer();
    	typeTimer.start(0.05, showNextLetter, fullText.length);
	}
}

function showNextLetter(timer:FlxTimer){
    dialogText.text += fullText.charAt(currentIndex);
    currentIndex++;
	dialogText.setPosition(textBox.x+6, textBox.y+8);

    // Si terminó el texto
    if (currentIndex >= fullText.length){
        isTyping = false;
    }
}

function skipDialog(){
	typeTimer.cancel();
	dialogText.text = fullText;
	isTyping = false;
}

function finishDialog(){
	FlxG.sound.play(Paths.sound('HoverSFX'));

	textBox.destroy();
	dialogText.destroy();
	typeTimer.cancel();
	typeTimer = null;

	player.canMove = true;
	currentIndex = 0;

	new FlxTimer().start(0.1, ()->{inDialog = false;});
}







//! ----- Player code ------
class Player extends FlxSprite
{
	public inline var SPEED:Float = 100;
	public var facing;
	public var isMoving:Bool;
	public var canMove:Bool = true;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		
		loadGraphic(Paths.image('characters/bf/bf'), true, 16, 16);
		drag.x = drag.y = 5000;
		

		//setSize(8, 8);
		offset.set(0, 4);

		animation.add("d_idle", [1]);
		animation.add("l_idle", [7]);
		animation.add("r_idle", [9]);
		animation.add("u_idle", [4]);
		animation.add("d_walk", [1, 0, 1, 2], 6);
		animation.add("l_walk", [7, 6], 6);
		animation.add("r_walk", [8, 9], 6);
		animation.add("u_walk", [4, 3, 4, 5], 6);
	}

	public function updateMovement(){
		speed = SPEED;
		
		var up:Bool = FlxG.keys.pressed.W;
		var down:Bool = FlxG.keys.pressed.S;
		var left:Bool = FlxG.keys.pressed.A;
		var right:Bool = FlxG.keys.pressed.D;

		if (FlxG.keys.pressed.SHIFT) speed += 50;
		if (up || down || left || right) {

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if(canMove && (up || down || left || right)){
			var newAngle:Float = 0;
			if (up){
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
				facing = 'up';
			}
			else if (down){
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
				facing = 'down';
			}
			else if (left){
				newAngle = 180;
				facing = 'left';
			}

			else if (right){
				newAngle = 0;
				facing = 'right';
			}
			
			velocity.setPolarDegrees(speed, newAngle);
		}

	}

		// ------- Sprite animation ---------
	var action = "idle";
	// check if the player is moving, and not walking into walls
	if ((velocity.x != 0 || velocity.y != 0))
	{
		action = "walk";
	}
	switch (facing)
	{
		case 'left':
			animation.play('l_' + action);
		case 'right':
			animation.play("r_" + action);
		case 'up':
			animation.play("u_" + action);
		case 'down':
			animation.play("d_" + action);
		case null:
	}

	isMoving = velocity.x == 0 && velocity.x == 0 ? false : true;
}
}

