// script extracted from FNDustin' all the credits to they


import Type;

import funkin.backend.MusicBeatTransition;



var overwriteStates:Map<String, String> = [
    "funkin.menus.TitleState" => "MyTitleState",
    "funkin.menus.MainMenuState" => "MyMainMenu",
    "funkin.menus.FreeplayState" => "MyFreeplayState",
    "funkin.menus.StoryMenuState" => "MyMainMenu"
];

function new() {
    MusicBeatTransition.script = 'data/scripts/customTransition';
    trace("Transition script path: " + MusicBeatTransition.script);

	if(FlxG.save.data.unlockedSongs == null) FlxG.save.data.unlockedSongs = ["u" => "stoopid", "frostbite" => "unlocking", "insomnia" => "unlocking", "isotope" => "unlocking"];
	if(!FlxG.save.data.unlockedSongs.exists("frostbite")) FlxG.save.data.unlockedSongs.set("frostbite", "unlocking");
	if(!FlxG.save.data.unlockedSongs.exists("insomnia")) FlxG.save.data.unlockedSongs.set("insomnia", "unlocking");
	if(!FlxG.save.data.unlockedSongs.exists("isotope")) FlxG.save.data.unlockedSongs.set("isotope", "unlocking");
	//FlxG.save.data.unlockedSongs = ["u" => "stoopid", "frostbite" => "unlocking", 'lost-cause' => 'unlocking', 'left-unchecked' => 'unlocking', 'safety-lullaby' => 'unlocking', 'missingno' => 'unlocking', 'insomnia' => 'unlocking'];

	if(FlxG.save.data.lullabyMechanics == null) FlxG.save.data.lullabyMechanics = true;
	if(FlxG.save.data.lullabyShaders == null) FlxG.save.data.lullabyShaders = true;
}
function preStateSwitch() {
    if (overwriteStates.get(Type.getClassName(Type.getClass(FlxG.game._requestedState))) != null)
        FlxG.game._requestedState = new ModState(overwriteStates.get(Type.getClassName(Type.getClass(FlxG.game._requestedState))));
}
