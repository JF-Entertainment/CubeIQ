package app.components;

class Position {

	public var X: Int;
	public var Y: Int;
	public var oldX: Int;
	public var oldY: Int;

	public function new(X: Int, Y: Int) {
		this.X = X;
		this.Y = Y;
		this.oldX = X;
		this.oldY = Y;
	}

}