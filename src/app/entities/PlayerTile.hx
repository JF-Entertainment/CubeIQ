package app.entities;

import app.entities.Tile;
import app.components.Texture;
import app.components.Input;

class PlayerTile extends Tile {

	public function new(TileX: Int, TileY: Int) {
		super(TileX, TileY, true);

		this.add(new Texture("res/images/tiles/player.png", 1));
		this.add(new Input());
		
		
	}

}