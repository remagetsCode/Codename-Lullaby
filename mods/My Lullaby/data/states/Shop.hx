/**
	I should really really start using classes in this script...
**/

import sys.io.File;
import haxe.Json;
import flixel.math.FlxRect;
import funkin.backend.utils.DiscordUtil;
import funkin.menus.StoryWeeklist;
import flixel.graphics.frames.FlxAtlasFrames;

FlxG.game.setFilters([]);
public static var aberration = new CustomShader('aberration');
public var shaderCrt = new CustomShader('monitor');

var options:Array = [];
var curSelected = -1;
var data:String = CoolUtil.parseJson(Paths.json("shop/shopText"));
var talk:FunkinText;
var windowTitle = "Friday Night Funkin' - Shop";
public var onSubstate:Bool = false;

var items:Array = [
	"1Pokemon Silver", 
	"2GameBoy Advanced SP", 
	"3Pokemon Red",
	"4Lit Candle", 
	"5Mysterious Letter", 
	"6Broken Note", 
	"7Pasta Night Mushroom", 
	"8Trainer Bow", 
	"9Broken Vinyl",
	"10Cursed Writings"
];

var itemsGrp:FlxSpriteGroup;
var pricesGrp:FlxSpriteGroup;
var prices:Array = [];
var curMusic = FlxG.sound.music;
var buying:Bool = false;

var introing:Bool = true;
var defaultItemsY:Int = 0;

