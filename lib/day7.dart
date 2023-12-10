import 'dart:io';

int part1() {
  final input = File('assets/day7/input.txt').readAsLinesSync();
  List<Hand> hands = input.map((e) => Hand.fromString(e)).toList();
  hands.sort();

  int winnings = 0;
  for (int i = 0; i < hands.length; i++) {
    winnings += hands[i].bet * (i + 1);
  }
  return winnings;
}

int part2() {
  final input = File('assets/day7/input.txt').readAsLinesSync();
  List<Hand> hands = input.map((e) => Hand.fromString(e)).toList();
  hands.sort((a, b) {
    final aType = a.typeWithJokers;
    final bType = b.typeWithJokers;
    if (aType == bType) {
      for (int i = 0; i < a.cards.length; i++) {
        int comp = a.cardValue(a.cards[i], lowJoker: true).compareTo(b.cardValue(b.cards[i], lowJoker: true));
        if (comp != 0) {
          return comp;
        }
      }
      return 0;
    } else {
      return aType.compareTo(bType);
    }
  });

  int winnings = 0;
  for (int i = 0; i < hands.length; i++) {
    winnings += hands[i].bet * (i + 1);
  }
  return winnings;
}

class Hand implements Comparable<Hand> {
  Hand.fromString(String input)
      : cards = input.split(' ')[0].split(''),
        bet = int.parse(input.split(' ')[1]);

  final List<String> cards;
  final int bet;

  int get type {
    final Map<String, int> map = {};
    for (String card in cards) {
      map.update(card, (value) => value + 1, ifAbsent: () => 1);
    }
    final sortedValues = map.values.toList();
    sortedValues.sort((a, b) => a.compareTo(b) * -1);
    if (map.keys.length == 1) {
      return 7;
    } else if (map.keys.length == 2 && sortedValues[0] == 4) {
      return 6;
    } else if (map.keys.length == 2 &&
        sortedValues[0] == 3 &&
        sortedValues[1] == 2) {
      return 5;
    } else if (map.keys.length == 3 && sortedValues[0] == 3) {
      return 4;
    } else if (map.keys.length == 3 && sortedValues[0] == 2) {
      return 3;
    } else if (map.keys.length == 4 && sortedValues[0] == 2) {
      return 2;
    } else if (map.keys.length == 5) {
      return 1;
    } else {
      print('Invalid');
      return 0;
    }
  }

  int get typeWithJokers {
    if (!cards.contains('J')) {
      return type;
    }
    if (cards.join() == 'JJJJJ') {
      return 7;
    }
    final Map<String, int> map = {};
    for (String card in cards) {
      map.update(card, (value) => value + 1, ifAbsent: () => 1);
    }

    var sortedValues = map.entries
        .where((element) => element.key != 'J')
        .map((e) => e.value)
        .toList();
    sortedValues.sort((a, b) => a.compareTo(b) * -1);

    final topKey = map.entries
        .firstWhere((element) => element.key != 'J' && element.value == sortedValues[0])
        .key;
    map.update(topKey, (value) => value + map['J']!);
    map.remove('J');

    sortedValues = map.values.toList();
    sortedValues.sort((a, b) => a.compareTo(b) * -1);

    if (map.keys.length == 1) {
      return 7;
    } else if (map.keys.length == 2 && sortedValues[0] == 4) {
      return 6;
    } else if (map.keys.length == 2 &&
        sortedValues[0] == 3 &&
        sortedValues[1] == 2) {
      return 5;
    } else if (map.keys.length == 3 && sortedValues[0] == 3) {
      return 4;
    } else if (map.keys.length == 3 && sortedValues[0] == 2) {
      return 3;
    } else if (map.keys.length == 4 && sortedValues[0] == 2) {
      return 2;
    } else if (map.keys.length == 5) {
      return 1;
    } else {
      print('Invalid with Joker: ${cards.join()}');
      return 0;
    }
  }

  int cardValue(String card, {lowJoker = false}) {
    int value;
    switch (card) {
      case 'A':
        value = 13;
        break;
      case 'K':
        value = 12;
        break;
      case 'Q':
        value = 11;
        break;
      case 'J':
        value = lowJoker ? 0 : 10;
        break;
      case 'T':
        value = 9;
        break;
      default:
        value = int.parse(card) - 1;
        break;
    }
    return value;
  }

  @override
  int compareTo(Hand other) {
    final thisType = type;
    final otherType = other.type;
    if (type == otherType) {
      for (int i = 0; i < cards.length; i++) {
        int comp = cardValue(cards[i]).compareTo(cardValue(other.cards[i]));
        if (comp != 0) {
          return comp;
        }
      }
      return 0;
    } else {
      return thisType.compareTo(otherType);
    }
  }
}
