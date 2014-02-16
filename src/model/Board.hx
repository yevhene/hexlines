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

    createTiles();
  }

  public function ballAt(tile : Tile) : Ball {
    for (ball in balls) {
      if (ball.tile == tile) {
        return ball;
      }
    }
    return null;
  }

  public function tileAt(x : Int, y : Int) : Tile {
    for (tile in tiles) {
      if (tile.x == x && tile.y == y) {
        return tile;
      }
    }
    return null;
  }

  public function tileAtCube(x : Int, y : Int, z : Int) : Tile {
    for (tile in tiles) {
      if (tile.cubeX == x && tile.cubeY == y && tile.cubeZ == z) {
        return tile;
      }
    }
    return null;
  }

  public function spawnBall(color) : Ball {
    var availableTiles = tilesWithoutBall();
    var tile = availableTiles[Std.random(availableTiles.length)];
    var ball = new Ball(color);
    ball.tile = tile;
    balls.push(ball);
    return ball;
  }

  public function removeBalls(balls : Array<Ball>) {
    for (ball in balls) {
      this.balls.remove(ball);
    }
  }

  public function moveBall(ball : Ball, tile : Tile) {
    ball.tile = tile;
  }

  private function createTiles() {
    for (y in 0...height) {
      for (x in 0...width) {
        tiles.push(new Tile(x, y));
      }
    }
  }

  private function tilesWithoutBall() : Array<Tile> {
    var tilesWithoutBall : Array<Tile> = [];
    for (tile in tiles) {
      if (ballAt(tile) == null) {
        tilesWithoutBall.push(tile);
      }
    }
    return tilesWithoutBall;
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

