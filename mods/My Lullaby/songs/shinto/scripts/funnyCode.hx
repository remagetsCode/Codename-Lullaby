var blueballed:Bool = false;

function create(){
    camExtra = new FlxCamera(0, 0);
    camExtra.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(camExtra, false);

    hand = new FlxSprite(800, 400);
    hand.frames = Paths.getFrames('characters/shitno/shitno_pokeball');
    hand.animation.addByPrefix('1', 'shitno', 16, false);
    hand.cameras = [camExtra];
    hand.scale.set(4,4);
    hand.updateHitbox();
    hand.alpha = 0;
    add(hand);

}

function postCreate(){
    var d = downscroll ? -1 : 1;
    modchart.setPercent('tipsyx', 0.2, 0);
    for(i in 0...4) {
        modchart.setPercent('y'+i, 800*d);
        var o = i+4;
        modchart.ease('y'+i, i*4, 3, 0, FlxEase.quadOut, 0);
        modchart.ease('y'+i, o*4, 3, 0, FlxEase.quadOut, 1);
        }
    modchart.set('bounce', 96, -0.4);
    modchart.set('bounce', 159, 0);
    modchart.set('bounce', 256, -0.4);
    modchart.set('bounce', 316, 0);
    for(i in 0...4) {
        modchart.set('beaty'+i, 96, i%2==0 ? 1.5 : -1.5);
        modchart.set('beaty'+i, 159.5, 0);
        modchart.set('beaty'+i, 256, i%2==0 ? 1.5 : -1.5);
        modchart.set('beaty'+i, 316.5, 0);
    }

}

function update(){
    if(blueballed){
        inst.pause();
        vocals.pause();
        if(controls.ACCEPT) {
            var waitTime = 0.7;

		    new FlxTimer().start(waitTime, function(tmr:FlxTimer)
		    {
			    camera.fade(FlxColor.BLACK, 1, false, function()
			    {
			    	skipTransOut = true;
			    	FlxG.switchState(new PlayState());
			    });
		    });
        }   
    }
}
var p1:Int = 640;
var p2:Int = 768;
var p3:Int = 1408;
var p4:Int = 1856;
function stepHit(e){
    switch(e){
        case 1:
            setMarginColor(FlxColor.fromRGB(247, 223, 111)); 
            holds.visible = false;
        
        case p1 | p1+16 | p1+24 | p1+32 | p1+48 | p1+64:
            pattern1();
            var targAngle = modchart.getPercent('confusionOffset', 1) == 360 ? 0 : 360;
            modchart.ease('confusionOffset', curBeatFloat, 1.5, targAngle, FlxEase.cubeOut, 1);
            modchart.ease('opponentSwap', curBeatFloat, 1.5, modchart.getPercent('opponentSwap') == 0 ? 1 : 0, FlxEase.cubeOut);

        case p2 | p2+16 | p2+24 | p2+32 | p2+48 | p2+64:
            pattern1();
            var targAngle = modchart.getPercent('confusionOffset', 1) == 360 ? 0 : 360;
            modchart.ease('confusionOffset', curBeatFloat, 1.5, targAngle, FlxEase.cubeOut, 1);
            modchart.ease('opponentSwap', curBeatFloat, 1.5, modchart.getPercent('opponentSwap') == 0 ? 1 : 0, FlxEase.cubeOut);

        case p3 | p3+16 | p3+24 | p3+32 | p3+48 | p3+64:
            pattern1();
            var targAngle = modchart.getPercent('confusionOffset', 1) == 360 ? 0 : 360;
            modchart.ease('confusionOffset', curBeatFloat, 1.5, targAngle, FlxEase.cubeOut, 1);
            modchart.ease('opponentSwap', curBeatFloat, 1.5, modchart.getPercent('opponentSwap') == 0 ? 1 : 0, FlxEase.cubeOut);

        case p4 | p4+16 | p4+24 | p4+32 | p4+48 | p4+64:
            pattern1();
            var targAngle = modchart.getPercent('confusionOffset', 1) == 360 ? 0 : 360;
            modchart.ease('confusionOffset', curBeatFloat, 1.5, targAngle, FlxEase.cubeOut, 1);
            modchart.ease('opponentSwap', curBeatFloat, 1.5, modchart.getPercent('opponentSwap') == 0 ? 1 : 0, FlxEase.cubeOut);

        case 2080: 
            hand.alpha = 1;
            hand.animation.play('1');
            dad.playAnim('shitno_end');
    }
}

function onGameOver(e){
    e.cancel();
    inst.pause();
    vocals.pause();
    canPause = false;
    FlxG.sound.play(Paths.sound('ShintoRetry'));
    
    FlxTween.tween(camHUD, {alpha: 0}, 1);
    new FlxTimer().start(0.2, ()->dad.playAnim('shitno_lose'));
    new FlxTimer().start(1.1, ()->dad.alpha = 0);
    blueballed = true;
}