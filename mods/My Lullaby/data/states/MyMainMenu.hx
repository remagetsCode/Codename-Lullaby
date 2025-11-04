import funkin.menus.MainMenuState;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.editors.EditorPicker;

import funkin.backend.system.Controls;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import funkin.backend.system.Control;
import funkin.options.PlayerSettings;
import flixel.addons.display.FlxBackdrop;

import funkin.backend.utils.DiscordUtil;

var curMusic = FlxG.sound.music;
FlxG.game.setFilters([]);

var windowTitle = "Friday Night Funkin' Lullaby - Main Menu";

var player:FlxSprite;
public var walls:FlxGroup;
var tileSize = 16;

function create(){
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
		
	
	Main.scaleMode.width = 1280;
    Main.scaleMode.height = 960;

	FlxG.width = 1280; 
	FlxG.height = 960;
    
    for(c in FlxG.cameras.list){
        c.width = 1280;
        c.height = 960;
    }	

	window.title = windowTitle;		
	var ocean = new FlxBackdrop(Paths.image("overworld/ocean"));
	add(ocean);

	FlxTween.tween(ocean, {x: ocean.x+10}, 2, {ease: FlxEase.sineInOut, type: 4});

	var bg = new FlxSprite(0, 0, "images/overworld/cinnabar.png");
	bg.scale.set(1, 1);
	bg.immovable = true;
	bg.updateHitbox();
	bg.solid = false;
    add(bg);
	
	trace(playerSpawnPos);
	player = new Player(playerSpawnPos[0], playerSpawnPos[1]);
	add(player);
		
	walls = new FlxGroup();
	add(walls);
	mapLayout();
	
	camera.follow(player,FlxCamera.STYLE_LOCKON);
	camera.zoom = 5;
	camera.minScrollY = 35;camera.maxScrollY = 320;
	camera.minScrollX = 16;camera.maxScrollX = 400;
}

function update(){
	//trace(controls.UP);
	if(controls.SWITCHMOD){
		persistentDraw = !(persistentUpdate = false);
		openSubState(new ModSwitchMenu());
	}
	if(controls.BACK)FlxG.switchState(new TitleState());
	if(inDialog && controls.ACCEPT){
		if(isTyping)skipDialog(); else finishDialog();	
	}
	if(controls.DEV_ACCESS){
		FlxG.game.setFilters([]);
		persistentUpdate = false;
		persistentDraw = true;
		openSubState(new EditorPicker());
	}	
}

function destroy(){
	Main.scaleMode.width = 1280;
    Main.scaleMode.height = 720;

	FlxG.width = 1280; 
	FlxG.height = 720;
    
    for(c in FlxG.cameras.list){
        c.width = 1280;
        c.height = 720;
    }
}

//Dialog
var textBox:FlxSprite;
var dialogText:FunkinText;         // El cuadro de texto
var fullText:String;
var currentIndex:Int = 0;
var typeTimer:FlxTimer;         // Timer para mostrar letra por letra
var isTyping:Bool = true;
var inDialog:Bool = false;

function startDialog(text){	
	player.canMove = false;
	player.startingTrigger = true;
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
    if(currentIndex >= fullText.length)isTyping = false;
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

	new FlxTimer().start(0.1, ()->{inDialog = false;player.startingTrigger = false;});
}

//Walls
function mapLayout(){
	createWall(3,4,1,13); //Left Wall
	createWall(4,16,1,1); //Bottom Left Wall
	createWall(5,16,1,2);
	createWall(5,18,15,1); //Bottom Wall
	createWall(20,13,1,6);
	createWall(20,6,1,6);
	
	createWall(9,2,1,2); // Left Bridge
	createWall(12,2,2,2); // Right Bridge
	
	createWall(10,2,2,2,1); // Bridge Trigger
	createWall(20,12,1,1,2); // Missingno Trigger
	
	createWall(4,4,6,4); //Top left Building
	createWall(14,4,6,4); //Top Right Building
	
	createWall(6,13,1,1,3); //Credits Building Trigger
	createWall(4,10,6,4); //Credits Building
	
	createWall(11,15,1,1,4); //Options Building Trigger
	createWall(10,12,4,4); //Options Building
	
	createWall(15,15,1,1,5); //Freeplay Building Trigger
	createWall(14,12,4,4); //Freeplay Building
	
	createWall(13,7,1,1,6); //North Sign
	createWall(9,9,1,1,7); //Useless Sign
	createWall(9,15,1,1,8); //Menu Sign
}

class Wall extends FlxSprite
{
	var type = 0;
	var solid = true;
	public function new(x:int = 0, y:int = 0, width:int = 1, height:int = 1, type:int = 0)
	{
		super(x, y);
		makeGraphic(width, height, FlxColor.BLUE);
		immovable = true;
		alpha = .5;visible = false;
		this.type = type;
		solid = (this.type == 0 || this.type >= 3);
	}
}

function createWall(x:Float, y:Float, width:Float, height:Float, type:int = 0){
	var wall = new Wall(x*tileSize,y*tileSize,width*tileSize,height*tileSize,(type == null?0:type));
	walls.add(wall);
}

//Player
class Player extends FlxSprite
{	
	public var isMoving:Bool = false;
	public var canMove:bool = true;
	var percentToNextTile:Float = 0;
	var prevX = 0;var prevY = 0;
	var yDir = 0;var xDir = 0;
	var dir = "down";
	var speed = 5;
	var tileInFront = null;
	var startingTrigger = false;
	
