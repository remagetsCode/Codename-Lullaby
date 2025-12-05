var missingno = new CustomShader('missingno');
missingno.ENABLE_MODE = 1;
missingno.MODE = 4;
missingno.GLITCH_RECT_DIVISION = 10;
missingno.GLITCH_THR = 0.0;

function create(){
        FlxG.game.addShader(missingno);
}

function postCreate(){
    dad.alpha = 0;
    camGame.alpha = camHUD.alpha = 0;
    iconDAD.visible = false;
    iconBF.visible = false;
}

var time:Float = 0;
function update(e){
    missingno.iTime = time += e;
}

function beatHit(curBeat) {
    switch (curBeat) {
        case 1: holds.visible = false;
        case 1 | 588: 
            camGame.alpha = camHUD.alpha =  0.25;
        case 2 | 589: 
            camGame.alpha = camHUD.alpha =  0.5;
        case 3 | 590: 
            camGame.alpha = camHUD.alpha =  0.75;
        case 4 | 591: 
            camGame.alpha = camHUD.alpha =  1;
        case 157: 
            dad.alpha = 0.25;
        case 158: 
            dad.alpha = 0.5;
        case 159: 
            dad.alpha = 0.75;
        case 160: 
            dad.alpha = 1;
        case 584 | 694:
            camGame.alpha = camHUD.alpha = 0;
        
    }
}

function stepHit(stepHit){
    switch(curStep){
        case 1036 | 1296 | 2068 | 2320 | 2756: FlxTween.num(0.0010, 0.10, 1, {onUpdate: (v)->missingno.GLITCH_THR = v.value});
        case 1056 | 1314 | 2080 | 2336: FlxTween.num(0, 0, 1, {onUpdate: (v)->missingno.GLITCH_THR = v.value});
    }
}
function destroy() FlxG.game.setFilters([]);