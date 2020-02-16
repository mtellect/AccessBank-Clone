import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../app/baseApp.dart';
import 'AuthSignUp.dart';

class AuthChooser extends StatefulWidget {
  @override
  _AuthChooserState createState() => _AuthChooserState();
}

class _AuthChooserState extends State<AuthChooser> {
  int activeChosen = -1;

  bool get hasChosen => activeChosen != -1;

  List<BaseModel> chooser = [
    BaseModel()
      ..put(COLORS, Color(0xFF1C68EC))
      ..put(IMAGE_PATH, FontAwesome.user_o)
      ..put(TITLE, "Customer")
      ..put(VALUE, "Make purchases and pay over time"),
    BaseModel()
      ..put(COLORS, Color(0xFF17A2B8))
      ..put(IMAGE_PATH, FontAwesome.shopping_cart)
      ..put(TITLE, "Retailer/Merchant")
      ..put(VALUE,
          "For merchants looking to provide credit option for their customers"),
    BaseModel()
      ..put(COLORS, Color(0xFF6F42C1))
      ..put(IMAGE_PATH, FontAwesome.bank)
      ..put(TITLE, "Financial Institution")
      ..put(VALUE,
          "For lenders looking to provide point-of-sale consumer credit for buyers"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: <Widget>[
          Container(
            color: backgroundColor,
          ),
          pageBody()
        ],
      ),
    );
  }

  pageBody() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              child: Icon(Icons.close),
            ),
          ),
          addSpace(10),
          Container(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "What kind of account would you like to open?",
                  textAlign: TextAlign.start,
                  style: textStyle(true, 25, headerColor),
                ),
                addSpace(10),
                Text(
                  "CredPal accounts only takes minutes to open.",
                  textAlign: TextAlign.center,
                  style: textStyle(false, 14, black.withOpacity(.6)),
                ),
              ],
            ),
          ),
          addSpace(15),
          Flexible(
            child: ListView.builder(
                itemCount: chooser.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (ctx, p) {
                  BaseModel bm = chooser[p];
                  String title = bm.getString(TITLE);
                  String value = bm.getString(VALUE);
                  IconData icon = bm.get(IMAGE_PATH);
                  Color color = bm.get(COLORS);
                  bool active = activeChosen == p;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        activeChosen = p;
                      });
                    },
                    child: active
                        ? Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            color: white.withOpacity(active ? 1 : 0),
                            //shadowColor: white.withOpacity(active ? 1 : 0),
                            animationDuration: Duration(milliseconds: 500),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      icon,
                                      size: 20,
                                      color: color,
                                    ),
                                    decoration: BoxDecoration(
                                        color: color.withOpacity(.1),
                                        shape: BoxShape.circle),
                                  ),
                                  addSpaceWidth(15),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          title,
                                          style:
                                              textStyle(false, 18, headerColor),
                                        ),
                                        addSpace(10),
                                        Text(
                                          value,
                                          style: textStyle(false, 15, black),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    icon,
                                    size: 20,
                                    color: color,
                                  ),
                                  decoration: BoxDecoration(
                                      color: color.withOpacity(.1),
                                      shape: BoxShape.circle),
                                ),
                                addSpaceWidth(15),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        title,
                                        style:
                                            textStyle(false, 18, headerColor),
                                      ),
                                      addSpace(10),
                                      Text(
                                        value,
                                        style: textStyle(false, 15, black),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                  );
                }),
          ),
          addSpace(15),
          Container(
            padding: EdgeInsets.all(14),
            child: FlatButton(
              onPressed: () {
                pushAndResult(
                    context,
                    AuthSignUp(
                      authPage: activeChosen,
                    ));
              },
              color: hasChosen ? buttonColor : buttonSelectedColor,
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Continue",
                  style: textStyle(true, 16, white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
