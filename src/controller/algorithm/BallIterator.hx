package controller.algorithm;

import model.Tile;
import model.Ball;
import model.Board;

import controller.algorithm.Direction;


class BallIterator {

  private var tileIterator : TileIterator;
  private var board : Board;

  public function new(board : Board, ball : Ball, direction : Direction) {
    this.board = board;
    tileIterator = new TileIterator(board, ball.tile, direction);
  }

  public function reset() {
    tileIterator.reset();
  }

  public function next() : Ball {
    return board.ballAt(tileIterator.next());
  }

  public function prev() : Ball {
    return board.ballAt(tileIterator.prev());
  }

}
