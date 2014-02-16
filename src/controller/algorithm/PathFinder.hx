package controller.algorithm;

import model.Tile;
import model.Ball;
import model.Board;


class PathFinder {

  private var board : Board;

  private var tile_from : Tile;
  private var tile_to : Tile;

  public function new(board : Board, tile_from : Tile, tile_to : Tile) {
    this.board = board;
    this.tile_from = tile_from;
    this.tile_to = tile_to;
  }

  public function run() : Array<Tile> {
    return search([[tile_from]]);
  }

  private function search(paths : Array<Array<Tile>>) : Array<Tile> {
    var new_paths = [];
    for (path in paths) {
      var last_tile = path[path.length - 1];
      var neighbors = neighbors_for(last_tile);
      var filtered_neighbors = filter_neighbors(neighbors, paths.concat(new_paths));
      for (neighbor in filtered_neighbors) {
        var new_path = path.concat([neighbor]);
        if (neighbor == tile_to) {
          return new_path;
        }
        new_paths.push(new_path);
      }
    }
    if (new_paths.length == 0) {
      return null;
    }
    return search(new_paths);
  }

  private function filter_neighbors(neighbors : Array<Tile>, paths : Array<Array<Tile>>) : Array<Tile> {
    var filtered_neighbors = [];
    for (neighbor in neighbors) {
      if (neighbor != null && check_neighbor(neighbor, paths)) {
        filtered_neighbors.push(neighbor);
      }
    }
    return filtered_neighbors;
  }

  private function check_neighbor(neighbor : Tile, paths : Array<Array<Tile>>) : Bool {
    return board.ball_at(neighbor) == null && !paths_contains_tile(neighbor, paths);
  }

  private function paths_contains_tile(tile : Tile, paths : Array<Array<Tile>>) : Bool {
    for (path in paths) {
      if (contains_tile(tile, path)) {
        return true;
      }
    }
    return false;
  }

  private function contains_tile(tile : Tile, path : Array<Tile>) : Bool {
    for (t in path) {
      if (t == tile) {
        return true;
      }
    }
    return false;
  }

  private function neighbors_for(tile : Tile) : Array<Tile> {
    var neighbors_mods = [
      [ 1, -1,  0], [ 1,  0, -1], [ 0,  1, -1],
      [-1,  1,  0], [-1,  0,  1], [ 0, -1,  1]
    ];
    var neighbors : Array<Tile> = [];
    for (m in neighbors_mods) {
      neighbors.push(board.tile_at_cube(
        tile.cube_x + m[0], tile.cube_y + m[1], tile.cube_z + m[2]
      ));
    }
    return neighbors;
  }

}
