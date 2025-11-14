// script extracted from FNDustin', edited by me.


import Type;

import funkin.backend.MusicBeatTransition;
import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;
import funkin.backend.MusicBeatState;
import funkin.backend.system.Controls.Control;
import funkin.backend.system.Controls;
import funkin.backend.utils.NdllUtil;
import openfl.geom.ColorTransform;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxBasic;
import lime.app.Application;
import openfl.display.Sprite;
import openfl.display.GradientType;

public static var playerSpawnPos:Array<Int> = [12,9];
var overwriteStates:Map<String, String> = [
    "funkin.menus.TitleState" => "MyTitleState",
    "funkin.menus.MainMenuState" => "MyMainMenu",
    "funkin.menus.FreeplayState" => "Shop",
    "funkin.menus.StoryMenuState" => "CartridgeMenu"
];

static var SET_TRANSPARENT = NdllUtil.getFunction("ndllexample", "ndllexample_set_windows_transparent", 4);
function new() {
	
    MusicBeatTransition.script = 'data/scripts/customTransition';
    trace("Transition script path: " + MusicBeatTransition.script);

    //Hacker mode
	//FlxG.save.data.unlockedSongs = ["u" => "stoopid", "frostbite" => "unlocking", 'lost-cause' => 'unlocking', 'left-unchecked' => 'unlocking', 'safety-lullaby' => 'unlocking', 'missingno' => 'unlocking', 'insomnia' => 'unlocking', 'monochrome' => 'unlocking', 'purin' => 'unlocking'];

    //Noob mode
    //FlxG.save.data.unlockedSongs = ["u" => "stoopid"];

	if(FlxG.save.data.unlockedSongs == null) FlxG.save.data.unlockedSongs = ["u" => "stoopid"];
	if(FlxG.save.data.cartridgesOwned == null) FlxG.save.data.cartridgesOwned = ["HypnoWeek"];
	if(FlxG.save.data.lullabyMoney == null) FlxG.save.data.lullabyMoney = 0;

	if(FlxG.save.data.lullabyMechanics == null) FlxG.save.data.lullabyMechanics = true;
	if(FlxG.save.data.lullabyShaders == null) FlxG.save.data.lullabyShaders = true;
	if(FlxG.save.data.monochromeWindow == null) FlxG.save.data.monochromeWindow = false;
}

function preStateSwitch() {
    if (overwriteStates.get(Type.getClassName(Type.getClass(FlxG.game._requestedState))) != null)FlxG.game._requestedState = new ModState(overwriteStates.get(Type.getClassName(Type.getClass(FlxG.game._requestedState))));
	if(Std.isOfType(FlxG.game._requestedState, MusicBeatState) && FlxG.game._requestedState.scriptName == "MyMainMenu"){
		playerSpawnPos = [12, 9];
		if(Std.isOfType(FlxG.game._state, OptionsMenu))playerSpawnPos = [11, 16];
		if(Std.isOfType(FlxG.game._state, CreditsMain))playerSpawnPos = [6, 14];
		if(Std.isOfType(FlxG.game._state, MusicBeatState) && FlxG.game._state.scriptName == "Shop")playerSpawnPos = [15, 16];	
	}
	initMarginCamera();
}

public static var twen:FlxTween;
public static var colTween:FlxTween;
public static var windowBorderBg:Sprite;
public static var targColor = 0xa50505;
static function initMarginCamera()
    {
		if(windowBorderBg == null) windowBorderBg = new Sprite();

		if(twen != null) twen.destroy();
		twen = FlxTween.num(0.05, 0.7, 5, {
			type: 4,
			onUpdate: function(v){
				windowBorderBg.alpha = FlxMath.lerp(windowBorderBg.alpha, v.value, 0.1);
			}
		});

        FlxG.signals.gameResized.add((w, h) -> {
			windowBorderBg.graphics.clear();
			windowBorderBg.graphics.beginFill(targColor);
			windowBorderBg.graphics.drawRect(0, 0, window.width, window.height);
			windowBorderBg.graphics.endFill();
		});

        Main.instance.addChildAt(windowBorderBg, 0);
}

static function setMarginColor(color, ?vel){
	color ??= FlxColor.BLACK;
	vel ??= 1;

	if(colTween != null) colTween.destroy();
	colTween = FlxTween.color(null, vel, targColor, color, {
		onUpdate: (tween)->{
			windowBorderBg.graphics.clear();
			windowBorderBg.graphics.beginFill(tween.color);
			windowBorderBg.graphics.drawRect(0, 0, window.width, window.height);
			windowBorderBg.graphics.endFill();

			targColor = tween.color;
		}
	});
}

static function marginTween(?status:Bool){
	status ??= !twen.active;
	twen.active = status;
}