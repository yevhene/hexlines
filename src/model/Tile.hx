package model;


class Tile {

  public var x (get, null) : Int;
  public var y (get, null) : Int;

  @:isVar
  public var cube_x (get, null) : Int;

  @:isVar
  public var cube_y (get, null) : Int;

  @:isVar
  public var cube_z (get, null) : Int;

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

  private function get_cube_x() : Int {
    return x;
  }

  private function get_cube_y() : Int {
    return (-cube_x) - (cube_z);
  }

  private function get_cube_z() : Int {
    return y - Math.floor((x - (x & 1)) / 2);
  }

}
