package;

import flash.display.Sprite;
import flash.Lib;

import controller.Game;

import view.BoardView;


class MainView extends Sprite {

  public function new() {
    super();

    init();

    Game.instance().start();
  }

  private function init() {
    var board_view = new BoardView(Game.instance().board,
                                   Lib.current.stage.stageWidth - 1,
                                   Lib.current.stage.stageHeight - 1);
    addChild(board_view);
  }

}
