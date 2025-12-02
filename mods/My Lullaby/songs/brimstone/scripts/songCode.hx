import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

var directions = ["LEFT", "DOWN", "UP", "RIGHT"];
introLength = 0;
function create(){
    //player.cpu = true;
    if(FlxG.save.data.lullabyShaders){
        bur = stage.getSprite("buried");
        
        bur.shader = heat1;
        desat.desaturationAmount = 1;
        heat1.intensity = 0;
        heat1.v_comp = 5.0;
        camGame.addShader(desat);
        FlxG.game.addShader(gameboy);
    }

    
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

    bars = [];
    for(i in 0...20){
        var bar = new FlxSprite(0, 0).makeGraphic(FlxG.width, 46, FlxColor.BLACK);
        bar.setPosition(0, i*bar.height);
        bar.camera = camExtra;
        bars.push(bar);
        add(bar);
        new FlxTimer().start(0.05, ()->{
            bar.x += i%2==1 ? -35 : 35;
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

    pkball = new FlxSprite(-100, downscroll ? 150 : 300);
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
    pkball.alpha = 0;
    insert(10, pkball);
    
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

    waShad = new FlxSprite(wa.x, wa.y + 50).loadGraphic(Paths.image("characters/buried/shadow"));
    waShad.scale.set(3,3);
    waShad.updateHitbox();
    waShad.alpha = 0;
    insert(7, waShad);

    nogega = new FlxSprite(200, 350).loadGraphic(Paths.image("UI/pixel/nogega"));
    nogega.camera = camHUD;
    nogega.scale.set(6,6);
    nogega.alpha = 0;
    add(nogega);

    red = new FlxSprite().loadGraphic(Paths.image("UI/base/badvignettered"));
    red.camera = camExtra;
    red.setGraphicSize(FlxG.width, FlxG.height);
    red.updateHitbox();
    red.alpha = 0;
    add(red);

    accuracyTxt.y = missesTxt.y = scoreTxt.y = 5;
	
	new FlxTimer().start(0.01, ()->{
		for (i in [uiStuff.members[0], uiStuff.members[1], iconBF, iconDAD]) i.visible = false;	
	});
}

var time:Float = 0;
function update(e){
    missingno.iTime = time += e;
    heat1.iTime = time*0.15;
    hpBar.percent = health*50;
    cpuBar.percent = (2.05-health)*50;
    waShad.setPosition(fakegf.x-469, -50);
    waShad.scale.set(2.5+(fakegf.y+68)*0.03,2.5+(fakegf.y+68)*0.01);    // Yeah, detail that 99.999999999999999999% of people wont notice. Ps: there must be a better way to do this.
}

function stepHit(s){
    hpBar.color = CoolUtil.lerpColor(hpBar.color, FlxColor.WHITE, 0.08);
    switch(s){
        case 1: holds.visible = false;

        // Buryman raising
        case 50: setMarginColor(FlxColor.fromRGB(136, 192, 112));
        case 96: shake();
        case 112: shake();
        case 128: shake();
        case 136: shake();
        case 144: shake();
        case 125: buryman.playAnim('buryman_scream', true);

        //gamemboy green color off
        case 416: 
            setMarginColor(FlxColor.GRAY);
            FlxTween.num(1, 0, 0.5, {onUpdate: (v)->gameboy.interpolation = v.value});

        // gengar entrance
        case 932: FlxTween.tween(camHUD, {alpha: 0}, 1);
        case 940: 
            setMarginColor(FlxColor.fromRGB(154, 120, 183));
            gengarEnt.alpha = 1;
            gengarEnt.animation.play('enter');
        case 970: FlxTween.tween(camHUD, {alpha: 1}, 1);
        case 1050: setMarginColor(FlxColor.GRAY);

        // Starts throwing gengar notes
        case 1272:
            setMarginColor(FlxColor.fromRGB(164, 80, 193));
            nogega.alpha = FlxG.save.data.lullabyMechanics;
            FlxTween.tween(nogega, {alpha: 0.3}, 5);
        case 1281:
            FlxTween.tween(nogega, {"scale.x": 3, "scale.y": 3, x:580, y: 80}, 2, {ease: FlxEase.quintInOut});

        // Bf throws pokeball
        case 1593:
            pkball.alpha = 1;
            FlxTween.tween(pkball, {x: 150, y: 200}, 0.07);
            pkball.animation.play('throw');
        case 1620: pkball.animation.play('break1');
        case 1665: pkball.animation.play('break2');
        case 1710: 
            FlxTween.tween(bfxml, {x: bf.xml.x-70}, 1);
            FlxTween.tween(missingnobf, {x: bf.xml.x-140}, 1);
            pkball.animation.play('final');
        case 1730: missingnobf.alpha = 1;

        // Starts gameboy green color again, gengar and missingno are out
        case 2385:
            setMarginColor(FlxColor.fromRGB(136, 192, 112));
            FlxTween.num(0, 1, 1, {onUpdate: (v)->gameboy.interpolation = v.value});
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

        // green color off and loanmonster enters
        case 2656: FlxTween.num(1, 0, 0.5, {onUpdate: (v)->gameboy.interpolation = v.value});
        case 2700:
            setMarginColor(FlxColor.fromRGB(191, 164, 211));
            loan.alpha = 1;
            loan.playAnim('Muk_Intro');

        // white hand appears
        case 3240:
            wa.alpha = 1;
            wa.animation.play('intro');
            FlxTween.tween(waShad, {alpha: 1}, 1);

        // white hand transforms
        case 3450:
            loan.playAnim('Muk_Intro', true, null, true);
        case 3460:
            setMarginColor(FlxColor.RED);
            wa.animation.play('gf');
            loan.kill();
            FlxTween.num(0, 3, 5, {onUpdate: (v)->heat1.intensity = v.value});
            FlxTween.num(1, 0.2, 7, {onUpdate: (v)->desat.desaturationAmount = v.value});
            FlxTween.tween(waShad, {y: -22}, 2);
        case 3468:
            apparitiongf = true;
        case 3616: FlxTween.tween(camHUD, {alpha: 1}, 2);

        // idk
        case 4192: FlxTween.num(0.2, 0.5, 5, {onUpdate: (v)->desat.desaturationAmount = v.value});
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
            FlxG.sound.play(Paths.sound("GengarNoteSFX"), 1);
            e.healthGain = -0.2;
            hpBar.color = FlxColor.PURPLE;
            FlxTween.shake(nogega, 0.09, 1);
        default:
            e.preventAnim();
            bfxml.playSingAnim(e.direction);
    }
}

function onPlayerMiss(e){
    if(e.note.noteType == "geng note"){
        #if mobile
        e.preventAnim();
        e.preventMissSound();
        e.preventResetCombo();
        e.preventStunned();
        e.preventVocalsMute();
        e.healthGain = 0;
        e.misses = 0;
        e.accuracy = null;
        #else
        e.cancel(); // Dunno why, but this lags a lot in mobile
        #end
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

    FlxTween.shake(buryman, 0.05, 0.5, FlxAxes.X);

}

function loanCums(){
    if(!FlxG.save.data.lullabyMechanics) return;

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

var gfTween:FlxTween;
var apparitiongf:Bool = false;
function measureHit(){
    if(apparitiongf) FlxTween.tween(red, {alpha: 0.2}, 0.05, {onComplete: ()->FlxTween.tween(red, {alpha: 0}, 1)});
    if(apparitiongf && gfTween == null) gfTween = FlxTween.circularMotion(fakegf, fakegf.x, fakegf.y-18, 20, 0, true, 10, true,{type: 2});
}