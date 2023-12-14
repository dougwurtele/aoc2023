import 'dart:io';

int part1() {
  final input = File('assets/day14/input.txt').readAsLinesSync()
  .map((e) => e.split(''))
  .toList();
  for (int col = 0; col < input[0].length; col++) {
    bool movement = false;
    do {
      movement = false;
      for (int row = 0; row < input.length - 1; row++) {
        if (input[row + 1][col] == 'O' && input[row][col] == '.') {
          input[row][col] = 'O';
          input[row + 1][col] = '.';
          movement = true;
        }
      }
    } while (movement);
  }
  // for (int row = 0; row < input.length; row++) {
  //   for (int col = 0; col < input[row].length; col++) {
  //     stdout.write(input[row][col]);
  //   }
  //   stdout.write('\n');
  // }
  return northLoad(input);
}

int part2() {
  final input = File('assets/day14/input.txt').readAsLinesSync()
      .map((e) => e.split(''))
      .toList();
  List<List<String>> data = input;
  final Map<String, List<List<String>>> cache = {};
  final List<String> keys = [];
  final cycles = 1000000000;
  int? firstCache;
  String? firstKey;
  for (int i = 0; i < cycles; i++) {
    String key = data.map((e) => e.join()).join();
    if (firstKey != null && firstKey == key) {
      print('Loop complete at $i');
      break;
    }
    keys.add(key);
    if (cache[key] != null) {
      data = cache[key]!;
      if (firstCache == null) {
        firstCache = i;
        firstKey = key;
        print('Loop started at $i');
      }
      if (northLoad(data) == 102055) {
        print('Correct on i = $i');
        sleep(Duration(milliseconds: 250));
      }
      continue;
    }
    // North
    for (int col = 0; col < data[0].length; col++) {
      bool movement = false;
      do {
        movement = false;
        for (int row = 0; row < data.length - 1; row++) {
          if (data[row + 1][col] == 'O' && data[row][col] == '.') {
            data[row][col] = 'O';
            data[row + 1][col] = '.';
            movement = true;
          }
        }
      } while (movement);
    }

    // West
    for (int row = 0; row < data.length; row++) {
      bool movement = false;
      do {
        movement = false;
        for (int col = 0; col < data[row].length - 1; col++) {
          if (data[row][col + 1] == 'O' && data[row][col] == '.') {
            data[row][col] = 'O';
            data[row][col + 1] = '.';
            movement = true;
          }
        }
      } while (movement);
    }

    // South
    for (int col = 0; col < data[0].length; col++) {
      bool movement = false;
      do {
        movement = false;
        for (int row = data.length - 1; row > 0; row--) {
          if (data[row - 1][col] == 'O' && data[row][col] == '.') {
            data[row][col] = 'O';
            data[row - 1][col] = '.';
            movement = true;
          }
        }
      } while (movement);
    }

    // East
    for (int row = 0; row < data.length; row++) {
      bool movement = false;
      do {
        movement = false;
        for (int col = data[row].length - 1; col > 0; col--) {
          if (data[row][col - 1] == 'O' && data[row][col] == '.') {
            data[row][col] = 'O';
            data[row][col - 1] = '.';
            movement = true;
          }
        }
      } while (movement);
    }
    cache[key] = data.map((e) => [...e].toList()).toList();
  }
  int loopSize = keys.length - firstCache!;
  int mod = (cycles - firstCache) % loopSize;
  int correct = firstCache + mod - 1;
  data = cache[keys[correct]]!;
  return northLoad(data);
}

int northLoad(List<List<String>> input) {
  int result = 0;
  for (int row = 0; row < input.length; row++) {
    int count = input[row].where((element) => element == 'O').length;
    int multiplier = input.length - row;
    result += count * multiplier;
  }
  return result;
}
