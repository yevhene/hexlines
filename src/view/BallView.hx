package view;

import flash.display.Sprite;
import flash.events.MouseEvent;

import model.Ball;
import model.Color;

import controller.Game;


class BallView extends Sprite {

  public var ball (get, null) : Ball;

  private var active : Bool;

  private var w : Float;
  private var h : Float;

  public function new(ball : Ball, w : Float, h : Float) {
    super();

    this.ball = ball;
    this.w = w;
    this.h = h;

    draw();

    addEventListener(MouseEvent.CLICK, onClick);

    initListeners();
  }

  private function initListeners() {
    Game.instance().addListener(GameEvent.BallSelected, function(b : Ball) {
      if (b == ball && !active) {
        active = true;
        draw();
      } else if (b != ball && active) {
        active = false;
        draw();
      }
    });
  }

  private function draw() {
    graphics.lineStyle(3, colorToInt(ball.color));
    if (active) {
      graphics.beginFill(colorToInt(ball.color));
    } else {
      graphics.beginFill(0xffffff);
    }
    graphics.drawCircle(w / 2, h / 2, Math.min(w, h) / 3);
    graphics.endFill();
  }

  private function onClick(event) {
    Game.instance().trigger(GameEvent.BallActivation, ball);
    event.stopPropagation();
  }

  private function colorToInt(color : Color) : Int {
    return switch(color) {
      case Red: 0xe50000;
      case Green: 0x15b01a;
      case Blue: 0x0343df;
      case Orange: 0xf97306;
      case Yellow: 0xffff14;
      case Indigo: 0x380282;
      case Violet: 0x9a0eea;
    }
  }

  private function get_ball() : Ball {
    return ball;
  }

}
