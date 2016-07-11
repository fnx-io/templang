@JS()
library jsedn;

import "package:js/js.dart";
import 'dart:js' as js;

@JS("jsedn.parse")
external Object parse(String input);

@JS("jsedn.List")
@anonymous
class List {
  external Object at(int idx);
  external bool exists(int idx);
}

@JS("jsedn.Symbol")
@anonymous
class Symbol {
  external String  get value;
  external String get name;
}

@JS("jsedn.Keyword")
@anonymous
class Keyword extends Symbol {

}

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

js.JsFunction ListConstructor = js.context['jsedn']['List'];
js.JsFunction SymbolConstructor = js.context['jsedn']['Symbol'];
js.JsFunction KeywordConstructor = js.context['jsedn']['Keyword'];

bool isList(Object o) {
  return isJsType(o, ListConstructor);
}

bool isSymbol(Object o) {
  return isJsType(o, SymbolConstructor);
}

bool isKeyword(Object o) {
  return isJsType(o, KeywordConstructor);
}

bool isJsType(Object o, js.JsFunction constructor) {
  if (o == null) return false;
  if (constructor == null) return false;
  if (o is String) return false;
  if (o is int) return false;
  if (o is bool) return false;
  return js.JsNative.instanceof(o, constructor);
}