import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';

class HomePop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 5),
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: black.withOpacity(.5),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: Text(
                            "Create Post or Bid",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  ),
                  //addLine(.5, black.withOpacity(.09), 0, 5, 0, 5),
                  gradientLine(alpha: .08),
                  Container(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Post"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, 0);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: transparent,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "To Feed",
                              style: textStyle(true, 18, black),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, 1);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: transparent,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "To Shop",
                              style: textStyle(true, 18, black),
                            ),
                          ),
                        ),
                        addLine(.2, black.withOpacity(.09), 0, 10, 0, 5),
                        Text("Bid"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, 2);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: transparent,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "I Want?",
                              style: textStyle(true, 18, black),
                            ),
                          ),
                        ),
                        addSpace(8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
