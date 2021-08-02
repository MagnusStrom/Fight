package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Character extends FlxSprite
{
	public var touchingObject = false;

	public var jumping = false;

	public var facingleft:Bool = true;
	public var canplay = false;
	public var hitting = false;

	var offsetx = 0;
	var offsety = 0;

	var canhit = true;

	public function new(playable = true, name = "test", path = "assets/characters/test.png", w = 60, h = 140, ox = -10, oy = -50, fwidth = 32, fheight = 32)
	{
		super();
		canplay = playable;
		loadGraphic(path, true, fwidth, fheight);
		drag.x = 350;
		offsetx = ox;
		offsety = oy;
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
		updateHitbox();
		width = w;
		height = h;
		acceleration.y = 900;
		maxVelocity.y = 300;
		screenCenter(X);
		offset.set(ox, oy);
	}

	public function respawn()
	{
		y = 0;
		screenCenter(X);
	}

	override public function update(elapsed:Float):Void
	{
		if (canplay)
		{
			if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
			{
				animation.play("moveleft");
				facingleft = true;
				velocity.x = -300;
			}
			if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
			{
				animation.play("moveright");
				facingleft = false;
				velocity.x = 300;
			}
			if (FlxG.keys.pressed.SPACE && !jumping)
			{
				velocity.y = -300;
				jumping = true;
			}

			// HIT CODE
			if (FlxG.keys.justPressed.P || FlxG.keys.justPressed.Z)
			{
				if (canhit)
				{
					hitting = true;
					if (!facingleft)
					{
						// width = 120;
						// offset.set(offsetx, offsety);
						animation.play("atkright");
					}
					else
					{
						// width = 120;
						// offset.set(-60, offsety); // ig if u attack first;
						animation.play("atkleft");
					}

					// reset
					canhit = false;
					var timer = new FlxTimer().start(1, function(timer)
					{
						canhit = true;
					});
				}
			}
			else
			{
				hitting = false;
			}

			if (jumping)
			{
				animation.play('jump');
			}
			if (!FlxG.keys.pressed.P && !FlxG.keys.pressed.Z && !FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.SPACE
				&& !FlxG.keys.pressed.A && !FlxG.keys.pressed.D)
			{
				animation.play('idle');
			}
		}
		if (y > 900)
		{
			respawn();
		}
		/*	if (acceleration.x > 0)
			{
				acceleration.x -= 1;
			}
			else if (acceleration.x < 0)
			{
				acceleration.x += 1;
			}
			if (acceleration.y > 0)
			{
				acceleration.y -= 1;
			}
			else if (acceleration.y < 0)
			{
				acceleration.y += 1;
		}*/
		super.update(elapsed);
	}
}
