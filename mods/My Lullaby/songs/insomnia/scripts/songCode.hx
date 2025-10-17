

var feralidying:Bool = false;
var a:Float = 0;

var pattern1:Array<Int> = [];
function postCreate(){
	coolEnabled = false;

	var back = stage.getSprite("Back");
	if(FlxG.save.data.lullabyShaders){
		FlxG.camera.addShader(fireflies1);
		FlxG.game.addShader(aberration);
		back.shader = fireflies;
	}

	aberration.iTime = 5;
	gf.alpha = 1;

	new FlxTimer().start(0.01, ()->{
		//blk = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		//blk.cameras = [camHUD];
		//blk.alpha = 0;
		//add(blk);
		
		for(i in 0...4) modchart.setPercent('y'+i, downscroll ? 200 : -200);}
	);
}

function onSongStart(){
	
	for(i in 0...4){
		modchart.ease('y'+i, 15, 2+(i*0.4), 0, FlxEase.cubeOut, 0);
		modchart.ease('y'+i, 45, 2+(i*0.5), 0, FlxEase.quadOut, 1);
	}
	modchart.set('x', 25, -300, 1);
	modchart.ease('z', 45, 1.8, -300, FlxEase.cubeOut, 0);
	modchart.ease('x', 45, 1.8, -200, FlxEase.cubeOut, 0);
	modchart.ease('alpha', 45, 1.8, 0.3, FlxEase.cubeOut, 0);
}

function update(elapsed) {
	a += elapsed;
	fireflies.iTime = a;
	fireflies1.iTime = a;

	if(FlxG.save.data.lullabyMechanics) feraMechanic();
}

function stepHit(){
	var g:Float = (0.84-accuracy)*-5;
	var r:Float = 1-g;
	var b:Float = 0.1;
	//accuracyTxt.color = 0xffff4343;
	accuracyTxt.color = FlxColor.fromRGB(
        Std.int(r * 255),
        Std.int(g * 255),
        Std.int(b * 255)
    );
}

function beatHit(beat){
	if(beat == 2 && FlxG.save.data.lullabyMechanics){ 
		FlxTween.tween(accuracyTxt, {x:520, y: 570}, 1, {
			ease: FlxEase.cubeOut
		});
		accuracyTxt.size = 20;
		FlxTween.tween(missesTxt, {x:missesTxt.x-100}, 1, {
			ease: FlxEase.cubeOut
		});
		FlxTween.tween(scoreTxt, {x:missesTxt.x-100}, 1, {
			ease: FlxEase.cubeOut
		});
	}
						
	switch(beat){
		case 547: FlxTween.tween(black, {alpha: 0.8}, 10);
		case 578: black.alpha = 1;
		case 582: black.alpha = 0;
		case 774: FlxTween.tween(vignette, {alpha: 0.8}, 4);
		case 843: FlxTween.tween(black, {alpha: 1}, 3);
	}
}

function feraMechanic(){
	if(accuracy < 0.85 && accuracy > 0){
		move = false;
		camGame.scroll.x = lerp(camGame.scroll.x, gf.x-500, 0.08);
		camGame.scroll.y = lerp(camGame.scroll.y, gf.y-200, 0.08);
		camGame.zoom += 0.01;	
	}

	if((accuracy < 0.85 && accuracy > 0) && !feralidying){ 
		feralidying = true;

		fSound = FlxG.sound.play(Paths.sound('feraligatrWakes'));
		shake = FlxTween.shake(accuracyTxt, 0.005, 5, FlxAxes.XY);
		
		timer1 = new FlxTimer().start(0.5, ()->{
			if(accuracy > 0.85) {
				fSound.stop();
				move = true;
				feralidying = false;
				timer2.cancel();
				shake.cancel();
			}
		},10);

		timer2 = new FlxTimer().start(5, ()->{gameOver();});
	}
}



function nothing(){var nothing = 'very useful function here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';}