import 'dart:io';

int part1() {
  final input = File('assets/day10/input.txt').readAsLinesSync();
  final loop = findLoop(input);
  return (loop.coordinates.length / 2).floor();
}

int part2() {
  final input = File('assets/day10/input.txt').readAsLinesSync();
  final loop = findLoop(input);
  // print(loop.printable(input[0].length, input.length));

  int lefts = 0;
  int rights = 0;
  Direction current = loop.coordinates.first.directionTo(loop.coordinates[1]);
  for (int i = 1; i < loop.coordinates.length - 1; i++) {
    Direction next = loop.coordinates[i].directionTo(loop.coordinates[i + 1]);
    if (next != current) {
      if (current == Direction.right && next == Direction.down) {
        rights++;
      } else if (current == Direction.down && next == Direction.left) {
        rights++;
      } else if (current == Direction.left && next == Direction.up) {
        rights++;
      } else if (current == Direction.up && next == Direction.right) {
        rights++;
      } else if (current == Direction.right && next == Direction.up) {
        lefts++;
      } else if (current == Direction.up && next == Direction.left) {
        lefts++;
      } else if (current == Direction.left && next == Direction.down) {
        lefts++;
      } else if (current == Direction.down && next == Direction.right) {
        lefts++;
      } else {
        throw 'Invalid turn';
      }
    }
    current = next;
  }
  Direction flood = rights > lefts ? Direction.right : Direction.left;

  final List<Coordinate> fill = [];
  Direction direction =
      loop.coordinates.first.directionTo(loop.coordinates[1]);
  for (int i = 0; i < loop.coordinates.length - 1; i++) {
    final location = loop.coordinates[i];
    fill.addAll(floodCoordinates(direction, flood, location, loop.coordinates).where((element) => !fill.contains(element)));
    direction = location.directionTo(loop.coordinates[i + 1]);
    fill.addAll(floodCoordinates(direction, flood, location, loop.coordinates).where((element) => !fill.contains(element)));
  }

  return fill.length;
}

List<Coordinate> floodCoordinates(Direction travelDirection, Direction floodDirection, Coordinate start, List<Coordinate> loop) {
  final List<Coordinate> flooded = [];
  int modifier = travelDirection.modifier(floodDirection);
  // print('Filling $floodDirection while traveling $travelDirection from ${start.x}, ${start.y}');
  if (travelDirection.vertical) {
    for (int x = start.x + modifier; loop.where((element) => element.x == x && element.y == start.y).firstOrNull == null; x += modifier) {
      // print('Flooding $x, ${start.y}');
      flooded.add(Coordinate(x, start.y, 'X'));
    }
  } else {
    for (int y = start.y + modifier; loop.where((element) => element.x == start.x && element.y == y).firstOrNull == null; y += modifier) {
      // print('Flooding ${start.x}, $y');
      flooded.add(Coordinate(start.x, y, 'X'));
    }
  }
  return flooded;
}

Path findLoop(List<String> input) {
  final List<Coordinate> map = [];
  for (int y = 0; y < input.length; y++) {
    final line = input[y].split('').toList();
    for (int x = 0; x < line.length; x++) {
      map.add(Coordinate(x, y, line[x]));
    }
  }
  map
      .where((element) => element.type != '.')
      .forEach((element) => element.loadNeighbors(map));
  List<Path> paths = [
    Path.fromStart(map.firstWhere((element) => element.type == 'S'))
  ];
  Path? loop;
  while (loop == null) {
    Path path = paths.removeAt(0);
    for (final option in path.coordinates.last.neighbors) {
      if (!path.coordinates.contains(option)) {
        Path update = Path.duplicateWithEnd(path, option);
        if (update.isComplete) {
          loop = update;
          break;
        } else {
          paths.add(update);
        }
      }
    }
  }
  return loop;
}

class Coordinate {
  final int x;
  final int y;
  final String type;
  late List<Coordinate> neighbors;

  Coordinate(this.x, this.y, this.type);

  void loadNeighbors(List<Coordinate> coordinates) {
    neighbors = coordinates.where((element) {
      if (element.x == x && element.y == y - 1) {
        return ['|', '7', 'F'].contains(element.type) ||
            (element.type == 'S' && ['|', 'L', 'J'].contains(type));
      } else if (element.x == x + 1 && element.y == y) {
        return ['-', 'J', '7'].contains(element.type) ||
            (element.type == 'S' && ['-', 'L', 'F'].contains(type));
      } else if (element.x == x && element.y == y + 1) {
        return ['|', 'L', 'J'].contains(element.type) ||
            (element.type == 'S' && ['|', '7', 'F'].contains(type));
      } else if (element.x == x - 1 && element.y == y) {
        return ['-', 'L', 'F'].contains(element.type) ||
            (element.type == 'S' && ['-', 'J', '7'].contains(type));
      } else {
        return false;
      }
    }).toList();
  }

  Direction directionTo(Coordinate next) {
    if (x == next.x && y == next.y + 1) {
      return Direction.up;
    } else if (x == next.x - 1 && y == next.y) {
      return Direction.right;
    } else if (x == next.x && y == next.y - 1) {
      return Direction.down;
    } else if (x == next.x + 1 && y == next.y) {
      return Direction.left;
    } else {
      throw 'Invalid direction';
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Coordinate && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

class Path {
  final List<Coordinate> coordinates;

  Path.fromStart(Coordinate start) : coordinates = [start];

  Path.duplicateWithEnd(Path existing, Coordinate end)
      : coordinates = [...existing.coordinates, end];

  bool get isComplete {
    return coordinates.length > 2 &&
        coordinates.last.neighbors.contains(coordinates.first);
  }

  String printable(int width, int height) {
    final buffer = StringBuffer();
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final current = coordinates
            .where((element) => element.x == x && element.y == y)
            .firstOrNull;
        if (current == null) {
          stdout.write('.');
        } else if (current.type != 'S') {
          stdout.write('X');
        } else {
          stdout.write('S');
        }
      }
      stdout.write('\n');
    }
    return buffer.toString();
  }
}

enum Direction {
  up(true),
  down(true),
  left(false),
  right(false);

  final bool vertical;

  const Direction(this.vertical);

  int modifier(Direction flood) {
    if (this == Direction.up) {
      return flood == Direction.right ? 1 : -1;
    } else if (this == Direction.down) {
      return flood == Direction.right ? -1 : 1;
    } else if (this == Direction.left) {
      return flood == Direction.right ? -1 : 1;
    } else if (this == Direction.right) {
      return flood == Direction.right ? 1 : -1;
    } else {
      throw 'Invalid flood direction';
    }
  }
}
