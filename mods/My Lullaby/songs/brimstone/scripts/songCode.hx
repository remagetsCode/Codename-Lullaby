import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

var directions = ["LEFT", "DOWN", "UP", "RIGHT"];
function create(){
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
    modchart.setPercent('opponentSwap', 1.14);
    modchart.setPercent('reverse', downscroll ? 0 : 1, 0);
    modchart.setPercent('y', -30, 0);
    modchart.setPercent('y', downscroll ? -30 : 0, 1);
    buryman.playAnim('buryman_ground', true);

    healthBar.visible = false;
    healthBarBG.visible = false;
    iconP1.visible = false;
    iconP2.visible = false;

    gengarEnt = new FlxSprite(485, 20);
    gengarEnt.frames = Paths.getFrames("characters/buried/enter_gengar");
    gengarEnt.animation.addByPrefix('enter', 'gengar', 24, false);
    gengarEnt.animation.onFinish.addOnce(function(_){
        gengarEnt.alpha = 0;
        gengar.alpha = 1;
    });
    gengarEnt.alpha = 0;
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
    
    wa = new FlxSprite(350, -1);
    wa.frames = Paths.getFrames("characters/buried/WA_assets");
    wa.animation.addByPrefix('idle', 'WH_Idle', 24, true);
    wa.animation.addByPrefix('intro', 'WH_Intro', 24, false);
    wa.animation.addByPrefix('gf', 'WH_ToGF', 24, false);
    wa.animation.onFinish.add(function(a){
        switch(a){
            case "intro": wa.animation.play('idle');
            case "gf": wa.kill(); fakegf.alpha = 1;
        }
    });
    wa.scale.set(3, 3);
    wa.alpha = 0;
    add(wa);
}

var time:Float = 0;
function update(e){
    missingno.iTime = time += e;
    hpBar.percent = health*50;
    cpuBar.percent = (2.05-health)*50;
}

function stepHit(s){
    switch(s){
        case 1: holds.visible = false;
        
        case 123: buryman.playAnim('buryman_scream', true);

        case 940: 
            gengarEnt.alpha = 1;
            gengarEnt.animation.play('enter');

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
            gengarEnt.alpha = 1;
            gengar.alpha = 0;
            gengarEnt.animation.play('enter', false, true);
        case 2390:
            gengarEnt.kill();
            gengar.kill();
        case 2400: 
            FlxTween.tween(missingnobf, {y: 1000}, 0.8, {ease: FlxEase.quintOut});
            FlxTween.tween(bfxml, {x: bfxml.x + 100}, 1, {ease: FlxEase.quintOut});

        case 2704:
            loan.alpha = 1;
            loan.playAnim('Muk_Intro');

        case 2954:
            wa.alpha = 1;
            wa.animation.play('intro');

        case 3464:
            loan.playAnim('Muk_Intro');
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
        default:
            e.preventAnim();
            bfxml.playSingAnim(e.direction);
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