function create(){
	window.title = windowTitle;
	weekList = StoryWeeklist.get(true, false);
	if(FlxG.save.data.lullabyShaders){
		FlxG.game.addShader(shaderCrt);
		FlxG.game.addShader(aberration);
		aberration.iTime = 7;
		aberration.amount = 0.5;
	}

	itemsGrp = new FlxSpriteGroup();
	pricesGrp = new FlxSpriteGroup();

	var songList = CoolUtil.coolTextFile(Paths.txt("shop/songsList"));
	for(song in songList) graphicCache.cache(Paths.image('menus/freeplay/' + song));
	graphicCache.cache(Paths.image('menus/freeplay/unknown'));

	cgIntro = new FlxSprite();
	cgIntro.frames = Paths.getFrames('menus/shop/CGIntro_assets');
	cgIntro.animation.addByPrefix('idle','CG_Intro',24,false);
	cgIntro.setGraphicSize(cgIntro.width*1.5, cgIntro.height*1.5);
	cgIntro.screenCenter();
	cgIntro.x -= 150;
	add(cgIntro);

	cgShop = new FlxSprite();
	cgShop.frames = Paths.getFrames('menus/shop/CGShop_assets');
	cgShop.animation.addByPrefix('idle1', 'CG_Idle01',24,true);
	cgShop.animation.addByPrefix('idle1Alt', 'CG_Idle01_Alt',24,true);
	cgShop.animation.addByPrefix('idle2', 'CG_Idle02',24,true);
	cgShop.animation.addByPrefix('idle2Alt', 'CG_Idle02_Alt',24,true);
	cgShop.animation.addByPrefix('idle3', 'CG_Idle03',24,true);
	cgShop.animation.addByPrefix('idle3Alt', 'CG_Idle03_Alt',24,true);
	cgShop.animation.addByPrefix('scared', 'CG_Scared01',24,true);
	cgShop.animation.addByPrefix('scaredLoop', 'CG_Scared02_Loop',24,true);
	cgShop.setGraphicSize(cgShop.width*1.5, cgShop.height*1.5);
	cgShop.screenCenter();
	cgShop.animation.play('idle'+FlxG.random.int(1,3));
	cgShop.x -= 150;
	cgShop.visible = false;
	add(cgShop);

	shopSign = new FlxSprite();
	shopSign.frames = Paths.getFrames('menus/shop/CGShopSign_assets');
	shopSign.animation.addByPrefix('opening', 'ShopSign',24,false);
	shopSign.x = 500;
	shopSign.y += 100;
	add(shopSign);

	candle = new FlxSprite().loadGraphic(Paths.image('menus/shop/CandleLight'));
	candle.y = 360;
	candle.x -= 80;
	add(candle);

	upperBar = new FlxSprite().makeGraphic(FlxG.width, FlxG.height/7, FlxColor.WHITE);
	add(upperBar);

	upperText = new FunkinText(1, 1, 0, "SHOP", 32, false);
    upperText.setFormat(Paths.font("pokefont.ttf"), 80, 0x111111);
	upperText.screenCenter();
	upperText.y = 0;
	upperText.scrollFactor.set(0);
    add(upperText);

	pokeDollar = new FlxSprite();
	pokeDollar.frames = Paths.getFrames('menus/shop/PokeDollarSign');
	pokeDollar.setGraphicSize(pokeDollar.width*0.8, pokeDollar.height*0.8);
	pokeDollar.animation.addByPrefix('idle', 'PokeDollarSign instance 1', 24, true);
	pokeDollar.animation.play('idle');
	pokeDollar.x = upperText.x + 450;
	pokeDollar.y = upperText.y - 10;
	add(pokeDollar);

	upperCash = new FunkinText(1, 1, 0, "", 32, false);
    upperCash.setFormat(Paths.font("pokefont.ttf"), 40, 0x111111);
	upperCash.screenCenter();
	upperCash.x = pokeDollar.x + 100;
	upperCash.y = pokeDollar.y + 35;
    add(upperCash);

	textBox = new FlxSprite().loadGraphic(Paths.image('UI/base/amusia/questionareTextBox'));
	textBox.screenCenter();
	textBox.x -= 50;
	textBox.y += 250;
	textBox.visible = false;
	add(textBox);

	selBox = new FlxSprite().loadGraphic(Paths.image('UI/base/amusia/questionareTextBox'));
	selBox.setGraphicSize(selBox.width/3, selBox.height);
	selBox.screenCenter();
	selBox.x = textBox.x + 470;
	selBox.y = textBox.y - 30;
	selBox.angle = 90;
	//selBox.y += 250;
	selBox.visible = false;
	add(selBox);

	buyBox = new FlxSprite().loadGraphic(Paths.image('UI/base/amusia/bigsquaredTextBox'));
	buyBox.screenCenter();
	buyBox.x -= 50;
	buyBox.y -= 50;
	add(buyBox);

	var posh:Int = 0;
	var posw:Int = 0;
	for(i => item in items) {
		if (i % 4 == 0 && i != 0){ 
			posw = 0;
			posh++;
		}

		var d:String = CoolUtil.parseJson(Paths.json("shop/items/" + item));
		spr = new FunkinSprite((270+150*posw), (150+160*posh));
		spr.frames = Paths.getFrames("shop/" + item + "/item");
		spr.animation.addByPrefix('idle', d.itemDetail.animName, 24, true);
		spr.animation.play('idle');
		spr.name = d.itemDetail.songUnlock;
		spr.extra.set('dialog', d.itemDetail.songDescription);
		spr.extra.set('price', d.itemDetail.price);
		itemsGrp.add(spr);

		price = new FunkinText(spr.x, spr.y+120, 130, d.itemDetail.price, 24, false);
		price.color = FlxColor.BLACK;
		price.alignment = "center";
		if(FlxG.save.data.unlockedSongs.exists(d.itemDetail.songUnlock)) price.text = "OWNED";
		if(FlxG.save.data.cartridgesOwned.contains("LostSilverWeek") && d.itemDetail.name == "Pokemon Silver") price.text = "OWNED";
		pricesGrp.add(price);

		prices.push(d.itemDetail.price);
		posw++;
		spr.x += d.itemDetail.xOffset;
		spr.y += d.itemDetail.yOffset;
	}
	defaultItemsY = itemsGrp.y;
	add(itemsGrp);
	add(pricesGrp);

	up = new FlxSprite().loadGraphic(Paths.image('UI/pixel/selector'));
	up.setGraphicSize(up.width*4, up.height*4);
	up.setPosition(buyBox.x+650, buyBox.y+45);
	up.angle = -90;
	//up.visible = false;
	add(up);

	down = new FlxSprite().loadGraphic(Paths.image('UI/pixel/selector'));
	down.setGraphicSize(down.width*4, down.height*4);
	down.setPosition(buyBox.x+650, buyBox.y+310);
	down.angle = 90;
	//down.visible = false;
	add(down);

	talk = new FunkinText(textBox.x+30, textBox.y+30, 650, "", 28, false);
	talk.wordWrap = true;
	talk.setFormat(Paths.font("pokefont.ttf"), 28, 0x000000);
	add(talk);

	hand = new FlxSprite();
	hand.frames = Paths.getFrames('menus/shop/ShopCursor');
	hand.animation.addByPrefix('idle','ShopCursor instance 1',24,true);
	hand.animation.play('idle');
	hand.setGraphicSize(hand.width/2, hand.height/2);
	hand.y = 99999;
	hand.visible = false;
	add(hand);

	for (k => v in CoolUtil.coolTextFile(Paths.txt("shop/shopButtons"))) {
        var txt = new FunkinText(1010, selBox.y+(k*60), 0, v, 32, false);
        txt.setFormat(Paths.font("pokefont.ttf"), 32, 0x111111);
        txt.ID = k;
		txt.visible = false;
        add(txt);
        options.push(txt);
		hand.x = txt.x - 240;
    }

	right = new FlxSprite();
	right.frames = Paths.getFrames('UI/base/assets');
	right.animation.addByPrefix('idle', 'arrow push right',24,true);
	right.animation.addByPrefix('push', 'arrow right',24,true);
	right.animation.play('idle');
	right.screenCenter();
	right.x = FlxG.width*0.945;
	add(right);
	
	staticImg = new FlxSprite();
	staticImg.frames = Paths.getFrames('menus/shop/static');
	staticImg.animation.addByPrefix('idle', 'static',24,true);
	staticImg.setGraphicSize(FlxG.width*1.5, FlxG.height*1.5);
	staticImg.animation.play('idle');
	staticImg.visible = false;
	add(staticImg);

	vignette = new FlxSprite().loadGraphic(Paths.image('UI/base/vignette2'));
	vignette.antialiasing = true;
	vignette.screenCenter();
	vignette.setGraphicSize(FlxG.width, FlxG.height);
	vignette.alpha = 0.7;
	add(vignette);
	
	cgIntro.animation.onFinish.addOnce(function(){
		FlxG.sound.playMusic(Paths.music('FreeplayMenu'),0);
		var fpMusic = FlxG.sound.music;
		FlxTween.tween(fpMusic, {volume:1},1);
		
		cgIntro.visible = false;
		cgShop.visible = true;
		
		staticImg.visible = true;
		new FlxTimer().start(0.5, ()->{
			staticImg.visible = false;
			introing = false;
			for(a in FlxG.save.data.unlockedSongs) if(a == "unlocking") {
					onSubstate = true;
					right.animation.play('push');
					openSubState(new ModSubState('RealFreePlay'));
					break;
			};
		});

		showDialogue();
		curMusic = FlxG.sound.music;
	});

	changeItem(1);
	
	DiscordUtil.config.clientID = "1433852304745824318";
	DiscordUtil.config.logoKey = "unknown";
	DiscordUtil.changePresence("Shop", "Getting some songs...");
}

