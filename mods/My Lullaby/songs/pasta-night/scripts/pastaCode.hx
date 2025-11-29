
public static var asMX:Bool = false;
public static var asHypno:Bool = false;
public static var asLordX:Bool = false;

var mxStrum;
var hypnoStrum;
var lordxStrum;
var addedShader:Bool = false;

introLength = 1;
function postCreate(){
    mxStrum = strumLines.members[0];
    hypnoStrum = strumLines.members[2];
    lordxStrum = strumLines.members[1];

    mx = strumLines.members[0].characters[0];
    mxArm = strumLines.members[0].characters[1];

    //if(!asMX && !asHypno && !asLordX){
        persistentUpdate = false;
        persistentDraw = false;
        openSubState(new ModSubState('CharacterSelect'));
    //}

    block = new FlxSprite(-38, 900);
    block.frames = Paths.getFrames('mxblock');
    block.animation.addByPrefix('idle', 'Block', 24, false);
    insert(99, block);

    remove(iconDAD);
    insert(5, iconDAD);
    remove(iconBF);
    insert(6, iconBF);

    camHUD.alpha = 0;
}

subStateClosed.add(function(){
    if(!addedShader && FlxG.save.data.lullabyShaders) {
        camGame.addShader(old); 
        addedShader = true;
    }
});

function onCountdown(e) e.cancel();

function beatHit(b) {
    block.animation.play('idle');
    if(b == 1) holds.visible = false;
    switch(b) {
        case 2: FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.quadOut});
        case 40 | 63 | 84 | 106 | 111 | 133 | 143 | 168 | 177 | 186 | 191 | 250 | 262 | 274 | 284 | 292 | 299: mxHit();
    }

}

function onSongStart() {
    iconDAD.setIcon(asMX ? 'icon-lord-x' : asHypno ? 'icon-mx' : 'icon-hypno-cards');
    iconBF.setIcon(asMX ? 'icon-mx' : asHypno ? 'icon-hypno-cards' : 'icon-lord-x');
}

var time:Float = 0;
function update(e) {
    old.iTime = time += e;
    //trace(asMX, asHypno, asLordX);
    modchart.setPercent('x', -100, 0);
    modchart.setPercent('x', -320, 1);
    modchart.setPercent('x', 740, 2);

    modchart.setPercent('z', asMX ? 0 : -100, 0);
    modchart.setPercent('z', asLordX ? 0 : -100, 1);
    modchart.setPercent('z', asHypno ? 0 : -100, 2);

    modchart.setPercent('alpha', asMX ? 1 : 0.4, 0);
    modchart.setPercent('alpha', asLordX ? 1 : 0.4, 1);
    modchart.setPercent('alpha', asHypno ? 1 : 0.4, 2);

    FlipIcons = false;
    if(asMX) {
        FlipIcons = true;
        customHealthBarColors = [0x3A0101, bfColor];
        iconDAD.flipX=true;
        iconBF.flipX=true;
    }
    else if(asLordX) customHealthBarColors = [0xBDB004, bfColor];
    else customHealthBarColors = [0x3A0101, 0xBDB004];

    scrollSpeed = asLordX ? 2.9 : 3.9;

    mxStrum.cpu = !asMX ? true : false;
    hypnoStrum.cpu = !asHypno ? true : false;
    lordxStrum.cpu = !asLordX ? true : false;
}

function onPlayerHit(e) {
    e.healthGain = 0;
    health += 0.05;
}

function onPlayerMiss(e) {
    e.healthGain = 0;
    health -= 0.05;
}

function mxHit() {
    if(asMX || !FlxG.save.data.lullabyMechanics) return;
    var time:Float = 0.5;

    mx.playAnim('Hit1Back');
    mxArm.playAnim('Hit1Front');
    new FlxTimer().start(time, ()->{
        FlxG.sound.play(Paths.sound('POW'));
        block.alpha = 0;
        mx.playAnim('Hit2Back');
        mxArm.playAnim('Hit2Front');

        for(i in 0...4) {
            modchart.ease('reverse'+i, curBeat, 1.5, 0.5, FlxEase.cubeIn);
            modchart.ease('reverse'+i, curBeatFloat+0.55, 1+0.15*i, modchart.getPercent('reverse'+i) == 1 ? 0 : 1 , FlxEase.bounceOut);
        };
    });
    new FlxTimer().start(time+0.65, ()->{
        block.alpha = 1;
    });
}