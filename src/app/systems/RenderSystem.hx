package app.systems;

import ash.core.System;
import ash.core.NodeList;
import ash.core.Engine;

import engine.ui.View;
import engine.graphics.rendering.Canvas;
import app.nodes.RenderNode;
import app.nodes.GameNode;
import app.components.Position;
import app.components.Texture;
import app.components.GameState;
import app.core.Level;

class RenderSystem extends System {

	private var Canvas(default, null): Canvas;
	private var View(default, null): View;
	private var RenderNodes: NodeList<RenderNode>;
	private var GameNodes: NodeList<GameNode>;

	public function new(View: View) {
		super();
		this.View = View;
		this.Canvas = View.Game.Canvas;
	}

	public override function update(time:Float) :Void {
		

		for (GameNode in this.GameNodes) {
			var GameState: GameState = GameNode.GameState,
				Level: Level = GameState.Level;

			//Calculate zoom and position of tiles
			var SafeArea: Float =  0.7, //Border of tile grid
				MarginBottom: Float = 1.8,

				TileGridWidth: Float = Level.TileWidth * Level.TileSize,
				TileGridHeight: Float = Level.TileHeight * Level.TileSize,
				Zoom: Float = (this.View.Width * SafeArea) / TileGridWidth,

				TileGridX: Float = (this.View.Width - TileGridWidth * Zoom) / 2,
				TileGridY: Float = (this.View.Height - TileGridHeight * Zoom) / MarginBottom;


			//Draw background grid
			for(Y in 0...Level.TileHeight) {
				for(X in 0...Level.TileWidth) {

					this.Canvas.drawImage(
						this.View.Game.ResourceManager.getResource("res/images/tiles/background.png"), 
						X * Level.TileSize * Zoom + TileGridX,
						Y * Level.TileSize * Zoom + TileGridY,
						Level.TileSize * Zoom,
						Level.TileSize * Zoom
					);	

				}
			}	


			//Draw grid
			for (RenderNode in this.RenderNodes) {	
				var Position: Position = RenderNode.Position,
					Texture: Texture = RenderNode.Texture;
				//Draw tile
				this.Canvas.drawImage(
					this.View.Game.ResourceManager.getResource(Texture.Path), 
					(Position.X - ((Position.X - Position.oldX) * (1 - this.EaseInOut(GameState.AnimationProgress)))) * Level.TileSize * Zoom + TileGridX,
					(Position.Y - ((Position.Y - Position.oldY) * (1 - this.EaseInOut(GameState.AnimationProgress)))) * Level.TileSize * Zoom + TileGridY,
					Level.TileSize * Zoom,
					Level.TileSize * Zoom
				);

			}


			}

	}


	//Helper function for sliding animation.
	private function EaseInOut(t: Float) : Float {
		return t<.5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1;
	}

	private function onNodeAdded(Node: RenderNode) : Void {
		this.sortRenderNodes();
	}


	private function sortRenderNodes() : Void {
		//Sort Rendernodes by Z-value
		this.RenderNodes.insertionSort( function(node1 : RenderNode, node2 : RenderNode) : Int {
			return node1.Texture.Z - node2.Texture.Z;
		});
	}

	public override function addToEngine(Engine:Engine):Void {
        this.RenderNodes = Engine.getNodeList(RenderNode);
        this.GameNodes = Engine.getNodeList(GameNode);

        //Register event
    	this.RenderNodes.nodeAdded.add(this.onNodeAdded);

    	//Sort array for the first time
    	this.sortRenderNodes();
    }

    public override function removeFromEngine(Engine:Engine):Void {
        this.RenderNodes = null;
        this.GameNodes = null;
    }


}