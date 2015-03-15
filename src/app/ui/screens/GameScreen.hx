package app.ui.screens;

import ash.core.Engine;
import ash.core.Entity;
import app.entities.Tile;
import app.components.GameState;

import engine.ui.screens.Screen;
import app.systems.SystemPriorities;
import app.systems.RenderSystem;
import app.systems.GameSystem;
import app.systems.InputSystem;

class GameScreen extends Screen {

	private var Engine: Engine;

	public override function Load() : Void {
		super.Load();

		//Intialize engine
		this.Engine = new Engine();

		this.startGame();

	}

	private function startGame() : Void {


		//Intialize game-entity
        this.Engine.addEntity( new Entity().add(new GameState()) ); //Core game-entity

		//Initalize systems
		this.Engine.addSystem(new GameSystem( this.Game.ResourceManager.getResource("res/levels/Levels.json") ), SystemPriorities.preUpdate);
		this.Engine.addSystem(new InputSystem(this), SystemPriorities.Update);
		this.Engine.addSystem(new RenderSystem(this), SystemPriorities.Render);

	}

	public override function Update(time: Float) : Void {
		//Update ecs-engine
		this.Engine.update(time);
		super.Update(time);
	}

}