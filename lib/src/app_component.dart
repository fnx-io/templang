import 'package:angular2/core.dart';

import 'package:templang/src/edn.dart' as edn;
import 'dart:js' as js;
import 'dart:html' as h;
import 'dart:async';

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

  String currentName;
  String loadName;

  List<String> saved = [];

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

  void save() {
    if (currentName == null || currentName.isEmpty) {
      h.window.alert("Please, input a name for this mockup");
    } else {
      h.window.localStorage["templang:${currentName}"] = txtInput;
    }
    buildSavedList();
  }

  void autosave() {
    if (currentName == null || currentName.isEmpty) {
      return;
    } else {
      h.window.localStorage["templang:${currentName}-autosave"] = txtInput;
    }
    buildSavedList();
  }

  void load(){
    txtInput = h.window.localStorage[loadName];
    inputChanged(txtInput);
    currentName = loadName.replaceFirst(new RegExp(".*:"), "");
    currentName = currentName.replaceFirst(new RegExp("-autosave\$"), "");

    js.JsObject doc = editor.callMethod("getDoc");
    doc.callMethod("setValue", [txtInput]);
  }

  void buildSavedList() {
    saved = h.window.localStorage.keys.where((String n) => n != null && n.startsWith("templang:")).toList();
  }

  @override
  ngOnInit() {
    inputChanged(txtInput);
    buildSavedList();
    currentName = "demo";
    save();
    Timer t = new Timer.periodic(new Duration(seconds: 10), (_) {
       if (currentName != null && currentName.isNotEmpty) {
         autosave();
       }
    });
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