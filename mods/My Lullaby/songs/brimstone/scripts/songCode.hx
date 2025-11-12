import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

var directions = ["LEFT", "DOWN", "UP", "RIGHT"];
introLength = 0;
function create(){
    player.cpu = true;
    camGame.addShader(heat1);
    heat1.intensity = 1;
    heat1.v_comp = 5.0;
    
    buryman = cpu.characters[0];
    gengar = cpu.characters[1];
    fakegf = cpu.characters[2];
    loan = cpu.characters[3];

    missingnobf = player.characters[0];
    bfxml = player.characters[1];

    gengar.alpha = 0;
    fakegf.alpha = 0;
    loan.alpha = 0;
    missingnobf.alpha = 0;

    hudp = new FunkinSprite(120,95).loadGraphic(Paths.image("UI/pixel/buried_center"));
    hudp.camera = camHUD;
    hudp.scale.set(3.5,3.5);
    add(hudp);

    hudo = new FunkinSprite(FlxG.width-320, downscroll ? 95 : FlxG.height-145).loadGraphic(Paths.image("UI/pixel/buried_center"));
    hudo.camera = camHUD;
    hudo.scale.set(3.5,3.5);
    add(hudo);

    hpBar = new FlxBar(
		145, downscroll ? 42 : 196,
		FlxBarFillDirection.LEFT_TO_RIGHT,
		175, 5
	);

	hpBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.CYAN);
    hpBar.cameras = [camHUD];
	hpBar.numDivisions = 200;
	hpBar.camera = camHUD;
	add(hpBar);

    cpuBar = new FlxBar(
		984, downscroll ? 42 : FlxG.height-44,
		FlxBarFillDirection.RIGHT_TO_LEFT,
		175, 5
	);

	cpuBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.fromRGB(107, 130, 149));
    cpuBar.cameras = [camHUD];
	cpuBar.numDivisions = 200;
	cpuBar.camera = camHUD;
	add(cpuBar);

    if(downscroll) {bfxml.y -= 200; missingnobf.y -= 200;}
}

function postCreate(){
    camExtra = new FlxCamera(0, 0);
    camExtra.bgColor = FlxColor.TRANSPARENT;
    FlxG.cameras.add(camExtra, false);

    modchart.setPercent('opponentSwap', 1.14);
    modchart.setPercent('reverse', downscroll ? 0 : 1, 0);
    modchart.setPercent('y', -30, 0);
    modchart.setPercent('y', downscroll ? -30 : 0, 1);
    buryman.playAnim('buryman_ground', true);

    healthBar.visible = false;
    healthBarBG.visible = false;
    iconP1.visible = false;
    iconP2.visible = false;

    bars = [];
    for(i in 0...20){
        var bar = new FlxSprite(0, 0).makeGraphic(FlxG.width, 46, FlxColor.BLACK);
        bar.setPosition(0, i*bar.height);
        bar.camera = camExtra;
        bars.push(bar);
        add(bar);
        new FlxTimer().start(0.05, ()->{
            bar.x += i%2==1 ? -30 : 30;
        },50);
    }

    bfxml.x += 1280;
    new FlxTimer().start(2, ()->FlxTween.tween(bfxml, {x:bfxml.x - 1280}, 1.5, {onComplete: ()->for(b in bars) b.destroy()}));

    gengarEnt = new FlxSprite(763, 240);
    gengarEnt.frames = Paths.getFrames("characters/buried/enter_gengar");
    gengarEnt.animation.addByPrefix('enter', 'gengar', 24, false);
    gengarEnt.animation.onFinish.addOnce(function(_){
        gengarEnt.alpha = 0;
        gengar.alpha = 1;
    });
    gengarEnt.alpha = 0;
    gengarEnt.camera = camExtra;
    gengarEnt.scale.set(3,3);
    add(gengarEnt);

    pkball = new FlxSprite(-100, downscroll ? 150 : 250);
    pkball.frames = Paths.getFrames("characters/buried/missingnopokeball_assets");
    pkball.animation.addByPrefix('throw', 'Ball_Throw', 24, false);
    pkball.animation.addByPrefix('idle1', 'Ball_Idle_Normal', 24, true);
    pkball.animation.addByPrefix('break1', 'Ball_Break01', 24, false);
    pkball.animation.addByPrefix('idle2', 'Ball_Idle_Break01', 24, true);
    pkball.animation.addByPrefix('break2', 'Ball_Break02', 24, false);
    pkball.animation.addByPrefix('idle3', 'Ball_Idle_Break02', 24, true);
    pkball.animation.addByPrefix('final', 'Ball_Final', 24, false);

    pkball.animation.onFinish.add(function(a){
        switch(a){
            case "throw": pkball.animation.play('idle1');
            case "break1": pkball.animation.play('idle2');
            case "break2": pkball.animation.play('idle3');
            case "final": pkball.kill();
            default: //nothing
        }
    });
    pkball.scale.set(3,3);
    insert(13, pkball);


    
    wa = new FlxSprite(251, -122);
    wa.frames = Paths.getFrames("characters/buried/WA_assets");
    wa.animation.addByPrefix('idle', 'WH_Idle', 24, true);
    wa.animation.addByPrefix('intro', 'WH_Intro', 24, false);
    wa.animation.addByPrefix('gf', 'WH_ToGF', 24, false);
    wa.animation.onFinish.add(function(a){
        switch(a){
            case "intro": 
                FlxTween.tween(wa, {y: wa.y + 10}, 1.5, {type: 4, ease: FlxEase.quadInOut});
                wa.animation.play('idle');
            case "gf": wa.kill(); fakegf.alpha = 1;
        }
    });
    wa.scale.set(3, 3);
    wa.alpha = 0;
    wa.updateHitbox();
    insert(6, wa);

    waShad = new FlxSprite(wa.x, wa.y + 100).loadGraphic(Paths.image("characters/buried/shadow"));
    waShad.scale.set(3,3);
    waShad.updateHitbox();
    waShad.alpha = 0;
    add(waShad);

    nogega = new FlxSprite(200, 350).loadGraphic(Paths.image("UI/pixel/nogega"));
    nogega.camera = camHUD;
    nogega.scale.set(6,6);
    nogega.alpha = 0;
    //nogega.screenCenter(FlxAxes.X);
    //617
    add(nogega);
}

