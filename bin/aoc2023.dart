import 'package:aoc2023/day7.dart' as day;

void main(List<String> arguments) async {
  final start = DateTime.timestamp();
  final solution = await day.part2();
  print('AOC 2023 - Day 7 - Part 2: $solution');
  final time = DateTime.timestamp().difference(start).inMilliseconds;
  print('Total time: $time ms');
}
