package app.core;

import ash.core.Engine;
import app.core.EntityCreator;

class Level {

	public var TileSize(default, never):Int = 64;
	public var TileWidth: Int;
	public var TileHeight: Int;
	public var Name: String;

	public function new() {
		this.TileWidth = 0;
		this.TileHeight = 0;
	}

	public function loadFromJson(Json: Dynamic, Engine: Engine) : Void {

		//Read dimensions of level
		this.TileWidth = Json.Width;
		this.TileHeight = Json.Height;

		this.Name = Json.Name;

		var EntityCreator: EntityCreator = new EntityCreator(Engine);

		//Create tiles
		var Y: Int = 0,
			X: Int = 0;

		while (Y < this.TileHeight) {

			while (X < this.TileWidth) {

				//Convert 2-Dimensional Grid to 1-Dimensional Array
				var ArrayPosition: Int = Y * this.TileWidth + X;

				//Add tile to engine
				this.addTile(Json.Tiles[ArrayPosition], X, Y, EntityCreator);

				X++;
			}
			X = 0;
			Y++;
		}
	}


	private function addTile(Id: Int, X: Int, Y: Int, EntityCreator: EntityCreator) : Void {

		switch Id {
			case 1:
				EntityCreator.createPlayerTile(X, Y);

			case 9:
				EntityCreator.createFinishTile(X, Y);

		}

	}

}