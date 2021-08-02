package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class MapStage extends FlxSprite
{
	public function new(x = 0, y = 400, color = FlxColor.GRAY)
	{
		super();
		makeGraphic(x, y, color);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
