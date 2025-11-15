
var curSelected:Int = 0;
var canMove:Bool = false;
var cgSound = FlxG.sound.load(Paths.sound('cartridgeguy/cartridgeGuy'), 0.5);

function create(){
    cg = new FlxSprite(0, -70);
    cg.frames = Paths.getFrames("menus/cartridgeguy/CartridgeGuy_Cutscene");
    cg.animation.addByPrefix('1', 'CG_Cutscene_01', 20, false);
    cg.animation.addByPrefix('2', 'CG_Cutscene_02', 20, false);
    cg.animation.play('1');
    cg.scale.set(0.8, 0.8);
    cg.antialiasing = true;
    cg.screenCenter(FlxAxes.X);
    add(cg);

    textBox = new FlxSprite(0, 440).loadGraphic(Paths.image('menus/cartridgeguy/textBox'));
    textBox.screenCenter(FlxAxes.X);
    add(textBox);
    
    text = new FlxTypeText(470, 465, 350, "Hello Player,", 36);
    text.alignment = "center";
    text.setFormat(Paths.font("pokefont.ttf"), 38, 0xFFFFFF);
    text.start(0.05);
    text.sounds = [cgSound];
    add(text);

    yes = new FlxText(490, 640, 0, "YES", 30);
    yes.setFormat(Paths.font("pokefont.ttf"), 30, 0xFFFFFF);
    yes.alpha = 0;
    add(yes);

    no = new FlxText(710, 640, 0, "NO", 30);
    no.setFormat(Paths.font("pokefont.ttf"), 30, 0xFFFFFF);
    no.alpha = 0;
    add(no);

    new FlxTimer().start(2, ()->{
        cg.animation.play('2');
        text2 = new FlxTypeText(480, 515, 400, "want a free videogame?", 40);
        text2.setFormat(Paths.font("pokefont.ttf"), 38, 0xFFFFFF);
        text2.sounds = [cgSound];
        text2.start(0.05);
        add(text2);
    });

    new FlxTimer().start(4, ()->{
        canMove = true;
        FlxTween.tween(yes, {alpha: 1}, 3);
        FlxTween.tween(no, {alpha: 1}, 3);
    });

    black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    black.alpha = 0;
    
}

function update(){
    var leftP:Bool = controls.LEFT_P;
	var rightP:Bool = controls.RIGHT_P;
	var scroll = FlxG.mouse.wheel;

    if(canMove){
	    if (leftP || rightP || scroll != 0){
            FlxG.sound.play(Paths.sound("scrollMenu"));
	    	curSelected = curSelected==0 ? 1 : 0;
        }
        if(controls.ACCEPT){
            canMove = false;
            
            text.resetText("If your curiosity calls for more, you can find me elsewhere.");
            text.size = 30;
            text.start(0.05);

            text2.destroy();
            yes.visible = false;
            no.visible = false;

            new FlxTimer().start(3.5, ()->{
                add(black); // yeah im too lazy
                if(curSelected == 0){
                    FlxG.sound.play(Paths.sound('cartridgeguy/selectorYes'), 1, false, null, true, ()->{
                        FlxG.switchState(new StoryMenuState());
                    });
                }
                else{
                    FlxG.sound.play(Paths.sound('cartridgeguy/selectorNo'), 1, false, null, true, ()->{
                        FlxG.switchState(new MainMenuState());
                    });
                }
                new FlxTimer().start(0.15, ()->black.alpha += 0.15, 8);
            });

        }
    }
        
    yes.color = curSelected == 1 ? 0x888888 : 0xFFFFFF;
    no.color = curSelected == 0 ? 0x888888 : 0xFFFFFF;
}