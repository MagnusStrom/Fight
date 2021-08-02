package;

import flixel.FlxG;
import flixel.FlxSprite;

class MapStage extends FlxSprite
{
	public function new()
	{
		super();
		makeGraphic(100, 100, 0xFFFFFFFF);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
