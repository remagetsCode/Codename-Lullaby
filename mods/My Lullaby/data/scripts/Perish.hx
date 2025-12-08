import flixel.addons.text.FlxTypeText;

var blueballed:Bool = false;
var redvignette:FlxSprite;
var heartbeat:FlxSound = FlxG.sound.load(Paths.sound('heartbeat'));
var staticSound:FlxSound = FlxG.sound.load(Paths.sound('static'));
var deathMessages:Array<String> = [
    "That was funny to watch.",
    "My dog plays better than you lmao.",
    "This was very painful to see, not for me but for you.",
    "That was a good try. But all destinies end into death, but YOU can always try again.",
    "You're not good enough, this is not a kid's game.",
    "No one said it'd be easy.",
    "Do you know you're supposed to win? Then stop being so bad and play seriously."
];
var retryMessages:Array<String> = [
    "Retry?",
    "Do you want to try again?",
    "Stay Determined Player!",
    "Let's continue, shall we?",
    "Try again?",
    "Un-die?"
];


//TODO: mobile screen support
function update() {
    if(blueballed){
        inst.pause();
        vocals.pause();
        if(controls.ACCEPT) {
            var waitTime = 0.5;

		    new FlxTimer().start(waitTime, function(tmr:FlxTimer)
		    {
			    camera.fade(FlxColor.BLACK, 1, false, function()
			    {
			    	skipTransOut = true;
			    	FlxG.switchState(new PlayState());
			    });
		    });
        } 
        else if(controls.BACK) FlxG.switchState(new MainMenuState());  
    }
    redvignette?.alpha = lerp(redvignette?.alpha, 0, 0.025);
    
    if (FlxG.keys.justPressed.R){
        FlxG.keys.reset();
    }
}

function onGameOver(e){
    e.cancel();
    inst.pause();
    vocals.pause();
    canPause = false;
    canDie = false;
    canDadDie = false;
    heartbeat.play();
    camGame.alpha = 1;

    bgmusic = FlxG.sound.play(Paths.music('freakyMenu'), 1, true).fadeIn(5);

	pauseCam = new FlxCamera(0, 0);
    pauseCam.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(pauseCam, false);

    if(FlxG.save.data.lullabyShaders) camGame.addShader(monitor);

    anotherblack = new FunkinSprite().makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
    anotherblack.camera = camGame;
    anotherblack.alpha = 0;
    anotherblack.zoomFactor = 0;
    anotherblack.screenCenter();
    add(anotherblack);

    estatic = new FunkinSprite();
    estatic.frames = Paths.getFrames("stages/disabled/images/static");
    estatic.animation.addByPrefix('xd', 'static', 24, true);
    estatic.animation.play('xd');
    estatic.scrollFactor.set(0,0);
    estatic.camera = camGame;
    estatic.setGraphicSize(FlxG.width+200, FlxG.height+200);
    estatic.updateHitbox();
    estatic.screenCenter();
    estatic.alpha = 0;
    add(estatic);

    redvignette = new FlxSprite().loadGraphic(Paths.image("UI/base/badvignettered"));
    redvignette.camera = pauseCam;
    redvignette.setGraphicSize(FlxG.width, FlxG.height);
    redvignette.updateHitbox();
    redvignette.alpha = 1;
    add(redvignette);

    FlxTween.tween(estatic, {alpha: 1}, 1, {ease: FlxEase.cubeOut, onComplete: ()->{
        anotherblack.alpha = 1;
        FlxTween.tween(estatic, {alpha: 0}, 2.3, {ease: FlxEase.cubeIn});
    }});
    
    staticSound.play().fadeIn(1.5, null, null, ()->staticSound.fadeOut(2.3));

    FlxTween.tween(camGame, {zoom: 0.9}, 1, {ease: FlxEase.cubeOut, onComplete: ()->FlxTween.tween(camGame, {zoom: 0.8}, 60, {ease: FlxEase.quadOut})});
    defaultCamZoom = 0.9;
    
    FlxTween.tween(camHUD, {alpha: 0}, 0.6);
    blueballed = true;

    new FlxTimer().start(2.5, function(tmr:FlxTimer){
        deathText = new FlxTypeText(100, 200, 630, FlxG.random.getObject(deathMessages), 30);
        deathText.alignment = "center";
        deathText.camera = pauseCam;
        deathText.screenCenter();
        deathText.y -= 150;
        deathText.start(0.05);
        add(deathText);

        retryText = new FlxTypeText(100, 400, 630, FlxG.random.getObject(retryMessages), 20);
        retryText.alignment = "center";
        retryText.camera = pauseCam;
        retryText.screenCenter(FlxAxes.X);
        add(retryText);

        deathText.completeCallback = ()->{
            new FlxTimer().start(1, ()->{
                retryText.y = deathText.y+deathText.height+70;
                retryText.start(0.05);
                FlxTween.shake(retryText, 0.002, 99999, FlxAxes.XY);
            });
        }
    });
}