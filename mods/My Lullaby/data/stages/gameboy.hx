function postCreate(){
    var bg = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/201Street/ghost_bg"));
	bg.setGraphicSize(Std.int(bg.width * 5));
	bg.updateHitbox();
	bg.antialiasing = false;
	insert(1, bg);
    comboGroup.visible = false;
}