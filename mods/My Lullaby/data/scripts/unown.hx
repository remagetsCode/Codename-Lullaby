import flixel.group.FlxTypedSpriteGroup;

var unownCam:FlxCamera;

var data:String = CoolUtil.parseJson(Paths.json("unownTexts"));
var counter:Int = 0;
var counter2ndcoming:Int = 0;
var unown:Bool = false;
var unownGrp:FlxTypedSpriteGroup<FlxSprite>;
var linesGrp:FlxTypedSpriteGroup<FlxSprite>;
var curWord:String;
var time:Int = 0;
var unownTimer:FlxTimer;
var anotherTimer:FlxTimer;
var timer:FlxText;
var timeBar:FlxBar;
var groupWidth:Float;
var groupX:Float;

function postCreate() {
    unownCam = new FlxCamera(0, 0);
	unownCam.bgColor = FlxColor.TRANSPARENT;
	FlxG.cameras.add(unownCam, false);
}

public function unownMechanic(?word:String) {
	if (!FlxG.save.data.lullabyMechanics) return;

    counter = 0;
    counter2ndcoming = 0;
    unown = true;

    word = 'HELLO WORLD';
    if (word == "")
        curWord = data.monochromeTexts.words[FlxG.random.int(0, data.monochromeTexts.words.length - 1)];
    else
        curWord = word;

    bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(255, 20, 20, 150));
    bg.scrollFactor.set(0);
    bg.camera = unownCam;
    add(bg);

    unownGrp = new FlxTypedSpriteGroup<FlxSprite>();
    unownGrp.cameras = [unownCam];
    linesGrp = new FlxTypedSpriteGroup<FlxSprite>();
    add(unownGrp);
    add(linesGrp);

    var test = 1 - curWord.length * 0.055;

    for (i in 0...curWord.length) {
        var char = curWord.charAt(i);
        if (char == " ") continue;

        var uAlpha = new FlxSprite();
        uAlpha.frames = Paths.getFrames('UI/base/Unown_Alphabet');
        uAlpha.animation.addByPrefix('this', char, 24, true);
        uAlpha.animation.play('this');
        uAlpha.setPosition((uAlpha.width * 1.4) * i, 150);
        uAlpha.antialiasing = Options.antialiasing;
        unownGrp.add(uAlpha);

        var line = new FlxSprite().loadGraphic(Paths.image('UI/base/line'));
        line.scrollFactor.set(0);
        line.setGraphicSize(line.width * test, line.height * test);
        line.setPosition(uAlpha.x - line.width / 4, uAlpha.y + 450);
        line.camera = unownCam;
        linesGrp.add(line);
    }
    updateGroupBounds(unownGrp);
    var counter = 0;
    while(groupWidth > 1100 && counter < 10) 
    {   
        trace(groupWidth);
        //unownGrp.offset.x = 0;
        //unownGrp.scale.x -= 0.1;
        //unownGrp.scale.y -= 0.1;
        //unownGrp.updateHitbox();

        for(i => char in unownGrp.members)
        {
            char.scale.x -= 0.1;
            char.scale.y -= 0.1;
            //char.updateHitbox();
            //char.offset.x = 0;
            char.setPosition((char.width * 1.4 * char.scale.x) * i, 150);
        }

        updateGroupBounds(unownGrp);
        counter++;
        trace(groupWidth);
    }
    

    unownTimer = new FlxTimer().start(6, () -> {
        FlxTween.num(health, health - (curWord.length - counter) * 0.3, 0.75, {
            ease: FlxEase.quintOut,
            onUpdate: (v) -> {
                health = v.value;
            }
        });
        if (bg.alive || unownGrp.alive) {
            bg.kill();
            unownGrp.kill();
            linesGrp.kill();
            timer.kill();
            timeBar.kill();
            anotherTimer.kill();
        }
    });

    timer = new FlxText(0, 0, 0, "6", 34, false);
    timer.screenCenter();
    timer.y += 100;
    timer.camera = unownCam;
    add(timer);

    timeBar = new FlxBar(FlxG.width * 0.06, FlxG.height * 0.7, FlxBarFillDirection.LEFT_TO_RIGHT, 1123, 15);

    timeBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.WHITE);
    timeBar.cameras = [camHUD];
    timeBar.numDivisions = 200;
    timeBar.camera = unownCam;
    add(timeBar);

    anotherTimer = new FlxTimer().start(0.03, () -> {
        if (unownTimer.active) {
            timer.text = 6 - Std.int(unownTimer.elapsedTime);
            timeBar.percent = (6 - unownTimer.elapsedTime) * (100 / 6);
            timeBar.updateBar();
        }
    }, 0);
	
}

function updateGroupBounds(group:FlxTypedSpriteGroup<FlxSprite>):Void {
    var minX:Float = 9999;
    var maxX:Float = 9999;

    if(group.length <= 0) return groupWidth = groupX = 0;

    groupWidth = group.members[group.length - 1].x + group.members[group.length - 1].width;
    groupX = group.members[group.length - 1].x;
}