package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Character extends FlxSprite
{
	public var touchingObject = false;

	public function new(name = "test", path = "assets/characters/test.png", width = 32, height = 32)
	{
		super();
		loadGraphic(path, true, width, height);
		drag.x = 10;
		drag.y = 10;
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
				animation.add("hit", [8], 1);
				animation.add("jump", [9], 1);
				setGraphicSize(300);
		}
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.D)
		{
			animation.play("moveright");
			velocity.x = 30;
		}
		if (FlxG.keys.pressed.A)
		{
			animation.play("moveleft");
			velocity.x = -30;
		}
		if (FlxG.keys.pressed.SPACE)
		{
			animation.play("jump");
			velocity.y = -30;
		}
		if (!touchingObject)
		{
			y += 10;
		}

		super.update(elapsed);
	}
}
