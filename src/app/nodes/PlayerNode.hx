package app.nodes;

import ash.core.Node;
import app.components.Player;
import app.components.Tile;
import app.components.Position;

class PlayerNode extends Node<PlayerNode> {

    public var Tile: Tile;
    public var Position: Position;
    public var Player: Player;
}