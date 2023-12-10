import 'dart:io';
import 'dart:math';

int part1() {
  final input = File('assets/day5/input.txt').readAsLinesSync();
  final List<int> seeds =
      input[0].split(': ')[1].split(' ').map((e) => int.parse(e)).toList();
  final List<List<DataMap>> maps = [];
  List<DataMap> current = [];
  for (int i = 2; i < input.length; i++) {
    if (input[i].endsWith('map:')) {
      if (current.isNotEmpty) {
        maps.add(current);
        current = [];
      }
    } else if (input[i].isNotEmpty) {
      current.add(DataMap.fromString(input[i]));
    }
  }
  if (current.isNotEmpty) {
    maps.add(current);
  }
  return seeds.map((seed) {
    // print('Processing seed $seed');
    int current = seed;
    int? destination;
    for (var map in maps) {
      if (destination != null) {
        current = destination;
      }
      destination = null;
      for (var i = 0; i < map.length && destination == null; i++) {
        destination = map[i].destination(current);
      }
      destination ??= current;
      // print('$current -> $destination');
    }
    return destination!;
  }).reduce((value, element) => min(value, element));
}

int part2() {
  final input = File('assets/day5/input.txt').readAsLinesSync();
  final List<int> seedsInput =
  input[0].split(': ')[1].split(' ').map((e) => int.parse(e)).toList();

  final List<int> seeds = [];

  for (int i = 0; i < seedsInput.length; i += 2) {
    int start = seedsInput[i];
    int length = seedsInput[i + 1];
    for (int j = start; j < start + length; j++) {
      seeds.add(j);
    }
  }
  print('Processing ${seeds.length} seeds');

  final List<List<DataMap>> maps = [];
  List<DataMap> current = [];
  for (int i = 2; i < input.length; i++) {
    if (input[i].endsWith('map:')) {
      if (current.isNotEmpty) {
        maps.add(current);
        current = [];
      }
    } else if (input[i].isNotEmpty) {
      current.add(DataMap.fromString(input[i]));
    }
  }
  if (current.isNotEmpty) {
    maps.add(current);
  }
  return seeds.map((seed) {
    // print('Processing seed $seed');
    int current = seed;
    int? destination;
    for (var map in maps) {
      if (destination != null) {
        current = destination;
      }
      destination = null;
      for (var i = 0; i < map.length && destination == null; i++) {
        destination = map[i].destination(current);
      }
      destination ??= current;
      // print('$current -> $destination');
    }
    return destination!;
  }).reduce((value, element) => min(value, element));
}

class DataMap {
  final int destinationStart;
  final int sourceStart;
  final int length;

  DataMap.fromString(String input)
      : destinationStart = int.parse(input.split(' ')[0]),
        sourceStart = int.parse(input.split(' ')[1]),
        length = int.parse(input.split(' ')[2]);

  int? destination(int source) {
    if (source >= sourceStart && source < sourceStart + length) {
      return destinationStart + (source + length) - (sourceStart + length);
    }
    return null;
  }
}
