import funkin.menus.StoryWeeklist;
import funkin.backend.utils.DiscordUtil;

var cartridges:Array = [];
var curSelected:Int = 0;
var canMove:Bool = true;
var weekList ;
// wth is a typedef

/** Cartridge
 * @param weekName Name of the week data
 * @param weekFile Name of the file
 * @param weekDisplayName Name of the week
 */
var cartridgeList:Array = [
	{
		weekDisplayName: "Hypno's Lullaby",
		weekFile: "HypnoWeek"
	},
	{
		weekDisplayName: "Lost Silver",
		weekFile: "LostSilverWeek"
	},
	{
		weekDisplayName: "Missingno",
		weekFile: "GlitchWeek"
	}
];

function create(){
	#if mobile
	trace('hola');
	#else
	DiscordUtil.changePresence("Cartridge Selection", "What am i going to play now?");
	#end
	weekList = StoryWeeklist.get(true, false);
	if(FlxG.sound.music != null) FlxTween.tween(FlxG.sound.music, {pitch: 0.3, volume: 0.2}, 3);

	var unlockedSilver = true;
	var unlockedGlitch = false;
	var gameboyIdleAnim = [for(i in 0...8) i];
	var gameboyConfirmAnim = [for(i in 15...50) i];

	for(i => cartridge in cartridgeList) {
		if(FlxG.save.data.cartridgesOwned.contains(cartridge.weekFile)){
			cart = new FlxSprite(0, 0);
			cart.frames = Paths.getFrames('menus/story/' + cartridge.weekFile);
			cart.animation.addByPrefix('idle', cartridge.weekFile + '0', 24, true);
			cart.animation.addByPrefix('confirm', cartridge.weekFile + 'Confirm', i==2?40:24, false);
			cart.animation.play('idle');
			cart.scale.set(0.7, 0.7);
			cart.updateHitbox();
			cart.antialiasing = true;
			cart.ID = i;
			cartridges.push(cart);
			add(cart);
		}
	}
	

    gameboy = new FlxSprite();
	gameboy.frames = Paths.getFrames('menus/story/CampaignBoy');
	gameboy.animation.add('idle', gameboyIdleAnim, 24, true);
	gameboy.animation.add('confirm', gameboyConfirmAnim, 24, false);
	gameboy.scale.set(0.7, 0.7);
	gameboy.updateHitbox();
	gameboy.screenCenter(FlxAxes.X);
	gameboy.y = 450;
	gameboy.antialiasing = true;
	gameboy.animation.play('idle');

	add(gameboy);

	upperBar = new FlxSprite().makeGraphic(FlxG.width, FlxG.height/7, FlxColor.WHITE);
	add(upperBar);

	cartName = new FlxText(0, 30, 0, cartridgeList[curSelected].weekDisplayName, 30, false);
	cartName.setFormat(Paths.font("pokefont.ttf"), 40, 0x111111);
	cartName.screenCenter(FlxAxes.X);
	add(cartName);
}

function update(elapsed){
	if(!canMove) return;
	var leftP:Bool = controls.LEFT_P;
	var rightP = controls.RIGHT_P;
	var scroll = FlxG.mouse.wheel;

    if(controls.BACK) {
		if(FlxG.sound.music != null) FlxTween.tween(FlxG.sound.music, {pitch: 1, volume: 0.5}, 1.5);
		FlxG.switchState(new MainMenuState());
	}
	if(controls.ACCEPT){
		select();	
	}
	if (leftP || rightP || scroll != 0)
		changeItem((leftP ? -1 : 0) + (rightP ? 1 : 0) - scroll);

	for (i in 0...cartridges.length)
		{
			var curSprite:FlxSprite = cartridges[i];
			curSprite.setPosition(gameboy.x + gameboy.width / 2 - curSprite.width / 2, -325);
			if (i == 2) {
				curSprite.y += -20;
			}
			var currentAngle:Float = -((i - curSelected) * 60);
			curSprite.angle = lerp(curSprite.angle, currentAngle, 0.2);
			curSprite.x = curSprite.x - Math.sin(curSprite.angle * (Math.PI / 180)) * 600;
			curSprite.y = curSprite.y + Math.cos(curSprite.angle * (Math.PI / 150)) * 550;
			curSprite.alpha = (i - curSelected == 0) ? 1 : 0.3;
		}
}

function changeItem(huh:Int = 0, ?mouse:Bool = false)
{		
	FlxG.sound.play(Paths.sound("menu/scroll"),0.5);
	if(mouse) curSelected = huh;
	curSelected = FlxMath.wrap(curSelected + huh, 0, cartridges.length-1);	
	cartName.text = cartridgeList[curSelected].weekDisplayName;
	cartName.screenCenter(FlxAxes.X);
}

function select() {
	cartridges[curSelected].animation.play('confirm');
	gameboy.animation.play('confirm');
	canMove = false;
	cartridges[curSelected].animation.onFinish.add(function(){
		FlxG.sound.music.fadeOut(0.25, 0, function(){
			FlxG.sound.play(Paths.sound('GameboyStartup'), 0.25, false, null, true, function() {
					FlxG.switchState(PlayState.loadWeek(weekList.weeks[curSelected], 'hard'));
					FlxG.switchState(new PlayState());
			});
		});
	});
}

#if mobile
addTouchPad('LEFT_RIGHT', 'A_B');
addTouchPadCamera();
#end