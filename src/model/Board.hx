package model;

import model.Color;
import model.Tile;
import model.Ball;


class Board {

  public var tiles (get, null) : Array<Tile>;
  public var balls (get, null) : Array<Ball>;

  public var width (get, null) : Int;
  public var height (get, null) : Int;

  public function new(width : Int, height : Int) {
    this.width = width;
    this.height = height;

    tiles = [];
    balls = [];

    create_tiles();
  }

  public function ball_at(tile : Tile) : Ball {
    for (ball in balls) {
      if (ball.tile == tile) {
        return ball;
      }
    }
    return null;
  }

  public function tile_at(x : Int, y : Int) : Tile {
    for (tile in tiles) {
      if (tile.x == x && tile.y == y) {
        return tile;
      }
    }
    return null;
  }

  public function tile_at_cube(x : Int, y : Int, z : Int) : Tile {
    for (tile in tiles) {
      if (tile.cube_x == x && tile.cube_y == y && tile.cube_z == z) {
        return tile;
      }
    }
    return null;
  }

  public function spawn_ball(color) : Ball {
    var available_tiles = tiles_without_ball();
    var tile = available_tiles[Std.random(available_tiles.length)];
    var ball = new Ball(color);
    ball.tile = tile;
    balls.push(ball);
    return ball;
  }

  public function remove_balls(balls : Array<Ball>) {
    for (ball in balls) {
      this.balls.remove(ball);
    }
  }

  public function move_ball(ball : Ball, tile : Tile) {
    ball.tile = tile;
  }

  private function create_tiles() {
    for (y in 0...height) {
      for (x in 0...width) {
        tiles.push(new Tile(x, y));
      }
    }
  }

  private function tiles_without_ball() : Array<Tile> {
    var tiles_without_ball : Array<Tile> = [];
    for (tile in tiles) {
      if (ball_at(tile) == null) {
        tiles_without_ball.push(tile);
      }
    }
    return tiles_without_ball;
  }

  private function get_width() : Int {
    return width;
  }

  private function get_height() : Int {
    return height;
  }

  private function get_tiles() : Array<Tile> {
    return tiles;
  }

  private function get_balls() : Array<Ball> {
    return balls;
  }

}

