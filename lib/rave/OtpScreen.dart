import 'package:credpal/app/assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String message, title;
  final bool isPin;
  const OtpScreen({Key key, this.message, this.title, this.isPin = false})
      : super(key: key);
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var onTapRecognizer;

  /// this [StreamController] will take input of which function should be called

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: <Widget>[
                  //SizedBox(height: 30),
                  Image.asset(
                    'assets/${widget.isPin ? "atmpin" : "verify"}.png',
                    height: 200,
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8),
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
                      child: PinCodeTextField(
                        length: widget.isPin ? 4 : 6,
                        mainAxisAlignment: widget.isPin
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.spaceBetween,
                        obsecureText: widget.isPin,
                        animationType: AnimationType.fade,
                        shape: PinCodeFieldShape.box,
                        animationDuration: Duration(milliseconds: 300),
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        backgroundColor: Colors.white,
                        fieldWidth: 40,
                        onChanged: (value) {
                          setState(() {
                            currentText = value;
                          });
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      hasError ? "*Please fill up all the cells properly" : "",
                      style:
                          TextStyle(color: Colors.red.shade300, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 30),
                    child: ButtonTheme(
                      height: 50,
                      child: FlatButton(
                        onPressed: () {
                          // conditions for validating
                          if (currentText.length != (widget.isPin ? 4 : 6)) {
                            setState(() {
                              hasError = true;
                            });
                            return;
                          }

                          Navigator.pop(context, currentText);
//                          else {
//                            setState(() {
//                              hasError = false;
//                              scaffoldKey.currentState.showSnackBar(SnackBar(
//                                content: Text("Aye!!"),
//                                duration: Duration(seconds: 2),
//                              ));
//                            });
//                          }
                        },
                        child: Center(
                            child: Text(
                          "VERIFY".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.green.shade200,
                              offset: Offset(1, -2),
                              blurRadius: 5),
                          BoxShadow(
                              color: Colors.green.shade200,
                              offset: Offset(-1, 2),
                              blurRadius: 5)
                        ]),
                  ),
                  // Center(
                  //     child: Text(
                  //   submittedString,
                  //   style: TextStyle(fontSize: 18),
                  // )
                  // ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop("");
              },
              child: Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.only(left: 10, top: 30),
                child: Icon(Icons.close),
                decoration: BoxDecoration(
                    color: white,
                    //border: Border.all(color: black.withOpacity(.2)),
                    boxShadow: [
                      BoxShadow(color: black.withOpacity(.1), blurRadius: 4)
                    ],
                    shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