function postCreate(){
	if(curMusic != null) FlxTween.tween(curMusic, {volume: 0}, 1);

	new FlxTimer().start(0.3, ()->{
		cgIntro.animation.play('idle');
		shopSign.animation.play('opening');
	});

	FlxTween.shake(right, 0.04, 99999999, FlxAxes.XY, {
		ease: FlxEase.cubeInOut
	});
	FlxTween.tween(right, {x: FlxG.width*0.96}, 0.3, {
		ease: FlxEase.circOut,
		type: FlxTween.PINGPONG
	});
}

var canMove:Bool = true;
function update(elapsed){
	DiscordUtil.changePresence("Shop - Money: " + FlxG.save.data.lullabyMoney, "''" + talk.text + "''");
	var leftP = controls.LEFT_P;
	var upP = controls.UP_P;
	var downP = controls.DOWN_P;
	var rightP = controls.RIGHT_P;
	var scroll = FlxG.mouse.wheel;

	if(!onSubstate && !introing){
		if(canMove){
			if ((upP || downP || scroll != 0) && textBox.visible && !buying)
				changeItem((upP ? -1 : 0) + (downP ? 1 : 0) - scroll);
			else if((leftP || rightP || upP || downP) && buying)
				changeItem((leftP ? -1 : 0) + (rightP ? 1 : 0) + (downP ? 4 : 0) + (upP ? -4 : 0));

			if(rightP && !buying) {
				right.animation.play('push');
				new FlxTimer().start(0.1, (_)->{right.animation.play('idle');});
				openSubState(new ModSubState('RealFreePlay'));
			}
		}
		
		if(controls.ACCEPT) selectItem();

		if (controls.BACK && buying && pricesGrp.members[curSelected].text == "CONFIRM?") {pricesGrp.members[curSelected].text = itemsGrp.members[curSelected].extra.get('price'); canMove = true;}
		else if (controls.BACK && buying) {buying = false; curSelected = 0;}
		else if (controls.BACK) FlxG.switchState(new MainMenuState());
	}
	else if(!onSubstate && introing){
		if(controls.ACCEPT) cgIntro.animation.finished = true; 
	}

	try{
		// Lmao wtf did I just do hahaha I'll leave this like that, I like it. This line is too long aaah it scares me
		if(textBox.visible) upperText.setGraphicSize(lerp(upperText.width, curMusic.amplitude > 0.8 ? 350*curMusic.amplitude : 140, 0.15), lerp(upperText.height, curMusic.amplitude > 0.8 ? 200*curMusic.amplitude : 80, 0.15));
	}
	catch(e:Dynamic){
		trace('hxsehexception: maybe the music reseted');
	}
	
	if (gameboy?.isAnimFinished()) {
		FlxG.switchState(PlayState.loadWeek(weekList.weeks[3], 'hard'));
		FlxG.switchState(new PlayState());
	}
}

