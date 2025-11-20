introLength = 0;
function postCreate(){
    camExtra = new FlxCamera(0, 0);
    camExtra.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(camExtra, false);

    if(FlxG.save.data.lullabyShaders) FlxG.game.addShader(aberration); //I know, i know... i've been using this shader too many times, but i like the ambience it gives to the scene
    aberration.amount = 0.3;

    for(i in [healthBar, healthBarBG, iconP1, iconP2]) i.alpha = 0;
    camHUD.alpha = 0;
    
    modchart.setPercent('alpha', 0, 0);
    for(i in 0...4) {
        modchart.setPercent('x'+i, -300-130*i, 0);
        modchart.setPercent('x'+i, -570+(170*i), 1);
        modchart.ease('x'+i, 105, 5, 0, FlxEase.cubeOut);
    }

    new FlxTimer().start(0.03, ()->{
        vignette.alpha = 0.9;
        vignette.camera = camExtra;
    });
}

function stepHit(e){

    switch(e){
        // So cold... Why is it so cold?...
        case 90: 
            window.title = "So cold...";
            bf.playAnim('GreyCold_Talk');
        case 100: 
            FlxTween.tween(camHUD, {alpha: 1}, 2);

        case 115: window.title = "Why is it so cold?";

        case 428:
            for(i in [healthBar, healthBarBG, iconP1, iconP2]) FlxTween.tween(i, {alpha: 1}, 2);
            FlxTween.tween(vignette, {alpha: 0.5}, 5); 
            bf.cameraOffset = FlxPoint.get(-400, 0);
        case 1232: FlxTween.tween(vignette, {alpha: 0.85}, 5); 
        case 1744: FlxTween.tween(vignette, {alpha: 0.5}, 5); 
        case 2908: 
            FlxTween.tween(camGame, {alpha: 0}, 3);
            FlxTween.tween(camHUD, {alpha: 0}, 3);
    }
}

function onPlayerMiss(e){
    if(curStep > 428) e.animSuffix = "-alt";
}