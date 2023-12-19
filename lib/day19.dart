import 'dart:io';
import 'dart:math';

final workflowRegex = RegExp(r'(\w+)\{([xmas][<>]\d+:\w+,?)+,(\w+)}');
final ruleRegex = RegExp(r'([xmas])([<>])(\d+):(\w+)');

int part1() {
  final partRegex = RegExp(r'\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)}');
  final List<Workflow> workflows = [];
  final List<Part> parts = [];
  for (final line in File('assets/day19/input.txt').readAsLinesSync()) {
    final workflowMatch = workflowRegex.firstMatch(line);
    if (workflowMatch != null) {
      final name = workflowMatch.group(1)!;
      final end = workflowMatch.group(3)!;
      final workflow = Workflow(name, end);

      for (final ruleMatch in ruleRegex.allMatches(line)) {
        workflow.rules.add(Rule(ruleMatch.group(1)!, ruleMatch.group(2)!,
            int.parse(ruleMatch.group(3)!), ruleMatch.group(4)!));
      }
      workflows.add(workflow);
    }

    final partMatch = partRegex.firstMatch(line);
    if (partMatch != null) {
      parts.add(Part(
          int.parse(partMatch.group(1)!),
          int.parse(partMatch.group(2)!),
          int.parse(partMatch.group(3)!),
          int.parse(partMatch.group(4)!)));
    }
  }

  return parts
      .where((part) {
        bool? accepted;
        Workflow current =
            workflows.firstWhere((element) => element.name == 'in');
        while (accepted == null) {
          bool ruleApplied = false;
          for (final rule in current.rules) {
            if (rule.doesApply(part)) {
              if (rule.destination == 'A') {
                accepted = true;
              } else if (rule.destination == 'R') {
                accepted = false;
              } else {
                current = workflows
                    .firstWhere((element) => element.name == rule.destination);
              }
              ruleApplied = true;
              break;
            }
          }
          if (!ruleApplied) {
            if (current.endState == 'A') {
              accepted = true;
            } else if (current.endState == 'R') {
              accepted = false;
            } else {
              current = workflows
                  .firstWhere((element) => element.name == current.endState);
            }
          }
        }
        return accepted;
      })
      .map((e) => e.totalRating)
      .reduce((value, element) => value + element);
}

int part2() {
  final List<Workflow> workflows = [];
  for (final line in File('assets/day19/input.txt').readAsLinesSync()) {
    final workflowMatch = workflowRegex.firstMatch(line);
    if (workflowMatch != null) {
      final name = workflowMatch.group(1)!;
      final end = workflowMatch.group(3)!;
      final workflow = Workflow(name, end);

      for (final ruleMatch in ruleRegex.allMatches(line)) {
        workflow.rules.add(Rule(ruleMatch.group(1)!, ruleMatch.group(2)!,
            int.parse(ruleMatch.group(3)!), ruleMatch.group(4)!));
      }
      workflows.add(workflow);
    }
  }

  final List<Node> acceptable = [];
  final List<Node> unsettled = [];
  final inWorkflow = workflows.firstWhere((element) => element.name == 'in');
  final start = Node(inWorkflow.name);
  unsettled.add(start);

  while (unsettled.isNotEmpty) {
    final node = unsettled.removeAt(0);
    final workflow =
        workflows.where((element) => element.name == node.name).firstOrNull;
    if (workflow != null) {
      final List<Rule> rulesToPath = [];
      for (final rule in workflow.rules) {
        rulesToPath.add(rule);
        if (rule.destination == 'A') {
          Node end = Node.fromParent(node, 'Acceptable #${acceptable.length + 1}');
          updateRestriction(end, rulesToPath, false);
          acceptable.add(end);
        } else if (rule.destination != 'R') {
          Node step = Node.fromParent(node, rule.destination);
          updateRestriction(step, rulesToPath, false);
          unsettled.add(step);
        }
      }
      if (workflow.endState == 'A') {
        Node end = Node.fromParent(node, 'Acceptable #${acceptable.length + 1}');
        updateRestriction(end, workflow.rules, true);
        acceptable.add(end);
      } else if (workflow.endState != 'R') {
        Node elseNode = Node.fromParent(node, workflow.endState);
        updateRestriction(elseNode, workflow.rules, true);
        unsettled.add(elseNode);
      }
    }
  }

  Node first = acceptable[0];
  Node? current = first;
  while (current != null) {
    if (current != first) {
      stdout.write(' <- ');
    }
    stdout.write(current.name);
    current = current.parent;
  }
  stdout.write('\n');
  print('${first.xRestriction.min} <= x <= ${first.xRestriction.max}');
  print('${first.mRestriction.min} <= m <= ${first.mRestriction.max}');
  print('${first.aRestriction.min} <= a <= ${first.aRestriction.max}');
  print('${first.sRestriction.min} <= s <= ${first.sRestriction.max}');

  return acceptable.map((e) {
    int x = e.xRestriction.max - e.xRestriction.min + 1;
    int m = e.mRestriction.max - e.mRestriction.min + 1;
    int a = e.aRestriction.max - e.aRestriction.min + 1;
    int s = e.sRestriction.max - e.sRestriction.min + 1;
    return x * m * a * s;
  }).reduce((value, element) => value + element);
}

