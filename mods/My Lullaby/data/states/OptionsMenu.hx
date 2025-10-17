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
}