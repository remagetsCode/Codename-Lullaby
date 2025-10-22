var amnt:Float = 1;
function create(){
    if(FlxG.save.data.lullabyShaders){
        FlxG.game.addShader(desat);
        FlxG.game.addShader(heat);
        heat.intensity = 0;
        heat.vel = 0;
        desat.desaturationAmount = amnt;
    }
}

var a:Float = 0.0;
function update(elapsed){
    heat.iTime = a += elapsed;
}

var bru:Int = 0;
var br:Float = 0;
function stepHit(step){
    

    amnt = lerp(amnt, 1, 0.035);
    desat.desaturationAmount = amnt;

    if(bru == 1) {heat.intensity = br = lerp(br, 1, 0.05); heat.vel = br;}
    if(bru == 2) {heat.intensity = br = lerp(br, 0, 0.1); heat.vel = br;}

    switch(step){
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