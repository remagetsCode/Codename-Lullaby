introLength = 0;
function postCreate(){
    for(i in [healthBar, healthBarBG, iconP1, iconP2]) i.alpha = 0;
    camHUD.alpha = 0;
    
    
    for(i in 0...4) {
        modchart.setPercent('x'+i, -300-130*i, 0);
        modchart.setPercent('x'+i, -570+(170*i), 1);
        modchart.ease('x'+i, 105, 5, 0, FlxEase.cubeOut);
    }
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

        case 428: bf.cameraOffset = FlxPoint.get(-400, 0);
    }
}

function onPlayerMiss(e){
    if(curStep > 428) e.animSuffix = "-alt";
}