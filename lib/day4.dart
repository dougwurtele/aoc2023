import 'dart:io';
import 'dart:math';

Future<num> part1() async {
  final data = await File('assets/day4/input.txt').readAsLines();
  return data
      .map((e) {
        final winners = e
            .split(':')[1]
            .split('|')[0]
            .trim()
            .split(RegExp(r'\s+'))
            .map((w) => int.parse(w))
            .toList();
        return e
            .split(':')[1]
            .split('|')[1]
            .trim()
            .split(RegExp(r'\s+'))
            .map((p) => int.parse(p))
            .where((element) => winners.contains(element))
            .length;
      })
      .where((element) => element > 0)
      .map((e) => pow(2, e - 1))
      .reduce((value, element) => value + element);
}

Future<int> part2() async {
  final data = await File('assets/day4/input.txt').readAsLines();
  for (int i = 0; i < data.length; i++) {
    final input = data[i];
    final winners = input
        .split(':')[1]
        .split('|')[0]
        .trim()
        .split(RegExp(r'\s+'))
        .map((w) => int.parse(w))
        .toList();
    final adds = input
        .split(':')[1]
        .split('|')[1]
        .trim()
        .split(RegExp(r'\s+'))
        .map((p) => int.parse(p))
        .where((element) => winners.contains(element))
        .length;
    final card =
        int.parse(RegExp(r'Card\s+(\d+)').firstMatch(input)!.group(1)!);
    for (int a = card + 1; a <= card + adds; a++) {
      data.add(data[a - 1]);
    }
  }
  return data.length;
}

Future<int> part2Optimized() async {
  final data = await File('assets/day4/input.txt').readAsLines();
  final Map<int, int> gameMatches = {};
  for (int i = 0; i < data.length; i++) {
    final winners = data[i]
        .split(':')[1]
        .split('|')[0]
        .trim()
        .split(RegExp(r'\s+'))
        .map((w) => int.parse(w))
        .toList();
    final matches = data[i]
        .split(':')[1]
        .split('|')[1]
        .trim()
        .split(RegExp(r'\s+'))
        .map((p) => int.parse(p))
        .where((element) => winners.contains(element))
        .length;
    gameMatches[i + 1] = matches;
  }
  final Map<int, int> cards = {};
  for (int i = 1; i <= gameMatches.length; i++) {
    cards.putIfAbsent(i, () => 0);
    cards.update(i, (value) => value + 1);
    for (int j = 1; j <= gameMatches[i]!; j++) {
      final copies = cards[i]!;
      cards.putIfAbsent(i + j, () => 0);
      cards.update(i + j, (value) => value + copies);
    }
  }
  return cards.values.reduce((value, element) => value + element);
}
