package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.display.Display.Package;
import openfl.display.Stage;

class PlayState extends FlxState
{
	var stage:MapStage;
	var p1:Character;
	var p2:Character;

	var p1Objects:FlxTypedGroup<Hitbox>;

	override public function create()
	{
		p1Objects = new FlxTypedGroup<Hitbox>(0);
		add(p1Objects);
		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(157, 237, 232));
		add(bg);
		p1 = new Character(1);
		add(p1);
		p2 = new Character(2, false);
		add(p2);
		stage = new MapStage(500, 400, 1000, 400);
		add(stage);
		stage.screenCenter(X);
		p1Objects = new FlxTypedGroup<Hitbox>(0);
		add(p1Objects);
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
					var testCharLazer:Hitbox = new Hitbox(p1.x, p1.y + 20, 50, 50, FlxColor.BLUE, 700,
						1000); // testCharLazer.x = (p1.facingleft ? (p1.x + 100) : (p1.x - 70));
					testCharLazer.velocity.x = (p1.attackleft ? -1000 : 1000);
					p1Objects.add(testCharLazer);
					// trace("ADDED");
			}
		}

		if (p1.hitting)
		{
			switch (p1.char)
			{
				case "test":
					var p1hitbox:Hitbox = new Hitbox(p1.x + (50 * (p1.attackleft ? -1 : 1.3)), p1.y + 20, 50, 50, FlxColor.TRANSPARENT, 500, 2500);
					p1Objects.add(p1hitbox);
					var timer = new FlxTimer().start(0.1, function(timer)
					{
						p1Objects.remove(p1hitbox);
					});
			}
		}
		/*	if (p1.hitboxInUse)
			{
				p1hitbox.x = p1.hitboxX;
				p1hitbox.y = p1.hitboxY;
				// p1hitbox.color = p1.hitboxColor;
				p1hitbox.velocity.x = p1.hitboxVelocityX;
				p1hitbox.velocity.y = p1.hitboxVelocityY;
		}*/

		FlxG.overlap(p1Objects, p2, function(hitbox:Hitbox, p2:Character)
		{
			// p2.velocity.x = (p1.facingleft ? FlxG.random.int(-250, -500) : FlxG.random.int(250, 500));
			p2.velocity.x = FlxG.random.int(hitbox.knockbackx, hitbox.knockbackx) * (p1.attackleft ? -1 : 1);
			p2.velocity.y = FlxG.random.int(-hitbox.knockbacky, -hitbox.knockbacky);
			// trace(hitbox.knockbackx);
			// trace(hitbox.knockbacky);
			if (!p2.stunned)
			{
				p2.stunned = true;
				var timer = new FlxTimer().start(FlxG.random.float(0.1, 1), function(timer)
				{
					p2.stunned = false;
				});
			}
		});
		// if (p1.animation)
		super.update(elapsed);
	}
}
