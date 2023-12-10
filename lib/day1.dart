import 'dart:io';

int part1() {
  final input = File('assets/day1/input.txt');
  final data = input.readAsLinesSync();
  final List<List<int>> values = data
      .map((e) => e
          .split('')
          .where((element) => int.tryParse(element) != null)
          .map((element) => int.parse(element))
          .toList())
      .toList();
  return values
      .map((e) => e.first * 10 + e.last)
      .reduce((value, element) => value + element);
}

int part2() {
  final input = File('assets/day1/input.txt').readAsLinesSync();
  final search = RegExp(r'(?=(one|two|three|four|five|six|seven|eight|nine|\d))');
  return input.map((e) => search.allMatches(e))
      .map((e) {
    var result = '';
    for (var match in [e.first.group(1), e.last.group(1)]) {
      result += match!
          .replaceFirst('one', '1')
          .replaceFirst('two', '2')
          .replaceFirst('three', '3')
          .replaceFirst('four', '4')
          .replaceFirst('five', '5')
          .replaceFirst('six', '6')
          .replaceFirst('seven', '7')
          .replaceFirst('eight', '8')
          .replaceFirst('nine', '9');
    }
    return result;
  })
      .map((e) => int.parse(e))
      .reduce((value, element) => value + element);
}
