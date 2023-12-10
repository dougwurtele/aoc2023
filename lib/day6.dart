import 'dart:io';

int part1() {
  final input = File('assets/day6/input.txt').readAsLinesSync();
  final List<int> times = input[0]
      .split(':')[1]
      .trim()
      .split(RegExp(r'\s+'))
      .map((e) => int.parse(e))
      .toList();
  final List<int> distances = input[1]
      .split(':')[1]
      .trim()
      .split(RegExp(r'\s+'))
      .map((e) => int.parse(e))
      .toList();
  int wins = 1;
  for (int i = 0; i < times.length; i++) {
    int time = times[i];
    int distance = distances[i];
    int faster = [for (int t = 0; t < time; t++) t]
        .map((t) {
          int speed = t;
          int duration = time - speed;
          return speed * duration;
        })
        .where((element) => element > distance)
        .length;
    wins *= faster;
  }
  return wins;
}

int part2() {
  final input = File('assets/day6/input.txt').readAsLinesSync();
  final int time = int.parse(input[0].split(':')[1].trim().replaceAll(RegExp(r'\s+'), ''));
  final int distance = int.parse(input[1].split(':')[1].trim().replaceAll(RegExp(r'\s+'), ''));

  return [for (int t = 0; t < time; t++) t]
  .map((t) {
    int speed = t;
    int duration = time - speed;
    return speed * duration;
  })
  .where((element) => element > distance)
  .length;
}
