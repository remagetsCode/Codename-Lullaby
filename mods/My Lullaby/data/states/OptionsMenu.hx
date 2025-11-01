import funkin.backend.utils.DiscordUtil;

var bgMusic = FlxG.sound.music;
var windowTitle = "Friday Night Funkin' - Options Menu";

FlxG.game.setFilters([]);


function create(){
	window.title = windowTitle;
	if(bgMusic != null)
		FlxTween.tween(bgMusic, {volume: 0}, 1, {
			onComplete: ()->{
				FlxG.sound.playMusic(Paths.music('optionsTheme'),0);
				FlxTween.tween(bgMusic, {volume:0.35},1);
			}
		});

	DiscordUtil.config.clientID = "1433852304745824318";
	DiscordUtil.config.logoKey = "unknown";
	DiscordUtil.changePresence("Options Menu", "Adjusting the gears.");
}