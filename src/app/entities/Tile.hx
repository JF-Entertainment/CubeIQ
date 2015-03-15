package app.entities;

import ash.core.Entity;
import app.components.Position;

class Tile extends Entity {

	public function new(TileX: Int, TileY: Int, Collision: Bool) {
		super();

		this.add( new Position(TileX, TileY) );
		this.add( new app.components.Tile(Collision) );
	}

}