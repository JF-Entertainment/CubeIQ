package app.core;

import engine.core.Game;
import app.ui.screens.GameScreen;
import engine.io.resources.Image;
import engine.io.resources.Text;

class App extends Game {


	public override function Load() {
		super.Load();


		//Resource-Callback
		this.ResourceManager.onLoad = function() {
			this.setView(new GameScreen());
		}

		//Load resources
		this.ResourceManager.addResource( new Text("res/levels/Levels.json"));
		this.ResourceManager.addResource( new Image("res/images/tiles/background.png"));
		this.ResourceManager.addResource( new Image("res/images/tiles/player.png"));
		this.ResourceManager.addResource( new Image("res/images/tiles/finish.png"));

	}


}