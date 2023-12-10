import 'dart:io';

Future<int> part1() async {
  return File('assets/day9/input.txt')
      .readAsLinesSync()
      .map((line) => line.split(' ').map((e) => int.parse(e)).toList())
      .map((data) {
    List<List<int>> layers = [];
    List<int> current = data;
    while (current.toSet().length > 1 || current.toSet().first != 0) {
      layers.add(current);
      List<int> next = [];
      for (int i = 0; i < current.length - 1; i++) {
        next.add(current[i + 1] - current[i]);
      }
      current = next;
    }
    layers.add(current);
    for (int i = layers.length - 1; i >= 0; i--) {
      if (i == layers.length - 1) {
        layers[i].add(0);
      } else {
        layers[i].add(layers[i].last + layers[i + 1].last);
      }
    }
    return layers[0].last;
  }).reduce((value, element) => value + element);
}

Future<int> part2() async {
  return File('assets/day9/input.txt')
      .readAsLinesSync()
      .map((line) => line.split(' ').map((e) => int.parse(e)).toList())
      .map((data) {
    List<List<int>> layers = [];
    List<int> current = data;
    while (current.toSet().length > 1 || current.toSet().first != 0) {
      layers.add(current);
      List<int> next = [];
      for (int i = 0; i < current.length - 1; i++) {
        next.add(current[i + 1] - current[i]);
      }
      current = next;
    }
    layers.add(current);
    for (int i = layers.length - 1; i >= 0; i--) {
      if (i == layers.length - 1) {
        layers[i].insert(0, 0);
      } else {
        layers[i].insert(0, layers[i].first - layers[i + 1].first);
      }
    }
    return layers[0].first;
  }).reduce((value, element) => value + element);
}
