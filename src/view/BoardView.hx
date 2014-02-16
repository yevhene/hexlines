package view;

import flash.display.Sprite;
import flash.events.MouseEvent;

import model.Tile;
import model.Ball;
import model.Board;

import controller.Game;


class BoardView extends Sprite {

  private var w : Float;
  private var h : Float;

  private var tileW : Float;
  private var tileH : Float;

  private var board : Board;

  private var ballViews : Array<BallView>;

  public function new(board : Board, w : Float, h : Float) {
    super();

    this.board = board;
    this.w = w;
    this.h = h;
    ballViews = [];

    calculateTileSize();
    draw();

    initListeners();

    addEventListener(MouseEvent.CLICK, onClick);
  }

  private function initListeners() {
    Game.instance().addListener(GameEvent.BallCreate, function(ball : Ball) {
      var ballView = new BallView(ball, tileW, tileH);
      var position = getTilePosition(ball.tile);
      ballView.x = position['x'];
      ballView.y = position['y'];
      ballViews.push(ballView);
      addChild(ballView);
    });

    Game.instance().addListener(GameEvent.BallMove, function(data : Map<String, Dynamic>) {
      moveBall(data['ball'], convertPath(data['path']));
    });

    Game.instance().addListener(GameEvent.BallDestroy, function(ball : Ball) {
      var ballView = ballViewFor(ball);
      ballViews.remove(ballView);
      removeChild(ballView);
    });
  }

  private function moveBall(ball : Ball, screenPath : Array<Map<String, Float>>) {
    var ballView = ballViewFor(ball);
    var lastPosition = screenPath[screenPath.length - 1];
    ballView.x = lastPosition['x'];
    ballView.y = lastPosition['y'];
  }

  private function convertPath(path : Array<Tile>) : Array<Map<String, Float>> {
    var convertedPath : Array<Map<String, Float>> = [];
    for(tile in path) {
      convertedPath.push(getTilePosition(tile));
    }
    return convertedPath;
  }

  private function calculateTileSize() {
    tileW = this.w / (Math.ceil(board.width / 2) + Math.floor(board.width / 2) / 2 + 0.25 * (1 - board.width % 2));
    tileH = this.h / (board.height + 0.5);
  }

  private function draw() {
    for (tile in board.tiles) {
      drawTile(tile);
    }
  }

  private function drawTile(tile : Tile) {
    var position = getTilePosition(tile);
    var screenX = position['x'];
    var screenY = position['y'];
    graphics.lineStyle(1, 0x000000);
    graphics.beginFill(0xffffff);
    graphics.moveTo( screenX                , screenY + tileH / 2 );
    graphics.lineTo( screenX + tileW / 4    , screenY              );
    graphics.lineTo( screenX + tileW * 3 / 4, screenY              );
    graphics.lineTo( screenX + tileW        , screenY + tileH / 2 );
    graphics.lineTo( screenX + tileW * 3 / 4, screenY + tileH     );
    graphics.lineTo( screenX + tileW / 4    , screenY + tileH     );
    graphics.endFill();
  }

  private function getTilePosition(tile : Tile) : Map<String, Float> {
    var screenX = (tileW * 3 / 4) * tile.x;
    var screenY = tileH * (tile.y + 0.5 * (tile.x % 2));
    return ['x' => screenX, 'y' => screenY];
  }

  private function ballViewFor(ball : Ball) {
    for (ballView in ballViews) {
      if (ballView.ball == ball) {
        return ballView;
      }
    }
    return null;
  }

  // TODO: Regard shape.
  private function tileAt(screenX : Int, screenY : Int) : Tile {
    var tileX = Math.floor(screenX / (tileW * 3 / 4));
    var tileY = Math.floor((screenY - ((tileX % 2) * tileH / 2)) / tileH);
    return board.tileAt(tileX, tileY);
  }

  private function onClick(event) {
    var tile = tileAt(event.localX, event.localY);
    if (tile != null) {
      Game.instance().trigger(GameEvent.TileActivation, tile);
    }
  }

}
