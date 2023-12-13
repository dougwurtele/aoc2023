import 'package:aoc2023/day12.dart' as day;

void main(List<String> arguments) {
  final start = DateTime.timestamp();
  final solution = day.part2();
  print('AOC 2023 - Day 12 - Part 2: $solution');
  final time = DateTime.timestamp().difference(start).inMilliseconds;
  print('Total time: $time ms');
}
