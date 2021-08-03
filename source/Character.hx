package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Character extends FlxSprite
{
	public var touchingObject = false;

	public var jumping = false;

	public var facingleft:Bool = true;
	public var meleeleft:Bool = true;
	public var canplay = false;
	public var hitting = false;
	// fuck my life
	public var special = false;
	public var usingspecial = false;

	var offsetx = 0;
	var offsety = 0;

	var canhit = true;
	var canspecial = true;

	public var hitboxInUse:Bool = false;

	public var hitboxX:Float = 0;
	public var hitboxY:Float = 0;
	public var hitboxColor = FlxColor.TRANSPARENT;
	public var hitboxVelocityX = 0;
	public var hitboxVelocityY = 0;

	public var char:String = "test";

	public function new(playable = true, name = "test", path = "assets/characters/test.png", w = 60, h = 140, ox = -10, oy = -50, fwidth = 32, fheight = 32)
	{
		super();

		char = name;
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
		maxVelocity.y = 500;
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
				if (!canhit)
				{
					if (!meleeleft)
					{
						animation.play("atkright", true);
					}
					else
					{
						animation.play("atkleft", true);
					}
				}
				else
				{
					animation.play("moveleft");
				}

				facingleft = true;
				velocity.x = -300;
			}
			if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
			{
				if (!canhit)
				{
					if (!meleeleft)
					{
						animation.play("atkright", true);
					}
					else
					{
						animation.play("atkleft", true);
					}
				}
				else
				{
					animation.play("moveright");
				}
				facingleft = false;
				velocity.x = 300;
			}
			if (FlxG.keys.pressed.SPACE && !jumping)
			{
				velocity.y = -500;
				jumping = true;
			}

			// HIT CODE
			if (FlxG.keys.justPressed.P || FlxG.keys.justPressed.Z)
			{
				if (canhit)
				{
					hitboxInUse = true;
					hitting = true;
					if (!facingleft)
					{
						meleeleft = false;
						// width = 120;
						// offset.set(offsetx, offsety);
						animation.play("atkright", true);
						hitboxX = (!facingleft ? (x + 100) : (x - 70));
						hitboxY = y + 20;
					}
					else
					{
						meleeleft = true;
						hitboxX = (!facingleft ? (x + 100) : (x - 70));
						hitboxY = y + 20;
						animation.play("atkleft", true);
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
				hitboxInUse = false;
			}

			// SPECIAL CODE
			if (FlxG.keys.justPressed.O || FlxG.keys.justPressed.X)
			{
				if (canspecial)
				{
					special = true;
					hitboxInUse = true;
					if (!facingleft)
					{
						animation.play("spcright");
					}
					else
					{
						animation.play("spcleft");
					}

					// reset
					canspecial = false;
					var timer = new FlxTimer().start(5, function(timer)
					{
						hitboxInUse = false;
						canspecial = true;
						usingspecial = false;
					});
				}
			}
			else
			{
				special = false;
			}

			if (jumping)
			{
				if (!canhit)
				{
					if (!meleeleft)
					{
						animation.play("atkright", true);
					}
					else
					{
						animation.play("atkleft", true);
					}
				}
				else
				{
					animation.play('jump', false);
				}
			}
			if (!FlxG.keys.pressed.P && !FlxG.keys.pressed.Z && !FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.SPACE
				&& !FlxG.keys.pressed.A && !FlxG.keys.pressed.D && !FlxG.keys.pressed.O && !FlxG.keys.pressed.X)
			{
				if (!canhit)
				{
					if (!meleeleft)
					{
						animation.play("atkright", true);
					}
					else
					{
						animation.play("atkleft", true);
					}
				}
				else
				{
					animation.play('idle');
				}
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