void updateRestriction(Node node, List<Rule> rules, bool negate) {
  final restrictions = {
    'x': node.xRestriction,
    'm': node.mRestriction,
    'a': node.aRestriction,
    's': node.sRestriction
  };
  for (final rule in rules) {
    final restriction = restrictions[rule.category]!;
    final ruleNegate = negate ? negate : rule != rules.last;
    if (!ruleNegate && rule.operator == '<') {
      restriction.max = min(restriction.max, rule.amount - 1);
    } else if (!ruleNegate && rule.operator == '>') {
      restriction.min = max(restriction.min, rule.amount + 1);
    } else if (ruleNegate && rule.operator == '<') {
      restriction.min = max(restriction.min, rule.amount);
    } else if (ruleNegate && rule.operator == '>') {
      restriction.max = min(restriction.max, rule.amount);
    }
  }
}

class Node {
  final String name;
  final Restriction xRestriction = Restriction();
  final Restriction mRestriction = Restriction();
  final Restriction aRestriction = Restriction();
  final Restriction sRestriction = Restriction();
  final Node? parent;

  Node(this.name, {this.parent});

  Node.fromParent(this.parent, this.name) {
    xRestriction.min = parent!.xRestriction.min;
    xRestriction.max = parent!.xRestriction.max;
    mRestriction.min = parent!.mRestriction.min;
    mRestriction.max = parent!.mRestriction.max;
    aRestriction.min = parent!.aRestriction.min;
    aRestriction.max = parent!.aRestriction.max;
    sRestriction.min = parent!.sRestriction.min;
    sRestriction.max = parent!.sRestriction.max;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is Node && other.name == name;
}

class Restriction {
  int min;
  int max;

  Restriction({this.min = 1, this.max = 4000});
}

class Workflow {
  final String name;
  final String endState;
  final List<Rule> rules = [];

  Workflow(this.name, this.endState);

  List<String> get destinations {
    return [...rules.map((e) => e.destination), endState];
  }
}

class Rule {
  final String category;
  final String operator;
  final int amount;
  final String destination;

  Rule(this.category, this.operator, this.amount, this.destination);

  bool doesApply(Part part) {
    int value = 0;
    if (category == 'x') {
      value = part.x;
    } else if (category == 'm') {
      value = part.m;
    } else if (category == 'a') {
      value = part.a;
    } else if (category == 's') {
      value = part.s;
    }
    if (operator == '<') {
      return value < amount;
    } else {
      return value > amount;
    }
  }

  @override
  String toString() => '$category$operator$amount:$destination';
}

class Part {
  final int x;
  final int m;
  final int a;
  final int s;

  Part(this.x, this.m, this.a, this.s);

  int get totalRating => x + m + a + s;
}
