@JS()
library jsedn;

import "package:js/js.dart";

@JS("jsedn.parse")
external Object parse(String input);

@JS("jsedn.List")
class List {
  external Object at(int idx);
  external bool exists(int idx);
}

@JS("jsedn.Symbol")
class Symbol {
  external String  get value;
  external String get name;
}

@JS("jsedn.Keyword")
class Keyword extends Symbol {

}

@JS("isListObject")
external bool isList(Object o);

@JS("isSymbolObject")
external bool isSymbol(Object o);

@JS("isKeywordObject")
external bool isKeyword(Object o);

void forEach(List list, int startIdx, void f(Object o)) {
  if (list == null) return;
  int idx = startIdx;
  while (list.exists(idx)) {
    f(list.at(idx));
    idx++;
  }
}

void forEachWhile(List list, int startIdx, bool f(Object o)) {
  if (list == null) return;
  int idx = startIdx;
  while (list.exists(idx)) {
    var val = list.at(idx);
    bool res = f(val);
    idx++;
    if (!res) return;
  }
}
