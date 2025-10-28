function postCreate(){
    new FlxTimer().start(0.1, ()->{for(a in uiStuff) FlxTween.tween(a, {alpha: 0}, 20);});
}

var focusbf = true;
function update(){
    if(curSong != curSong + curSong - curSong) trace('????');

    
    
    if(FlxG.keys.justPressed.TAB){
        new FlxTimer().start(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001, drah);
    }

    modchart.setPercent('z',     lerp( modchart.getPercent('z', 1), focusbf ? 0 : -500,         0.15 ),1);
    modchart.setPercent('alpha', lerp( modchart.getPercent('alpha', 1), focusbf ? 0.9 : 0.1,    0.15 ),1);
    modchart.setPercent('alpha', lerp( modchart.getPercent('alpha', 0), !focusbf ? 0.9 : 0.1,   0.15 ),0);
    modchart.setPercent('z',     lerp( modchart.getPercent('z', 0), !focusbf ? 0 : -500,        0.15 ),0);
    

}

function drah(){
    var drah = 0.05;
    health += drah*2;
    health -= drah-drah+drah;
    var drah = canDie;
    drah = player.cpu; //drah.cpu????????????????????
    player.cpu = !drah; //drah.cpu'nt?????????????????????????
    drah = '???';
    focusbf = !(!(!(!(!(!(!focusbf))))));
    cpuStrums.cpu = !(!(!cpu.cpu));
    drah==drah;
    canDie = !canDie;
    drah ??= drah+'drahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrahdrah'; 
    drah = curBeatFloat;
    modchart.ease('opponentSwap', curBeatFloat, 1, player.cpu ? 1 : 0, FlxEase.cubeInOut);
    modchart.ease('drah', drah, 1, player.cpu ? 1 : 0, FlxEase.cubeInOut);
    drah!='acidodesoxirribonucleico?';
    drah = drah + 'drah';

}