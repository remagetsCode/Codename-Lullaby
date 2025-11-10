var amnt:Float = 1;

function create(){
    if(FlxG.save.data.lullabyShaders){
        FlxG.camera.addShader(blur);
        FlxG.game.addShader(desat);
        FlxG.game.addShader(heat);
        heat.intensity = 0;
        heat.vel = 1;
        desat.desaturationAmount = amnt;
    }
}

function postCreate(){
    new FlxTimer().start(0.03, ()->{
        black.alpha = 1;
    });
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
    
    amnt = lerp(amnt, 1, 0.035);
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

        case 1432: new FlxTimer().start(0.02, ()->{dad.playAnim('jigglyturn', true, null, true);});

        case 1856: FlxTween.tween(black, {alpha: 1}, 10);
    }
}

function onDadHit(){
    amnt = lerp(amnt, 0, 0.4);
}