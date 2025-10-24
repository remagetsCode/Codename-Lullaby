var dont = false;

function postCreate(){
	FlxG.game.setFilters([]);
}
function stepHit(){
	if(dad.animation.curAnim.name == "Psyshock" && !dont){
		dont = true;
		hypnoAttack();
	}
	else if(dad.animation.curAnim.name != "Psyshock" && dont){dont = false;}
}

function hypnoAttack(){
	healthHypno -= 0.07;
	health -= 0.05;
	FlxG.sound.play(Paths.sound('Psyshock'));
	camGame.flash(FlxColor.RED, 1);
}