function postCreate(event) {
    transitionTween.cancel(); // Disabling original tween
	rectUp = new FlxSprite();
	rectUp.makeGraphic(FlxG.width, FlxG.height/2, FlxColor.BLACK);
	rectUp.y = event.transOut ? FlxG.height/2 : FlxG.height;
	//rectUp.y += camHUD.height;
	add(rectUp);
	

	rectDown = new FlxSprite();
	rectDown.makeGraphic(FlxG.width, FlxG.height/2, FlxColor.BLACK);
	rectDown.y = event.transOut ? FlxG.height*2 : rectUp.height*3;
	
	add(rectDown);
	//trace(rectDown.y);

		//trace(event.transOut);
		FlxTween.tween(rectUp, { y: event.transOut ? FlxG.height : FlxG.height/2 }, 0.65, {
			ease:FlxEase.smootherStepInOut
		});
		FlxTween.tween(rectDown, { y: rectUp.height*3 }, 0.65, {
			ease:FlxEase.smootherStepInOut,
			onComplete: () -> finish()
		});
	
}

function onPostFinish(){
		FlxG.camera.flash(FlxColor.BLACK, 1.5);
}