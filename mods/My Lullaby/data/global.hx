// script extracted from FNDustin' all the credits to they


import Type;

import funkin.backend.MusicBeatTransition;
import funkin.options.OptionsMenu;
import funkin.menus.credits.CreditsMain;
import funkin.backend.MusicBeatState;
import funkin.backend.system.Controls.Control;
import funkin.backend.system.Controls;

public static var playerSpawnPos:Array<Int> = [12,9];

var overwriteStates:Map<String, String> = [
    "funkin.menus.TitleState" => "MyTitleState",
    "funkin.menus.MainMenuState" => "MyMainMenu",
    "funkin.menus.FreeplayState" => "Shop",
    "funkin.menus.StoryMenuState" => "MyMainMenu"
];

function new() {
    MusicBeatTransition.script = 'data/scripts/customTransition';
    trace("Transition script path: " + MusicBeatTransition.script);

    //Hacker mode
	//FlxG.save.data.unlockedSongs = ["u" => "stoopid", "frostbite" => "unlocking", 'lost-cause' => 'unlocking', 'left-unchecked' => 'unlocking', 'safety-lullaby' => 'unlocking', 'missingno' => 'unlocking', 'insomnia' => 'unlocking', 'monochrome' => 'unlocking', 'purin' => 'unlocking'];

    //Noob mode
    //FlxG.save.data.unlockedSongs = ["u" => "stoopid"];

	if(FlxG.save.data.unlockedSongs == null) FlxG.save.data.unlockedSongs = ["u" => "stoopid", "frostbite" => "unlocking", "insomnia" => "unlocking"];
	if(FlxG.save.data.lullabyMoney == null) FlxG.save.data.lullabyMoney = 0;
	if(!FlxG.save.data.unlockedSongs.exists("frostbite")) FlxG.save.data.unlockedSongs.set("frostbite", "unlocking");
	if(!FlxG.save.data.unlockedSongs.exists("insomnia")) FlxG.save.data.unlockedSongs.set("insomnia", "unlocking");
	if(!FlxG.save.data.unlockedSongs.exists("monochrome")) FlxG.save.data.unlockedSongs.set("monochrome", "unlocking");



	if(FlxG.save.data.lullabyMechanics == null) FlxG.save.data.lullabyMechanics = true;
	if(FlxG.save.data.lullabyShaders == null) FlxG.save.data.lullabyShaders = true;
}

function preStateSwitch() {
    if (overwriteStates.get(Type.getClassName(Type.getClass(FlxG.game._requestedState))) != null)FlxG.game._requestedState = new ModState(overwriteStates.get(Type.getClassName(Type.getClass(FlxG.game._requestedState))));
	if(Std.isOfType(FlxG.game._requestedState, MusicBeatState) && FlxG.game._requestedState.scriptName == "MyMainMenu"){
		playerSpawnPos = [12, 9];
		if(Std.isOfType(FlxG.game._state, OptionsMenu))playerSpawnPos = [11, 16];
		if(Std.isOfType(FlxG.game._state, CreditsMain))playerSpawnPos = [6, 14];
		if(Std.isOfType(FlxG.game._state, MusicBeatState) && FlxG.game._state.scriptName == "Shop")playerSpawnPos = [15, 16];	
	}
}