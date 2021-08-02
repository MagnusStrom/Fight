package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.display.Stage;

class PlayState extends FlxState
{
	var stage:MapStage;
	var p1:Character;
	var p2:Character;
	var p1hitbox:FlxSprite;
	var p2hitbox:FlxSprite;

	override public function create()
	{
		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(157, 237, 232));
		add(bg);
		p1 = new Character();
		add(p1);
		p1hitbox = new FlxSprite(p1.x + 20, p1.y).makeGraphic(20, 50, FlxColor.TRANSPARENT);
		add(p1hitbox);
		p2 = new Character(false);
		add(p2);
		stage = new MapStage();
		add(stage);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		// game logic ig
		// yanderedev moment

		if (FlxG.collide(p1, stage))
		{
			p1.jumping = false;
		}
		if (FlxG.collide(p2, stage))
		{
			p2.jumping = false;
		}

		if (p1.hitting == true)
		{
			p1hitbox.x = (!p1.facingleft ? (p1.x + 100) : (p1.x - 70));
			p1hitbox.y = p1.y + 20;
		}
		else
		{
			p1hitbox.x = 1000;
		}

		if (FlxG.overlap(p2, p1hitbox))
		{
			trace(p1.facingleft ? "FACING LEFT" : "FACING RIGHT");
			p2.velocity.x = (p1.facingleft ? -250 : 250);
			p2.velocity.y = (p1.facingleft ? -2500 : 2500);
		}

		// if (p1.animation)

		super.update(elapsed);
	}
}
