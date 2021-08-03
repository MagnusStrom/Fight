package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Http;

class MenuState extends FlxState
{
	var character:FlxInputText;
	var code:FlxInputText;
	var join:FlxButton;
	var clearlog:FlxButton;
	var log:FlxText;

	function req(path, post)
	{
		//	var data = new haxe.Http('http://localhost:3000/' + path);
		//	data.setHeader('code', code.text)
		//	data.request(post);
	}

	override public function create():Void
	{
		super.create();
		// var client = new Client('ws://localhost:3000');

		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		add(bg);
		log = new FlxText(0, 0, 0, "Log here.", 24);
		add(log);
		code = new FlxInputText(0, 0, 200, "enter code", 24, FlxColor.BLACK);
		add(code);
		code.screenCenter();
		character = new FlxInputText(0, 0, 200, "stickman or test", 24, FlxColor.BLACK);
		add(character);
		character.screenCenter();
		character.y -= 200;

		join = new FlxButton(0, 0, "JOIN", function()
		{
			logshit("[Client] CONTACTING SERVER WITH CODE " + code.text);
			var data = new haxe.Http('http://localhost:3000/getserver');
			data.setHeader('code', code.text);
			data.setHeader('character', character.text);
			data.onData = function(data)
			{
				logshit(data);
			}
			data.request(true);
		});
		join.screenCenter();
		join.y += 300;
		add(join);

		clearlog = new FlxButton(0, 0, "CLEAR LOG", function()
		{
			log.text = "";
		});
		clearlog.screenCenter();
		clearlog.y += 350;
		add(clearlog);

		var data = haxe.Http.requestUrl('http://localhost:3000/test');
		logshit(data);
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
