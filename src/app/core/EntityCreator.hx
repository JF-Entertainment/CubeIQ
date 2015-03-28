package app.core;

import ash.core.Entity;
import ash.core.Engine;

import app.components.Position;
import app.components.Tile;
import app.components.Texture;
import app.components.Input;

class EntityCreator {

    private var Engine: Engine;

    public function new(Engine:Engine) {
        this.Engine = Engine;
    }

    public function createFinishTile(TileX: Int, TileY: Int) : Entity {

        var newTile: Entity = new Entity()
            .add( new Position(TileX, TileY) )
            .add( new Texture("res/images/tiles/finish.png", 0) )
            .add( new app.components.Tile(false) );

        this.Engine.addEntity(newTile);
        return newTile;
    }

    public function createPlayerTile(TileX: Int, TileY: Int) : Entity {

        var newTile: Entity = new Entity()
            .add( new Position(TileX, TileY) )
            .add( new Texture("res/images/tiles/player.png", 1) )
            .add( new app.components.Tile(true) )
            .add( new Input() );

        this.Engine.addEntity(newTile);
        return newTile;
    }


}