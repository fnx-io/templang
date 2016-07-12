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
(block This is a form
  (label Please fill out this beautiful lorem ipsum form.
          Please fill out this beautiful lorem ipsum form.
          Please fill out this beautiful lorem ipsum form.
          Please fill out this beautiful lorem ipsum form.
  )
  (text Full name)
  (textarea Short bio)
  (row
    (block Contact
      (text Email)
      (text Phone)
      (row
        (check Yes, you can contact me)
        (check But not too often)
      )
    )
    (block Address
      (text Street)
      (text City)
      (text Zip)
      (select Housing type)
      (date I have been living there since)
    )
  )
  (check I agree with everything, just let me go)
  (row
    (button cancel)
    (space)
    (space)
    (button submit)
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

    var opts = {'lineNumbers': true, 'matchBrackets': true};
    editor = cm.callMethod("fromTextArea", [textArea.nativeElement, new js.JsObject.jsify(opts)]);
    var self = this;
    var handler = (dynamic ed, dynamic change) {
      var jsObject = new js.JsObject.fromBrowserObject(ed);
      String value = jsObject.callMethod("getValue", []);
      txtInput = value;
      self.inputChanged(value);
      changes.detectChanges();
    };
    editor.callMethod("setSize", ["100%", "70vh"]);
    editor.callMethod("on", ['change', js.allowInterop(handler)]);
  }


}