package controller;


class EventDispatcher {

  private var handlers : Map<String, Array<Dynamic -> Void>>;

  public function new() {
    handlers = new Map();
  }

  public function add_listener(name : String, handler : Dynamic -> Void) {
    var concrete_handlers = handlers[name];
    if (concrete_handlers == null) {
      concrete_handlers = [];
      handlers[name] = concrete_handlers;
    }
    concrete_handlers.push(handler);
  }

  public function trigger(name : String, data : Dynamic) {
    var concrete_handlers = handlers[name];
    if (concrete_handlers != null) {
      for (handler in concrete_handlers) {
        handler(data);
      }
    }
  }

}
