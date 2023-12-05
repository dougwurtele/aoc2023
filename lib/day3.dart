import 'dart:io';

Future<int> part1() async {
  final input = await File('assets/day3/input.txt').readAsLines();
  final numberSearch = RegExp(r'(\d+)');
  final symbolSearch = RegExp(r'[^.\d]');
  final List<PositionedNumber> numbers = [];
  final List<PositionedSymbol> symbols = [];
  for (int lineNo = 0; lineNo < input.length; lineNo++) {
    String line = input[lineNo];
    numbers.addAll(numberSearch.allMatches(line).map(
          (e) =>
          PositionedNumber(
            y: lineNo,
            startX: e.start,
            value: int.parse(e.group(1)!),
          ),
    ));
    symbols.addAll(symbolSearch
        .allMatches(line)
        .map((e) => PositionedSymbol(e.start, lineNo)));
  }
  return numbers
      .where((element) {
    for (int y = element.y - 1; y <= element.y + 1; y++) {
      for (int x = element.startX - 1; x <= element.endX + 1; x++) {
        if (symbols
            .where((s) => s.x == x && s.y == y)
            .isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  })
      .map((e) => e.value)
      .reduce((value, element) => value + element);
}

Future<int> part2() async {
  final input = await File('assets/day3/input.txt').readAsLines();
  final numberSearch = RegExp(r'(\d+)');
  final gearSearch = RegExp(r'\*');
  final List<PositionedNumber> numbers = [];
  final List<PositionedSymbol> gears = [];
  for (int lineNo = 0; lineNo < input.length; lineNo++) {
    String line = input[lineNo];
    numbers.addAll(numberSearch.allMatches(line).map(
          (e) =>
          PositionedNumber(
            y: lineNo,
            startX: e.start,
            value: int.parse(e.group(1)!),
          ),
    ));
    gears.addAll(gearSearch
        .allMatches(line)
        .map((e) => PositionedSymbol(e.start, lineNo)));
  }
  return gears.map((gear) {
    final List<PositionedNumber> parts = [];
    for (int y = gear.y - 1; y <= gear.y + 1; y++) {
      parts.addAll(numbers.where((part) => part.y == y &&
          gear.x >= part.startX - 1 && gear.x <= part.endX + 1));
    }
    if (parts.length == 2) {
      return Gear(parts[0], parts[1]);
    } else {
      return null;
    }
  }).where((element) => element != null)
  .map((e) => e!.ratio)
  .reduce((value, element) => value + element);
}

class Gear {
  final PositionedNumber part1;
  final PositionedNumber part2;

  const Gear(this.part1, this.part2);

  int get ratio {
    return part1.value * part2.value;
  }
}

class PositionedSymbol {
  final int x;
  final int y;

  const PositionedSymbol(this.x, this.y);
}

class PositionedNumber {
  final int y;
  final int startX;
  final int value;

  const PositionedNumber({
    required this.y,
    required this.startX,
    required this.value,
  });

  int get endX {
    return value
        .toString()
        .length + startX - 1;
  }
}
