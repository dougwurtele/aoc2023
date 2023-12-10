import 'dart:io';
import 'package:dart_numerics/dart_numerics.dart' as numerics;

int part1() {
  final input = File('assets/day8/input.txt').readAsLinesSync();
  final List<String> instructions = input[0].split('');
  final List<Node> nodes = [];
  for (int i = 2; i < input.length; i++) {
    nodes.add(Node.fromString(input[i]));
  }
  for (final node in nodes) {
    node.left = nodes.firstWhere((element) => element.label == node.leftLabel);
    node.right = nodes.firstWhere((element) => element.label == node.rightLabel);
  }
  int step = 0;
  Node current = nodes.firstWhere((element) => element.label == 'AAA');
  while (current.label != 'ZZZ') {
    String instruction = instructions[step % instructions.length];
    if (instruction == 'L') {
      current = current.left;
    } else if (instruction == 'R') {
      current = current.right;
    }
    step++;
  }
  return step;
}

int part2() {
  final input = File('assets/day8/input.txt').readAsLinesSync();
  final List<String> instructions = input[0].split('');
  final List<Node> nodes = [];
  for (int i = 2; i < input.length; i++) {
    nodes.add(Node.fromString(input[i]));
  }
  for (final node in nodes) {
    node.left = nodes.firstWhere((element) => element.label == node.leftLabel);
    node.right = nodes.firstWhere((element) => element.label == node.rightLabel);
  }
  List<Node> startingNodes = nodes.where((element) => element.isStartNode).toList();
  Map<Node, int> solutions = {};
  for (var node in startingNodes) {
    int step = 0;
    Node current = node;
    while (!current.isEndNode) {
      String instruction = instructions[step % instructions.length];
      if (instruction == 'L') {
        current = current.left;
      } else if (instruction == 'R') {
        current = current.right;
      }
      step++;
    }
    solutions[node] = step;
  }
  return solutions.values.reduce((value, element) => numerics.leastCommonMultiple(value, element));
}

class Node {
  Node.fromString(String input)
      : label = input.split(' = ')[0],
        leftLabel = input.split(' = (')[1].split(', ')[0],
        rightLabel = input.split(' = (')[1].split(', ')[1].substring(0, 3);

  final String label;
  final String leftLabel;
  final String rightLabel;
  late Node left;
  late Node right;

  bool get isStartNode => label.endsWith('A');
  bool get isEndNode => label.endsWith('Z');

  @override
  bool operator ==(Object other) => other is Node && label == other.label;

  @override
  int get hashCode => label.hashCode;

  @override
  String toString() => label;
}