	public function new(x:int = 0, y:int = 0)
	{
		super(x, y);
		
		loadGraphic("images/overworld/bf.png",true,16,16);
		offset.set(0, 4);
		setPosition(x*tileSize,y*tileSize);

		animation.add("idle_down", [1]);
		animation.add("idle_side", [7]);
		animation.add("idle_up", [4]);
		animation.add("walk_down", [1, 0, 1, 2], 9);
		animation.add("walk_side", [7, 6], 9);
		animation.add("walk_up", [4, 3, 4, 5], 9);		
		moves = true;
		animation.play('idle_down');
		updateHitbox();
	}
	
	public function updateMovement()
	{
		//Sprinting
		speed = FlxG.keys.pressed.SHIFT ? 8 : 4;
		animation.getByName("walk_side").frameRate = (speed == 8 ? 14 : 9);
		animation.getByName("walk_down").frameRate = (speed == 8 ? 14 : 9);
		animation.getByName("walk_up").frameRate = (speed == 8 ? 14 : 9);
		
		if(isMoving){
			percentToNextTile += speed * FlxG.elapsed;
			if(percentToNextTile >= 1){
				percentToNextTile = 0;isMoving = false;tileInFront = GetTileInFront(); //Get the newest tile in front after moving
				setPosition(prevX + (tileSize * xDir), prevY + (tileSize * yDir));
			}else{
				setPosition(prevX + (tileSize * xDir * percentToNextTile), prevY + (tileSize * yDir * percentToNextTile));
			}
		}else{
			if(yDir == 0)xDir = ((FlxG.keys.pressed.D||FlxG.keys.pressed.RIGHT || PlayerSettings.solo.controls.RIGHT)-(FlxG.keys.pressed.A||FlxG.keys.pressed.LEFT||PlayerSettings.solo.controls.LEFT));
			if(xDir == 0)yDir = ((FlxG.keys.pressed.S||FlxG.keys.pressed.DOWN||PlayerSettings.solo.controls.DOWN)-(FlxG.keys.pressed.W||FlxG.keys.pressed.UP||PlayerSettings.solo.controls.UP));
			if((yDir != 0 || xDir != 0) && canMove){	
				tileInFront = GetTileInFront(); //Check the next tile to see if its solid
				var blocked = tileInFront != null && tileInFront.solid;				
				isMoving = !blocked;
				dir = yDir == -1 ? "up" : yDir == 1 ? "down" : xDir == -1 ? "left" : "right";
				prevX = x;prevY = y;
			}
			if(!startingTrigger)InteractionTriggers(); //Triggers action triggers
		}
		
		flipX = dir == "right"; //Flips the side sprite instead of having 2 copies
		animation.play((isMoving?'walk_':'idle_')+((dir == "left" || dir == "right")?"side":dir)); //Plays idle/walk anims
		if(!startingTrigger)FlxG.overlap(cast(this,FlxObject), walls, OverlapWallTriggers); //Triggers walk over triggers
	}
	
	//Triggers that require an input
	function InteractionTriggers(){
		if(tileInFront != null && PlayerSettings.solo.controls.ACCEPT){
			switch(tileInFront.type){
				case 3: //Credits
					FlxG.switchState(new CreditsMain());startingTrigger = true;
				case 4: //Options
					FlxG.switchState(new OptionsMenu());startingTrigger = true;
				case 5: //Shop
					FlxG.switchState(new FreeplayState());startingTrigger = true;
				case 6: //North Sign
					if(!inDialog)startDialog("North: Story \n\nSouth: Menu houses\n\nEast: ???");
				case 7: //Useless Sign
					if(!inDialog)startDialog("Why is this sign even here? ");
				case 8: //South Sign
					if(!inDialog)startDialog("Left house: Credits Menu \n\nMiddle house: Options Menu \n\nRight house: Shop");
			}
		}	
	}
	
	//Triggers that require you to walk over them
	function OverlapWallTriggers(self:FlxObject, other:FlxObject){
		switch(other.type){
			default:
				return;
			case 1:
				canMove = false;
				if(!isMoving){
					FlxG.switchState(PlayState.loadWeek({
						name: 'Lullaby',
						id: '1',
						songs: [{name: 'safety-lullaby'}, {name: 'left-unchecked'}, {name: 'lost-cause'}],
						difficulties: ['hard']
					}, 'hard'));
					FlxG.switchState(new PlayState());
					startingTrigger = true;			
				}
				return;
			case 2:
				canMove = false;
				if(!isMoving){
					curMusic.volume = 0;
					FlxG.sound.play(Paths.sound('StartupBroke'), 0.5);
					new FlxTimer().start(5, ()->{
						FlxG.switchState(PlayState.loadSong('missingno', 'hard'));
						FlxG.switchState(new PlayState()); 
					});
					startingTrigger = true;
				}
				return;
		}
	}
	
	function GetTileInFront():Wall{
		var moveRect = new FlxRect(x + tileSize * xDir, y + tileSize * yDir, width, height);
		for(wall in walls.members){
			if(wall != null && wall.exists){						
				var wallRect = new FlxRect(wall.x, wall.y, wall.width, wall.height);
				if(moveRect.overlaps(wallRect))return wall;
			}
		}	
	}	
	
	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}
}

#if mobile
	addTouchPad("LEFT_FULL", "A_B_C");
	addTouchPadCamera();
#end