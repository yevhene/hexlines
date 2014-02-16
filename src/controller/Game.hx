package controller;

import model.Board;
import model.Ball;
import model.Tile;
import model.Color;

import controller.EventDispatcher;

import controller.algorithm.PathFinder;
import controller.algorithm.LinesFinder;


class Game {

  private var event_dispatcher : EventDispatcher;

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
    event_dispatcher = new EventDispatcher();

    board = new Board(16, 10);

    init_listeners();
  }

  public function start() {
    spawn_balls(3);
  }

  private function init_listeners() {
    add_listener('ball_activation', function(ball : Ball) {
      if (active_ball == ball) {
        active_ball = null;
      } else {
        active_ball = ball;
      }
      trigger('ball_selected', active_ball);
    });

    add_listener('tile_activation', function(tile : Tile) {
      var ball = board.ball_at(tile);
      if (ball != null) {
        trigger('ball_activation', ball);
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
      trigger('ball_move', move_data);
      active_ball = null;
      trigger('ball_selected', null);
    }
    return path != null;
  }

  private function destroy_balls() {
    var balls = new LinesFinder(board).run();
    board.remove_balls(balls); // Model updates before notification.
    for (ball in balls) {
      trigger('ball_destroy', ball);
    }
    return balls.length > 0;
  }

  private function spawn_balls(count : Int) {
    for (i in 0...count) {
      var ball = board.spawn_ball(Colors.random(3));
      trigger('ball_create', ball);
    }
  }

  public function add_listener(name : String, handler : Dynamic -> Void) {
    event_dispatcher.add_listener(name, handler);
  }

  public function trigger(name : String, data : Dynamic) {
    event_dispatcher.trigger(name, data);
  }

  private function get_board() : Board {
    return board;
  }

}
