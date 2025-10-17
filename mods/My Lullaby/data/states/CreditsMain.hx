var curMusic = FlxG.sound.music;
var windowTitle = "Friday Night Funkin' Lullaby - Credits Menu";

function create(){
	window.title = windowTitle;

	FlxTween.tween(curMusic, {volume: 0}, 1, {
		onComplete: ()->{
			FlxG.sound.playMusic(Paths.music('creditsTheme'),0);
			FlxTween.tween(curMusic, {volume:0.35},1);
		}
	});
}