import 'dart:collection';
import 'dart:io';

import 'package:dart_numerics/dart_numerics.dart';

int part1() {
  final modules = File('assets/day20/input.txt').readAsLinesSync().map((e) {
    final parts = e.split(' -> ');
    String name = parts[0];
    String type = 'broadcaster';
    if (name.startsWith('%')) {
      type = 'flip-flop';
      name = name.substring(1);
    } else if (name.startsWith('&')) {
      type = 'conjunction';
      name = name.substring(1);
    }
    return Module(name, type, parts[1].split(', '));
  }).toList();
  for (var module in modules) {
    module.inputs.addAll(modules.where((element) => element.outputs.contains(module.name)).map((e) => e.name));
    for (var input in module.inputs) {
      module.inputStates[input] = false;
    }
  }

  final Map<String, List<int>> cache = {};
  int low = 0;
  int high = 0;
  for (int i = 0; i < 1000; i++) {
    final queue = Queue<Action>();
    queue.add(Action(Module('button', 'button', ['broadcaster']), modules.firstWhere((element) => element.name == 'broadcaster'), false));
    low++;
    while (queue.isNotEmpty) {
      final action = queue.removeFirst();
      final key = modules.map((e) => e.key).fold('', (previousValue, element) => previousValue + element) + (action.isHigh ? '1' : '0');
      List<int> pulses;
      if (cache.containsKey(key)) {
        pulses = cache[key]!;
      } else {
        pulses = handleAction(modules, action, queue);
      }
      low += pulses[0];
      high += pulses[1];
    }
  }

  print('Low = $low, high = $high');
  return low * high;
}

int part2() {
  final input = File('assets/day20/input.txt').readAsLinesSync();
  final modules = input.map((e) {
    final parts = e.split(' -> ');
    String name = parts[0];
    String type = 'broadcaster';
    if (name.startsWith('%')) {
      type = 'flip-flop';
      name = name.substring(1);
    } else if (name.startsWith('&')) {
      type = 'conjunction';
      name = name.substring(1);
    }
    return Module(name, type, parts[1].split(', '));
  }).toList();

  final outputsNames = input.map((e) => e.split(' -> ')[1].split(', '))
      .fold([], (value, element) {
    value.addAll(element);
    return value;
  }).where((element) => !modules.map((e) => e.name).contains(element));
  modules.addAll(outputsNames.map((e) => Module(e, 'output', [])));

  for (var module in modules) {
    module.inputs.addAll(modules.where((element) => element.outputs.contains(module.name)).map((e) => e.name));
    for (var input in module.inputs) {
      module.inputStates[input] = false;
    }
  }

  final rx = modules.firstWhere((element) => element.name == 'rx');
  final nand = rx.inputs.map((e) => modules.firstWhere((element) => element.name == e)).first;

  int buttonPresses = 0;
  Map<String, int> nandInputs = {};
  do {
    buttonPresses++;
    final queue = Queue<Action>();
    queue.add(Action(Module('button', 'button', ['broadcaster']), modules.firstWhere((element) => element.name == 'broadcaster'), false));
    while (queue.isNotEmpty) {
      final action = queue.removeFirst();
      if (nand.inputs.contains(action.from.name) && action.isHigh) {
        if (!nandInputs.containsKey(action.from.name)) {
          nandInputs[action.from.name] = buttonPresses;
          if (nandInputs.keys.length == 4) {
            return leastCommonMultipleOfMany(nandInputs.values.toList());
          }
        }
      }
      handleAction(modules, action, queue);
    }
  } while (true);
}

List<int> handleAction(List<Module> modules, Action action, Queue<Action> queue) {
  if (action.module.type == 'broadcaster') {
    final outputs = action.module.outputs;
    queue.addAll(outputs.where((o) => modules.map((m) => m.name).contains(o)).map((e) => Action(action.module, modules.firstWhere((element) => element.name == e), action.isHigh)));
    return [action.isHigh ? 0 : outputs.length, action.isHigh ? outputs.length : 0];
  } else if (action.module.type == 'flip-flop') {
    if (action.isHigh) {
      return [0, 0];
    } else {
      action.module.isHigh = !action.module.isHigh;
      final outputs = action.module.outputs;
      queue.addAll(outputs.where((o) => modules.map((m) => m.name).contains(o)).map((e) => Action(action.module, modules.firstWhere((element) => element.name == e), action.module.isHigh)));
      return [action.module.isHigh ? 0 : outputs.length, action.module.isHigh ? outputs.length : 0];
    }
  } else if (action.module.type == 'conjunction') {
    action.module.inputStates[action.from.name] = action.isHigh;
    bool output = action.module.inputStates.containsValue(false) ? true : false;
    final outputs = action.module.outputs;
    queue.addAll(outputs.where((o) => modules.map((m) => m.name).contains(o)).map((e) => Action(action.module, modules.firstWhere((element) => element.name == e), output)));
    return [output ? 0 : outputs.length, output ? outputs.length : 0];
  }
  return [0, 0];
}

class Module {
  final String name;
  final String type;
  final List<String> outputs;
  final List<String> inputs = [];
  final Map<String, bool> inputStates = {};
  bool isHigh = false;

  Module(this.name, this.type, this.outputs);

  String get key {
    final buffer = StringBuffer();
    buffer.write(name);
    buffer.write(isHigh ? '1' : '0');
    if (type == 'conjunction') {
      final sortedKeys = inputStates.keys.toList();
      sortedKeys.sort();
      for (final iKey in sortedKeys) {
        buffer.write(inputStates[iKey]! ? '1' : '0');
      }
    }
    return buffer.toString();
  }
}

class Action {
  final Module from;
  final Module module;
  final bool isHigh;

  Action(this.from, this.module, this.isHigh);
}
