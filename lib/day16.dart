import 'dart:io';
import 'dart:math';

int part1() {
  final grid = Grid(File('assets/day16/input.txt').readAsLinesSync());
  grid.terminate(
      grid.squares
          .firstWhere((element) => element.row == 0 && element.col == 0),
      Direction.right);
  return grid.squares.where((element) => element.beams.isNotEmpty).length;
}

int part2() {
  final grid = Grid(File('assets/day16/input.txt').readAsLinesSync());
  int rows = grid.squares.map((e) => e.row).reduce(max);
  int cols = grid.squares.map((e) => e.col).reduce(max);
  int maxEnergized = 0;
  for (int row = 0; row <= rows; row++) {
    if (row == 0 || row == rows) {
      for (int col = 0; col <= cols; col++) {
        grid.reset();
        grid.terminate(grid.squares.firstWhere((element) => element.row == row && element.col == col), row == 0 ? Direction.down : Direction.up);
        int value = grid.squares.where((element) => element.beams.isNotEmpty).length;
        maxEnergized = max(value, maxEnergized);
        if (row == 0) {
          print('Down from $row, $col: $maxEnergized');
        } else {
          print('Up from $row, $col: $maxEnergized');
        }
      }
    }
    grid.reset();
    grid.terminate(grid.squares.firstWhere((element) => element.row == row && element.col == 0), Direction.right);
    int leftValue = grid.squares.where((element) => element.beams.isNotEmpty).length;
    maxEnergized = max(leftValue, maxEnergized);
    print('Right from $row, 0: $maxEnergized');

    grid.reset();
    grid.terminate(grid.squares.firstWhere((element) => element.row == row && element.col == cols), Direction.left);
    int rightValue = grid.squares.where((element) => element.beams.isNotEmpty).length;
    maxEnergized = max(rightValue, maxEnergized);
    print('Left from $row, $cols: $maxEnergized');
  }
  return maxEnergized;
}

class Grid {
  final List<GridSquare> squares;

  Grid(List<String> input) : squares = [] {
    for (int row = 0; row < input.length; row++) {
      for (int col = 0; col < input[row].length; col++) {
        squares.add(GridSquare(row, col, input[row][col]));
      }
    }
  }

  void terminate(GridSquare current, Direction direction) {
    // print('Terminating from ${current.row}, ${current.col} $direction');
    current.beams.add(direction);
    if (current.item == r'.') {
      continueOnPath(current, direction);
    } else if ([r'/', r'\'].contains(current.item)) {
      if (current.item == r'/') {
        if (direction == Direction.up) {
          continueOnPath(current, Direction.right);
        } else if (direction == Direction.down) {
          continueOnPath(current, Direction.left);
        } else if (direction == Direction.left) {
          continueOnPath(current, Direction.down);
        } else if (direction == Direction.right) {
          continueOnPath(current, Direction.up);
        }
      } else if (current.item == r'\') {
        if (direction == Direction.up) {
          continueOnPath(current, Direction.left);
        } else if (direction == Direction.down) {
          continueOnPath(current, Direction.right);
        } else if (direction == Direction.left) {
          continueOnPath(current, Direction.up);
        } else if (direction == Direction.right) {
          continueOnPath(current, Direction.down);
        }
      }
    } else if ([r'|', r'-'].contains(current.item)) {
      if (current.item == r'|' && !direction.isVertical) {
        continueOnPath(current, Direction.up);
        continueOnPath(current, Direction.down);
      } else if (current.item == r'-' && direction.isVertical) {
        continueOnPath(current, Direction.left);
        continueOnPath(current, Direction.right);
      } else {
        continueOnPath(current, direction);
      }
    }
  }

  void continueOnPath(GridSquare current, Direction direction) {
    // print('Continuing on path from ${current.row}, ${current.col} $direction');
    // print('Looking for ${current.row + direction.rowModifier}, ${current.col + direction.colModifier}');
    final next = squares
        .where((element) =>
    element.row == current.row + direction.rowModifier &&
        element.col == current.col + direction.colModifier)
        .firstOrNull;
    if (next != null) {
      if (next.beams.where((element) => element == direction).isEmpty) {
        // print('Moving to ${next.row}, ${next.col} $direction');
        terminate(next, direction);
      } else {
        // print('Loop detected at ${next.row}, ${next.col}');
      }
    } else {
      // print('Path terminated at ${current.row}, ${current.col} $direction');
    }
  }

  void reset() {
    for (var element in squares) {
      element.beams.clear();
    }
  }
}

class GridSquare {
  final int row;
  final int col;
  final String item;
  final Set<Direction> beams = {};

  GridSquare(this.row, this.col, this.item);
}

enum Direction {
  up,
  down,
  left,
  right;

  bool get isVertical => this == Direction.up || this == Direction.down;

  int get rowModifier => isVertical ? (this == Direction.down ? 1 : -1) : 0;

  int get colModifier => isVertical ? 0 : (this == Direction.right ? 1 : -1);

  @override
  String toString() => name;
}
