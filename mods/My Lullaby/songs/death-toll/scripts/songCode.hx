public var bell;
introLength = 10;
function onCountdown(e){
    e.cancel();
}
function postCreate(){
    camDS = new FlxCamera(0, 0);
    camDS.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(camDS, false);
    //player.cpu = true;
    
    if(FlxG.save.data.lullabyShaders)
    {
        FlxG.game.addShader(blur);
        FlxG.game.addShader(aberration);
        FlxG.game.addShader(heat1);
        blur.Size = 0;
        aberration.iTime = 6.5;
    }
    camDS.setFilters([]);
    gf.alpha = 1;

    drama = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    drama.scrollFactor.set(0);
    drama.zoomFactor = 0;
    drama.alpha = 0;
    insert(15, drama);

    dawnbf = player.characters[1];
    dawn = player.characters[0];
    bell = strumLines.members[2].characters[0];

    contract = new FlxSprite(dad.x-260, dad.y+450);
    contract.frames = Paths.getFrames("characters/ContractBF");
    contract.animation.addByPrefix('e', 'Contract', 4, false);
    contract.alpha = 0;
    contract.antialiasing = true;
    add(contract);

    white = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    white.scrollFactor.set(0);
    white.camera = camDS;
    white.zoomFactor = 0;
    add(white);

    dStart = new FunkinSprite();
    dStart.frames = Paths.getFrames("UI/base/hellbell/bimbembo");
    dStart.animation.addByPrefix('start', 'dsintro', 24, false);
    dStart.animation.play('start');
    dStart.animation.onFinish.add(function(){
        FlxTween.tween(dStart, {alpha: 0}, 1);
        FlxTween.tween(white, {alpha: 0}, 1);
        FlxTween.tween(dsi, {alpha: 0}, 0.3);
        FlxTween.tween(camDS, {zoom: 1}, 1.5, {ease: FlxEase.backIn});
        FlxTween.tween(camHUD, {zoom: 0.9}, 2, {ease: FlxEase.quadInOut});
    });
    dStart.scrollFactor.set(0);
    dStart.zoomFactor = 0.5;
    dStart.camera = camDS;
    dStart.antialiasing = true;
    dStart.screenCenter();
    add(dStart);

    dsi = new FunkinSprite().loadGraphic(Paths.image("UI/base/hellbell/i"));
    dsi.scrollFactor.set(0);
    dsi.zoomFactor = 0.5;
    dsi.screenCenter();
    dsi.x += 500;
    dsi.y -= 150;
    dsi.camera = camDS;
    dsi.antialiasing = true;
    add(dsi);

    dsBF = new FunkinSprite().loadGraphic(Paths.image("UI/base/hellbell/ds_03"));
    dsBF.scrollFactor.set(0);
    dsBF.zoomFactor = 0.5;
    dsBF.screenCenter();
    dsBF.camera = camDS;
    dsBF.alpha = 0;
    dsBF.antialiasing = true;
    add(dsBF);


    ds = new FunkinSprite().loadGraphic(Paths.image("UI/base/hellbell/ds_01"));
    ds.scrollFactor.set(0);
    ds.zoomFactor = 0.5;
    ds.screenCenter();
    ds.camera = camDS;
    ds.antialiasing = true;
    add(ds);

    FlxTween.tween(camDS, {zoom: 0.4}, 0.5, {ease: FlxEase.quadInOut});
    FlxTween.tween(camHUD, {zoom: 0.6}, 0.5, {ease: FlxEase.quadInOut});

    new FlxTimer().start(0.2, ()->FlxG.sound.play(Paths.sound("bimbembodsi")));
    // Thanks to BASHIR for flipping the healthbar
	healthBar.flipX = iconP1.flipX = iconP2.flipX = true;
	updateIconPositions = function(){
		var iconOffset:Int = 26;

		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(100-healthBar.percent, 0, 100, 1, 0);

		iconP2.x = center - iconOffset;
		iconP1.x = center - (iconP1.width - iconOffset);

		health = FlxMath.bound(health, 0, maxHealth);

		iconP1.health = healthBar.percent / 100;
		iconP2.health = 1 - (healthBar.percent / 100);
	}

    pitio = FlxG.sound.play(Paths.sound('pitio'), 0, true);


}

var shaderVel:Float = 1;
var time:Float = 0;
public var bruh;
function update(e){
    heat1.iTime = time += e*shaderVel;
    blur.Size = bruh;
    bruh = lerp(bruh, 0, 0.009);
    modchart.setPercent('x', 1550-(camera.scroll.x*0.95), 0);
    modchart.setPercent('y', -452-camera.scroll.y, 0);
}

var amount:Float = 0.1;
function postUpdate(){
    dawnbf.alpha = 1-dawn.alpha;
    inst.volume = lerp(inst.volume, dawnbf.idleSuffix == "-cover" ? 0.6 : 1, amount);
    vocals.volume = lerp(inst.volume, dawnbf.idleSuffix == "-cover" ? 0.8 : 1, amount);
    pitio.volume = lerp(pitio.volume, 0, 0.005); 

    if(curBeat > 7) modchart.setPercent('vibrate', modchart.getPercent('vibrate', 1) > 0 ? modchart.getPercent('vibrate', 1)-0.01 : 0, 1);
}

