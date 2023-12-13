import 'dart:io';

int part1() {
  return File('assets/day12/input.txt').readAsLinesSync()
  .map((e) {
    // print('Processing $e');
    final groups = e.split(' ')[1].split(',').map((e) => int.parse(e)).toList();
    final String data = e.split(' ')[0];
    final result = permutations(data, groups);
    // print('Found $result permutations');
    return result;
  }).reduce((value, element) => value + element);
}

int part2() {
  final input = File('assets/day12/input.txt').readAsLinesSync();
  int processed = 0;
  return input
      .map((e) {
    // print('Processing $e');
    List<int> groups = e.split(' ')[1].split(',').map((e) => int.parse(e)).toList();
    String data = e.split(' ')[0];
    groups = [...groups, ...groups, ...groups, ...groups, ...groups];
    data = '$data?$data?$data?$data?$data';
    final result = permutations(data, groups);
    // print('Found $result permutations');
    print('Processed ${processed++} of ${input.length} records (${processed / input.length * 100}%)');
    return result;
  }).reduce((value, element) => value + element);
}

final Map<String, int> cache = {};

int permutations(String data, List<int> groups) {
  final key = '$data:${groups.join(',')}';
  if (cache[key] == null) {
    cache[key] = permutationsInternal(data, groups);
  }
  return cache[key]!;
}

int permutationsInternal(String data, List<int> groups) {
  if (data.isEmpty) {
    return groups.isEmpty ? 1 : 0;
  } else if (data.startsWith('.')) {
    return permutations(data.substring(1), groups);
  } else if (data.startsWith('?')) {
    return permutations(data.replaceFirst('?', '.'), groups) + permutations(data.replaceFirst('?', '#'), groups);
  } else if (data.startsWith('#')) {
    if (groups.isEmpty) {
      return 0;
    } else if (data.length < groups[0]) {
      return 0;
    } else if (data.substring(0, groups[0]).contains(r'.')) {
      return 0;
    } else if (groups.length > 1) {
      if (data.length < groups[0] + 1 || data.substring(groups[0], groups[0] + 1) == '#') {
        return 0;
      } else {
        return permutations(data.substring(groups[0] + 1), groups.sublist(1));
      }
    } else {
      return permutations(data.substring(groups[0]), groups.sublist(1));
    }
  }
  throw 'Invalid data';
}
