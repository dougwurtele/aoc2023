import 'dart:collection';
import 'dart:io';
import 'package:scidart/numdart.dart';

int part1() {
  final grid = File('assets/day21/input.txt')
      .readAsLinesSync()
      .map((e) => e.replaceAll('S', '.'))
      .toList();

  return plotsAtStep(grid, 64);
}

int part2() {
  final input = File('assets/day21/input.txt')
      .readAsLinesSync()
      .map((e) => e.replaceAll('S', '.'))
      .toList();
  final gridMult = 5;
  final List<String> grid = [];
  for (int i = 0; i < gridMult; i++) {
    grid.addAll(input.map((e) {
      final buffer = StringBuffer();
      for (int j = 0; j < gridMult; j++) {
        buffer.write(e);
      }
      return buffer.toString();
    }));
  }

  final start = (input.length ~/ 2).toDouble();
  final height = (input.length).toDouble();
  final steps = Array([start, start + height, start + height * 2]);
  final plots = Array([]);
  for (final step in steps) {
    plots.add(plotsAtStep(grid, step.toInt()).toDouble());
  }

  final poly = PolyFit(steps, plots, 2);
  return poly.predict(26501365).toInt();
}

int plotsAtStep(List<String> grid, int stepCount) {
  final directions = [
    [-1, 0],
    [0, 1],
    [1, 0],
    [0, -1],
  ];

  final queue = Queue();
  queue.add(Path(grid.length ~/ 2, grid[0].length ~/ 2, 0));
  final Set<Path> visited = {};
  final Set<Path> plots = {};

  while (queue.isNotEmpty) {
    final path = queue.removeFirst();
    if (!visited.contains(path)) {
      visited.add(path);
      if (path.steps == stepCount) {
        plots.add(path);
      } else if (path.steps < stepCount) {
        queue.addAll(directions
            .map((e) => Path(path.row + e[0], path.col + e[1], path.steps + 1))
            .where((element) =>
                element.row >= 0 &&
                element.row < grid.length &&
                element.col >= 0 &&
                element.col < grid[element.row].length &&
                grid[element.row][element.col] != '#'));
      }
    }
  }

  return plots.length;
}

class Path {
  final int row;
  final int col;
  final int steps;

  Path(this.row, this.col, this.steps);

  @override
  int get hashCode => Object.hash(row, col, steps);

  @override
  bool operator ==(Object other) =>
      other is Path &&
      other.row == row &&
      other.col == col &&
      other.steps == steps;
}
