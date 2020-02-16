import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';

class messageDialog extends StatelessWidget {
  var icon;
  Color iconColor;
  String title;
  String message;
  String yesText;
  String noText;
  BuildContext context;
  bool cancellable;
  bool isIcon;
  double iconPadding;

  messageDialog(
    icon,
    iconColor,
    title,
    message,
    yesText, {
    noText,
    bool cancellable = false,
    bool isIcon = false,
    double iconPadding = 12.0,
  }) {
    this.iconColor = iconColor;
    this.icon = icon;
    this.title = title;
    this.message = message;
    this.yesText = yesText;
    this.noText = noText;
    this.cancellable = cancellable;
    this.isIcon = isIcon;
    this.iconPadding = iconPadding;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
      onWillPop: () {
        if (cancellable) Navigator.pop(context);
      },
      child: Stack(fit: StackFit.expand, children: <Widget>[
        GestureDetector(
          onTap: () {
            if (cancellable) Navigator.pop(context);
          },
          child: Container(
            color: black.withOpacity(.8),
          ),
        ),
        page()
      ]),
    );
  }

  page() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 45, 25, 25),
        child: new Container(
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    new Container(
                      width: double.infinity,
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          /* if (isIcon)
                            Icon(
                              icon,
                              color: iconColor,
                            )
                          else*/
                          Image.asset(
                            ic_launcher,
                            height: 15,
                            width: 15,
                          ),
                          addSpaceWidth(10),
                          Flexible(
                            flex: 1,
                            child: new Text(
                              APP_NAME,
                              style:
                                  textStyle(false, 11, black.withOpacity(.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isIcon)
                      Center(
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: iconColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: white,
                              size: 15,
                            )),
                      )
                    else
                      Center(
                        child: Container(
                            width: 35,
                            height: 35,
                            padding: EdgeInsets.all(iconPadding),
                            decoration: BoxDecoration(
                              color: iconColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              icon,
                              color: white,
                              height: 15,
                              width: 15,
                            )),
                      ),
                  ],
                ),
                //addSpace(5),

                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 2),
                  child: new Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        addSpace(10),
                        Text(
                          title,
                          style: textStyle(true, 15, iconColor),
                          textAlign: TextAlign.center,
                        ),
                        addSpace(5),
                        Text(
                          message,
                          style: textStyle(false, 12, black.withOpacity(.5)),
                          textAlign: TextAlign.center,
                        ),
                        addSpace(15),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  color: APP_COLOR,
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text(
                                    yesText,
                                    style: textStyle(true, 14, white),
                                  )),
                            )
                          ],
                        ),
                        noText == null
                            ? new Container()
                            : Container(
                                width: double.infinity,
                                child: FlatButton(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    /*shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              color: blue3,*/
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text(
                                      noText,
                                      style: textStyle(false, 14, red0),
                                    )),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
