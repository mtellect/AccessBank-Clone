import 'dart:async';
import 'dart:math';

import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:credpal/auth/AuthLogin.dart';
import 'package:flutter/material.dart';

import 'auth/AuthChooser.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  List<int> activeProduct = [];
  Timer timer;
  int maxSize = 24;

  @override
  initState() {
    super.initState();
    opacityUpdater();
  }

  @override
  dispose() {
    super.dispose();
    timer?.cancel();
  }

  opacityUpdater() {
    timer = Timer.periodic(Duration(seconds: 5), (_) {
      if (mounted)
        setState(() {
          activeProduct.clear();
        });
      List<int> contains = activeProduct;
      var rand = Random();
      int p = rand.nextInt(maxSize);
      int p2 = rand.nextInt(maxSize);
      bool has = contains.contains(p);
      activeProduct.add(p);
      activeProduct.add(p2);
      if (mounted) setState(() {});
    });
  }

  double isActive(int p) {
    bool show = activeProduct.contains(p);
    return show ? 1 : .05;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          productBackground(),
          landingContent(),
          authButtons()
        ],
      ),
    );
  }

  productBackground() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
      itemBuilder: (context, p) {
        return AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: isActive(p),
            child: Image.asset("assets/products/$p.png"));
      },
      itemCount: maxSize,
      padding: EdgeInsets.all(25),
      physics: NeverScrollableScrollPhysics(),
    );
  }

  landingContent() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        color: white.withOpacity(.9),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Modern consumer credit solution for Africa",
              textAlign: TextAlign.center,
              style: textStyle(true, 30, headerColor),
            ),
            addSpace(10),
            Text(
              "CredPal connects consumers to lenders willing to finance their purchases while they pay back in fixed monthly installments.",
              textAlign: TextAlign.center,
              style: textStyle(false, 13, black.withOpacity(.6)),
            ),
            addSpace(15),
          ],
        ),
      ),
    );
  }

  authButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                pushAndResult(context, AuthLogin());
              },
              color: blue,
              padding: EdgeInsets.all(25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Login",
                  style: textStyle(true, 16, white),
                ),
              ),
            ),
            addSpace(5),
            FlatButton(
              onPressed: () {
                pushAndResult(context, AuthChooser());
              },
              color: transparent,
              padding: EdgeInsets.all(25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "Get Started",
                  style: textStyle(true, 16, textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
