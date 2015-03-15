package;

import openfl.display.Sprite;
import app.core.App;

class Main extends Sprite {
	
	
	public function new () {
		super();
		var Game: App = new App(this);
		Game.Load();
	}
	
}
