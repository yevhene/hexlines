package controller;

import model.Board;
import model.Ball;
import model.Tile;
import model.Color;

import controller.algorithm.PathFinder;
import controller.algorithm.LinesFinder;


enum GameEvent {
  BallDestroy;
  BallActivation;
  TileActivation;
  BallSelected;
  BallMove;
  BallCreate;
}


class Game {

  private var handlers : Map<GameEvent, Array<Dynamic -> Void>>;

  private static var game : Game;

  private var active_ball : Ball;

  public var board  (get, null): Board;

  public static function instance() : Game {
    if (game == null) {
      game = new Game();
    }
    return game;
  }

  private function new() {
    handlers = new Map();

    board = new Board(16, 10);

    init_listeners();
  }

  public function start() {
    spawn_balls(3);
  }

  private function init_listeners() {
    add_listener(GameEvent.BallActivation, function(ball : Ball) {
      if (active_ball == ball) {
        active_ball = null;
      } else {
        active_ball = ball;
      }
      trigger(GameEvent.BallSelected, active_ball);
    });

    add_listener(GameEvent.TileActivation, function(tile : Tile) {
      var ball = board.ball_at(tile);
      if (ball != null) {
        trigger(GameEvent.BallActivation, ball);
      } else {
        if (active_ball != null) {
          if (move_active_ball(tile)) {
            if (!destroy_balls()) {
              spawn_balls(3);
              destroy_balls();
            }
          }
        }
      }
    });
  }

  private function move_active_ball(tile_to) {
    var path = new PathFinder(board, active_ball.tile, tile_to).run();
    if (path != null) {
      board.move_ball(active_ball, tile_to); // Model updates before notification.
      var move_data : Map<String, Dynamic> = ['ball' => active_ball, 'path' => path];
      trigger(GameEvent.BallMove, move_data);
      active_ball = null;
      trigger(GameEvent.BallSelected, null);
    }
    return path != null;
  }

  private function destroy_balls() {
    var balls = new LinesFinder(board).run();
    board.remove_balls(balls); // Model updates before notification.
    for (ball in balls) {
      trigger(GameEvent.BallDestroy, ball);
    }
    return balls.length > 0;
  }

  private function spawn_balls(count : Int) {
    for (i in 0...count) {
      var ball = board.spawn_ball(Colors.random(3));
      trigger(GameEvent.BallCreate, ball);
    }
  }

  private function get_board() : Board {
    return board;
  }

  public function add_listener(name : GameEvent, handler : Dynamic -> Void) {
    var concrete_handlers = handlers[name];
    if (concrete_handlers == null) {
      concrete_handlers = [];
      handlers[name] = concrete_handlers;
    }
    concrete_handlers.push(handler);
  }

  public function trigger(name : GameEvent, data : Dynamic) {
    var concrete_handlers = handlers[name];
    if (concrete_handlers != null) {
      for (handler in concrete_handlers) {
        handler(data);
      }
    }
  }

}
