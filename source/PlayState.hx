package;

import flixel.FlxG;
import flixel.FlxState;
import openfl.display.Stage;

class PlayState extends FlxState
{
	var stage:MapStage;
	var p1:Character;

	override public function create()
	{
		p1 = new Character();
		add(p1);
		stage = new MapStage();
		add(stage);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.overlap(p1, stage) == true)
		{
			// trace("TOUCHING STAGER");
			p1.velocity.y = 0;
			p1.touchingObject = true;
		}
		else
		{
			p1.touchingObject = false;
		}
		super.update(elapsed);
	}
}
