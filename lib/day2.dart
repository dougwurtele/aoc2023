import 'dart:io';
import 'dart:math';

int part1() {
  final input = File('assets/day2/input.txt');
  final data = input.readAsLinesSync();
  final int maxRed = 12;
  final int maxGreen = 13;
  final int maxBlue = 14;
  return data
      .where((element) => element.trim().isNotEmpty)
      .where((line) {
        List<CubePull> pulls = line
            .split(':')[1]
            .split(';')
            .map((e) => CubePull.fromString(e))
            .toList();
        for (var pull in pulls) {
          if (pull.red > maxRed ||
              pull.green > maxGreen ||
              pull.blue > maxBlue) {
            return false;
          }
        }
        return true;
      })
      .map((line) => int.parse(line.split(':')[0].substring(4)))
      .reduce((value, element) => value + element);
}

int part2() {
  final input = File('assets/day2/input.txt');
  final data = input.readAsLinesSync();
  return data.where((element) => element.trim().isNotEmpty).map((line) {
    List<CubePull> pulls = line
        .split(':')[1]
        .split(';')
        .map((e) => CubePull.fromString(e))
        .toList();
    int red = pulls.fold(
        0, (previousValue, element) => max(previousValue, element.red));
    int green = pulls.fold(
        0, (previousValue, element) => max(previousValue, element.green));
    int blue = pulls.fold(
        0, (previousValue, element) => max(previousValue, element.blue));
    return red * green * blue;
  }).reduce((value, element) => value + element);
}

class CubePull {
  final int red;
  final int green;
  final int blue;

  CubePull.fromString(String input)
      : red = parseColor(input, 'red'),
        green = parseColor(input, 'green'),
        blue = parseColor(input, 'blue');

  static int parseColor(String input, String color) {
    return input
        .split(', ')
        .where((element) => RegExp('\\d+ $color').hasMatch(element))
        .map((e) => int.parse(e.trim().split(' ')[0]))
        .fold(0, (value, element) => value + element);
  }
}
