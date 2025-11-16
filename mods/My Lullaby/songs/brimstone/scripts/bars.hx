function create(){
    bars = new FlxTypedGroup();
    upBar = new FunkinSprite(0, -360).makeGraphic(FlxG.width*2, FlxG.height/2, FlxColor.BLACK);
    upBar.screenCenter(FlxAxes.X);
    upBar.scrollFactor.set(0,0);
    upBar.zoomFactor = 0;
    bars.add(upBar);

    lowBar = new FunkinSprite(0, FlxG.height).makeGraphic(FlxG.width*2, FlxG.height/2, FlxColor.BLACK);
    lowBar.screenCenter(FlxAxes.X);
    lowBar.scrollFactor.set(0,0);
    lowBar.zoomFactor = 0;
    bars.add(lowBar);

    add(bars);

    moveBars();
}

public function moveBars(?percent:Float, ?time:Float, ?ease:FlxEase){
    percent ??= 1;
    time ??= 2;
    ease ??= FlxEase.quintOut;
    
    for(i => bar in bars.members) {
        FlxTween.cancelTweensOf(bar);
        FlxTween.tween(bar, {y: i==0? (-360)*percent : 360+360*percent}, time, {ease: ease});
    }
}

public function angleBars(?ang:Float, ?time:Float, ?ease:FlxEase){
    ang ??= 0;
    time ??= 0.1;
    ease ??= FlxEase.smoothStepIn;
    for(i => bar in bars.members) FlxTween.angle(bar, bar.angle, ang, time, {ease: ease});
}

var moveBeat:Bool = false;
var moveMeasure:Bool = false;
public function moveBarsEvery(?time:String){
    if(time == null) return;

    switch(time){
        case "step": trace("why would i do that?");
        case "beat": moveBeat = !moveBeat;
        case "measure": moveMeasure = !moveMeasure;
        case default: return;
    }
}

function beatHit(b){
    switch(b){
        case 228: moveBars(0.95, 0.1);
        case 230: moveBars(0.9, 0.1);
        case 231: moveBars(0.85, 0.5);
        case 236: moveBars(0.6);
        case 240: moveBars(0.8);
        case 272: moveBars(0.5, 2);
        case 276: moveBars(1, 0.5, FlxEase.cubeOut);
        case 744: moveBars(0.7); 
        case 808: moveBars(0.95); 
        case 864: moveBars(0.9, 0.05); 
        case 866: moveBars(0.85, 0.05); 
        case 868: moveBars(0.8, 0.05); 
        case 870: moveBars(0.75); 
        case 872: moveBars(0.5, 5, FlxEase.cubeInOut); 
        case 895: moveBars(0.8, 6); 
        case 970: moveBars(0.9, 3); 
        case 1032: moveBars(1); 
            
    }

    if(moveBeat){
        for(i => bar in bars.members){
            beat1 = FlxTween.tween(bar, {y: i==0? bar.y+20 : bar.y-20}, 0.01, {
                ease: FlxEase.quintOut,
                onComplete: ()->{
                    FlxTween.tween(bar, {y: i==0? bar.y-20 : bar.y+20}, 0.15, {ease:FlxEase.quadIn});
                }
            });
            
        }
    }
}

function measureHit(){
    if(moveMeasure){
        for(i => bar in bars.members){
            beat1 = FlxTween.tween(bar, {y: i==0? bar.y+30 : bar.y-30}, 0.01, {
                ease: FlxEase.quintOut,
                onComplete: ()->{
                    FlxTween.tween(bar, {y: i==0? bar.y-30 : bar.y+30}, 0.23, {ease:FlxEase.quadIn});
                }
            });
            
        }
    }
}