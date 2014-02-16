package model;

import model.Color;
import model.Tile;


class Ball {

  @:isVar
  public var tile (get, set) : Tile;

  public var color (get, null) : Color;

  public function new(color) {
    this.color = color;
  }

  private function get_color() : Color {
    return color;
  }

  private function get_tile() : Tile {
    return tile;
  }

  private function set_tile(tile : Tile) : Tile {
    return this.tile = tile;
  }

}
