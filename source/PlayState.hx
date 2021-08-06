package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import haxe.Timer;
import haxe.display.Display.Package;
import js.html.WebSocket;
import openfl.display.Stage;

class PlayState extends FlxState
{
	var stage:MapStage;
	var p1:Character;
	var p2:Character;

	var p1Objects:FlxTypedGroup<Hitbox>;
	var p2Objects:FlxTypedGroup<Hitbox>;

	public var code:String = "NONE";

	var player:String = "69";

	var player1:Bool = false;

	var ip:String = "localhost";

	var port:String = "3920";

	var stats:FlxText;

	var ws:WebSocket;

	var playersloaded:Bool = false;

	var last:String;

	// to make shit easier!!
	function logshit(msg)
	{
		trace(msg);
	}

	override public function new(gamecode, playernum, ipdata, portdata)
	{
		code = gamecode;
		player = playernum;
		ip = ipdata;
		port = portdata;
		super();
	}

	/**
		*Parse a string into a bool.
	**/
	function parseBool(string:String)
	{
		if (string == "true")
			return true;
		else if (string == "false")
			return false;
		else
			throw "Cannot parse non true or false";
	}

	override public function create()
	{
		// shit
		FlxG.fixedTimestep = false;
		FlxG.autoPause = false;

		// im tired
		if (player == "1")
		{
			player1 = true;
		}
		else
		{
			player1 = false;
		}
		// websocket shit
		// stolen form me!!
		ws = new WebSocket("ws://" + ip + ":" + port);
		ws.onopen = function()
		{
			logshit("[Client] Connected to server, sending info request to code " + code);
			var getserverrequest = {
				"type": "getserver",
				"code": code
			}
			ws.send(Json.stringify(getserverrequest));
		};

		ws.onmessage = function(e)
		{
			var data = Json.parse(e.data);
			var lastdata = Json.parse(last);
			var lastnull = (lastdata == null ? true : false);

			if (data.type == "message")
			{
				logshit(data.message);
			}

			// main logic for game here
			if (data.code == code)
			{ // if the data sent is game related
				if (!playersloaded)
				{
					p1 = new Character(1, player1, data.userdata[1].character, "assets/characters/" + data.userdata[1].character + ".png", 60, 140, -29, -50,
						32, 32);
					add(p1);
					p2 = new Character(2, !player1, data.userdata[2].character, "assets/characters/" + data.userdata[2].character + ".png");
					add(p2);
					playersloaded = true;
				}
				else
				{
					if (player == "1")
					{
						p2.x = Std.parseFloat(data.userdata[2].x);
						p2.y = Std.parseFloat(data.userdata[2].y);
						//	trace(data.userdata[2].animation);
						if (data.userdata[2].animation != null)
						{
							p2.animation.play(data.userdata[2].animation);
						}

						if (!lastnull)
						{
							if (lastdata.userdata[2].hitting == true)
							{
								p2.hitting = false;
							}
							else
							{
								p2.hitting = parseBool(data.userdata[2].hitting);
							}

							if (lastdata.userdata[2].special == true)
							{
								p2.special = false;
							}
							else
							{
								p2.special = parseBool(data.userdata[2].special);
							}
						}
						p2.facingleft = parseBool(data.userdata[2].facingleft);
						p2.attackleft = parseBool(data.userdata[2].attackleft);
					}
					else if (player == "2")
					{ // to be safe ig
						p1.x = Std.parseFloat(data.userdata[1].x);
						p1.y = Std.parseFloat(data.userdata[1].y);
						// trace(data.userdata[1].animation);
						if (data.userdata[1].animation != null)
						{
							p1.animation.play(data.userdata[1].animation);
						}

						if (!lastnull)
						{
							if (lastdata.userdata[1].hitting == true)
							{
								p1.hitting = false;
							}
							else
							{
								p1.hitting = parseBool(data.userdata[1].hitting);
							}

							if (lastdata.userdata[1].special == true)
							{
								p1.special = false;
							}
							else
							{
								p1.special = parseBool(data.userdata[1].special);
							}
						}

						p1.facingleft = parseBool(data.userdata[1].facingleft);
						p1.attackleft = parseBool(data.userdata[1].attackleft);
					}
				}
			}
			last = e.data;
		};

		ws.onclose = function()
		{
			logshit("[Client] disconnected");
		};

		var timer = new Timer(10);
		timer.run = function()
		{
			if (playersloaded)
			{
				if (player == "1")
				{
					var req = {
						"type": "updateplayer",
						"code": code,
						"player": "1",
						"x": Std.string(p1.x),
						"y": Std.string(p1.y),
						"hitting": Std.string(p1.hitting),
						"special": Std.string(p1.special),
						"animation": p1.animation.curAnim.name,
						"facingleft": Std.string(p1.facingleft),
						"attackleft": Std.string(p1.attackleft)
					}
					ws.send(Json.stringify(req));
				}
				else if (player == "2")
				{ // to be safe ig
					// trace("UPLOADING P2X: " + p2.x);
					var req = {
						"type": "updateplayer",
						"code": code,
						"player": "2",
						"x": Std.string(p2.x),
						"y": Std.string(p2.y),
						"hitting": Std.string(p2.hitting),
						"special": Std.string(p2.special),
						"animation": p2.animation.curAnim.name,
						"attackleft": Std.string(p2.attackleft)
					}
					ws.send(Json.stringify(req));
				}
			}

			if (playersloaded)
			{
				if (p1.special)
				{
					switch (p1.char)
					{
						case "test":
							var testCharLazer:Hitbox = new Hitbox(p1.x, p1.y + 60, 50, 50, FlxColor.BLUE, 700,
								1000); // testCharLazer.x = (p1.facingleft ? (p1.x + 100) : (p1.x - 70));
							testCharLazer.velocity.x = (p1.attackleft ? -1000 : 1000);
							p1Objects.add(testCharLazer);
						// trace("ADDED");
						case "stickman":
							var explosion:Hitbox = new Hitbox(p1.x + 26, p1.y + 70, 10, 10, FlxColor.BLUE, 2500,
								2500); // testCharLazer.x = (p1.facingleft ? (p1.x + 100) : (p1.x - 70));
							explosion.alpha = 0.5;
							p1Objects.add(explosion);
							FlxTween.tween(explosion, {"scale.x": 20, "scale.y": 20}, 0.5, {
								onUpdate: function(tween)
								{
									//	FlxG.watch.addQuick("mid", (p1.width / 2));
									explosion.updateHitbox();
									explosion.x = ((p1.width / 2) + p1.x) - (explosion.width / 2);
									explosion.y = ((p1.height / 2) + p1.y) - (explosion.height / 2);
									// trace("X: " + explosion.x);
								},
								onComplete: function(tween)
								{
									p1Objects.remove(explosion);
								},
								type: ONESHOT
							});
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
						case "stickman":
							var p1bullet:Hitbox = new Hitbox(p1.x + (50 * (p1.attackleft ? -1 : 1.3)), p1.y + 50, 10, 10, FlxColor.RED, 700, 500);
							p1Objects.add(p1bullet);
							p1bullet.velocity.x = (500 * (p1.attackleft ? -1 : 1.3));
							var timer = new FlxTimer().start(5, function(timer)
							{
								p1Objects.remove(p1bullet);
							});
					}
				}
				if (p2.special)
				{
					switch (p2.char)
					{
						case "test":
							var testCharLazer:Hitbox = new Hitbox(p2.x, p2.y + 60, 50, 50, FlxColor.BLUE, 700,
								1000); // testCharLazer.x = (p2.facingleft ? (p2.x + 100) : (p2.x - 70));
							testCharLazer.velocity.x = (p2.attackleft ? -1000 : 1000);
							p2Objects.add(testCharLazer);
						// trace("ADDED");
						case "stickman":
							var explosion:Hitbox = new Hitbox(p2.x + 26, p2.y + 70, 10, 10, FlxColor.BLUE, 2500,
								2500); // testCharLazer.x = (p2.facingleft ? (p2.x + 100) : (p2.x - 70));
							explosion.alpha = 0.5;
							p2Objects.add(explosion);
							FlxTween.tween(explosion, {"scale.x": 20, "scale.y": 20}, 0.5, {
								onUpdate: function(tween)
								{
									//	FlxG.watch.addQuick("mid", (p2.width / 2));
									explosion.updateHitbox();
									explosion.x = ((p2.width / 2) + p2.x) - (explosion.width / 2);
									explosion.y = ((p2.height / 2) + p2.y) - (explosion.height / 2);
									// trace("X: " + explosion.x);
								},
								onComplete: function(tween)
								{
									p2Objects.remove(explosion);
								},
								type: ONESHOT
							});
					}
				}

				if (p2.hitting)
				{
					switch (p2.char)
					{
						case "test":
							var p2hitbox:Hitbox = new Hitbox(p2.x + (50 * (p2.attackleft ? -1 : 1.3)), p2.y + 20, 50, 50, FlxColor.TRANSPARENT, 500, 2500);
							p2Objects.add(p2hitbox);
							var timer = new FlxTimer().start(0.1, function(timer)
							{
								p2Objects.remove(p2hitbox);
							});
						case "stickman":
							var p2bullet:Hitbox = new Hitbox(p2.x + (50 * (p2.attackleft ? -1 : 1.3)), p2.y + 50, 10, 10, FlxColor.RED, 700, 500);
							p2Objects.add(p2bullet);
							p2bullet.velocity.x = (500 * (p2.attackleft ? -1 : 1.3));
							var timer = new FlxTimer().start(5, function(timer)
							{
								p2Objects.remove(p2bullet);
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

				if (player == "2")
				{
					FlxG.overlap(p1Objects, p2, function(hitbox:Hitbox, p2:Character)
					{
						// p2.velocity.x = (p1.facingleft ? FlxG.random.int(-250, -500) : FlxG.random.int(250, 500));
						p2.velocity.x = FlxG.random.int(hitbox.knockbackx, hitbox.knockbackx) * (p1.attackleft ? -1 : 1);
						p2.velocity.y = FlxG.random.int(-hitbox.knockbacky, -hitbox.knockbacky);
						// trace(hitbox.knockbackx);
						// trace(hitbox.knockbacky);
						p1Objects.remove(hitbox);
						if (!p2.stunned)
						{
							p2.stunned = true;
							var timer = new FlxTimer().start(FlxG.random.float(0.1, 1), function(timer)
							{
								p2.stunned = false;
							});
						}
					});
				}
				if (player == "1")
				{
					FlxG.overlap(p2Objects, p1, function(hitbox:Hitbox, p1:Character)
					{
						// p2.velocity.x = (p1.facingleft ? FlxG.random.int(-250, -500) : FlxG.random.int(250, 500));
						p1.velocity.x = FlxG.random.int(hitbox.knockbackx, hitbox.knockbackx) * (p2.attackleft ? -1 : 1);
						p1.velocity.y = FlxG.random.int(-hitbox.knockbacky, -hitbox.knockbacky);
						// trace(hitbox.knockbackx);
						// trace(hitbox.knockbacky);
						p2Objects.remove(hitbox);
						if (!p1.stunned)
						{
							p1.stunned = true;
							var timer = new FlxTimer().start(FlxG.random.float(0.1, 1), function(timer)
							{
								p1.stunned = false;
							});
						}
					});
				}
			}
		};

		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(157, 237, 232));
		add(bg);
		stage = new MapStage(500, 400, 1000, 400);
		add(stage);
		stage.screenCenter(X);
		p1Objects = new FlxTypedGroup<Hitbox>(0);
		add(p1Objects);
		p2Objects = new FlxTypedGroup<Hitbox>(0);
		add(p2Objects);
		stats = new FlxText(0, 0, 0, "GAME STATS:\nCode: " + code + "\nPlayer: " + player, 24, true);
		stats.screenCenter();
		add(stats);
		stats.color = FlxColor.BLACK;
		super.create();
	}

	override public function update(elapsed:Float)
	{
		// All data is moved to a timer loop to compensate for lag. However, to prevent through the stage collisions are kept here

		if (FlxG.collide(p1, stage))
		{
			p1.jumping = false;
		}
		if (FlxG.collide(p2, stage))
		{
			p2.jumping = false;
		}

		super.update(elapsed);
	}
}
