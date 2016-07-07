import 'package:angular2/core.dart';

import 'package:templang/src/edn.dart' as edn;

@Component(
    selector: 'app',
    templateUrl: 'app_component.html')
class AppComponent implements OnInit {

  String txtInput = """
(blok a b
   (text q w)
   (row
      (button d c)
      (button d c)
      (button d c)
      (button d c)
   )
)
  """;

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


  @override
  ngOnInit() {
    inputChanged(txtInput);
  }
}