package;

import flixel.FlxState;
import openfl.display.Stage;

class PlayState extends FlxState
{
	var stage:MapStage;

	override public function create()
	{
		super.create();
		stage = new MapStage();
		add(stage);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
