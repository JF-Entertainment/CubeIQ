package app.systems;

import ash.core.System;
import ash.core.NodeList;
import ash.core.Engine;
import engine.ui.View;

import engine.utils.helpers.Animation;

import app.nodes.GameNode;
import app.nodes.InputNode;
import app.nodes.TileNode;
import app.components.Position;
import app.components.Tile;
import app.components.GameState;
import app.core.Level;

enum Direction{
	Up;
	Down;
	Left;
	Right;
}

class InputSystem extends System {

	private var GameNodes: NodeList<GameNode>;
	private var InputNodes: NodeList<InputNode>;
	private var TileNodes: NodeList<TileNode>;
	private var View: View;

	private var isInputAllowed: Bool;
	private var InputFreezeTime(default, never): Float = 650;

	public function new(View: View) {
		super();
		this.View = View;
		this.isInputAllowed = true;
	}

	public override function update(time: Float) : Void {
		
		//Update InputFreezeTimer and allow input, if it has reached InputFreezeTime
		for (GameNode in this.GameNodes) {
			var GameState: GameState = GameNode.GameState;

			GameState.AnimationValue += time;
			if (GameState.AnimationValue > this.InputFreezeTime) {
				//Timer has reached its end
				GameState.AnimationValue = this.InputFreezeTime;
				this.isInputAllowed = true;
			}

			GameState.AnimationProgress = GameState.AnimationValue/this.InputFreezeTime;
			
		}

	}

	//Moves players until they hit something
	private function Move(Direction: Direction) : Void {


		for (GameNode in this.GameNodes) {
			var GameState: GameState = GameNode.GameState;


			//Check if input had just been made
			if (this.isInputAllowed) {

				var Players: Int = 0;
				//Move tiles
				for (InputNode in this.InputNodes) {
					var Position: Position = InputNode.Position;

					//Save old position for animation
					Position.oldX = Position.X;
					Position.oldY = Position.Y;

					//Get clear space and moves player n blocks
					switch (Direction) {
						case Up: Position.Y -= this.getClearSpace(Position.X, Position.Y, Direction, GameState.Level);
						case Down: Position.Y += this.getClearSpace(Position.X, Position.Y, Direction, GameState.Level);
						case Right: Position.X += this.getClearSpace(Position.X, Position.Y, Direction, GameState.Level);
						case Left: Position.X -= this.getClearSpace(Position.X, Position.Y, Direction, GameState.Level);
					}
				}

				//Hacky way to allow between-player-collision
				for (i in 0...Players + 1) {
					for (InputNode in this.InputNodes) {
						var Position: Position = InputNode.Position;
						//Get clear space and moves player n blocks
						switch (Direction) {
							case Up: Position.Y -= this.getClearSpace(Position.X, Position.Y, Direction, GameState.Level);
							case Down: Position.Y += this.getClearSpace(Position.X, Position.Y, Direction, GameState.Level);
							case Right: Position.X += this.getClearSpace(Position.X, Position.Y, Direction, GameState.Level);
							case Left: Position.X -= this.getClearSpace(Position.X, Position.Y, Direction, GameState.Level);
						}
					}
				}


				//Disallow input and start timer
				this.isInputAllowed = false;
				GameState.AnimationValue = 0;
			}


		}
	}

	//Returns available space in one direction
	private function getClearSpace(X: Int, Y: Int, Direction: Direction, Level: Level) : Int {

		var startX: Int = X,
			startY: Int = Y,
			looping: Bool = true;

		while (looping) {

			var oldX: Int = X,
				oldY: Int = Y; 

			//Move to test
			switch (Direction) {
				case Up: Y--;
				case Down: Y++;
				case Right: X++;
				case Left: X--;
			}

			//If new position collides
			if (this.hasCollideableTile(X, Y, Level)) {
				//Move to old Position
				X = oldX;
				Y = oldY;

				//Abort loop
				looping = false;
			}

		}


		switch (Direction) {
			case Up: return startY - Y;
			case Down: return Y - startY;
			case Right: return X - startX;
			case Left: return startX - X;
		}

	}

	//Returns if a tile is collideable (also returns true, if out of tile-grid)
	private function hasCollideableTile(X: Int, Y: Int, Level: Level) : Bool {

		//Check if tile is out of grid
		if (X < 0 || Y < 0 || X >= Level.TileWidth || Y >= Level.TileHeight) return true;

		//Check if tile exists
		for (TileNode in this.TileNodes) {
			var Position: Position = TileNode.Position,
				Tile: Tile = TileNode.Tile;
			if (Position.X == X && Position.Y == Y && Tile.Collision) return true;
		}

		//Tile is neither out of grid nor exists
		return false;
	}

	//KeyDown Handler
	private function onKeyDown(Event: engine.input.KeyboardEvent) : Void {
		switch (Event.KeyCode) {
			case 38: this.Move(Up);
			case 40: this.Move(Down);
			case 39: this.Move(Right);
			case 37: this.Move(Left);
		}
	}

	public override function addToEngine(Engine:Engine):Void {
        this.GameNodes = Engine.getNodeList(GameNode);
        this.InputNodes = Engine.getNodeList(InputNode);
        this.TileNodes = Engine.getNodeList(TileNode);

        //Register events
        this.View.KeyboardInput.onKeyDown.addListener(this.onKeyDown);
    }

    public override function removeFromEngine(Engine:Engine):Void {
        this.GameNodes = null;
        this.InputNodes = null;
        this.TileNodes = null;
    }


}