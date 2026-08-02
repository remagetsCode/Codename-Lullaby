var chars:Array = ["MX_", "LordX_", "Hypno_"];
var charSprites:Array = [];
var offsets:Array = [-27, 15, 0];
var hypno:Array = [];
var mx:Array = [];
var lordx:Array = [];

var curSelected:Int = 0;
var selected:Bool = false;
var canMove:Bool = true;

public var crt = new CustomShader('crt');
function postCreate(){
    selectorCam = new FlxCamera();
    selectorCam.bgColor = FlxColor.BLACK;
    FlxG.cameras.add(selectorCam, false);

    selectorCam.width = 840;
    selectorCam.x = 250;

    if(FlxG.save.data.lullabyShaders) selectorCam.addShader(crt);

    fuckingoldmusic = FlxG.sound.play(Paths.sound('PastaNightSelect'), 1, true);
    
    var path = 'UI/base/pasta/PastaSelect_';
    bg = new FlxSprite().loadGraphic(Paths.image(path + 'BG'));
    bg.cameras = [selectorCam];
    bg.scale.set(3,3);
    bg.screenCenter();
    add(bg);

    arrow = new FlxSprite(0, 350).loadGraphic(Paths.image(path + 'Arrow'));
    arrow.cameras = [selectorCam];
    arrow.scale.set(2,2);
    add(arrow);

    for(idx=>character in chars){   
        trace(idx); 
        for(i in 1...4){
            char = new FlxSprite(220+idx*170, 500+offsets[idx]).loadGraphic(Paths.image(path + character + "0" + i));
            char.cameras = [selectorCam];
            char.scale.set(3,3);
            //char.screenCenter();
            add(char);

            switch(character) {
                case "Hypno_": hypno.push(char);
                case "MX_": mx.push(char);
                case "LordX_": lordx.push(char);
            }
        }
    }

    for(i in [bg, arrow]) i.x -= 220;
}

var time:Float = 0;
function update(e) {
    crt.time = time += e/2;
    if(!canMove) return;

    var right = controls.NOTE_RIGHT_P;
    var left = controls.NOTE_LEFT_P;
    if(right || left) change((right ? 1 : 0) + (left ? -1 : 0));

    if(controls.ACCEPT) select();

    for(idx=>char in [mx, lordx, hypno]) {
        char[0].alpha = curSelected == idx && !selected ? 1 : 0;
        char[1].alpha = (curSelected == idx) && selected ? 1 : 0;
        char[2].alpha = curSelected != idx ? 1 : 0;
    }
    arrow.x = curSelected == 0 ? mx[0].x+25 : curSelected == 1 ? lordx[0].x+5 : hypno[0].x;
}

function change(huh) {
    curSelected = FlxMath.wrap(curSelected + huh, 0, chars.length - 1);
}

function select() {
    selected = true;
    canMove = false;

    switch(curSelected) {
        case 0: 
            asHypno = false; 
            asMX = true;
            asLordX = false;
        case 1: 
            asMX = false; 
            asHypno = false;
            asLordX = true;
        case 2: 
            asLordX = false; 
            asHypno = true;
            asMX = false;
    }
    new FlxTimer().start(1.48, ()->selectorCam.setFilters([]));
    new FlxTimer().start(1.5, ()->{
        selectorCam.destroy();
        fuckingoldmusic.destroy();
        close();
    });
}