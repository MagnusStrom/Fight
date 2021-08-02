package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class MapStage extends FlxSprite
{
	public function new(name = "test", path = "assets/characters/test.png", width = 32, height = 32)
	{
		super();
		loadGraphic(path, width, height);
		switch (name)
		{
			case "test":
				animation.add("idle", [0, 1], 1);
				animation.add("moveleft", [3], 1);
				animation.add("moveright", [2], 1);
				animation.add("atkleft", [5], 1);
				animation.add("atkright", [4], 1);
				animation.add("spcleft", [7], 1);
				animation.add("spcright", [6], 1);
                animation.add("hit", [8], 1)\
                animation.add("jump", [9], 1)
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