var curMoney:Int;
function postUpdate(){
	upperCash.text = Math.round(curMoney = lerp(curMoney, FlxG.save.data.lullabyMoney, 0.05));

	if(!buying){
		for (a in options) {
    	    var s = 1.0 + (a.ID == curSelected ? 0.1 : 0);
    	    a.scale.x = lerp(a.scale.x, s, 0.25);
    	    a.scale.y = lerp(a.scale.y, s, 0.25);
    	    a.updateHitbox();
			a.color = a.ID == curSelected ? 0x333333 : 0x000000;
    	}
	}

	buyBox.visible = itemsGrp.visible = pricesGrp.visible = down.visible = up.visible = buying;

	hand.y = lerp(hand.y, (buying ? itemsGrp.members[curSelected].y - itemsGrp.members[curSelected].height/5: options[curSelected].y - hand.height/2), 0.3);
	hand.x = lerp(hand.x, (buying ? itemsGrp.members[curSelected].x : options[curSelected].x) - hand.width*0.7, 0.3);


	for(spr in itemsGrp.members) 
		spr.clipRect = new FlxRect(
			0, 														// X
			(buyBox.y+18)-spr.y < 0 ? 0 : (buyBox.y+18)-spr.y, 		// Y
			spr.width, 												// Width
			spr.height-(spr.y - (spr.name == "mauve-macabre" ? 365 : 400))								// Height
		);
	for(spr in pricesGrp.members) 
		spr.clipRect = new FlxRect(
			0, 														// X
			(buyBox.y+18)-spr.y < 0 ? 0 : (buyBox.y+18)-spr.y, 		// Y
			spr.width, 												// Width
			spr.height-(spr.y - 450)								// Height
		);
}

function beatHit() {
	if(up.visible) up.alpha = up.alpha == 1 ? 0 : 1;
	if(down.visible) down.alpha = down.alpha == 1 ? 0 : 1;
	if(itemsGrp.y+itemsGrp.height+50 < buyBox.y+buyBox.height) down.alpha = 0;
	if(itemsGrp.y+itemsGrp.height+50 > buyBox.y+buyBox.height) up.alpha = 0;
}

function showDialogue(){
	//trace(data.shopLines);
	for(i in [textBox, selBox, hand]) i.visible = true;
	for(a in options) a.visible = true;

	targ = data.shopLines.idleLines[FlxG.random.int(0,data.shopLines.idleLines.length-1)];
	if(FlxG.random.bool(40) && !FlxG.save.data.lullabyMechanics) targ = data.shopLines.pussyLines[FlxG.random.int(0,data.shopLines.pussyLines.length-1)];
	
	dialogue(targ);
}

function changeItem(huh:Int = 0, ?mouse:Bool = false)
	{
		var len = buying ? itemsGrp.length-1 : options.length-1;
		FlxG.sound.play(Paths.sound("menu/scroll"),0.5);

		if(mouse) curSelected = huh;
		curSelected = FlxMath.wrap(curSelected + huh, 0, len);	

		if(buying && curSelected < 4) {
			FlxTween.tween(itemsGrp, {y: defaultItemsY}, 0.15);
			FlxTween.tween(pricesGrp, {y: defaultItemsY}, 0.15);
		}
		if(buying && curSelected > 7) {
			FlxTween.tween(itemsGrp, {y: defaultItemsY-150}, 0.15);
			FlxTween.tween(pricesGrp, {y: defaultItemsY-150}, 0.15);
		}
	}

