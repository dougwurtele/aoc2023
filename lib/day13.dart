import 'dart:io';
import 'dart:math';

int part1() {
  final data = getRowsAndCols(File('assets/day13/input.txt').readAsLinesSync());
  final rows = data[0];
  final cols = data[1];
  // print('Rows');
  int rowTotal = rows.map((e) => reflectingIndex(e)).reduce((value, element) => value + element);
  // print('Cols');
  int colTotal = cols.map((e) => reflectingIndex(e)).reduce((value, element) => value + element);

  return rowTotal * 100 + colTotal;
}

int part2() {
  final data = getRowsAndCols(File('assets/day13/input.txt').readAsLinesSync());
  final rows = data[0];
  final cols = data[1];
  final List<int> fixed = [];
  int rowTotal = rows.map((e) {
    int originalIndex = reflectingIndex(e);
    // print('Rows item ${rows.indexOf(e)}: original = $originalIndex');
    int result = 0;
    for (int i = 0; i < e.length && (result == 0 || result == originalIndex); i++) {
      for (int j = 0; j < e[i].length && (result == 0 || result == originalIndex); j++) {
        final original = e[i][j];
        e[i] = e[i].replaceRange(j, j + 1, original == '.' ? '#' : '.');
        result = reflectingIndex(e, including: i);
        e[i] = e[i].replaceRange(j, j + 1, original);
      }
    }
    if (result > 0) {
      fixed.add(rows.indexOf(e));
      // print('Reflection at $result');
    }
    return result;
  }).reduce((value, element) => value + element);

  int colTotal = cols.map((e) {
    if (fixed.contains(cols.indexOf(e))) {
      return 0;
    }
    int originalIndex = reflectingIndex(e);
    int result = 0;
    for (int i = 0; i < e.length && (result == 0 || result == originalIndex); i++) {
      for (int j = 0; j < e[i].length && (result == 0 || result == originalIndex); j++) {
        final original = e[i][j];
        e[i] = e[i].replaceRange(j, j + 1, original == '.' ? '#' : '.');
        result = reflectingIndex(e, including: i);
        e[i] = e[i].replaceRange(j, j + 1, original);
      }
    }
    return result;
  }).reduce((value, element) => value + element);
  return rowTotal * 100 + colTotal;
}

List<List<List<String>>> getRowsAndCols(List<String> input) {
  final List<List<String>> rows = [[]];
  for (String line in input) {
    if (line.isEmpty) {
      rows.add([]);
    } else {
      rows.last.add(line);
    }
  }
  final List<List<StringBuffer>> colBuilder = [];
  for (int i = 0; i < rows.length; i++) {
    colBuilder.add([]);
    for (int j = 0; j < rows[i][0].length; j++) {
      colBuilder[i].add(StringBuffer());
      for (int k = 0; k < rows[i].length; k++) {
        colBuilder[i][j].write(rows[i][k][j]);
      }
    }
  }
  final List<List<String>> cols = colBuilder.map((e) => e.map((e) => e.toString()).toList()).toList();
  return [rows, cols];
}

int reflectingIndex(List<String> input, {int? including}) {
  for (int i = 1; i < input.length; i++) {
    bool reflection = true;
    for (int j = 1; i - j >= 0 && i + j - 1 < input.length && reflection; j++) {
      reflection = input[i - j] == input[i + j - 1];
    }
    if (reflection) {
      // print('Reflection at $i\n${input.join('\n')}');
      if (including != null) {
        int reflectionLength = min(input.length - i, i);
        int lowerRange = i - reflectionLength;
        int upperRange = i + reflectionLength;
        if (including >= lowerRange && including <= upperRange) {
          return i;
        }
      } else {
        return i;
      }
    }
  }
  // print('No reflection for\n${input.join('\n')}');
  return 0;
}
