import 'package:angular2/core.dart';

import 'package:templang/src/edn.dart' as edn;
import 'dart:js' as js;

@Component(
    selector: 'app',
    templateUrl: 'app_component.html')
class AppComponent implements OnInit, AfterViewInit {

  @ViewChild("txtarea") ElementRef textArea;

  js.JsObject editor;

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

  ChangeDetectorRef changes;


  AppComponent(ChangeDetectorRef ref) {
    this.changes = ref;
  }

  void inputChanged(String text) {
    try {
      root = edn.parse(text);
    } catch (e) {
      // unparsable input
    }
  }

  @override
  ngOnInit() {
    inputChanged(txtInput);
  }

  @override
  ngAfterViewInit() {
    js.JsObject cm = js.context['CodeMirror'];

    var opts = {'lineNumbers': true};
    editor = cm.callMethod("fromTextArea", [textArea.nativeElement, new js.JsObject.jsify(opts)]);
    var self = this;
    var handler = (dynamic ed, dynamic change) {
      var jsObject = new js.JsObject.fromBrowserObject(ed);
      String value = jsObject.callMethod("getValue", []);
      txtInput = value;
      self.inputChanged(value);
      changes.detectChanges();
    };
    editor.callMethod("on", ['change', js.allowInterop(handler)]);
  }


}