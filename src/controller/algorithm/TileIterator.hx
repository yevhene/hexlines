package controller.algorithm;

import model.Tile;
import model.Board;

import controller.algorithm.Direction;


class TileIterator {

  private var board : Board;
  private var startTile : Tile;
  private var currentTile : Tile;
  private var nextMod: Array<Int>;
  private var prevMod: Array<Int>;

  public function new(board : Board, tile : Tile, direction : Direction) {
    this.board = board;
    this.startTile = tile;

    switch (direction) {
      case Vertical: setMods([0, -1, 1], [0, 1, -1]);
      case Ascending: setMods([-1, 0,  1], [1, 0, -1]);
      case Descending: setMods([-1, 1, 0], [1, -1, 0]);
    }

    reset();
  }

  public function reset() {
    currentTile = startTile;
  }

  public function next() : Tile {
    return currentTile = modTile(nextMod);
  }

  public function prev() : Tile {
    return currentTile = modTile(prevMod);
  }

  private function modTile(mod) {
    return board.tileAtCube(currentTile.cubeX + mod[0],
                            currentTile.cubeY + mod[1],
                            currentTile.cubeZ + mod[2]);
  }

  private function setMods(prevMod : Array<Int>, nextMod : Array<Int>) {
    this.prevMod = prevMod;
    this.nextMod = nextMod;
  }

}