function selectItem(){
	FlxG.sound.play(Paths.sound("confirmMenu"));

	// Outside buy menu
	if(curSelected != null && !buying){
		var selected = curSelected;
			switch(selected){
				case 0: CGDialog("buy"); buying = true; changeItem(0);
				case 1: 
					FlxTween.shake(selBox, 0.01, 0.5, FlxAxes.XY, {
						ease: FlxTween.cubeInOut
					});
					FlxG.sound.play(Paths.sound('errorMenu'));
				case 2: FlxG.switchState(new MainMenuState());
		}
	}

	// Inside buy menu
	else if(curSelected != null && buying && pricesGrp.members[curSelected].text != "OWNED"){
		var ptext = pricesGrp.members[curSelected].text;
		var item = itemsGrp.members[curSelected];
		var itemPrice = item.extra.get('price');

		if(ptext == "CONFIRM?" && FlxG.save.data.lullabyMoney >= itemPrice){
			pricesGrp.members[curSelected].text = "OWNED";
			canMove = true;

			// LostSilver cartridge
			if (item.name == "") {
				FlxG.save.data.cartridgesOwned.push("LostSilverWeek");
				return;
			}
			else if (item.name == "shinto") {
				FlxG.save.data.lullabyMoney -= itemPrice;
				FlxG.save.data.unlockedSongs.set(item.name, "unlocking");
				FlxG.save.data.unlockedSongs.set("shitno", "unlocking");
				showShintoAnim();
				return;
			}

			FlxG.save.data.lullabyMoney -= itemPrice;
			FlxG.save.data.unlockedSongs.set(item.name, "unlocking");

			onSubstate = true;
			right.animation.play('push');
			openSubState(new ModSubState('RealFreePlay'));
		}

		else if(ptext == "CONFIRM?" && FlxG.save.data.lullabyMoney < itemPrice) {
			CGDialog("poor"); 
			FlxG.sound.play(Paths.sound('errorMenu'));
		}

		else {
			pricesGrp.members[curSelected].text = "CONFIRM?";
			dialogue(item.extra.get('dialog'));
			canMove = false;
		}

	}
}

var typeTimer:FlxTimer;
var fullText:String;
var currentIndex:Int = 0;
function CGDialog(reason:String){
	switch(reason){
		case "buy": 
			var target = data.shopLines.buyLines[FlxG.random.int(0,data.shopLines.buyLines.length-1)];
			dialogue(target);
		case "poor": 
			var target = data.shopLines.poorLines[FlxG.random.int(0,data.shopLines.poorLines.length-1)];
			dialogue(target);
	}
}

function dialogue(target:String){
	//trace('a');
	fullText = target;
	currentIndex = 0;
	talk.text = "";

	//if(typeTimer != null) {typeTimer.cancel(); typeTimer = null;}

	if(typeTimer == null){
		typeTimer = new FlxTimer();
		typeTimer.start(0.04, showNextLetter, 0);
	}
	
}


function showNextLetter(timer:FlxTimer){
    talk.text += fullText.charAt(currentIndex);
    currentIndex++;

	if(fullText.charAt(currentIndex) != " ") FlxG.sound.play(Paths.sound('cartridgeguy/cartridgeGuy'), 0.1);

    if (currentIndex >= fullText.length){
		//trace('e');
        isTyping = false;
		typeTimer.cancel();
		typeTimer = null;
    }
}

// WE REACHED THE 4 HUNDRED LINES LETS GOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

subStateOpened.add(function(){onSubstate = true;});
subStateClosed.add(function(){onSubstate = false;});

var gameboy:FunkinSprite;
function showShintoAnim() {
	camExtra = new FlxCamera(0, 0);
    camExtra.bgColor = FlxColor.BLACK;
    FlxG.cameras.add(camExtra, false);

	FlxG.sound.music.volume = 0;
	FlxG.sound.play(Paths.sound("gameboyAnim"));

	gameboy = new FunkinSprite();
	gameboy.loadSprite("images/shop/gameboy");
	gameboy.addAnim('idle', 'Buying Broken Record', 24, false);
	gameboy.camera = camExtra;
	gameboy.playAnim('idle');
	gameboy.antialiasing = true;
	add(gameboy);

	gameboy.animation.onFinish.add(function(){
		trace('ee');
	});
}