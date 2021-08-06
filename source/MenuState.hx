package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Http;
import haxe.Json;
#if desktop
import sys.net.Socket;
#end
#if html5
import js.html.WebSocket;
#end

class MenuState extends FlxState
{
	var username:FlxInputText;
	var ip:FlxInputText;
	var port:FlxInputText;
	var character:FlxUIDropDownMenu;
	var code:FlxInputText;
	var join:FlxButton;
	var startgame:FlxButton;
	var clearlog:FlxButton;
	var log:FlxText;

	var stage:MapStage;
	var p1:Character;
	var p2:Character;

	// this makes my life easier so fuck you
	var ingame:Bool = false;
	var p2ingame:Bool = false;
	var startedgame:Bool = false;

	var charlist:Array<StrNameLabel>;
	var actualcharlist:Array<String> = ["test", "stickman"];

	function req(path, post)
	{
		//	var data = new haxe.Http('http://localhost:3000/' + path);
		//	data.setHeader('code', code.text)
		//	data.request(post);
	}

	override public function create():Void
	{
		super.create();

		charlist = new Array();
		for (i in 0...actualcharlist.length)
		{
			var listShit = new StrNameLabel(actualcharlist[i], actualcharlist[i]);
			charlist.push(listShit);
		}
		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		add(bg);
		log = new FlxText(0, 0, 0, "Log here.", 24);
		add(log);
		code = new FlxInputText(0, 0, 200, "enter code", 24, FlxColor.BLACK);
		add(code);
		code.screenCenter();
		character = new FlxUIDropDownMenu(0, 0, charlist);
		add(character);
		character.screenCenter();
		character.y -= 100;
		//	character.width = 200;
		//	character.height = 200;
		ip = new FlxInputText(0, 0, 200, "localhost", 24, FlxColor.BLACK);
		add(ip);
		ip.screenCenter();
		ip.y -= 200;
		port = new FlxInputText(0, 0, 200, "3920", 24, FlxColor.BLACK);
		add(port);
		port.screenCenter();
		port.y -= 300;
		username = new FlxInputText(0, 0, 200, "Username", 24, FlxColor.BLACK);
		add(username);
		username.screenCenter();
		username.y -= 400;

		join = new FlxButton(0, 0, "JOIN", function()
		{
			#if html5
			var ws = new WebSocket("ws://" + ip.text + ":" + port.text); // use native js WebSocket class (js.html.WebSocket in haxe)

			ws.onopen = function()
			{
				logshit("[Client] Connected to server, sending join request to code " + code.text);
				var joinrequest = {
					"type": "joinrequest",
					"character": character.selectedLabel,
					"username": username.text,
					"code": code.text
				}
				ws.send(Json.stringify(joinrequest));
			};
			ws.onmessage = function(e)
			{
				var data = Json.parse(e.data);
				if (data.type == "message")
				{
					logshit(data.message);
				}

				if (data.code == code.text)
				{
					if (!ingame)
					{ // meaning that the player is joining the game
						//	logshit(Json.stringify(data));
						var serverinfo = Json.parse(e.data);
						logshit("Joining server!");
						logshit("P1 Character: " + serverinfo.userdata[1].character);
						ingame = true;
						remove(username);
						remove(ip);
						remove(port);
						remove(character);
						remove(code);
						remove(join);
						p1 = new Character(1, false, serverinfo.userdata[1].character, "assets/characters/" + serverinfo.userdata[1].character + ".png", 60,
							140, -29, -50, 32, 32);
						add(p1);
						p1.x -= 100;
						if (serverinfo.userdata[2] != null)
						{
							p2ingame = true;
							p2 = new Character(2, false, serverinfo.userdata[2].character, "assets/characters/" + serverinfo.userdata[2].character + ".png");
							add(p2);
						}
						stage = new MapStage(500, 400, 1000, 400);
						add(stage);
						stage.screenCenter(X);

						logshit("Waiting for other players. Will update every\nsecond to look for new players.");
						var timer = new haxe.Timer(1000);
						timer.run = function()
						{
							var getserverrequest = {
								"type": "getserver",
								"code": code.text
							}
							ws.send(Json.stringify(getserverrequest));
							if (startedgame)
							{
								timer.run = function() {}
							}
						}
					}
					else
					{ // the player is getting the game details
						var serverinfo = Json.parse(e.data);
						if (!p2ingame) // checking to see if p2 is in game
						{
							//	logshit("Player 2 is not in game.");
							try
							{
								//	logshit(serverinfo.userdata[2].username);
							}
							catch (err)
							{
								//	logshit("cant find serverinfo.userdata[2]. logging to console");
								//	trace(Json.stringify(serverinfo));
							}
							if (serverinfo.userdata[2] != null)
							{
								p2ingame = true;

								logshit(serverinfo.userdata[2].username + " joined the lobby");
								p2 = new Character(2, false, serverinfo.userdata[2].character,
									"assets/characters/" + serverinfo.userdata[2].character + ".png");
								add(p2);

								startgame = new FlxButton(0, 0, "START GAME!", function()
								{
									var startgamerequest = {
										"type": "startgame",
										"code": code.text
									}
									ws.send(Json.stringify(startgamerequest));
									FlxG.switchState(new PlayState(serverinfo.code, "1", ip.text, port.text));
									startedgame = true;
								});
								startgame.screenCenter();
								startgame.setGraphicSize(300);
								startgame.y += 300;
								add(startgame);
							}
						}
						else
						{ // waiting for game to start. only for p2 cuz p1 would have left already(if they didint i dont feel like coding a failsafe for that so)
							if (serverinfo.status == "started")
							{
								// oh shit time to switch!
								if (!startedgame)
								{
									FlxG.switchState(new PlayState(serverinfo.code, "2", ip.text, port.text));
									startedgame = true;
								}
							}
						}
					}
				}
			};
			ws.onclose = function()
			{
				logshit("[Client] disconnected");
			};
			#else
			logshit("This platform is not supported");
			#end
		});
		join.screenCenter();
		join.setGraphicSize(300);
		join.y += 300;
		add(join);

		clearlog = new FlxButton(0, 0, "CLEAR LOG", function()
		{
			log.text = "";
		});
		join.setGraphicSize(300);
		clearlog.screenCenter();
		clearlog.y += 350;
		add(clearlog);
		#if html5
		logshit("You're on an html5 build");
		#else
		logshit("This platform is not supported yet");
		#end
		/*
			#if html5
			var ws = new WebSocket("ws://localhost:3920"); // use native js WebSocket class (js.html.WebSocket in haxe)

			ws.onopen = function()
			{
				logshit("[Client] Connected");
				ws.send("{}");
			};
			ws.onmessage = function(e)
			{
				var data = Json.parse(e.data);
				if (data.type == "message")
				{
					logshit(data.message);
				}

				if (data.extra == "joinserver")
				{
					remove(username);
					remove(ip);
					remove(port);
					remove(character);
					remove(code);
					remove(join);
				}
				trace(data.extra);
			};
			ws.onclose = function()
			{
				logshit("[Client] disconnected. This usually means that the server had an error.");
			};
			#end */
	}

	function logshit(msg)
	{
		log.text += "\n" + msg;
	}

	override public function update(elapsed:Float):Void
	{
		if (ingame)
		{
			FlxG.collide(p1, stage);
			FlxG.collide(p2, stage);
		}
		super.update(elapsed);
	}
}
