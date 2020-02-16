import 'package:credpal/app/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app/baseApp.dart';

class AuthLogin extends StatefulWidget {
  @override
  _AuthLoginState createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  bool showPassword = false;

  var emailController = TextEditingController();
  var passController = TextEditingController();

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
                  "Login to your account",
                  textAlign: TextAlign.start,
                  style: textStyle(true, 25, headerColor),
                ),
              ],
            ),
          ),
          addSpace(15),
          Flexible(
            child: ListView(
              children: <Widget>[
                authInputField(
                    controller: emailController,
                    title: "Email",
                    hint: "Enter your email address"),
                authInputField(
                    controller: passController,
                    title: "Password",
                    hint: "Enter your password",
                    isPassword: true,
                    showPassword: showPassword,
                    onPassChanged: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    }),
                Container(
                  padding: EdgeInsets.all(18),
                  alignment: Alignment.center,
                  child: Text(
                    "Can't remember your password?",
                    style: textStyle(false, 14, headerColor),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14),
                  child: FlatButton(
                    onPressed: () {
                      pushAndResult(context, AuthLogin());
                    },
                    color: blue.withOpacity(1),
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "LOG ME IN",
                        style: textStyle(true, 16, white),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(18),
                  alignment: Alignment.center,
                  child: Text(
                    "Don't have an account?",
                    style: textStyle(false, 14, headerColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  authInputField(
      {@required TextEditingController controller,
      String title,
      String hint,
      bool isPassword = false,
      bool showPassword = false,
      onPassChanged}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: Text(
              title,
              style: textStyle(false, 14, headerColor),
            ),
          ),
          addSpaceWidth(10),
          Flexible(
            child: CupertinoTextField(
              padding: EdgeInsets.all(18),
              placeholder: hint,
              obscureText: showPassword,
              suffix: isPassword
                  ? Container(
                      decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )),
                      child: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: white,
                          ),
                          onPressed: onPassChanged),
                    )
                  : null,
              decoration: BoxDecoration(
                  color: black.withOpacity(.04),
                  borderRadius: BorderRadius.circular(8)),
            ),
          )
        ],
      ),
    );
  }
}
