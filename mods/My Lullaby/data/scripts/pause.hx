var songName = game.curSong;

function create(event) {
	black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	black.alpha = 0.6;
	add(black);

	right = new FlxSprite().loadGraphic(Paths.image('pause/' + songName + '/right'));
	right.x = FlxG.width/2;
	right.y = FlxG.height;
	right.antialiasing = true;
	add(right);

	left = new FlxSprite().loadGraphic(Paths.image('pause/' + songName + '/left'));
	left.y = FlxG.height;
	left.antialiasing = true;
	add(left);


}

function postCreate(){
	FlxTween.tween(right, {y: 0}, 2, {
		ease: FlxEase.quintOut
	});
	FlxTween.tween(left, {y: 0}, 3, {
		ease: FlxEase.quintOut
	});
}

