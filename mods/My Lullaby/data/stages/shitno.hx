function create(){
    floor.alpha = 0;
    dad.alpha = 0;
}

function stepHit(e){
    if(e == 417) {
        FlxTween.tween(floor, {alpha: 1}, 4);
        FlxTween.tween(dad, {alpha: 1}, 4);
    }
}