package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import haxe.display.Display.Package;
import openfl.display.Stage;

class PlayState extends FlxState
{
	var stage:MapStage;
	var p1:Character;
	var p2:Character;
	var p1hitbox:FlxSprite;
	var p2hitbox:FlxSprite;

	var p1Objects:FlxTypedGroup<FlxSprite>;
	// fix this later
	var testCharLazer:FlxSprite;

	override public function create()
	{
		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(157, 237, 232));
		add(bg);
		p1 = new Character();
		add(p1);
		p1hitbox = new FlxSprite(p1.x + 20, p1.y).makeGraphic(50, 50, FlxColor.TRANSPARENT);
		add(p1hitbox);
		p2 = new Character(false);
		add(p2);
		stage = new MapStage(500, 400, 1000, 400);
		add(stage);
		stage.screenCenter(X);
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

		if (p1.special)
		{
			switch (p1.char)
			{
				case "test":
					testCharLazer = new FlxSprite(p1.x, p1.y + 20).makeGraphic(50, 50, FlxColor.RED);
					// testCharLazer.x = (p1.facingleft ? (p1.x + 100) : (p1.x - 70));
					testCharLazer.velocity.x = (p1.facingleft ? -1000 : 1000);
					add(testCharLazer);
			}
		}

		if (p1.hitboxInUse)
		{
			p1hitbox.x = p1.hitboxX;
			p1hitbox.y = p1.hitboxY;
			// p1hitbox.color = p1.hitboxColor;
			p1hitbox.velocity.x = p1.hitboxVelocityX;
			p1hitbox.velocity.y = p1.hitboxVelocityY;
		}

		if (FlxG.overlap(p2, p1hitbox))
		{
			if (p1.hitting == true)
			{
				trace(p1.facingleft ? "FACING LEFT" : "FACING RIGHT");
				p2.velocity.x = (p1.facingleft ? FlxG.random.int(-250, -500) : FlxG.random.int(250, 500));
				p2.velocity.y = FlxG.random.int(-2500, -5000);
				p2.animation.play('hit');
			}
		}
		// if (p1.animation)
		super.update(elapsed);
	}
}
