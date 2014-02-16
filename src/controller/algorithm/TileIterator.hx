package controller.algorithm;

import model.Tile;
import model.Board;

import controller.algorithm.Direction;


class TileIterator {

  private var board : Board;
  private var start_tile : Tile;
  private var current_tile : Tile;
  private var next_mod: Array<Int>;
  private var prev_mod: Array<Int>;

  public function new(board : Board, tile : Tile, direction : Direction) {
    this.board = board;
    this.start_tile = tile;

    switch (direction) {
      case Vertical: set_mods([0, -1, 1], [0, 1, -1]);
      case Ascending: set_mods([-1, 0,  1], [1, 0, -1]);
      case Descending: set_mods([-1, 1, 0], [1, -1, 0]);
    }

    reset();
  }

  public function reset() {
    current_tile = start_tile;
  }

  public function next() : Tile {
    return current_tile = mod_tile(next_mod);
  }

  public function prev() : Tile {
    return current_tile = mod_tile(prev_mod);
  }

  private function mod_tile(mod) {
    return board.tile_at_cube(current_tile.cube_x + mod[0],
                              current_tile.cube_y + mod[1],
                              current_tile.cube_z + mod[2]);
  }

  private function set_mods(prev_mod : Array<Int>, next_mod : Array<Int>) {
    this.prev_mod = prev_mod;
    this.next_mod = next_mod;
  }

}
