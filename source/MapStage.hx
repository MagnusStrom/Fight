package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class MapStage extends FlxSprite
{
	public function new(x = 500, y = 400, w = 500, h = 100, color = FlxColor.BLUE)
	{
		super(x, y);
		trace("CREATING???????");
		makeGraphic(w, h, color);
		immovable = true;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
