import 'dart:io';

int part1() {
  final input = File('assets/day11/input.txt').readAsLinesSync();
  final galaxies = <Location>[];
  for (int row = 0; row < input.length; row++) {
    for (int col = 0; col < input[row].length; col++) {
      if (input[row][col] == '#') {
        galaxies.add(Location(row, col));
      }
    }
  }
  for (int row = input.length - 1; row >= 0; row--) {
    if (galaxies.where((element) => element.row == row).firstOrNull == null) {
      galaxies.where((element) => element.row > row).forEach((element) => element.row++);
    }
  }
  for (int col = input[0].length - 1; col >= 0; col--) {
    if (galaxies.where((element) => element.col == col).firstOrNull == null) {
      galaxies.where((element) => element.col > col).forEach((element) => element.col++);
    }
  }
  int total = 0;
  for (int i = 0; i < galaxies.length; i++) {
    for (int j = i + 1; j < galaxies.length; j++) {
      final from = galaxies[i];
      final to = galaxies[j];
      total += (from.row - to.row).abs();
      total += (from.col - to.col).abs();
    }
  }
  return total;
}

int part2() {
  final input = File('assets/day11/input.txt').readAsLinesSync();
  final galaxies = <Location>[];
  for (int row = 0; row < input.length; row++) {
    for (int col = 0; col < input[row].length; col++) {
      if (input[row][col] == '#') {
        galaxies.add(Location(row, col));
      }
    }
  }
  for (int row = input.length - 1; row >= 0; row--) {
    if (galaxies.where((element) => element.row == row).firstOrNull == null) {
      galaxies.where((element) => element.row > row).forEach((element) => element.row += 999999);
    }
  }
  for (int col = input[0].length - 1; col >= 0; col--) {
    if (galaxies.where((element) => element.col == col).firstOrNull == null) {
      galaxies.where((element) => element.col > col).forEach((element) => element.col += 999999);
    }
  }
  int total = 0;
  for (int i = 0; i < galaxies.length; i++) {
    for (int j = i + 1; j < galaxies.length; j++) {
      final from = galaxies[i];
      final to = galaxies[j];
      total += (from.row - to.row).abs();
      total += (from.col - to.col).abs();
    }
  }
  return total;
}

class Location {
  int row;
  int col;

  Location(this.row, this.col);

  @override
  int get hashCode => Object.hash(row, col);

  @override
  bool operator ==(Object other) => other is Location && row == other.row && col == other.col;
}
