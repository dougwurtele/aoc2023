import 'dart:io';
import 'dart:math';

Future<int> part1() async {
  final input = File('assets/day1/input.txt');
  final data = await input.readAsLines();
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

Future<int> part2() async {
  final input = File('assets/day1/input.txt');
  final data = await input.readAsLines();
  final List<List<int>> values = data.map((e) {
    var result = e;
    for (int i = 0;
        i < result.length &&
            RegExp(r'^\d').stringMatch(result.substring(i)) == null;
        i++) {
      int initial = result.length;
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^one'), '1');
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^two'), '2');
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^three'), '3');
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^four'), '4');
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^five'), '5');
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^six'), '6');
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^seven'), '7');
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^eight'), '8');
      result = result.substring(0, i) +
          result.substring(i).replaceFirst(RegExp(r'^nine'), '9');
      int updated = result.length;
      if (updated < initial) {
        break;
      }
    }
    for (int i = 0;
        i < result.length &&
            RegExp(r'^\d').stringMatch(result.substring(result.length - i)) == null;
        i++) {
      int initial = result.length;
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^one'), '1');
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^two'), '2');
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^three'), '3');
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^four'), '4');
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^five'), '5');
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^six'), '6');
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^seven'), '7');
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^eight'), '8');
      result = result.substring(0, max(0, result.length - i)) +
          result
              .substring(max(0, result.length - i))
              .replaceFirst(RegExp(r'^nine'), '9');
      int updated = result.length;
      if (updated < initial) {
        break;
      }
    }
    return result
        .split('')
        .where((element) => int.tryParse(element) != null)
        .map((element) => int.parse(element))
        .toList();
  }).toList();
  return values.map((e) => e.first * 10 + e.last).reduce((value, element) => value + element);
}

Future<int> part2Regex() async {
  final input = await File('assets/day1/input.txt').readAsLines();
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
