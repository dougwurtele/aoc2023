import 'dart:io';
import 'dart:math';

import 'package:pathfinding/core/heap.dart';

int part1() {
  final grid = File('assets/day17/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList())
      .toList();
  return calculate(1, 3, grid);
}

int part2() {
  final grid = File('assets/day17/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('').map((e) => int.parse(e)).toList())
      .toList();
  return calculate(4, 10, grid);
}

int calculate(int minDistance, int maxDistance, List<List<int>> grid) {
  final directions = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0]
  ];
  final Set<Node> visited = {};
  final Map<Node, int> costs = {};
  final heap = Heap();
  heap.push(Node(0, 0, 0, -1));
  while (!heap.empty()) {
    Node current = heap.pop();
    if (current.row == grid.length - 1 && current.col == grid[0].length - 1) {
      return current.cost;
    }
    if (!visited.contains(current)) {
      visited.add(current);
      for (int direction = 0; direction < 4; direction++) {
        int increase = 0;
        if (direction == current.disallowedDirection ||
            (direction + 2) % 4 == current.disallowedDirection) {
          continue;
        }
        for (int distance = 1; distance <= maxDistance; distance++) {
          final row = current.row + directions[direction][0] * distance;
          final col = current.col + directions[direction][1] * distance;
          if (0 <= row &&
              row < grid.length &&
              0 <= col &&
              col < grid[0].length) {
            increase += grid[row][col];
            if (distance >= minDistance) {
              final next = Node(current.cost + increase, row, col, direction);
              if (next.cost < (costs[next] ?? pow(2, 32).toInt())) {
                costs[next] = next.cost;
                heap.push(next);
              }
            }
          }
        }
      }
    }
  }
  print('No path found');
  return 0;
}

class Node {
  final int cost;
  final int row;
  final int col;
  final int disallowedDirection;

  Node(this.cost, this.row, this.col, this.disallowedDirection);

  bool operator <(Object other) => other is Node && cost < other.cost;

  bool operator >(Object other) => other is Node && cost > other.cost;

  @override
  bool operator ==(Object other) =>
      other is Node &&
      other.row == row &&
      other.col == col &&
      other.disallowedDirection == disallowedDirection;

  @override
  int get hashCode => Object.hash(row, col, disallowedDirection);

  @override
  String toString() => '$row, $col ($cost)';
}
