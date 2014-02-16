package controller.algorithm;

import model.Tile;
import model.Ball;
import model.Board;

import controller.algorithm.Direction;


class BallIterator {

  private var tile_iterator : TileIterator;
  private var board : Board;

  public function new(board : Board, ball : Ball, direction : Direction) {
    this.board = board;
    tile_iterator = new TileIterator(board, ball.tile, direction);
  }

  public function reset() {
    tile_iterator.reset();
  }

  public function next() : Ball {
    return board.ball_at(tile_iterator.next());
  }

  public function prev() : Ball {
    return board.ball_at(tile_iterator.prev());
  }

}
