import 'dart:io';
import 'dart:math';

final inputRegex = RegExp(r'([UDLR]) (\d+) \(#([a-z0-9]{6})\)');
final Map<String, List<int>> directions = {
  'R': [1, 0],
  'L': [-1, 0],
  'U': [0, -1],
  'D': [0, 1]
};

int part1() {
  final instructions = File('assets/day18/input.txt')
      .readAsLinesSync()
      .map((e) => inputRegex.firstMatch(e)!)
      .map((e) => Instruction(e.group(1)!, int.parse(e.group(2)!), e.group(3)!))
      .toList();

  final List<Line> perimeter = findPerimeter(instructions);
  int area = calculateArea(perimeter);
  int border = perimeter.map((e) => e.length).reduce((value, element) => value + element);

  return area + border + 1;
}

int part2() {
  final Map<int, String> dirMap = {0: 'R', 1: 'D', 2: 'L', 3: 'U'};
  final instructions = File('assets/day18/input.txt')
      .readAsLinesSync()
      .map((e) => inputRegex.firstMatch(e)!)
      .map((e) {
    final hex = e.group(3)!;
    final distance = int.parse(hex.substring(0, 5), radix: 16);
    final direction = dirMap[int.parse(hex.substring(5))]!;
    return Instruction(direction, distance, hex);
  }).toList();

  final List<Line> perimeter = findPerimeter(instructions);
  int area = calculateArea(perimeter);
  int border = perimeter.map((e) => e.length).reduce((value, element) => value + element);

  return area + border + 1;
}

List<Line> findPerimeter(List<Instruction> instructions) {
  final List<Line> edge = [];
  for (final instruction in instructions) {
    Location start = edge.isEmpty ? Location(0, 0) : edge.last.end;
    Location end = Location(
        start.x + directions[instruction.direction]![0] * instruction.distance,
        start.y + directions[instruction.direction]![1] * instruction.distance);
    edge.add(Line(start, end));
  }
  return edge;
}

int calculateArea(List<Line> perimeter) {
  final List<Location> points = [perimeter.first.start];
  for (final line in perimeter) {
    points.add(line.end);
  }

  int area = 0;
  for (int i = 0; i < points.length - 1; i++) {
    area += points[i].x * points[i + 1].y;
    area -= points[i].y * points[i + 1].x;
  }
  area ~/= 2;
  return area;
}

class Instruction {
  final String direction;
  final int distance;
  final String color;

  Instruction(this.direction, this.distance, this.color);

  @override
  String toString() => '$direction $distance';
}

class Location {
  final int x;
  final int y;

  Location(this.x, this.y);

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(Object other) =>
      other is Location && other.x == x && other.y == y;
}

class Line {
  final Location start;
  final Location end;

  Line(this.start, this.end);

  int get length => max(end.x - start.x, end.y - start.y).abs();
}
