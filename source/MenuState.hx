package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
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
	var character:FlxInputText;
	var code:FlxInputText;
	var join:FlxButton;
	var clearlog:FlxButton;
	var log:FlxText;

	var stage:MapStage;
	var p1:Character;
	var p2:Character;
	var ingame:Bool = false;

	function req(path, post)
	{
		//	var data = new haxe.Http('http://localhost:3000/' + path);
		//	data.setHeader('code', code.text)
		//	data.request(post);
	}

	override public function create():Void
	{
		super.create();

		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		add(bg);
		log = new FlxText(0, 0, 0, "Log here.", 24);
		add(log);
		code = new FlxInputText(0, 0, 200, "enter code", 24, FlxColor.BLACK);
		add(code);
		code.screenCenter();
		character = new FlxInputText(0, 0, 200, "character", 24, FlxColor.BLACK);
		add(character);
		character.screenCenter();
		character.y -= 100;
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
					"character": character.text,
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

				if (data.extra == "joinserver")
				{
					logshit("Joining server!");
					ingame = true;
					remove(username);
					remove(ip);
					remove(port);
					remove(character);
					remove(code);
					remove(join);
					p1 = new Character(1, false, "test", "assets/characters/test.png", 60, 140, -29, -50, 32, 32);
					add(p1);
					p2 = new Character(2, false, "stickman", "assets/characters/stickman.png");
					add(p2);
					stage = new MapStage(500, 400, 1000, 400);
					add(stage);
					stage.screenCenter(X);
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
		super.update(elapsed);
	}
}
