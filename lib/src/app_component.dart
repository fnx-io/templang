import 'package:angular2/core.dart';

import 'package:templang/src/edn.dart' as edn;

@Component(
    selector: 'app',
    templateUrl: 'app_component.html')
class AppComponent {

  String txtInput;

  Object root;

  void inputChanged(String text) {
    print(text);
    try {
      root = edn.parse(text);
      print("PARSED TO: $root");
    } catch (e) {
      print("error: $e");
    }
  }

}