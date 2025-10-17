//var txt:FlxText;
function addText(x:Int, y:Int, text:String, size:Int, time:Float, color = 0xFFFFFF){
	var txt = new FlxText(x, y, 1000, text, size);
	txt.setFormat(Paths.font("pokefont.ttf"), size, color);
	txt.wordWrap = true;
	txt.cameras = [camHUD];
	txt.scrollFactor.set(0);
	//txt.screenCenter();
	add(txt);

	new FlxTimer().start(time, ()->{
		FlxTween.tween(txt, {alpha:0}, 1, {onComplete: ()->{
			//trace('destroyed');
			txt.destroy();
	}});
	});

	if(curSong == 'safety-lullaby'){ txt.x = 200; txt.y = 300;}
}
function onEvent(event) {
	switch (event.event.name) {
		case 'Add Text':
			addText(event.event.params[0], event.event.params[1], event.event.params[2], event.event.params[3], event.event.params[4], event.event.params[5]);
	}
}