var colors:Array = ["Purple", "Blue", "Green", "Red"];
var generated:Bool = false;
public var holds:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
function onSongStart(){
	//holds = new FlxTypedGroup<FlxSprite>();
	for(i => color in colors){
		s = new FlxSprite(i*100, 0);
		s.frames = Paths.getFrames('holdCover'+color);
		s.animation.addByPrefix('start', 'holdCoverStart'+color, 20, false);
		s.animation.addByPrefix('hold', 'holdCover'+color, 20, true);
		s.animation.addByPrefix('end', 'holdCoverEnd'+color, 22, false);
		s.cameras = [camHUD];
		s.visible = false;
		s.animation.onFinish.add(function(e){
			switch(e){
				case "start": holds.members[i].animation.play('hold');
				case "end": holds.members[i].visible = false;
			}
		});
		holds.add(s);
	}
	generated = true;
}

function stepHit(){
	var mode = downscroll ? 87 : -5;

	var user;
	var userID;
	for(idx=>strumLine in strumLines.members) if(strumLine.cpu == false) {user = strumLine; userID = idx;}

	var swap = modchart.getPercent('opponentSwap', userID);
	var reverse = modchart.getPercent('reverse', userID);
	for(i in 0...4){
		var milk = holds.members[i];
		if(user.members[i].animation.name == "static" && generated){
			if(milk.animation.name == "hold") milk.visible = false;
		}

		if(generated) milk.setPosition(
			(user.members[i].x-user.members[i].width)+(modchart.getPercent('x'+i,userID) + modchart.getPercent('x',userID) + (-640*swap)), 
			(user.members[i].y-user.members[i].height) - mode + (modchart.getPercent('y'+i,userID)+modchart.getPercent('y',userID)) - 640*reverse
		);
	}
		
	
}

function onPlayerHit(event){
	if(event.direction > 3) return;

	var d = event.direction;
	var milk = holds.members[event.direction];
	
	if(event.note.isSustainNote){ 
		milk.visible = true;

		if(milk.animation.name != "hold") {
			milk.animation.play('start');
		}
	}

	if(event.note.nextSustain == null && milk.visible && event.note.isSustainNote) milk.animation.play('end');
	//if(event.note.nextNote.nextSustain != null) event.showSplash = false;	
}

