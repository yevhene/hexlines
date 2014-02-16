package model;


class Tile {

  public var x (get, null) : Int;
  public var y (get, null) : Int;

  @:isVar
  public var cubeX (get, null) : Int;

  @:isVar
  public var cubeY (get, null) : Int;

  @:isVar
  public var cubeZ (get, null) : Int;

  public function new(x : Int, y : Int) {
    this.x = x;
    this.y = y;
  }

  private function get_x() : Int {
    return x;
  }

  private function get_y() : Int {
    return y;
  }

  private function get_cubeX() : Int {
    return x;
  }

  private function get_cubeY() : Int {
    return (-cubeX) - (cubeZ);
  }

  private function get_cubeZ() : Int {
    return y - Math.floor((x - (x & 1)) / 2);
  }

}
