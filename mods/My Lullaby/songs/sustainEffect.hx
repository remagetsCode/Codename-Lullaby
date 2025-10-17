var colors:Array = ["Purple", "Blue", "Green", "Red"];
var generated:Bool = false;
public var holds:FlxTypedGroup<FlxSprite>;
function onSongStart(){
	//holds = new FlxTypedGroup<FlxSprite>();
	for(i => color in colors){
		s = new FlxSprite(i*100, 0);
		s.frames = Paths.getFrames('holdCover'+color);
		s.animation.addByPrefix('start', 'holdCoverStart'+color, 24, false);
		s.animation.addByPrefix('hold', 'holdCover'+color, 24, true);
		s.animation.addByPrefix('end', 'holdCoverEnd'+color, 24, false);
		s.cameras = [camHUD];
		s.visible = false;
		s.animation.onFinish.add(function(e){
			switch(e){
				case "start": holds.members[i].animation.play('hold');
				case "end": holds.members[i].visible = false;
			}
		});
		//add(s);
		holds.add(s);
	}
	generated = true;
}

function stepHit(){
	var swap = modchart.getPercent('opponentSwap', 1);
	var mode = downscroll ? 87 : -5;

	for(i in 0...4){
		var milk = holds.members[i];
		if(player.members[i].animation.name == "static" && generated){
			if(milk.animation.name == "hold") milk.visible = false;
		}

		if(generated) milk.setPosition(
			(player.members[i].x-player.members[i].width)+(modchart.getPercent('x'+i,1) + modchart.getPercent('x',1) + (swap == 1 ? -640 : 0)), 
			(player.members[i].y-player.members[i].height)-mode+(modchart.getPercent('y'+i,1)+modchart.getPercent('y',1))
		);
	}
		
	
}

function onPlayerHit(event){
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

