import 'package:aoc2023/day15.dart' as day;

void main(List<String> arguments) {
  final start = DateTime.timestamp();
  final solution = day.part2();
  print('AOC 2023 - Day 15 - Part 2: $solution');
  final time = DateTime.timestamp().difference(start).inMilliseconds;
  print('Total time: $time ms');
}
