package app.systems;

import ash.core.System;
import ash.core.NodeList;
import ash.core.Engine;

import haxe.format.JsonParser;
import engine.io.resources.Text;

import app.nodes.GameNode;
import app.nodes.TileNode;
import app.components.GameState;
import app.core.Level;

class GameSystem extends System {

	private var GameNodes: NodeList<GameNode>;
	private var TileNodes: NodeList<TileNode>;
	private var Levels: Dynamic;
	private var Engine: Engine;

	public function new(JsonSrc: Text) {
		super();
		//Parse level-string
		this.Levels = JsonParser.parse(JsonSrc.Data).Levels;
	}

	public override function update(time:Float) :Void {
	

		for (GameNode in this.GameNodes) {
			var GameState: GameState = GameNode.GameState;



		}

	}


	public function loadLevel(Id: Int) : Void {

		//Destroy old tile-entities
		this.TileNodes.removeAll();

		//Load level with id 
		for (GameNode in this.GameNodes) {
			GameNode.GameState.Level.loadFromJson(this.Levels[Id], this.Engine);
		}
	}


	public override function addToEngine(Engine:Engine):Void {
        this.GameNodes = Engine.getNodeList(GameNode);
        this.TileNodes = Engine.getNodeList(TileNode);
        this.Engine = Engine;

        //Load first level
        for (GameNode in this.GameNodes) GameNode.GameState.Level = new Level();
        this.loadLevel(0);
    }

    public override function removeFromEngine(Engine:Engine):Void {
        this.GameNodes = null;
        this.TileNodes = null;
        this.Engine = null;
    }


}