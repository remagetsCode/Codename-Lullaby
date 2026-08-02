
import flixel.addons.display.FlxBackdrop;

var amnt:Float = 0.4;
var minMistVel:Float = 50;
var maxMistVel:Float = 90;
public var mistGroup:Array = [];

function create(){
    if(FlxG.save.data.lullabyShaders){
        FlxG.camera.addShader(blur);
        FlxG.game.addShader(desat);
        FlxG.game.addShader(heat);
        FlxG.game.addShader(adjustColor);
        adjustColor.contrast = 37;
        heat.intensity = 0;
        heat.vel = 1;
    }

    // Mist cuz yes cuz dramatic effect
    mist0 = new FlxBackdrop(Paths.image('stages/pokecenter/images/mistBack'), 0x01);
    mist0.setPosition(-650, 850);
    mist0.scrollFactor.set(1.2, 1.2);
    mist0.color = 0xFF5c5c5c;
    mist0.alpha = 0.9;
    mist0.blend = 0;
    mist0.velocity.x = -FlxG.random.int(minMistVel, maxMistVel);
    insert(50, mist0);

    mist1 = new FlxBackdrop(Paths.image('stages/pokecenter/images/mistMid'), 0x01);
    mist1.setPosition(-650, 850);
    mist1.scrollFactor.set(1.2, 1.2);
    mist1.color = 0xFF5c5c5c;
    mist1.alpha = 0.8;
    mist1.blend = 0;
    mist1.velocity.x = -FlxG.random.int(minMistVel, maxMistVel);
    insert(51, mist1);

    mist2 = new FlxBackdrop(Paths.image('stages/pokecenter/images/mistBack'), 0x01);
    mist2.setPosition(-650, 850);
    mist2.scrollFactor.set(1.2, 1.2);
    mist2.color = 0xFF5c5c5c;
    mist2.alpha = 0.65;
    mist2.blend = 0;
    mist2.velocity.x = -FlxG.random.int(minMistVel, maxMistVel);
    insert(52, mist2);

    mist3 = new FlxBackdrop(Paths.image('stages/pokecenter/images/mistMid'), 0x01);
    mist3.setPosition(-650, 850);
    mist3.scrollFactor.set(1.2, 1.2);
    mist3.color = 0xFF5c5c5c;
    mist3.alpha = 0.6;
    mist3.blend = 0;
    mist3.velocity.x = -FlxG.random.int(minMistVel, maxMistVel);
    insert(53, mist3);

    mist4 = new FlxBackdrop(Paths.image('stages/pokecenter/images/mistFront'), 0x01);
    mist4.setPosition(-650, 850);
    mist4.scrollFactor.set(1.2, 1.2);
    mist4.color = 0xFF5c5c5c;
    mist4.alpha = 0.6;
    mist4.blend = 0;
    mist4.velocity.x = -FlxG.random.int(minMistVel, maxMistVel);
    insert(54, mist4);

    mistGroup.push(mist0);
    mistGroup.push(mist1);
    mistGroup.push(mist2);
    mistGroup.push(mist3);
    mistGroup.push(mist4);
}

function postCreate(){
    FlxG.signals.postUpdate.addOnce(() -> black.alpha = 1);

    modchart.setPercent('alpha', 0);
    modchart.ease('alpha', 61, 40, 0.5, FlxEase.cubeOut, 0);
    modchart.ease('alpha', 88, 2.5, 1, FlxEase.cubeOut, 1);

    nurse = stage.getSprite("...");
    nurse.origin.set(nurse.width/2, 0);
    FlxTween.angle(nurse, 5, -5, 2, {
		ease: FlxEase.sineInOut,
        type: 4
	});
}

var a:Float = 0.0;
function update(elapsed){
    heat.iTime = a += elapsed * br;
    blur.Size = bruh;
}

var bruh:Float = 20;
var bru:Int = 0;
var br:Float = 0;
function stepHit(step){
    desat.desaturationAmount = amnt;

    if(bru == 1) {heat.intensity = br = lerp(br, 1, 0.04);}
    if(bru == 2) {heat.intensity = br = lerp(br, 0, 0.05);}

    switch(step){
        case 0: FlxTween.tween(black, {alpha: 0.2}, 25);
            FlxTween.num(bruh, 0, 30, {
                onUpdate: (v)->{bruh = v.value;}
            });
        case 345:
            bf.playAnim('Pico Turn', true, false, 0, null);
            bf.animation.onFinish.addOnce(function() {bf.playAnim('turned', true);});
            new FlxTimer().start(1, ()->{
                bf.animation.play('Pico Turn', true, true);
            });

        case 355: bf.playAnim('Knife out', true);

        case 1152: bru++;

        case 1400: bru++;

        case 1432: FlxG.signals.postUpdate.addOnce(() -> dad.playAnim('jigglyturn', true, null, true));

        case 1856: FlxTween.tween(black, {alpha: 1}, 10);
    }
}