var time:Float = 0;
function update(e){
    missingno.iTime = time += e;
    heat1.iTime = time;
    hpBar.percent = health*50;
    cpuBar.percent = (2.05-health)*50;
}

function stepHit(s){
    hpBar.color = CoolUtil.lerpColor(hpBar.color, FlxColor.WHITE, 0.08);
    switch(s){
        case 1: holds.visible = false;

        case 96: shake();
        case 112: shake();
        case 128: shake();
        case 136: shake();
        case 144: shake();
        
        case 123: buryman.playAnim('buryman_scream', true);

        case 940: 
            gengarEnt.alpha = 1;
            gengarEnt.animation.play('enter');

        case 1272:
            nogega.alpha = 1;
            FlxTween.tween(nogega, {alpha: 0.3}, 5);

        case 1281:
            FlxTween.tween(nogega, {"scale.x": 3, "scale.y": 3, x:580, y: 80}, 2, {ease: FlxEase.circInOut});

        case 1593:
            FlxTween.tween(pkball, {x: 150, y: 200}, 0.1);
            pkball.animation.play('throw');
        case 1620: pkball.animation.play('break1');
        case 1665: pkball.animation.play('break2');
        case 1710: 
            FlxTween.tween(bfxml, {x: bf.xml.x-70}, 1);
            FlxTween.tween(missingnobf, {x: bf.xml.x-140}, 1);
            pkball.animation.play('final');
        case 1730: missingnobf.alpha = 1;
        case 2385:
            FlxTween.tween(nogega, {alpha: 0}, 1, {onComplete: nogega.destroy});
            gengarEnt.alpha = 1;
            gengar.alpha = 0;
            gengarEnt.animation.play('enter', false, true);
        case 2390:
            gengarEnt.kill();
            gengar.kill();
        case 2395: 
            FlxTween.tween(missingnobf, {y: 1000}, 0.8, {ease: FlxEase.quintOut, onComplete: missingno.kill});
            FlxTween.tween(bfxml, {x: bfxml.x + 120}, 1, {ease: FlxEase.quintOut});

        case 2700:
            loan.alpha = 1;
            loan.playAnim('Muk_Intro');

        case 3240:
            wa.alpha = 1;
            wa.animation.play('intro');
            FlxTween.tween(waShad, {alpha: 1}, 1);

        case 3450:
            loan.playAnim('Muk_Intro', true, null, true);
        case 3460:
            wa.animation.play('gf');
            loan.kill();
    }
}

function onPlayerHit(e){
    switch(e.note.noteType){
        case "missingno-bf":
            e.preventAnim();
            missingnobf.playSingAnim(e.direction);
        case "geng note":
            e.preventAnim();
            bfxml.playAnim("BF_AURGH", true);
            FlxG.sound.play(Paths.sound("errorMenu"), 2);
            e.healthGain = -0.2;
            hpBar.color = FlxColor.PURPLE;
            FlxTween.shake(nogega, 0.07, 1);
        default:
            e.preventAnim();
            bfxml.playSingAnim(e.direction);
    }
}

function onPlayerMiss(e){
    if(e.note.noteType == "geng note"){
        e.cancel();
    }
}

function onDadHit(e){
    switch(e.note.noteType){
        case "gengar":
            e.preventAnim();
            gengar.playSingAnim(e.direction);
        case "loan":
            e.preventAnim();
            loan.playSingAnim(e.direction); 
        case "fake":
            e.preventAnim();
            fakegf.playSingAnim(e.direction); 
        default:
            e.preventAnim();
            buryman.playSingAnim(e.direction);
    }
}

inline function shake(){
    modchart.set('vibrate',curBeatFloat, 1, 0);
    modchart.ease('vibrate', curBeatFloat+0.5, 0.7, 0, FlxEase.cubeOut, 0);

    new FlxTimer().start(0.05, ()->{
        if(!window.fullscreen){
            window.x += FlxG.random.int(-5, 5);
            window.y += FlxG.random.int(-5, 5);
        }
    }, 4);
    FlxTween.shake(buryman, 0.05, 0.5, FlxAxes.X);

}

function loanCums(){
    loan.playAnim("Muk_Puke", true);
    new FlxTimer().start(0.25, ()->{
        var muk = new FlxSprite();
        muk.frames = Paths.getFrames('characters/buried/muksludge');
        muk.animation.addByPrefix('sludge', 'Sludge_0'+FlxG.random.int(1,3), 24, false);
        muk.animation.play('sludge');
        muk.camera = camExtra;
        muk.scale.set(3,3);
        muk.updateHitbox();
        muk.screenCenter();
        muk.alpha = 0;
        add(muk);

        FlxG.sound.play(Paths.sound('MukCums'), 3);
        bfxml.playAnim("BF_AURGH", true);

        FlxTween.tween(muk, {alpha: 1}, 0.1);
        new FlxTimer().start(1, ()->FlxTween.tween(muk, {alpha: 0}, 4, {onComplete: muk.destroy}));
    });

}