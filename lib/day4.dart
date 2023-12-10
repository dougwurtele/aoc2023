import 'dart:io';
import 'dart:math';

int part1() {
  final data = File('assets/day4/input.txt').readAsLinesSync();
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
      .map((e) => pow(2, e - 1).toInt())
      .reduce((value, element) => value + element);
}

int part2() {
  final data = File('assets/day4/input.txt').readAsLinesSync();
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
