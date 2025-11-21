var finishedOnce = false;
function onSongEnd(e) {  
    
    if(!finishedOnce){
        e.cancel();
        finishedOnce = true;

        moneyCam = new FlxCamera(0, 0);
        moneyCam.bgColor = FlxColor.fromRGB(0,0,0,245);
        FlxG.cameras.add(moneyCam, false);

        var got = Std.int(270*accuracy);
        FlxG.save.data.lullabyMoney += got;

        money = new FlxSprite(FlxG.width-150, -30);
        money.frames = Paths.getFrames('UI/base/moneybag');
        money.animation.addByPrefix('idle', 'Moneybag final', 24, false);
        money.animation.play('idle');
        money.cameras = [moneyCam];
        money.animation.onFinish.add(function(){
            // Unlock lost silver week
            if(curSong == "lost-cause" && this.isStoryMode && !FlxG.save.data.cartridgesOwned.contains("LostSilverWeek")) FlxG.switchState(new ModState("CartridgeGuyState"));
            else if(FlxG.random.bool(1) && (curSong != "safety-lullaby" || curSong != "left-unchecked" || curSong != "lost-cause")){
                FlxG.switchState(PlayState.loadSong('shinte', 'drah'));
			    FlxG.switchState(new PlayState()); 
            }
            else endSong();
        });
        add(money); 

        m = new FunkinText(money.x+20, 690, 0, "", 24, false);
        m.color = FlxColor.YELLOW;
        m.text = "+" + got;
        m.cameras = [moneyCam];
        add(m);

        new FlxTimer().start(0.5, ()->{FlxG.sound.play(Paths.sound('MoneyBagGet'));});

        new FlxTimer().start(1.2, ()->{
            FlxTween.tween(m, {y: 800}, 0.2);
        });

        
    }

        
    
}