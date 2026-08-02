

var stevenpov;
var steven2;
var steven3;

var mikebed;
var mike2;

function create() {
    if(FlxG.save.data.lullabyShaders) FlxG.game.addShader(aberration);
    aberration.amount = 0;
    stevenpov = strumLines.members[0].characters[0];
    steven2 = strumLines.members[0].characters[1];
    steven3 = strumLines.members[0].characters[2];
    steven4 = strumLines.members[0].characters[3];

    mikebed = strumLines.members[1].characters[0];
    mike2 = strumLines.members[1].characters[1];

    remove(mikebed);
    insert(members.indexOf(steven2)-1, mikebed);

    remove(steven2);
    insert(5, steven2);
    steven2.x += 250;

    steven3.visible = false;
    steven4.visible = false;
    mike2.visible = false;

    stevenpov.scrollFactor.set(0,0);
    stevenpov.screenCenter(FlxAxes.X);
    stevenpov.y = 250;

    blak = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blak.scrollFactor.set(0,0);
    blak.zoomFactor = 0;
    insert(members.indexOf(stevenpov),blak);

    blak2 = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blak2.scrollFactor.set(0,0);
    blak2.zoomFactor = 0;
    blak2.alpha = 0;
    insert(17,blak2);

    red = new FlxSprite().loadGraphic(Paths.image("stages/mikes-room/images/redoverlay"));
    red.cameras = [camHUD];
    red.alpha = 0;
    add(red);

    camHUD.alpha = 0;
}

function beatHit(b) {
    switch(b) {
        case 32:
            FlxTween.tween(camHUD, {alpha: 1}, 1);
            stevenpov.exists = false;
            blak.visible = false;
        case 100:
            steven2.exists = false;
            mikebed.exists = false;

            blak.visible = true;
            steven4.visible = true;
            mike2.visible = true;
            mike2.x = 850;
            mike2.y = -800;
            steven4.y += 700;
            FlxTween.tween(mike2, {y: -200}, 5, {ease: FlxEase.quadOut});
            FlxTween.tween(steven4, {y: steven4.y-700}, 5, {ease: FlxEase.quadOut});

            aberration.amount = 0.3;
            iconDAD.setIcon('icon-steven-evil');
            drain = true;

        case 226:
            black.alpha = 1;
            steven3.visible = true;
            steven3.screenCenter();
            steven3.x += 400;
            steven3.y += 150;
            remove(steven3);
            insert(20, steven3);

            blak2.alpha = 0.7;
            FlxTween.tween(red, {alpha: 1}, 6);
        case 227:
            black.alpha = 0;
        case 260:
            FlxTween.tween(red, {alpha: 0}, 2);
        case 360:
            FlxG.sound.play(Paths.sound('DissensionDeath'));
            red.alpha = 1;
            FlxTween.tween(red, {alpha: 0}, 2);

            FlxTween.tween(mike2, {y: -800}, 1.5, {ease: FlxEase.quadIn});
    }
}

var drain:Bool = false;
function stepHit() {
    if(drain && FlxG.save.data.lullabyMechanics) health -= health > 0.15 ? 0.03 : 0;
}