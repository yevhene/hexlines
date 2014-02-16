package controller.algorithm;


enum Direction {
  Vertical;
  Ascending;
  Descending;
}


class Directions {

  public static function list() {
    return [Vertical, Ascending, Descending];
  }

}
