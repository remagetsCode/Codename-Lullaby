function postCreate(){
    modchart.setPercent('opponentSwap', 1);
    modchart.setPercent('alpha', 0, 0);

    big = stage.getSprite("bighipno");
    pic = stage.getSprite("Transition");
    alexis = player.characters[1];
    smol = player.characters[0];

    pass = new FlxSprite(1040, -300);
    pass.frames = Paths.getFrames('stages/bygone/images/GGirl Alexis Passing Spritesheet');
    pass.animation.addByPrefix('pass', 'GGirl', 24, false);
    pass.alpha = 0;
    add(pass);
    
    light = new FlxSprite(pass.x-60,  pass.y+100);
    light.frames = Paths.getFrames('stages/bygone/images/Heavens Gate');
    light.animation.addByPrefix('lit', 'Heaven', 24, false);
    add(light);

    FlxTween.tween(alexis, {y: alexis.y + 25}, 1, {ease: FlxEase.sineInOut, type: 4});
    alexis.alpha = 0;
    pic.alpha = 0;
    pic.screenCenter();

    big.alpha = 0;
    iconP2.visible = false;

    modchart.ease('alpha', 38, 2, 0, FlxEase.cubeOut);
    modchart.ease('alpha', 46, 2, 1, FlxEase.cubeOut);
    modchart.ease('alpha', 143, 2, 0, FlxEase.cubeOut);
    modchart.set('tipsy', 156, 0.1, 1);
    modchart.set('tipsyx', 156, 0.25, 1);
    modchart.set('wiggle', 156, 0.3, 1);
    modchart.set('beatz', 160, 1.4, 1);
    modchart.ease('alpha', 177, 1, 0.65, FlxEase.cubeOut,1);
    modchart.ease('alpha', 177, 1, 1, FlxEase.cubeOut,0);
    modchart.ease('opponentSwap', 177, 1, 0, FlxEase.quadInOut);
    modchart.set('beatz', 276, 0, 1);
    modchart.ease('alpha', 307, 1, 0, FlxEase.cubeOut, 1);

    modchart.setPercent('xmod0', 0.65);
    modchart.setPercent('xmod1', 0.1);
    modchart.setPercent('xmod2', 0.45);
    modchart.setPercent('xmod3', 0.25);
    setMarginColor(0x000000, 1);
}

function stepHit(s){
    player.members[0].scrollSpeed = 2.0;
    player.members[1].scrollSpeed = 3.0;
    player.members[2].scrollSpeed = 2.75;
    player.members[3].scrollSpeed = 2.3;
    switch(s){
        case 156: for(i in uiStuff) FlxTween.tween(i, {alpha: 0}, 2);
        case 180: for(i in uiStuff) FlxTween.tween(i, {alpha: 1}, 2);

        case 588: 
            for(i in uiStuff) FlxTween.tween(i, {alpha: 0}, 4);
            FlxTween.tween(pic, {alpha: 1}, 5);
        case 634: 
            setMarginColor(0xFFFF00, 1);
            big.alpha = 1;
            smol.alpha = 0;
            iconP1.setIcon('icon-hypno');
            FlxTween.tween(pic, {alpha: 0}, 5);
            for(i in uiStuff) FlxTween.tween(i, {alpha: 0.5}, 4);
        case 714: 
            setMarginColor(0x13DCFF, 1);
            FlxTween.tween(alexis, {alpha: 0.9}, 1);
        case 720: iconP1.setIcon('icon-alexis');
        case 1236:
            pass.animation.play('pass');
            light.animation.play('lit');
            alexis.alpha = 0;
            pass.alpha = 1;

        case 1240: 
            setMarginColor(0xFF0000, 1);
            iconP1.setIcon('icon-hypno');
    }
}