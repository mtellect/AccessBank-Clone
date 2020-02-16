import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

import 'TransferSummary.dart';

class EnterAmount extends StatefulWidget {
  final String title;

  const EnterAmount({Key key, this.title}) : super(key: key);
  @override
  _EnterAmountState createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  String amountToPull = '0.00';
  bool shiftEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: payBody(),
    );
  }

  bool get isZeroValue => amountToPull == "0.00";

  payBody() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: white,
                ),
                color: red,
                padding: EdgeInsets.all(8),
                shape: CircleBorder(),
              ),
              if (!isZeroValue)
                FlatButton(
                  onPressed: () {
                    pushAndResult(
                        context,
                        TransferSummary(
                          amountToPull: int.parse(amountToPull),
                        ));
                  },
                  color: orang0,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "TRANSFER",
                      style: textStyle(true, 12, white),
                    ),
                  ),
                )
            ],
          ),
        ),
        Flexible(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  amountToPull,
                  style: textStyle(
                      true, 40, black.withOpacity(isZeroValue ? 0.6 : 1)),
                ),
                //if (isZeroValue)
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: red, borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(6),
                  child: Text(
                    "Please enter amount to Add/Transfer/Withdraw",
                    style: textStyle(false, 14, white),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          color: Colors.deepPurple,
          child: VirtualKeyboard(
              height: 300,
              textColor: Colors.white,
              type: VirtualKeyboardType.Numeric,
              onKeyPress: _onKeyPress),
        )
      ],
    );
  }

  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      if (isZeroValue) {
        amountToPull = (shiftEnabled ? key.capsText : key.text);
      } else {
        amountToPull = amountToPull + (shiftEnabled ? key.capsText : key.text);
      }
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          //print(text.length);
          if (amountToPull.length == 1 || isZeroValue || amountToPull.isEmpty) {
            amountToPull = "0.00";
          } else {
            amountToPull = amountToPull.substring(0, amountToPull.length - 1);
          }

          break;
        case VirtualKeyboardKeyAction.Return:
          amountToPull = amountToPull + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          amountToPull = amountToPull + key.text;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    setState(() {
      print("setting state");
    });
  }
}
