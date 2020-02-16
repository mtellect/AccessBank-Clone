import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/main_screens/Ponds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyPonds extends StatefulWidget {
  final Color pgColor;

  const MyPonds({Key key, this.pgColor}) : super(key: key);

  @override
  _MyPondsState createState() => _MyPondsState();
}

class _MyPondsState extends State<MyPonds> {
  @override
  Widget build(BuildContext context) {
    return emptyLayout(AntDesign.rocket1, "Start Ponding!",
        "Start ponding in verified opportunities.Let's help you get started.",
        isIcon: true, clickText: "Explore Ponds", click: () {
      vp.jumpToPage(1);
    }, color: widget.pgColor);
  }
}
