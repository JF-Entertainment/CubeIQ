package app.core;

import ash.core.Engine;
import app.entities.PlayerTile;
import app.entities.FinishTile;

class Level {

	public var TileSize(default, never):Int = 64;
	public var TileWidth: Int;
	public var TileHeight: Int;
	public var Name: String;

	public function new() {

	}

	public function loadFromJson(Json: Dynamic, Engine: Engine) : Void {

		//Read dimensions of level
		this.TileWidth = Json.Width;
		this.TileHeight = Json.Height;

		this.Name = Json.Name;

		//Create tiles
		var Y: Int = 0,
			X: Int = 0;

		while (Y < this.TileHeight) {

			while (X < this.TileWidth) {

				//Convert 2-Dimensional Grid to 1-Dimensional Array
				var ArrayPosition: Int = Y * this.TileWidth + X;

				//Add tile to engine
				this.addTile(Json.Tiles[ArrayPosition], X, Y, Engine);

				X++;
			}
			X = 0;
			Y++;
		}
	}


	private function addTile(Id: Int, X: Int, Y: Int, Engine:Engine) : Void {

		switch Id {
			case 1:
				Engine.addEntity(new PlayerTile(X, Y));

			case 9:
				Engine.addEntity(new FinishTile(X, Y));

		}

	}

}