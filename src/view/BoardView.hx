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

  private var tile_w : Float;
  private var tile_h : Float;

  private var board : Board;

  private var ball_views : Array<BallView>;

  public function new(board : Board, w : Float, h : Float) {
    super();

    this.board = board;
    this.w = w;
    this.h = h;
    ball_views = [];

    calculate_tile_size();
    draw();

    init_listeners();

    addEventListener(MouseEvent.CLICK, on_click);
  }

  private function init_listeners() {
    Game.instance().add_listener(GameEvent.BallCreate, function(ball : Ball) {
      var ball_view = new BallView(ball, tile_w, tile_h);
      var position = get_tile_position(ball.tile);
      ball_view.x = position['x'];
      ball_view.y = position['y'];
      ball_views.push(ball_view);
      addChild(ball_view);
    });

    Game.instance().add_listener(GameEvent.BallMove, function(data : Map<String, Dynamic>) {
      move_ball(data['ball'], convert_path(data['path']));
    });

    Game.instance().add_listener(GameEvent.BallDestroy, function(ball : Ball) {
      var ball_view = ball_view_for(ball);
      ball_views.remove(ball_view);
      removeChild(ball_view);
    });
  }

  private function move_ball(ball : Ball, screen_path : Array<Map<String, Float>>) {
    var ball_view = ball_view_for(ball);
    var last_position = screen_path[screen_path.length - 1];
    ball_view.x = last_position['x'];
    ball_view.y = last_position['y'];
  }

  private function convert_path(path : Array<Tile>) : Array<Map<String, Float>> {
    var converted_path : Array<Map<String, Float>> = [];
    for(tile in path) {
      converted_path.push(get_tile_position(tile));
    }
    return converted_path;
  }

  private function calculate_tile_size() {
    tile_w = this.w / (Math.ceil(board.width / 2) + Math.floor(board.width / 2) / 2 + 0.25 * (1 - board.width % 2));
    tile_h = this.h / (board.height + 0.5);
  }

  private function draw() {
    for (tile in board.tiles) {
      draw_tile(tile);
    }
  }

  private function draw_tile(tile : Tile) {
    var position = get_tile_position(tile);
    var screen_x = position['x'];
    var screen_y = position['y'];
    graphics.lineStyle(1, 0x000000);
    graphics.beginFill(0xffffff);
    graphics.moveTo( screen_x                 , screen_y + tile_h / 2 );
    graphics.lineTo( screen_x + tile_w / 4    , screen_y              );
    graphics.lineTo( screen_x + tile_w * 3 / 4, screen_y              );
    graphics.lineTo( screen_x + tile_w        , screen_y + tile_h / 2 );
    graphics.lineTo( screen_x + tile_w * 3 / 4, screen_y + tile_h     );
    graphics.lineTo( screen_x + tile_w / 4    , screen_y + tile_h     );
    graphics.endFill();
  }

  private function get_tile_position(tile : Tile) : Map<String, Float> {
    var screen_x = (tile_w * 3 / 4) * tile.x;
    var screen_y = tile_h * (tile.y + 0.5 * (tile.x % 2));
    return ['x' => screen_x, 'y' => screen_y];
  }

  private function ball_view_for(ball : Ball) {
    for (ball_view in ball_views) {
      if (ball_view.ball == ball) {
        return ball_view;
      }
    }
    return null;
  }

  // TODO: Regard shape.
  private function tile_at(screen_x : Int, screen_y : Int) : Tile {
    var tile_x = Math.floor(screen_x / (tile_w * 3 / 4));
    var tile_y = Math.floor((screen_y - ((tile_x % 2) * tile_h / 2)) / tile_h);
    return board.tile_at(tile_x, tile_y);
  }

  private function on_click(event) {
    var tile = tile_at(event.localX, event.localY);
    if (tile != null) {
      Game.instance().trigger(GameEvent.TileActivation, tile);
    }
  }

}