var getFreaky:Bool = false;
function beatHit(){
    if(getFreaky)
        FlxTween.num(3, 20, 0.001, {
            onUpdate: (v)->aberration.amount = v.value,
            onComplete: ()->FlxTween.num(20, 3, 0.35, {onUpdate: (v2)->aberration.amount = v2.value, ease: FlxEase.quadOut})
        });
}

var transTween:FlxTween;
var transAmount:Float = 1;
function stepHit(s){
     //1477, -452
    switch(s){
        case 5: setMarginColor(0xfd831a);
        case 240: heat1.intensity = 0.02;
        case 248: heat1.intensity = 0.04;
        case 256: FlxTween.tween(camDS, {zoom: 1.3}, 0.5, {ease: FlxEase.quadInOut});

        case 768:
            setMarginColor(0x000000); 
            FlxTween.num(1, 0.5, 3, {onUpdate: (v)->shaderVel = v.value});
            FlxTween.tween(drama, {alpha: 0.9}, 3);
        case 896: 
            setMarginColor(0xfd831a);
            FlxTween.tween(drama, {alpha: 0}, 1.5);

        case 1000: shaderVel = 1;

        case 1290:
            setMarginColor(0xff0000);
            FlxTween.num(1, 1.8, 2, {onUpdate: (v)->shaderVel = v.value});
            contract.alpha = 1;
            FlxTween.tween(contract, {y: contract.y+10}, 1, {ease: FlxEase.quadInOut, type: 4});
            
            contract.animation.onFinish.add(function(){
                contract.color = FlxColor.RED;
                FlxTween.tween(contract, {alpha: 0}, 1);
                FlxTween.tween(contract.scale, {x: 0.1, y: 0.1}, 1, {ease: FlxEase.backIn});
            });
        case 1296: getFreaky = true;
        
        case 1320:
            contract.animation.play('e');
            FlxTween.num(1, 0.1, 35, {onUpdate: (v)->transAmount = v.value});
            transTween = FlxTween.num(0,0.8, 2.4, {
                type: 4, 
                onUpdate: (v)->{
                    dawn.alpha = v.value + transAmount;
                }
            });

        case 1350: transAmount = 0.3;

        case 1550: 
            getFreaky = false;
            dawn.playAnim("morphingTrans", true);
            dawn.idleSuffix = "-morph";
        case 1556: getFreaky = true;

        case 1800:
            getFreaky = false;
            //FlxTween.num(20, 4, 2, {onUpdate: (v)->aberration.amount = v.value}); 
            FlxTween.num(1.8, 1, 2, {onUpdate: (v)->shaderVel = v.value});
            transTween.cancel();
            FlxTween.tween(dawn, {alpha: 0}, 2);

        case 1809: 
            setMarginColor(0x693609);
            iconP1.setIcon('bf');

        case 2336: 
            FlxTween.num(0.06, 0.0, 2, {onUpdate: (v)->heat1.intensity = v.value});
            FlxTween.tween(camDS, {zoom: 0.5}, 4, {ease: FlxEase.quadInOut});
        case 2370: 
            setMarginColor(0x000000);
            FlxTween.tween(black, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
            FlxTween.tween(dsBF, {alpha: 0.15}, 1, {ease: FlxEase.quadInOut});
        case 2375: FlxG.sound.play(Paths.sound("bimbembooff"));
    }
    
    if(dawn.idleSuffix == "") dawn.singAnims = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
    else if(dawn.idleSuffix == "-cover") dawn.singAnims = ["singLEFT-cover", "singDOWN-cover", "singUP-cover", "singRIGHT-cover"];
    else if(dawn.idleSuffix == "-morph") dawn.singAnims = ["singLEFT-morph", "singDOWN-morph", "singUP-morph", "singRIGHT-morph"];

    if(dawnbf.idleSuffix == "") dawnbf.singAnims = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
    else if(dawnbf.idleSuffix == "-cover") dawnbf.singAnims = ["singLEFT-cover", "singDOWN-cover", "singUP-cover", "singRIGHT-cover"];
}

var coverTime:FlxTimer = new FlxTimer();
function onPlayerHit(e){
    if(e.note.strumID == 4) {
        e.preventAnim();
        countAsCombo = false;
        countScore = false;
        if(dawn.idleSuffix == "")
        {
            dawn.playAnim('coveringTrans', true);
            dawn.idleSuffix = "-cover";
        }

        if(dawnbf.idleSuffix == "")
        {
            dawnbf.playAnim('coveringTrans', true);
            dawnbf.idleSuffix = "-cover";
        }
        
        coverTime.cancel();
        coverTime = new FlxTimer().start(0.25, ()->{
            if(dawn.idleSuffix != "-morph") dawn.idleSuffix = "";
            dawnbf.idleSuffix = "";
        });

    }
}

var missTime:FlxTimer = new FlxTimer();
function onPlayerMiss(e){
    if(e.note.strumID == 4){
        e.preventVocalsMute();
        e.healthGain = -0.2;

        inst.volume = 0;
        vocals.volume = 0;
        pitio.volume = 1;
        amount = 0.005;

        bruh = 10;
        missTime.cancel();
        missTime = new FlxTimer().start(5.25, ()->{
            amount = 0.1;
        });
    }
}