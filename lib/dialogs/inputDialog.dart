import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class inputDialog extends StatelessWidget {
  String title;
  String message;
  String hint;
  String okText;
  TextEditingController editingController;
  int clickBack = 0;
  TextInputType inputType;
  int maxLength;
  bool allowEmpty = false;
  Color color;
  inputDialog(title,
      {message,
      hint,
      okText,
      inputType,
      maxLength = 10000,
      allowEmpty,
      color = blue3}) {
    this.title = title;
    this.message = message;
    this.hint = hint;
    this.okText = okText;
    this.inputType = inputType;
    this.maxLength = maxLength;
    this.allowEmpty = allowEmpty;
    this.color = color;
  }

  @override
  Widget build(BuildContext c) {
    editingController = new TextEditingController(text: message);

    return WillPopScope(
        onWillPop: () {
          int now = DateTime.now().millisecondsSinceEpoch;
          if ((now - clickBack) > 5000) {
            clickBack = now;
            toast(context, "Click back again to exit",
                color: black.withOpacity(.5));
            return;
          }
          Navigator.pop(context);
        },
        child: Scaffold(backgroundColor: white, body: page()));
  }

  BuildContext context;

  Builder page() {
    return Builder(builder: (context) {
      this.context = context;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          addSpace(30),
          new Container(
            width: double.infinity,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                          child: Icon(
                        Icons.keyboard_backspace,
                        color: black,
                        size: 25,
                      )),
                    )),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: new Text(
                    title,
                    style: textStyle(true, 17, black),
                  ),
                ),
                addSpaceWidth(10),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: color,
                    onPressed: () {
                      String text = editingController.text.trim();
                      if (text.isEmpty && !allowEmpty) {
                        toast(context, "Nothing to update");
                        return;
                      }
                      if (text.length > maxLength) {
                        toast(context,
                            "Text should not be more than $maxLength characters");
                        return;
                      }
                      Navigator.pop(context, text);
                    },
                    child: Text(
                      okText == null ? "OK" : okText,
                      style: textStyle(true, 14, white),
                    )),
                addSpaceWidth(15)
              ],
            ),
          ),
          addLine(1, black.withOpacity(.1), 0, 5, 0, 0),
          new Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: new TextField(
                  //textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                  maxLength: maxLength,
                  decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: textStyle(
                        false,
                        24,
                        black.withOpacity(.5),
                      ),
                      border: InputBorder.none),
                  style: textStyle(false, 24, black),
                  controller: editingController,
                  cursorColor: black,
                  cursorWidth: 1,
                  maxLines: null,
                  keyboardType:
                      inputType == null ? TextInputType.multiline : inputType,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
