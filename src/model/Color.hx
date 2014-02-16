package model;


enum Color {
  Red;
  Green;
  Blue;
  Orange;
  Yellow;
  Indigo;
  Violet;
}


class Colors {

  public static function list() : Array<Color> {
    return [Red, Green, Blue, Orange, Yellow, Indigo, Violet];
  }

  public static function random(?max : Int) : Color {
    var colors = Colors.list();
    var limit = max != null ? max : colors.length;
    return colors[Std.random(limit)];
  }

}
