package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Character extends FlxSprite
{
	public var stunned = false;

	public var jumping = false;

	public var facingleft:Bool = true;
	public var attackleft:Bool = true;
	public var canplay = false;
	public var hitting = false;
	// fuck my life
	public var special = false;

	public var usingnormal = false;
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

	private var pnum = 1;

	// idk
	var charlist:Array<String> = ["test", "stickman", "bobross"];
	var atkcooldown:Array<Float> = [1, 1, 1];
	var specialcooldown:Array<Float> = [3, 10, 3];

	public function new(playernum = 1, playable = true, name = "test", path = "assets/characters/test.png")
	{
		super();

		pnum = playernum;
		char = name;
		canplay = playable;
		loadGraphic(path, true, 32, 32);
		if (canplay)
		{
			drag.x = 350;
		}

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
				offsetx = -9;
				offsety = -50;
				setGraphicSize(300);
				width = 60;
				height = 140;
			case "stickman":
				animation.add("idle", [0, 1], 1);
				animation.add("moveleft", [2, 3], 3);
				animation.add("moveright", [4, 5], 3);
				animation.add("atkleft", [6], 1);
				animation.add("atkright", [7], 1);
				animation.add("spcleft", [8, 9, 10, 11], 1);
				animation.add("spcright", [8, 9, 10, 11], 1);
				animation.add("hit", [12], 1);
				animation.add("jump", [13], 1);
				offsetx = -30;
				offsety = -50;
				setGraphicSize(300);
				width = 60;
				height = 140;
			case "bobross":
				animation.add("idle", [0, 1], 1);
				animation.add("moveleft", [2, 3], 3);
				animation.add("moveright", [4, 5], 3);
				animation.add("atkleft", [6], 1);
				animation.add("atkright", [7], 1);
				animation.add("spcleft", [8], 1);
				animation.add("spcright", [9], 1);
				animation.add("hit", [10], 1);
				animation.add("jump", [11], 1);
				offsetx = -30;
				offsety = -50;
				setGraphicSize(200);
				width = 90;
				height = 170;
		}
		animation.play('idle');
		// updateHitbox();
		if (canplay)
		{
			acceleration.y = 900;
			maxVelocity.y = 500;
		}
		screenCenter(X);
		offset.set(offsetx, offsety);
	}

	public function respawn()
	{
		y = 0;
		velocity.set(0, 0);
		screenCenter(X);
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.watch.addQuick("PLAYER" + pnum + "STUNNED", stunned);
		// FlxG.watch.addQuick("PLAYER" + pnum + "
		if (stunned)
		{
			animation.play("hit");
		}
		else
		{
			if (canplay)
			{
				if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
				{
					if (!canhit)
					{
						if (!attackleft)
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
						if (!attackleft)
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

				// This code is actually fucking monkey.
				if (canhit && canspecial)
				{
					if (FlxG.keys.justPressed.P || FlxG.keys.justPressed.Z)
					{
						FlxG.log.add("HIT TIME");
						if (canhit)
						{
							FlxG.log.add("HIT TIME");
							// hitboxInUse = true;
							hitting = true;
							if (!facingleft)
							{
								attackleft = false;
								// width = 120;
								// offset.set(offsetx, offsety);
								animation.play("atkright", true);
								hitboxX = (!facingleft ? (x + 100) : (x - 70));
								hitboxY = y + 20;
							}
							else
							{
								attackleft = true;
								hitboxX = (!facingleft ? (x + 100) : (x - 70));
								hitboxY = y + 20;
								animation.play("atkleft", true);
							}
							// reset
							canhit = false;
							var timer = new FlxTimer().start(atkcooldown[charlist.indexOf(char)], function(timer)
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
								attackleft = false;
							}
							else
							{
								animation.play("spcleft");
								attackleft = true;
							}

							// reset
							canspecial = false;
							var timer = new FlxTimer().start(specialcooldown[charlist.indexOf(char)], function(timer)
							{
								hitboxInUse = false;
								canspecial = true;
							});
						}
					}
					else
					{
						special = false;
					}
				}
				else
				{
					hitting = false;
					special = false;
				}

				if (jumping)
				{
					if (!canhit)
					{
						if (!attackleft)
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
						if (!attackleft)
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
			else
			{
				// punching bag, for waiting ig
				// animation.play('idle');
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
