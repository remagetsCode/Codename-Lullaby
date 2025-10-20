var amnt:Float = 1;
function create(){
    FlxG.game.addShader(desat);
    FlxG.game.addShader(heat);
    heat.intensity = 0;
    heat.vel = 0;
    desat.desaturationAmount = amnt;
}

var a:Float = 0.0;
function update(elapsed){
    heat.iTime = a += elapsed;
}

function stepHit(step){
    amnt = lerp(amnt, 1, 0.035);
    desat.desaturationAmount = amnt;
    switch(step){
        case 345:
            bf.playAnim('Pico Turn', true, false, 0, null);
            bf.animation.onFinish.addOnce(function() {bf.playAnim('turned', true);});
            new FlxTimer().start(1, ()->{
                bf.animation.play('Pico Turn', true, true);
            });

        case 355: bf.animation.play('Knife out', true);

        case 1152: FlxTween.num(0,1, 10, {
            onUpdate: function(v){heat.vel = v.value; heat.intensity = v.value;} 
        });

        case 1400: FlxTween.num(1,0, 3, {
            onUpdate: function(v){heat.vel = v.value; heat.intensity = v.value;} 
        });

        case 1432: new FlxTimer().start(0.02, ()->{dad.playAnim('jigglyturn', true, null, true);});

        case 1856: FlxTween.tween(black, {alpha: 1}, 15);
    }
}

function onDadHit(){
    amnt = lerp(amnt, 0, 0.4);
}