import haxe.ds.StringMap;

public var charMap:Array<Array<StringMap<Character>>> = [];
var funnyTraceMode = true;

function charMapNullCheck(strumIndex:Int, charIndex:Int) {
	if (charMap[strumIndex] == null) charMap[strumIndex] = [];
	if (charMap[strumIndex][charIndex] == null) charMap[strumIndex][charIndex] = new StringMap();
}

// partially 'borrowed' from gorefield (you guys are awesome) & definitive experience (not sorry, fuck you DE)
function postCreate() {
	// add pre-existing
	for (strumLine in strumLines) {
		var strumIndex:Int = strumLines.members.indexOf(strumLine);
		for (char in strumLine.characters) {
			var charIndex:Int = strumLine.characters.indexOf(char);

			// null check
			charMapNullCheck(strumIndex, charIndex);
			
			// le code
			charMap[strumIndex][charIndex].set(char.curCharacter, char);
			if (funnyTraceMode) trace('Preexisting index "' + charIndex + '" character "' + char.curCharacter + '" on strumLine "' + strumIndex + '".');
		}
	}
	// precache
	for (event in events)
		if (event.name == 'Change Character')
			precacheCharacter(event.params[0], event.params[1], event.params[2]);
}

public function precacheCharacter(strumIndex:Int, charName:String = 'bf', memberIndex:Int = 0) {
	// vars
	var strumLine:StrumLine = strumLines.members[strumIndex];
	var firstChar:Character = strumLine.characters[0];

	// null check
	charMapNullCheck(strumIndex, memberIndex);
	
	// precache process
	if (!charMap[strumIndex][memberIndex].exists(charName)) {
		var newChar:Character = new Character(firstChar.x, firstChar.y, charName, firstChar.isPlayer);
		charMap[strumIndex][memberIndex].set(newChar.curCharacter, newChar);
		newChar.active = newChar.visible = false;
		if (funnyTraceMode) trace('Precached index "' + memberIndex + '" character "' + newChar.curCharacter + '" on strumLine "' + strumIndex + '".');

		// sometimes this works and other times it doesn't
		try {
			for (c in newChar.cameras) {
				newChar.drawComplex(c);
			}
		}
		catch(e:Dynamic) {
			if (funnyTraceMode) trace('drawComplex didn\'t work this time for some reason');
		}

		// cam stage offsets
		switch (strumIndex) {
			case 0:
				newChar.cameraOffset.x += stage?.characterPoses['dad']?.camxoffset;
				newChar.cameraOffset.y += stage?.characterPoses['dad']?.camyoffset;
			case 1:
				newChar.cameraOffset.x += stage?.characterPoses['boyfriend']?.camxoffset;
				newChar.cameraOffset.y += stage?.characterPoses['boyfriend']?.camyoffset;
			case 2:
				newChar.cameraOffset.x += stage?.characterPoses['girlfriend']?.camxoffset;
				newChar.cameraOffset.y += stage?.characterPoses['girlfriend']?.camyoffset;
		}
	}
}

public function changeCharacter(strumIndex:Int, charName:String = 'bf', memberIndex:Int = 0, ?updateBar:Bool = true, newIconHeight:Int = 150, newIconWidth:Int = 150) {
	// vars
	var oldChar:Character = strumLines.members[strumIndex].characters[memberIndex];
	var newChar:Character = charMap[strumIndex][memberIndex].get(charName);

	// null check
	if (oldChar.curCharacter == newChar.curCharacter) return trace('It\'s the same character bro.');
	if (oldChar == null || newChar == null) return;

	// swaps old and new char
	var group = FlxTypedGroup.resolveGroup(oldChar);
	if (group == null) group = this;
	group.insert(group.members.indexOf(oldChar), newChar);
	newChar.active = newChar.visible = true;
	group.remove(oldChar);
	
	// fully apply change
	newChar.setPosition(oldChar.x, oldChar.y);
	newChar.playAnim(oldChar.animation?.name);
	newChar.animation?.curAnim?.curFrame = oldChar.animation?.curAnim?.curFrame;
	strumLines.members[strumIndex].characters[memberIndex] = newChar;
	if(updateBar){
		for(ico in iconArray) {
			if(ico.curCharacter == oldChar.getIcon())ico.setIcon(newChar.getIcon());
		}customHealthBarColors[0] = boyfriend.iconColor;customHealthBarColors[1] = dad.iconColor;
	}	
	if (funnyTraceMode) trace('Character index "' + memberIndex + '" changed to "' + newChar.curCharacter + '" on strumLine "' + strumIndex + '"!');
}

function onEvent(event) {
	switch (event.event.name) {
		case 'Change Character':
			changeCharacter(event.event.params[0], event.event.params[1], event.event.params[2], event.event.params[3], event.event.params[4], event.event.params[5]);
			strumLines.members[event.event.params[0]].characters[event.event.params[2]];
			dad.forceIsOnScreen = true;
			if (gf != null){
				gf.forceIsOnScreen = true;
			}
	}
}