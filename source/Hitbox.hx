package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Hitbox extends FlxSprite
{
	public var knockbackx:Int;
	public var knockbacky:Int;

	public function new(x:Float = 500, y:Float = 400, w, h, color = FlxColor.TRANSPARENT, kbx = 10, kby = 20)
	{
		knockbackx = kbx;
		knockbacky = kby;
		super(x, y);
		makeGraphic(w, h, color);
	}

	public function hitObject(obj:FlxSprite)
	{
		obj.velocity.x += knockbackx;
		obj.velocity.y += knockbacky;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
