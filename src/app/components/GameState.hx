package app.components;

import app.core.Level;

class GameState {

	public var Level: Level;
	public var AnimationValue: Float;
	public var AnimationProgress: Float;

	public function new() {
		this.AnimationValue = 1;
		this.AnimationProgress = 0;
	}

}