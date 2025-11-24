function postCreate(){
    gf.alpha = 1;

    //TODO: add squidward

    mxArm = strumLines.members[0].characters[1];
    hypnoArm = strumLines.members[2].characters[1];
    remove(mxArm);
    remove(hypnoArm);
    insert(300,mxArm);
    insert(300,hypnoArm);
}

var goldWalk:FlxTimer;
var gbWalk:FlxTimer;
function beatHit(b){
    switch(b){
        case 96: 
            trace('gold movin?');
            goldWalk = new FlxTimer().start(0.025, ()->gold.x -= 4, 0);
        case 135: 
            goldWalk.cancel();
            gold.kill();
        case 260:
            gbWalk = new FlxTimer().start(0.025, ()->gb.x -= 4, 0);
        case 300:
            gbWalk.cancel();
            gb.kill();
    }
}