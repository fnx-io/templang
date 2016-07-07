import 'package:angular2/core.dart';

import 'package:templang/src/edn.dart' as edn;
import 'dart:js';

@Component(
  selector: 'node',
  templateUrl: 'node.html'
)
class Node {

  @Input() Object node;

  List<Object> get children {
    var res = new List();
    if (!isInstruction(node)) return res;

    edn.forEach(node as edn.List, 0, (o) {
      if (isInstruction(o)) res.add(o);
    });
    return res;
  }

  bool get validInstruction => node is edn.List;

  bool isValidInstructionName(Object o) {
    return o is edn.Symbol || o is String;
  }

  String instructionNameToString(Object o) {
    if (o is edn.Symbol || o is edn.Keyword) {
      return (o as edn.Symbol).name;
    }
    if (o is String) return o;

    return null;
  }

  String get instruction {
    if (node == null) return null;
    if (!validInstruction) return 'invalid';
    edn.List instruction = node as edn.List;
    if (!instruction.exists(0) || !isValidInstructionName(instruction.at(0))) return 'invalid';

    var instructionName = instructionNameToString(instruction.at(0));
    return instructionName;
  }

  bool isInstruction(Object o) {
    return edn.isList(o);
  }

  String objToString(Object o) {
    if (o == null) return null;
    if (o is edn.Symbol) return o.name;
    if (o is String) return o;

    return o.toString();
  }

  Map<String, Object> collectOpts(Object node) {
    Map<String, Object> opts = {};
    if (!isInstruction(node)) return opts;
    var instruction = node as edn.List;
    String optName;
    edn.forEachWhile(instruction, 1, (Object o) {
      var instr = isInstruction(o);
      if (instr) return false;
      if (optName == null) {
        if (edn.isSymbol(o)) {
          var n = (o as edn.Symbol).name;
          optName = n;
        } else {
          optName = o.toString();
        }
      } else {
        opts[optName] = o;
        optName == null;
      }

      return true;
    });

    return opts;
  }

  Map<String, Object> get opts {
    return collectOpts(node);
  }

}