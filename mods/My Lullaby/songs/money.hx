var finishedOnce = false;
function update(){
    
    if (Conductor.songPosition >= inst.length-2300 && !finishedOnce) {
        finishedOnce = true;

        var got = FlxG.random.int(230,270);
        FlxG.save.data.lullabyMoney += got;

        money = new FlxSprite(FlxG.width-150, -30);
        money.frames = Paths.getFrames('UI/base/moneybag');
        money.animation.addByPrefix('idle', 'Moneybag final', 24, false);
        money.animation.play('idle');
        money.cameras = [camHUD];
        insert(30, money); 

        m = new FunkinText(money.x+20, 690, 0, "", 24, false);
        m.color = FlxColor.YELLOW;
        m.text = "+" + got;
        m.cameras = [camHUD];
        add(m);

        new FlxTimer().start(0.5, ()->{FlxG.sound.play(Paths.sound('MoneyBagGet'));});

        new FlxTimer().start(1.2, ()->{
            FlxTween.tween(m, {y: 900}, 0.2);
        });

        
    }
}