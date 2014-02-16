package controller.algorithm;

import model.Tile;
import model.Ball;
import model.Board;

import controller.algorithm.Direction;
import controller.algorithm.BallIterator;

// TODO: Fix
class LinesFinder {

  private var BALLS_IN_LINE = 5;

  private var board : Board;

  public function new(board : Board) {
    this.board = board;
  }

  public function run() : Array<Ball> {
    var balls : Array<Ball> = [];
    for (ball in board.balls) {
      if (check(ball)) {
        balls.push(ball);
      }
    }
    return balls;
  }

  private function check(ball : Ball) : Bool {
    var result = false;
    for (direction in Directions.list()) {
      result = result || check_direction(ball, direction);
    }
    return result;
  }

  private function check_direction(ball : Ball, direction : Direction) : Bool {
    var balls : Array<Ball> = [ball];
    var it = new BallIterator(board, ball, direction);
    var b = it.next();
    while (b != null && b.color == ball.color) {
      balls.push(ball);
      b = it.next();
    }
    it.reset();
    b = it.prev();
    while (b != null && b.color == ball.color) {
      balls.push(ball);
      b = it.prev();
    }
    return balls.length >= BALLS_IN_LINE;
  }
}
