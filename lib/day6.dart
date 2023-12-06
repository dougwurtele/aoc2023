import 'dart:io';

Future<int> part1() async {
  final input = await File('assets/day6/input.txt').readAsLines();
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

Future<int> part2() async {
  final input = await File('assets/day6/input.txt').readAsLines();
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
