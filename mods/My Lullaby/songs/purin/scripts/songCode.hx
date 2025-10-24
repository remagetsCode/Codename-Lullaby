var amnt:Float = 1;
function create(){
    if(FlxG.save.data.lullabyShaders){
        FlxG.camera.addShader(blur);
        FlxG.game.addShader(desat);
        FlxG.game.addShader(heat);
        heat.intensity = 0;
        heat.vel = 0;
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
}

var a:Float = 0.0;
function update(elapsed){
    heat.iTime = a += elapsed;
    blur.Size = bruh;
}

var bruh:Float = 20;
var bru:Int = 0;
var br:Float = 0;
function stepHit(step){
    
    amnt = lerp(amnt, 1, 0.035);
    desat.desaturationAmount = amnt;

    if(bru == 1) {heat.intensity = br = lerp(br, 1, 0.05); heat.vel = br;}
    if(bru == 2) {heat.intensity = br = lerp(br, 0, 0.1); heat.vel = br;}

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

function beatHit(beat){
    //switch(beat){
    //case 502:         money = new FlxSprite(FlxG.width-150, -30);
    //    money.frames = Paths.getFrames('UI/base/moneybag');
    //    money.animation.addByPrefix('idle', 'Moneybag final', 24, false);
    //    money.animation.play('idle');
    //    money.cameras = [camHUD];
    //    add(money); 
//
    //    m = new FunkinText(money.x+20, 690, 0, "", 24, false);
    //    m.color = FlxColor.YELLOW;
    //    m.text = "+";
    //    m.cameras = [camHUD];
    //    add(m);
    //}
}

function onDadHit(){
    amnt = lerp(amnt, 0, 0.4);
}