import 'package:credpal/app/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app/baseApp.dart';

class AuthSignUp extends StatefulWidget {
  final int authPage;

  const AuthSignUp({Key key, this.authPage}) : super(key: key);
  @override
  _AuthSignUpState createState() => _AuthSignUpState();
}

class _AuthSignUpState extends State<AuthSignUp> {
  bool showPassword = false;
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var nameController = TextEditingController();
  var bvnController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  int currentPage;

  int get authPage => widget.authPage;
  var vpController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentPage = authPage;
      vpController = PageController(initialPage: currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: <Widget>[
          Container(
            color: backgroundColor,
          ),
          PageView(
            controller: vpController,
            onPageChanged: (p) {
              setState(() {
                currentPage = p;
              });
            },
            children: <Widget>[
              page0(),
              page1(),
              page2(),
            ],
          )
        ],
      ),
    );
  }

  page0() {
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
                  titleValue,
                  textAlign: TextAlign.start,
                  style: textStyle(true, 25, headerColor),
                ),
              ],
            ),
          ),
          addSpace(15),
          Flexible(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                authInputField(
                    controller: nameController,
                    title: "Full Name",
                    hint: "Enter your first and last name"),
                authInputField(
                    controller: bvnController,
                    title: "BVN",
                    hint: "Enter your Bank Verification Number"),
                tipMessageItem("Note",
                    "We’re mandated by CBN to keep your BVN secure and confidential. This information will only be used to process your request."),
                authInputField(
                    controller: phoneController,
                    title: "Birthdate",
                    hint: "Select  your date of birth",
                    isBtn: true,
                    onBtnPressed: () {
                      print("am clicked...");
                    }),
                authInputField(
                    controller: phoneController,
                    title: "Phone",
                    hint: "Enter your phone number"),
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
                  padding: EdgeInsets.all(14),
                  child: FlatButton(
                    onPressed: () {
                      pushAndResult(context, AuthSignUp());
                    },
                    color: blue.withOpacity(1),
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "CREATE MY ACCOUNT",
                        style: textStyle(true, 16, white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(18),
                    alignment: Alignment.center,
                    child: Text(
                      "Choose another account type",
                      style: textStyle(false, 14, headerColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  page1() {
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
                  titleValue,
                  textAlign: TextAlign.start,
                  style: textStyle(true, 25, headerColor),
                ),
              ],
            ),
          ),
          addSpace(15),
          Flexible(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                authInputField(
                    controller: fNameController,
                    title: "First Name",
                    hint: "First Name"),
                authInputField(
                    controller: lNameController,
                    title: "Last Name",
                    hint: "Last Name"),
                authInputField(
                    controller: emailController, title: "Email", hint: "Email"),
                authInputField(
                    controller: emailController,
                    title: "Company",
                    hint: "Company's Name"),
                authInputField(
                    controller: phoneController,
                    title: "Phone Number",
                    hint: "Phone Number"),
                authInputField(
                    controller: emailController,
                    title: "Store Address",
                    hint: "Store Address"),
                authInputField(
                    controller: emailController,
                    title: "Website",
                    hint: "Website"),
                authInputField(
                    controller: phoneController,
                    title: "State",
                    hint: "State",
                    isBtn: true,
                    onBtnPressed: () {
                      print("am clicked...");
                    }),
                authInputField(
                    controller: phoneController,
                    title: "Average Order Value",
                    hint: "Average Order Value",
                    isBtn: true,
                    onBtnPressed: () {
                      print("am clicked...");
                    }),
                authInputField(
                    controller: phoneController,
                    title: "Annual Revenue",
                    hint: "Annual Revenue",
                    isBtn: true,
                    onBtnPressed: () {
                      print("am clicked...");
                    }),
                authInputField(
                    controller: phoneController,
                    title: "What do you sell?",
                    hint: "What do you sell?",
                    isBtn: true,
                    onBtnPressed: () {
                      print("am clicked...");
                    }),
                authInputField(
                    controller: phoneController,
                    title: "E-commerce Platform",
                    hint: "E-commerce Platform",
                    isBtn: true,
                    onBtnPressed: () {
                      print("am clicked...");
                    }),
                authInputField(
                    controller: phoneController,
                    title: "Industry",
                    hint: "Industry",
                    isBtn: true,
                    onBtnPressed: () {
                      print("am clicked...");
                    }),
                Container(
                  padding: EdgeInsets.all(14),
                  child: FlatButton(
                    onPressed: () {
                      pushAndResult(context, AuthSignUp());
                    },
                    color: blue.withOpacity(1),
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "REGISTER MY BUSINESS",
                        style: textStyle(true, 16, white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(18),
                    alignment: Alignment.center,
                    child: Text(
                      "Choose another account type",
                      style: textStyle(false, 14, headerColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  page2() {
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
                  titleValue,
                  textAlign: TextAlign.start,
                  style: textStyle(true, 25, headerColor),
                ),
              ],
            ),
          ),
          addSpace(15),
          Flexible(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: <Widget>[
                authInputField(
                    controller: fNameController,
                    title: "First Name",
                    hint: "Enter your first name"),
                authInputField(
                    controller: lNameController,
                    title: "Last Name",
                    hint: "Enter your last name"),
                authInputField(
                    controller: emailController,
                    title: "Company",
                    hint: "Enter your company name"),
                authInputField(
                    controller: emailController,
                    title: "Business Email",
                    hint: "Enter your email address"),
                authInputField(
                    controller: phoneController,
                    title: "Phone Number",
                    hint: "Enter your phone number"),
                authInputField(
                    controller: phoneController,
                    title: "Project Volume",
                    hint: "Select project volume",
                    isBtn: true,
                    onBtnPressed: () {
                      print("am clicked...");
                    }),
                authInputField(
                    controller: phoneController,
                    maxLines: 4,
                    title: "Message",
                    hint: "Describe your business or proposal"),
                Container(
                  padding: EdgeInsets.all(14),
                  child: FlatButton(
                    onPressed: () {
                      pushAndResult(context, AuthSignUp());
                    },
                    color: blue.withOpacity(1),
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: textStyle(true, 16, white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get titleValue {
    if (currentPage == 0) return "Create your account.";
    if (currentPage == 1) return "Register your business.";
    return "Contact our Sales Team";
  }

  authInputField(
      {@required TextEditingController controller,
      String title,
      String hint,
      bool isPassword = false,
      bool showPassword = false,
      bool isBtn = false,
      int maxLines = 1,
      onPassChanged,
      onBtnPressed}) {
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
              maxLines: maxLines,
              onTap: isBtn ? onBtnPressed : null,
              placeholder: hint,
              readOnly: isBtn,
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
                  : isBtn
                      ? Container(
                          padding: EdgeInsets.all(3),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.arrow_drop_up,
                                color: black.withOpacity(.6),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: black.withOpacity(.6),
                              ),
                            ],
                          ),
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
