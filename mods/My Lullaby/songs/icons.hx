import flixel.math.FlxRect;
import funkin.backend.system.Flags;

static var iconBF:HealthIcon;
static var iconDAD:HealthIcon;
public var iconArray:Array<Int> = [iconBF,iconDAD];
public var FlipIcons = false;

var cacheRect:FlxRect = new FlxRect();
public var customHealthBar:FlxSprite;
public var customHealthBarBG:FlxSprite;
public var bfColor = (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("iconColor") | boyfriend.xml.exists("color")) ? CoolUtil.getColorFromDynamic(boyfriend.xml.get("iconColor")) | CoolUtil.getColorFromDynamic(boyfriend.xml.get("color")) : 0xFF66FF33;
public var dadColor = (dad != null && dad.xml != null && dad.xml.exists("iconColor") | dad.xml.exists("color")) ? CoolUtil.getColorFromDynamic(dad.xml.get("iconColor")) | CoolUtil.getColorFromDynamic(dad.xml.get("color")): 0xFFFF0000;		
public var customHealthBarColors:Array<Int> = [dadColor, bfColor];

function create(){
    iconBF = new HealthIcon(boyfriend != null ? boyfriend.getIcon() : "face", true);
    iconDAD = new HealthIcon(dad != null ? dad.getIcon() : "face", false);
	iconArray = [iconBF,iconDAD];	
}

function postCreate() {
	if(FlipIcons)customHealthBarColors = [bfColor, dadColor];
    for(ico in iconArray) {
        ico.y = healthBar.y - (ico.height / 2);
        ico.cameras = [camHUD];
		ico.flipX = FlipIcons;
        insert(members.indexOf(healthBar) + 2, ico);
    }
	
	setIconPos(false);
	
    for (i in [iconP1, iconP2]) remove(i);
		
	customHealthBarBG = new FlxSprite(healthBarBG.x, healthBarBG.y+2).loadGraphic(Paths.image("UI/base/healthBar"));
	customHealthBarBG.cameras = [camHUD]; customHealthBarBG.scrollFactor.set();
	customHealthBarBG.screenCenter(FlxAxes.X); customHealthBarBG.antialiasing = true;
	customHealthBarBG.flipY = camHUD.downscroll;
	
	customHealthBar = new FlxSprite(healthBarBG.x, healthBarBG.y+2).loadGraphic(Paths.image("UI/base/healthBar_fill"));
	customHealthBar.cameras = [camHUD]; customHealthBar.scrollFactor.set();
	customHealthBar.screenCenter(FlxAxes.X); customHealthBar.antialiasing = true; 
	customHealthBar.flipY = camHUD.downscroll;
	
	remove(healthBarBG);remove(healthBar);
	insert(members.indexOf(healthBar) + 1, customHealthBarBG);
	insert(members.indexOf(healthBar) + 1, customHealthBar);

	customHealthBar.onDraw = () -> {
		for (i => color in customHealthBarColors) {
			var precentWidth:Float = (customHealthBar.width) * FlxMath.bound(Math.abs(((FlipIcons)?(health)/2:1-(health)/2)),0,1);
			switch (i) {
				case 0: cacheRect.set(0, 2, precentWidth, customHealthBar.height);
				case 1: cacheRect.set(precentWidth, 2, customHealthBar.width-precentWidth, customHealthBar.height);
			}
			customHealthBar.colorTransform.color = color;
			customHealthBar.clipRect = cacheRect;
			customHealthBar.draw();
		}
	};	
}

function postUpdate(elapsed:Float){
	for(ico in iconArray) {
		ico.health = (ico.isPlayer?(health)/2:1-(health)/2);
	}setIconPos(true);
}

function setIconPos(smooth:bool = true){
	var iconOffset = Flags.ICON_OFFSET;var healthBarPercent = healthBar.percent;
	var center:Float = healthBar.x + (healthBar.width * (FlxMath.bound(Math.abs(((FlipIcons)?(health)/2:1-(health)/2)),0.01,1)));
	iconBF.x = CoolUtil.fpsLerp(iconBF.x, FlipIcons ? (center - (iconBF.width - iconOffset-14)) : (center - iconOffset - 14), (smooth ? .5 : 1));
	iconDAD.x = CoolUtil.fpsLerp(iconDAD.x, FlipIcons ? (center - iconOffset-14) : (center - (iconDAD.width - iconOffset - 14)), (smooth ? .5 : 1));	
}

function beatHit(){
    for (i in iconArray){
       i.scale.set(i.defaultScale * Flags.BOP_ICON_SCALE, i.defaultScale * Flags.BOP_ICON_SCALE);
       FlxTween.tween(i.scale, {x: i.defaultScale, y: i.defaultScale}, (0.5 * (1 / (Conductor.bpm / 60))), {ease: FlxEase.cubeOut});
	   i.updateHitbox();
    }
}