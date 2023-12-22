import 'dart:io';
import 'dart:math' as math;

import 'package:pathfinding/core/heap.dart';

int part1() {
  int brickCount = 0;
  final bricks = File('assets/day22/input.txt').readAsLinesSync().map((e) {
    final parts = e.split('~').toList();
    final start = Coordinate.fromString(parts[0]);
    final end = Coordinate.fromString(parts[1]);
    return Brick.withRange(++brickCount, start, end);
  }).toList();

  dropBricks(bricks, logSize: true);

  int checked = 0;
  Set<int> announced = {};
  int dissolvable = 0;
  for (final brick in bricks) {
    bool isStable = true;
    for (final check in bricks.where(
            (element) =>
        element != brick && element.lowestZ > brick.highestZ)) {
      if (check.lowestZ > 1 &&
          !bricks
              .where((element) =>
          element != check &&
              element != brick &&
              element.highestZ == check.lowestZ - 1)
              .any((element) => element.occupiesSpaceBelow(check))) {
        isStable = false;
        break;
      }
    }
    if (isStable) {
      dissolvable++;
    }
    checked++;
    int pct = (checked / bricks.length * 100).floor();
    if (pct % 5 == 0 && !announced.contains(pct)) {
      print('Checked $pct%. Found $dissolvable bricks');
      announced.add(pct);
    }
  }

  return dissolvable;
}

int part2() {
  int brickCount = 0;
  final bricks = File('assets/day22/input.txt').readAsLinesSync().map((e) {
    final parts = e.split('~').toList();
    final start = Coordinate.fromString(parts[0]);
    final end = Coordinate.fromString(parts[1]);
    return Brick.withRange(++brickCount, start, end);
  }).toList();

  dropBricks(bricks, logSize: true);

  int checked = 0;
  Set<int> announced = {};

  int result = 0;
  for (final brick in bricks) {
    final clone = bricks.where((element) => element != brick)
        .map((e) => Brick.clone(e))
        .toList();
    result += dropBricks(clone).length;

    checked++;
    int pct = (checked / bricks.length * 100).floor();
    if (pct % 5 == 0 && !announced.contains(pct)) {
      print('Checked $pct%. Current sum = $result');
      announced.add(pct);
    }
  }

  return result;
}

Set<Brick> dropBricks(List<Brick> bricks, {bool logSize = false}) {
  final Set<Brick> moved = {};

  if (logSize) {
    int stackHeight = bricks.map((e) => e.highestZ).reduce(math.max);
    print('Found ${bricks.length} bricks. Max height = $stackHeight');
  }

  final heap = Heap();
  for (final brick in bricks) {
    heap.push(brick);
  }

  while (!heap.empty()) {
    final Brick current = heap.pop();
    if (current.lowestZ > 1 &&
        !bricks
            .where((element) =>
        element != current && element.highestZ == current.lowestZ - 1)
            .any((element) => element.occupiesSpaceBelow(current))) {
      moved.add(current);
      current.moveDown();
      heap.push(current);
    }
  }

  if (logSize) {
    int stackHeight = bricks.map((e) => e.highestZ).reduce(math.max);
    print('Collapsed bricks. Max height = $stackHeight');
  }

  return moved;
}

class Brick {
  final int id;
  final Set<Coordinate> coordinates;

  Brick(this.id, this.coordinates);

  Brick.withRange(this.id, Coordinate start, Coordinate end)
      : coordinates = {start, end} {
    for (int x = math.min(start.x, end.x) + 1;
    x < math.max(start.x, end.x);
    x++) {
      coordinates.add(Coordinate(x, start.y, start.z));
    }
    for (int y = math.min(start.y, end.y) + 1;
    y < math.max(start.y, end.y);
    y++) {
      coordinates.add(Coordinate(start.x, y, start.z));
    }
    for (int z = math.min(start.z, end.z) + 1;
    z < math.max(start.z, end.z);
    z++) {
      coordinates.add(Coordinate(start.x, start.y, z));
    }
  }

  Brick.clone(Brick original)
      : id = original.id,
        coordinates = original.coordinates.map((e) => Coordinate(e.x, e.y, e.z))
            .toSet();

  bool occupiesSpaceBelow(Brick other) {
    Set<Coordinate> otherCoordinates =
    other.coordinates.map((e) => Coordinate(e.x, e.y, e.z - 1)).toSet();
    return coordinates.any((element) => otherCoordinates.contains(element));
  }

  void moveDown() {
    for (final coordinate in coordinates) {
      coordinate.moveDown();
    }
  }

  int get lowestZ => coordinates.map((e) => e.z).reduce(math.min);

  int get highestZ => coordinates.map((e) => e.z).reduce(math.max);

  bool operator <(Object other) => other is Brick && lowestZ < other.lowestZ;

  bool operator >(Object other) => other is Brick && lowestZ > other.lowestZ;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Brick && other.id == id;

  @override
  String toString() => 'Brick $id';
}

class Coordinate {
  int x = 0;
  int y = 0;
  int z = 0;

  Coordinate(this.x, this.y, this.z);

  Coordinate.fromString(String input) {
    final parts = input.split(',').map((e) => int.parse(e)).toList();
    x = parts[0];
    y = parts[1];
    z = parts[2];
  }

  void moveDown() {
    z--;
  }

  @override
  String toString() => '$x, $y, $z';

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  bool operator ==(Object other) =>
      other is Coordinate && other.x == x && other.y == y && other.z == z;
}
