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

  private var activeBall : Ball;

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

    initListeners();
  }

  public function start() {
    spawnBalls(3);
  }

  private function initListeners() {
    addListener(GameEvent.BallActivation, function(ball : Ball) {
      if (activeBall == ball) {
        activeBall = null;
      } else {
        activeBall = ball;
      }
      trigger(GameEvent.BallSelected, activeBall);
    });

    addListener(GameEvent.TileActivation, function(tile : Tile) {
      var ball = board.ballAt(tile);
      if (ball != null) {
        trigger(GameEvent.BallActivation, ball);
      } else {
        if (activeBall != null) {
          if (moveActiveBall(tile)) {
            if (!destroyBalls()) {
              spawnBalls(3);
              destroyBalls();
            }
          }
        }
      }
    });
  }

  private function moveActiveBall(tileTo) {
    var path = new PathFinder(board, activeBall.tile, tileTo).run();
    if (path != null) {
      board.moveBall(activeBall, tileTo); // Model updates before notification.
      var moveData : Map<String, Dynamic> = ['ball' => activeBall, 'path' => path];
      trigger(GameEvent.BallMove, moveData);
      activeBall = null;
      trigger(GameEvent.BallSelected, null);
    }
    return path != null;
  }

  private function destroyBalls() {
    var balls = new LinesFinder(board).run();
    board.removeBalls(balls); // Model updates before notification.
    for (ball in balls) {
      trigger(GameEvent.BallDestroy, ball);
    }
    return balls.length > 0;
  }

  private function spawnBalls(count : Int) {
    for (i in 0...count) {
      var ball = board.spawnBall(Colors.random(3));
      trigger(GameEvent.BallCreate, ball);
    }
  }

  private function get_board() : Board {
    return board;
  }

  public function addListener(name : GameEvent, handler : Dynamic -> Void) {
    var concreteHandlers = handlers[name];
    if (concreteHandlers == null) {
      concreteHandlers = [];
      handlers[name] = concreteHandlers;
    }
    concreteHandlers.push(handler);
  }

  public function trigger(name : GameEvent, data : Dynamic) {
    var concreteHandlers = handlers[name];
    if (concreteHandlers != null) {
      for (handler in concreteHandlers) {
        handler(data);
      }
    }
  }

}
