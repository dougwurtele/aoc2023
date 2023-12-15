import 'dart:io';

int part1() {
  final List<String> input = File('assets/day15/input.txt').readAsLinesSync().first.split(',');
  final List<List<String>> data = input.map((e) => e.split('')).toList();
  return data.map((e) => hash(e)).reduce((value, element) => value + element);
}

int part2() {
  final List<String> input = File('assets/day15/input.txt').readAsLinesSync().first.split(',');
  final List<Box> boxes = [for (int i = 0; i < 256; i++) i].map((e) => Box(e)).toList();
  final r1 = RegExp(r'^(\w+)=(\d+)$');
  final r2 = RegExp(r'^(\w+)-$');
  for (String step in input) {
    if (r1.hasMatch(step)) {
      final match = r1.firstMatch(step)!;
      String label = match.group(1)!;
      int boxId = hash(label.split(''));
      int focalLength = int.parse(match.group(2)!);
      int existingIndex = boxes[boxId].lenses.indexWhere((element) => element.label == label);
      if (existingIndex >= 0) {
        boxes[boxId].lenses.replaceRange(existingIndex, existingIndex + 1, [Lens(label, focalLength)]);
      } else {
        boxes[boxId].lenses.add(Lens(label, focalLength));
      }
    } else if (r2.hasMatch(step)) {
      final match = r2.firstMatch(step)!;
      String label = match.group(1)!;
      int boxId = hash(label.split(''));
      int index = boxes[boxId].lenses.indexWhere((element) => element.label == label);
      if (index >= 0) {
        boxes[boxId].lenses.removeAt(index);
      }
    }
  }
  return boxes.map((e) => e.focusingPower).reduce((value, element) => value + element);
}

int hash(List<String> characters, {int current = 0}) {
  if (characters.isEmpty) {
    return current;
  } else {
    current += characters.first.codeUnitAt(0);
    current *= 17;
    current %= 256;
    return hash(characters.sublist(1), current: current);
  }
}

class Box {
  final int id;
  final List<Lens> lenses = [];
  
  Box(this.id);
  
  int get focusingPower {
    int power = 0;
    for (int i = 0; i < lenses.length; i++) {
      power += (id + 1) * (i + 1) * (lenses[i].focalLength);
    }
    return power;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Box && other.id == id;
}

class Lens {
  final String label;
  final int focalLength;
  
  Lens(this.label, this.focalLength);

  @override
  int get hashCode => label.hashCode;

  @override
  bool operator ==(Object other) => other is Lens && other.label == label;

  @override
  String toString() => '$label ($focalLength)';
}
