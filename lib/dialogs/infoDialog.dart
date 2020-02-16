import 'package:credpal/app/baseApp.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String title, message, btnTitle;
  final bool enableClick, canSkip;
  final Function onClick;
  final IconData icon;
  const InfoDialog(
      {Key key,
      this.title,
      this.message,
      this.btnTitle = "Contact Support",
      this.enableClick = true,
      this.onClick,
      this.icon,
      this.canSkip = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isAdmin) Navigator.pop(context);
        return false;
      },
      child: Material(
        color: white,
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Container(
              color: white,
              padding: EdgeInsets.all(15),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (isAdmin) {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        icon ?? Icons.update,
                        color: red0,
                        size: 50,
                      ),
                    ),
                    addSpace(10),
                    Text(
                      title,
                      style: textStyle(true, 16, black),
                      textAlign: TextAlign.center,
                    ),
                    addSpace(5),
                    Text(
                      message,
                      style: textStyle(false, 13, black.withOpacity(.4)),
                      textAlign: TextAlign.center,
                    ),
                    addSpace(10),
                    FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: APP_COLOR,
                        onPressed: () {
                          if (enableClick) {
                            Navigator.pop(context);
                            onClick();
                            return;
                          }
                        },
                        child: Text(
                          btnTitle,
                          style: textStyle(true, 14, white),
                        ))
                  ],
                ),
              ),
            ),
            if (canSkip)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, right: 15),
                  child: Text(
                    "Skip",
                    style: textStyle(true, 18, black),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
