package app.entities;

import app.entities.Tile;
import app.components.Texture;

class FinishTile extends Tile {

	public function new(TileX: Int, TileY: Int) {
		super(TileX, TileY, false);

		this.add(new Texture("res/images/tiles/finish.png", 0));
		
		
	}

}