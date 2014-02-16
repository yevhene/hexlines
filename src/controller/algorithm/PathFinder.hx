package controller.algorithm;

import model.Tile;
import model.Ball;
import model.Board;


class PathFinder {

  private var board : Board;

  private var tileFrom : Tile;
  private var tileTo : Tile;

  public function new(board : Board, tileFrom : Tile, tileTo : Tile) {
    this.board = board;
    this.tileFrom = tileFrom;
    this.tileTo = tileTo;
  }

  public function run() : Array<Tile> {
    return search([[tileFrom]]);
  }

  private function search(paths : Array<Array<Tile>>) : Array<Tile> {
    var newPaths = [];
    for (path in paths) {
      var lastTile = path[path.length - 1];
      var neighbors = neighborsFor(lastTile);
      var filteredNeighbors = filterNeighbors(neighbors, paths.concat(newPaths));
      for (neighbor in filteredNeighbors) {
        var newPath = path.concat([neighbor]);
        if (neighbor == tileTo) {
          return newPath;
        }
        newPaths.push(newPath);
      }
    }
    if (newPaths.length == 0) {
      return null;
    }
    return search(newPaths);
  }

  private function filterNeighbors(neighbors : Array<Tile>, paths : Array<Array<Tile>>) : Array<Tile> {
    var filteredNeighbors = [];
    for (neighbor in neighbors) {
      if (neighbor != null && checkNeighbor(neighbor, paths)) {
        filteredNeighbors.push(neighbor);
      }
    }
    return filteredNeighbors;
  }

  private function checkNeighbor(neighbor : Tile, paths : Array<Array<Tile>>) : Bool {
    return board.ballAt(neighbor) == null && !pathsContainsTile(neighbor, paths);
  }

  private function pathsContainsTile(tile : Tile, paths : Array<Array<Tile>>) : Bool {
    for (path in paths) {
      if (containsTile(tile, path)) {
        return true;
      }
    }
    return false;
  }

  private function containsTile(tile : Tile, path : Array<Tile>) : Bool {
    for (t in path) {
      if (t == tile) {
        return true;
      }
    }
    return false;
  }

  private function neighborsFor(tile : Tile) : Array<Tile> {
    var neighborsMods = [
      [ 1, -1,  0], [ 1,  0, -1], [ 0,  1, -1],
      [-1,  1,  0], [-1,  0,  1], [ 0, -1,  1]
    ];
    var neighbors : Array<Tile> = [];
    for (m in neighborsMods) {
      neighbors.push(board.tileAtCube(
        tile.cubeX + m[0], tile.cubeY + m[1], tile.cubeZ + m[2]
      ));
    }
    return neighbors;
  }

}
