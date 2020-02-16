import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:credpal/dialogs/baseDialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/CropConfig.dart';
import 'package:image_pickers/UIConfig.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'Countries.dart';
import 'assets.dart';
import 'basemodel.dart';

BaseModel countriesAndFlags() {
  List<String> counties = countries.map((c) => c["Name"]).toList();
  List<String> flags = countries.map((c) => "flags/${c["ISO"]}.png").toList();

  return BaseModel()..put(COUNTRY, counties)..put(COUNTRY_FLAG, flags);
}

List<String> months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sept",
  "oct",
  "Nov",
  "Dec"
];

inputLayout(title, hint,
    {TextEditingController controller,
    onTextChanged,
    String value,
    String btnValue,
    String btnHint,
    bool amPassword = false,
    bool passVisible = false,
    bool btnAlone = false,
    bool btnWith = false,
    bool showTitle = true,
    bool useValue = true,
    bool usePrice = false,
    bool canClick = true,
    imgAsset,
    bool withIcon = false,
    bool isAsset = false,
    bool negotiable = false,
    Color filledColor = black,
    Color textColor = black,
    Color titleColor = textColor,
    double fillOpacity = .03,
    double raduis = 15.0,
    onPassChanged,
    TextInputType keyboard = TextInputType.text,
    int maxLine = 1,
    onBtnClicked}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (showTitle)
        Text(
          title,
          style: textStyle(true, 14, titleColor),
        ),
      if (showTitle) addSpace(10),
      if (btnAlone)
        Container(
          //width: 100,
          decoration: BoxDecoration(
              color: light_grey, borderRadius: BorderRadius.circular(raduis)),
          child: FlatButton(
              onPressed: canClick ? onBtnClicked : null,
              padding: EdgeInsets.all(15),
              child: Center(
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (withIcon && isAsset)
                      Image.asset(
                        imgAsset,
                        height: 18,
                        width: 18,
                        color: black.withOpacity(.4),
                      )
                    else if (withIcon && !isAsset)
                      Icon(
                        imgAsset,
                        color: black.withOpacity(.4),
                      )
                    else
                      Icon(
                        Icons.arrow_drop_down,
                        color: black.withOpacity(.4),
                      ),
                    addSpaceWidth(10),
                    Flexible(
                      child: Text(
                        btnValue ?? hint,
                        style: textStyle(false, 14,
                            black.withOpacity(null != btnValue ? 1 : .6)),
                      ),
                    ),
                  ],
                ),
              )),
        )
      else
        Row(
          children: <Widget>[
            if (btnWith) ...[
              Container(
                //width: 100,
                color: light_grey,
                child: FlatButton(
                    onPressed: canClick ? onBtnClicked : null,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Row(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.arrow_drop_down),
                          addSpaceWidth(2),
                          Text(
                            btnValue ?? btnHint,
                            style: textStyle(false, 14,
                                black.withOpacity(null != value ? 1 : .6)),
                          ),
                        ],
                      ),
                    )),
              ),
              addSpaceWidth(10),
            ],
            if (usePrice) ...[
              Container(
                height: 25,
                width: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: white,
                    shape: BoxShape.circle,
                    border: Border.all(color: black, width: 2)),
                child: Text(
                  "₦",
                  style: textStyle(true, 14, black),
                ),
              ),
              addSpaceWidth(10),
            ],
            Flexible(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboard,
                onChanged: onTextChanged,
                maxLines: maxLine,
                obscureText: passVisible,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: black.withOpacity(.1), width: .7)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: black.withOpacity(.1), width: .7)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            color: black.withOpacity(.1), width: .7)),
                    hintText: hint,
                    hintStyle: TextStyle(color: textColor.withOpacity(.5)),
                    fillColor: filledColor.withOpacity(fillOpacity),
                    filled: true,
                    suffixIcon: amPassword
                        ? IconButton(
                            icon: Icon(
                              passVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: filledColor.withOpacity(.5),
                            ),
                            onPressed: onPassChanged)
                        : null),
              ),
            ),
            if (usePrice) ...[
              addSpaceWidth(10),
              GestureDetector(
                onTap: onBtnClicked,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: negotiable ? orang0 : transparent,
                      border: Border.all(
                          color: negotiable ? orang0 : black.withOpacity(.1)),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      addSpaceWidth(10),
                      Container(
                        height: 24,
                        width: 24,
                        padding: EdgeInsets.all(1),
                        child: Center(
                          child: Container(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: Icon(
                                Icons.check_circle,
                                size: 18,
                                color: negotiable ? orang0 : light_grey,
                              ),
                            ),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: black.withOpacity(.1)),
                                color: white,
                                shape: BoxShape.circle),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: negotiable
                                    ? transparent
                                    : black.withOpacity(.4)),
                            color: transparent,
                            shape: BoxShape.circle),
                      ),
                      addSpaceWidth(5),
                      Text(
                        "Negotiatable",
                        style: textStyle(true, 14,
                            negotiable ? white : black.withOpacity(.6)),
                      ),
                      addSpaceWidth(10)
                    ],
                  ),
                ),
              ),
            ],
          ],
        )
    ],
  );
}

SizedBox addSpace(double size) {
  return SizedBox(
    height: size,
  );
}

addSpaceWidth(double size) {
  return SizedBox(
    width: size,
  );
}

adaptiveScreenHeight(int size) {
  return ScreenUtil().setHeight(size);
}

adaptiveScreenWidth(int size) {
  return ScreenUtil().setWidth(size);
}

int getSeconds(String time) {
  List parts = time.split(":");
  int mins = int.parse(parts[0]) * 60;
  int secs = int.parse(parts[1]);
  return mins + secs;
}

String getTimerText(int seconds, {bool three = false}) {
  int hour = seconds ~/ Duration.secondsPerHour;
  int min = (seconds ~/ 60) % 60;
  int sec = seconds % 60;

  String h = hour.toString();
  String m = min.toString();
  String s = sec.toString();

  String hs = h.length == 1 ? "0$h" : h;
  String ms = m.length == 1 ? "0$m" : m;
  String ss = s.length == 1 ? "0$s" : s;

  return three ? "$hs:$ms:$ss" : "$ms:$ss";
}

Container addLine(
    double size, color, double left, double top, double right, double bottom) {
  return Container(
    height: size,
    width: double.infinity,
    color: color,
    margin: EdgeInsets.fromLTRB(left, top, right, bottom),
  );
}

Container bigButton(double height, double width, String text, textColor,
    buttonColor, onPressed) {
  return Container(
    height: height,
    width: width,
    child: RaisedButton(
      onPressed: onPressed,
      color: buttonColor,
      textColor: white,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20,
            fontFamily: "NirmalaB",
            fontWeight: FontWeight.normal,
            color: textColor),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );
}

textStyle(bool bold, double size, color,
    {underlined = false, String font = "Lato", bool padd = true}) {
  return TextStyle(
      color: color,
      fontWeight: bold ? FontWeight.w900 : FontWeight.normal,
      fontFamily: font,
      //fontFamily: bold ? POPPINS_BOLD : POPPINS_REGULAR,
      fontSize: size,
      decorationColor: APP_COLOR,
      decorationThickness: 3,
      decorationStyle: TextDecorationStyle.solid,
      decoration: underlined ? TextDecoration.underline : TextDecoration.none);
}

ThemeData darkTheme() {
  final ThemeData base = ThemeData();
  return base.copyWith(hintColor: white);
}

placeHolder(double height,
    {double width = 200, Color color = blue0, double opacity = .1}) {
  return new Container(
    height: height,
    width: width,
    color: color.withOpacity(opacity),
    child: Center(
        child: Opacity(
            opacity: .3,
            child: Image.asset(
              ic_launcher,
              width: 20,
              height: 20,
            ))),
  );
}

toast(scaffoldKey, text, {Color color}) {
  return scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Text(
        text,
        style: textStyle(false, 15, white),
      ),
    ),
    backgroundColor: color,
    duration: Duration(seconds: 2),
  ));
}

gradientCheckBox(Widget child, double padding,
    {bool active = false, double boxSize = 20}) {
  return Container(
    height: boxSize,
    width: boxSize,
    decoration: active
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0XFFe46514),
                Color(0XFFf79836),
              ],
            ),
            shape: BoxShape.circle,
          )
        : BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
    padding: EdgeInsets.all(padding ?? 20),
    alignment: Alignment.center,
    child: child,
  );
}

Widget transition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

loadingLayout({Color color = white, Color load = light_grey}) {
  return new Container(
    color: color,
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: Opacity(
            opacity: .3,
            child: Image.asset(
              ic_launcher,
              width: 20,
              height: 20,
            ),
          ),
        ),
        Center(
          child: CircularProgressIndicator(
            //value: 20,
            valueColor: AlwaysStoppedAnimation<Color>(load),
            strokeWidth: 2,
          ),
        ),
      ],
    ),
  );
}

errorDialog(retry, cancel, {String text}) {
  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Container(
        color: black.withOpacity(.8),
      ),
      Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: red0,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Text(
                        "!",
                        style: textStyle(true, 30, white),
                      ))),
                  addSpace(10),
                  Text(
                    "Error",
                    style: textStyle(false, 14, red0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              text == null ? "An unexpected error occurred, try again" : text,
              style: textStyle(false, 14, white.withOpacity(.5)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
      Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: new Container(),
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FlatButton(
                      onPressed: retry,
                      child: Text(
                        "RETRY",
                        style: textStyle(true, 15, white),
                      )),
                ),
                addSpace(15),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FlatButton(
                      onPressed: cancel,
                      child: Text(
                        "CANCEL",
                        style: textStyle(true, 15, white),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    ],
  );
}

addExpanded() {
  return Expanded(
    child: new Container(),
    flex: 1,
  );
}

addFlexible() {
  return Flexible(
    child: new Container(),
    flex: 1,
  );
}

emptyLayout(icon, String title, String text,
    {click, clickText, bool isIcon = false, Color color = APP_COLOR}) {
  return Container(
    color: white,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isIcon)
              Icon(
                icon,
                size: 100,
                color: APP_COLOR,
              )
            else
              Image.asset(
                icon,
                height: 100,
                width: 100,
              ),
//            new Container(
//              width: 50,
//              height: 50,
//              child: Stack(
//                children: <Widget>[
//                  new Container(
//                    height: 50,
//                    width: 50,
//                    decoration:
//                        BoxDecoration(color: red0, shape: BoxShape.circle),
//                  ),
//                  new Center(
//                      child: isIcon
//                          ? Icon(
//                              icon,
//                              size: 30,
//                              color: white,
//                            )
//                          : Image.asset(
//                              icon,
//                              height: 30,
//                              width: 30,
//                              color: white,
//                            )),
//                  new Container(
//                    child: Column(
//                      mainAxisSize: MainAxisSize.max,
//                      crossAxisAlignment: CrossAxisAlignment.end,
//                      children: <Widget>[
//                        addExpanded(),
//                        Container(
//                          width: 20,
//                          height: 20,
//                          decoration: BoxDecoration(
//                              color: red3,
//                              shape: BoxShape.circle,
//                              border: Border.all(color: white, width: 1)),
//                          child: Center(
//                            child: Text(
//                              "!",
//                              style: textStyle(true, 14, white),
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            ),
            addSpace(10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: black.withOpacity(.03),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              child: Text(
                title,
                style: textStyle(true, 17, black.withOpacity(.7)),
                textAlign: TextAlign.center,
              ),
            ),
            addSpace(5),
            Text(
              text,
              style: textStyle(false, 14, black.withOpacity(.5)),
              textAlign: TextAlign.center,
            ),
            addSpace(10),
            click == null
                ? new Container()
                : FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: color,
                    onPressed: click,
                    child: Text(
                      clickText,
                      style: textStyle(true, 14, white),
                    ))
          ],
        ),
      ),
    ),
  );
}

List<String> getFromList(String key, List<BaseModel> models,
    {String sortKey, bool sortWithNumber = true}) {
  List<String> list = new List();
  //List<BaseModel> models = new List();

  if (sortKey != null) {
    models.sort((b1, b2) {
      if (sortWithNumber) {
        int a = b1.getInt(sortKey);
        int b = b2.getInt(sortKey);
        return a.compareTo(b);
      }
      String a = b1.getString(sortKey);
      String b = b2.getString(sortKey);
      return a.compareTo(b);
    });
  }

  for (BaseModel bm in models) {
    list.add(bm.getString(key));
  }

  return list;
}

pushAndResult(context, item, {result}) {
  Navigator.push(
      context,
      PageRouteBuilder(
          transitionsBuilder: transition,
          opaque: false,
          pageBuilder: (context, _, __) {
            return item;
          })).then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}

String getRandomId() {
  var uuid = new Uuid();
  return uuid.v1();
}

double screenW(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenH(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

loadLocalUser(String userId,
    {Source source = Source.cache, bool server = false, noInternet}) async {
  //  var result = await (Connectivity().checkConnectivity());
//  if (result == ConnectivityResult.none) {
//    return;
//  }

  //try {
  if (userId.isNotEmpty) {
    Firestore.instance
        .collection(USER_BASE)
        .document(userId)
        .get(source: source)
        .then((doc) {
      if (doc.exists) {
        userModel = BaseModel(doc: doc);
        isAdmin = userModel.isMaugost() || userModel.getBoolean(IS_ADMIN);
      } else {
        isLoggedIn = false;
        FirebaseAuth.instance.signOut();
      }
    }).catchError((e) {
      if (e.toString().toLowerCase().contains("client is offline")) {
        noInternet(e.details);
        return;
      }

      if (e.toString().toLowerCase().contains("document from cache")) {
        loadLocalUser(userId,
            source: Source.serverAndCache,
            server: true,
            noInternet: noInternet);
        return;
      }
    });
  }

  Firestore.instance
      .collection(APP_SETTINGS_BASE)
      .document(APP_SETTINGS)
      .get(source: source)
      .then((doc) {
    if (doc.exists) {
      appSettingsModel = BaseModel(doc: doc);
    }
  }).catchError((e) {
    if (e.toString().toLowerCase().contains("client is offline")) {
      noInternet(e.details);
      return;
    }

    if (e.toString().toLowerCase().contains("document from cache")) {
      loadLocalUser(userId,
          source: Source.serverAndCache, server: true, noInternet: noInternet);
      return;
    }
  });
}

createBasicListeners({bool suspend = false, setUpMethods, redirectBack}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var data = jsonDecode(pref.getString(USER_BASE) ?? "{}");
  BaseModel bm = BaseModel(items: data);
  String authToken = bm.getString(AUTH_TOKEN);
  //User prefUser = User(bm);

  if (suspend) {
    isLoggedIn = false;
    userModel = new BaseModel();
    pref.clear();
    setUpMethods();
    return;
  }

  if (authToken.isEmpty) {
    isLoggedIn = false;
    userModel = new BaseModel();
    pref.clear();
    redirectBack();
    return;
  }
}

String getCountryCode(context) {
  return Localizations.localeOf(context).countryCode;
}

uploadFile(File file, onComplete) {
  final String ref = getRandomId();
  StorageReference storageReference = FirebaseStorage.instance.ref().child(ref);
  StorageUploadTask uploadTask = storageReference.putFile(file);
  uploadTask.onComplete
      /*.timeout(Duration(seconds: 3600), onTimeout: () {
    onComplete(null, "Error, Timeout");
  })*/
      .then((task) {
    if (task != null) {
      task.ref.getDownloadURL().then((_) {
        BaseModel model = new BaseModel();
        model.put(FILE_URL, _.toString());
        model.put(REFERENCE, ref);
        model.saveItem(REFERENCE_BASE, false);
        onComplete(_.toString(), null);
      }, onError: (error) {
        onComplete(null, error);
      });
    }
  }, onError: (error) {
    onComplete(null, error);
  });
}

uploadFiles(List filePaths, {onComplete, onError}) async {
  List fileUrls = List();

  bool connected = await isConnected();

  if (!connected) {
    onError("No internet access. Please check your internet connection");
    return;
  }

  for (int i = 0; i < filePaths.length; i++) {
    BaseModel bm = BaseModel(items: filePaths[i]);
    int type = bm.getType();
    bool isNetwork = bm.getBoolean(IS_NETWORK_IMAGE);
    String err = "";
    print("uploading T $type N $isNetwork....");

    if (isNetwork) {
      fileUrls.add(bm.items);
      if (fileUrls.length == filePaths.length) {
        onComplete(fileUrls);
      }
      continue;
    }

    if (err.isNotEmpty) {
      onError("Error occurred while uploading videos.\n $err");
      break;
    }

    if (type == ASSET_TYPE_VIDEO) {
      File video = File(bm.getString(VIDEO_PATH));
      File thumbnail = File(bm.getString(THUMBNAIL_PATH));
      File gif = File(bm.getString(GIF_PATH));
      print("uploading vidi....");

      uploadFile(video, (url, error) {
        if (error != null) {
          err = error;
          onError("Error occurred while uploading videos.\n $error");
          return;
        }

        print("uploaded $url");
        bm.put(VIDEO_URL, url);
        bm.put(VIDEO_PATH, "");
        bm.put(ASSET_FILE, "");
//        fileUrls.add(bm.items);
//        if (fileUrls.length == filePaths.length) {
//          onComplete(fileUrls);
//        }

        uploadFile(thumbnail, (url, error) {
          if (error != null) {
            err = error;
            onError(
                "Error occurred while uploading videos thumbnail.\n $error");
            return;
          }
          bm.put(THUMBNAIL_URL, url);
          bm.put(THUMBNAIL_PATH, "");
          bm.put(ASSET_FILE, "");
          fileUrls.add(bm.items);
          if (fileUrls.length == filePaths.length) {
            onComplete(fileUrls);
          }
        });
      });
    } else {
      File image = File(bm.getString(IMAGES_PATH));
      print("uploading img....");

      uploadFile(image, (url, error) {
        if (error != null) {
          err = error;
          onError("Error occurred while uploading images.\n $error");
          return;
        }
        bm.put(IMAGE_URL, url);
        bm.put(IMAGES_PATH, "");
        bm.put(ASSET_FILE, "");
        fileUrls.add(bm.items);
        if (fileUrls.length == filePaths.length) {
          onComplete(fileUrls);
        }
      });
    }
  }
}

Future<bool> isConnected() async {
  var result = await (Connectivity().checkConnectivity());
  if (result == ConnectivityResult.none) {
    return Future<bool>.value(false);
  }
  return Future<bool>.value(true);
}

void showProgress(bool show, String progressId, BuildContext context,
    {String msg, bool cancellable = false, double countDown}) {
  if (!show) {
    currentProgress = progressId;
    return;
  }

  currentProgress = "";

  pushAndResult(
      context,
      progressDialog(
        progressId,
        message: msg,
        cancelable: cancellable,
      ));
}

void showMessage(context, icon, iconColor, title, message,
    {int delayInMilli = 0,
    clickYesText = "OK",
    onClicked,
    clickNoText,
    bool cancellable = false,
    double iconPadding,
    bool isIcon = true}) {
  Future.delayed(Duration(milliseconds: delayInMilli), () {
    pushAndResult(
        context,
        messageDialog(
          icon,
          iconColor,
          title,
          message,
          clickYesText,
          noText: clickNoText,
          cancellable: cancellable,
          isIcon: isIcon,
          iconPadding: iconPadding,
        ),
        result: onClicked);
  });
}

void showListDialog(
  context,
  items, {
  images,
  title,
  onClicked,
  useIcon = true,
  usePosition = true,
  useTint = false,
  int delayInMilli = 0,
}) {
  Future.delayed(Duration(milliseconds: delayInMilli), () {
    pushAndResult(
        context,
        listDialog(
          items,
          title: title,
          images: images,
          isIcon: useIcon,
          usePosition: usePosition,
          useTint: useTint,
        ),
        result: onClicked);
  });
}

bool isEmailValid(String email) {
  if (!email.contains("@") || !email.contains(".")) return false;
  return true;
}

gradientLine({double height = 4, bool reverse = false, alpha = .3}) {
  return Container(
    width: double.infinity,
    height: height,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: reverse
                ? [
                    black.withOpacity(alpha),
                    transparent,
                  ]
                : [transparent, black.withOpacity(alpha)])),
  );
}

openLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

void yesNoDialog(context, title, message, clickedYes,
    {bool cancellable = true, bool isIcon = true, Color color = red0}) {
  Navigator.push(
      context,
      PageRouteBuilder(
          transitionsBuilder: transition,
          opaque: false,
          pageBuilder: (context, _, __) {
            return messageDialog(
              Icons.warning,
              color,
              title,
              message,
              "Yes",
              noText: "No, Cancel",
              cancellable: cancellable,
              isIcon: isIcon,
            );
          })).then((_) {
    if (_ != null) {
      if (_ == true) {
        clickedYes();
      }
    }
  });
}

adjustNumberSize(String price) {
  if (price.contains("000000")) {
    price = price.replaceAll("000000", "");
    price = "${price}M";
  } else if (price.length > 6) {
    double pr = (int.parse(price)) / 1000000;
    return "${pr.toStringAsFixed(1)}M";
  } else if (price.contains("000")) {
    price = price.replaceAll("000", "");
    price = "${price}K";
  } else if (price.length > 3) {
    double pr = (int.parse(price)) / 1000;
    return "${pr.toStringAsFixed(1)}K";
  }

  return price;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> getLocalFile(String name) async {
  final path = await _localPath;
  return File('$path/$name');
}

Future<File> getDirFile(String name) async {
  final dir = await getExternalStorageDirectory();
  var testDir = await Directory("${dir.path}/Maugost").create(recursive: true);
  return File("${testDir.path}/$name");
}

String formatDuration(Duration position) {
  final ms = position.inMilliseconds;

  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

  final minutesString =
      minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

  final secondsString =
      seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

  final formattedTime =
      '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

  return formattedTime;
}

int getPositionForLetter(String text) {
  return az.indexOf(text.toUpperCase());
}

String az = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
String getLetterForPosition(int position) {
  return az.substring(position, position + 1);
}

String convertListToString(String divider, List list) {
  StringBuffer sb = new StringBuffer();
  for (int i = 0; i < list.length; i++) {
    String s = list[i];
    sb.write(s);
    sb.write(" ");
    if (i != list.length - 1) sb.write(divider);
    sb.write(" ");
  }

  return sb.toString().trim();
}

List<String> convertStringToList(String divider, String text) {
  List<String> list = new List();
  var parts = text.split(divider);
  for (String s in parts) {
    list.add(s.trim());
  }
  return list;
}

placeCall(String phone) {
  openLink("tel://$phone");
}

sendEmail(String email, {String subject = ""}) {
  openLink("mailto:$email?subject=$subject");
}

List<String> getSearchString(String text) {
  text = text.toLowerCase().trim();
  if (text.isEmpty) return List();

  List<String> list = List();
  list.add(text);
  var parts = text.split(" ");
  for (String s in parts) {
    if (s.isNotEmpty) list.add(s);
    for (int i = 0; i < s.length; i++) {
      String sub = s.substring(0, i);
      if (sub.isNotEmpty) list.add(sub);
    }
  }
  for (int i = 0; i < text.length; i++) {
    String sub = text.substring(0, i);
    if (sub.isNotEmpty) list.add(sub.trim());
  }
  return list;
}

rateApp() {
  String packageName = appSettingsModel.getString(PACKAGE_NAME);
  if (packageName.isEmpty) return;

  userModel.put(HAS_RATED, true);
  userModel.updateItems();
  String link = "http://play.google.com/store/apps/details?id=$packageName";
  openLink(link);
}

String getTimeAgo(int milli) {
  return timeAgo.format(DateTime.fromMillisecondsSinceEpoch(milli));
}

tabIndicator(int tabCount, int currentPosition, {margin}) {
  return Container(
    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
    margin: margin,
    decoration: BoxDecoration(
        color: black.withOpacity(.7), borderRadius: BorderRadius.circular(25)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: getTabs(tabCount, currentPosition),
    ),
  );
}

getTabs(int count, int cp) {
  List<Widget> items = List();
  for (int i = 0; i < count; i++) {
    bool selected = i == cp;
    items.add(Container(
      width: selected ? 10 : 8,
      height: selected ? 10 : 8,
      //margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          color: white.withOpacity(selected ? 1 : (.5)),
          shape: BoxShape.circle),
    ));
    if (i != count - 1) items.add(addSpaceWidth(5));
  }

  return items;
}

stackImagesHolder(List<BaseModel> members,
    {leftPadding = 5,
    double holderSize = 30,
    double boxSize = 40,
    int max = 3}) {
  return Container(
    height: boxSize,
    width: boxSize,
    child: Stack(
      children:
          List.generate(members.length > max ? 3 : members.length, (int i) {
        BaseModel model = members[i];
        double padding =
            i == 1 ? 0 : (leftPadding + i * leftPadding).roundToDouble();
        if (model.myItem()) return Container();
        return Padding(
          //padding: EdgeInsets.only(left: padding),
          padding: EdgeInsets.only(left: leftPadding + (i * 4.0)),
          child: imageHolder(
            holderSize,
            model.getImage(),
            strokeColor: orang1,
            stroke: i == 1 ? 0 : .5,
          ),
        );
      }),
    ),
  );
}

imageHolder(
  double size,
  imageUrl, {
  double stroke = 0,
  strokeColor = primaryActiveColor,
  localColor = white,
  margin,
  bool local = false,
  bool hideIcon = false,
  iconHolder = Icons.person,
  stackHolder = Icons.star,
  double iconHolderSize = 14,
  double localPadding = 0,
  bool round = true,
  bool borderCurve = false,
  bool showDot = false,
  bool showStack = false,
  double curve = 20,
  dotColor = green,
  onImageTap,
}) {
  return GestureDetector(
    onTap: onImageTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(borderCurve ? curve : 0),
      child: AnimatedContainer(
        curve: Curves.ease,
        margin: margin,
        alignment: Alignment.center,
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(stroke),
        decoration: BoxDecoration(
          color: strokeColor,
          //borderRadius: BorderRadius.circular(borderCurve ? 15 : 0),
          //border: Border.all(width: 2, color: white),
          shape: round ? BoxShape.circle : BoxShape.rectangle,
        ),
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            new Card(
              margin: EdgeInsets.all(0),
              shape: round
                  ? CircleBorder()
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
              clipBehavior: Clip.antiAlias,
              color: transparent,
              elevation: .5,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: size,
                    height: size,
                    child: hideIcon
                        ? null
                        : Center(
                            child: Icon(
                            iconHolder,
                            color: white,
                            size: iconHolderSize,
                          )),
                  ),
                  imageUrl is File
                      ? (Image.file(
                          imageUrl,
                          width: size,
                          height: size,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
                        ))
                      : local
                          ? Padding(
                              padding: EdgeInsets.all(localPadding),
                              child: Image.asset(
                                imageUrl,
                                width: size,
                                height: size,
                                color: localColor,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CachedNetworkImage(
                              width: size,
                              height: size,
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                ],
              ),
            ),
            if (showStack)
              Container(
                width: 22,
                height: 22,
                padding: EdgeInsets.all(3),
                child: Icon(
                  stackHolder,
                  color: white,
                  size: 12,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: white, width: 2),
                  color: primaryActiveColor,
                ),
              ),
            if (showDot)
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: white, width: 2),
                  color: dotColor,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

avatarItem(String title, String image, onChanged) {
  return Column(
    children: <Widget>[
      GestureDetector(
        onTap: onChanged,
        child: image.isEmpty
            ? Container(
                height: 90,
                width: 90,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.withOpacity(.4)),
                    shape: BoxShape.circle),
              )
            : Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    image: DecorationImage(image: FileImage(File(image))),
                    border: Border.all(color: Colors.grey.withOpacity(.4)),
                    shape: BoxShape.circle),
              ),
      ),
      addSpace(10),
      Text(
        title,
        style: textStyle(true, 12, black.withOpacity(.4)),
      ),
    ],
  );
}

expandedContainer(child, {show = false}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 5),
    child: show ? child : null,
    curve: Curves.easeOut,
    //padding: EdgeInsets.all(show ? 5 : 0),
//      decoration: BoxDecoration(
//          border: Border.all(width: 0.5, color: Colors.black.withOpacity(.1)),
//          color: Colors.grey.withOpacity(.05)
//      ),
  );
}

bool isDomainEmailValid(String email) {
  if (email.contains("aol") ||
      email.contains("gmail") ||
      email.contains("yahoo") ||
      email.contains("hotmail")) return false;
  return true;
}

getDayOfWeekInt(int d) {
  if (d == DateTime.monday) return Day.Monday;
  if (d == DateTime.tuesday) return Day.Tuesday;
  if (d == DateTime.wednesday) return Day.Wednesday;
  if (d == DateTime.thursday) return Day.Thursday;
  if (d == DateTime.friday) return Day.Friday;
  if (d == DateTime.saturday) return Day.Saturday;
  return Day.Saturday;
}

getDayOfWeek(String d) {
  if (d == "Mon") return Day.Monday;
  if (d == "Tue") return Day.Tuesday;
  if (d == "Wed") return Day.Wednesday;
  if (d == "Thur") return Day.Thursday;
  if (d == "Fri") return Day.Friday;
  if (d == "Sat") return Day.Saturday;
  return Day.Saturday;
}

Future getImagePicker(ImageSource imageSource) async {
  var image = await ImagePicker.pickImage(source: imageSource);

  return image;
}

Future getVideoPicker(ImageSource imageSource) async {
  var image = await ImagePicker.pickVideo(source: imageSource);
  return image;
}

Future<String> getSingleCroppedImage() async {
  var media = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
      selectCount: 1,
      showCamera: true,
      compressSize: 300,
      uiConfig: UIConfig(uiThemeColor: primaryActiveColor),
      cropConfig: CropConfig(enableCrop: true, width: 10, height: 10));
  return media[0].path;
}

scrollUpDownView(scrollFeedTotalTop, scrollFeedTotalDown) {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            onPressed: scrollFeedTotalTop,
            padding: EdgeInsets.all(12),
            color: Colors.deepOrangeAccent,
            child: Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
            shape: CircleBorder(),
          ),
          addSpace(10),
          RaisedButton(
            onPressed: scrollFeedTotalDown,
            padding: EdgeInsets.all(12),
            color: Colors.deepOrangeAccent,
            child: Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
            shape: CircleBorder(),
          )
        ],
      ),
    ),
  );
}

scrollTotallyUp(ScrollController scrollController) {
  if (scrollController != null && !scrollController.position.outOfRange) {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: new Duration(milliseconds: 500), curve: Curves.linear);
  }
}

scrollTotallyDown(ScrollController scrollController) {
  if (scrollController != null && !scrollController.position.outOfRange) {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: new Duration(milliseconds: 500), curve: Curves.linear);
  }
}

openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}

String getExtImage(String fileExtension) {
  if (fileExtension == null) return "";
  fileExtension = fileExtension.toLowerCase().trim();
  if (fileExtension.contains("doc")) {
    return icon_file_doc;
  } else if (fileExtension.contains("pdf")) {
    return icon_file_pdf;
  } else if (fileExtension.contains("xls")) {
    return icon_file_xls;
  } else if (fileExtension.contains("ppt")) {
    return icon_file_ppt;
  } else if (fileExtension.contains("txt")) {
    return icon_file_text;
  } else if (fileExtension.contains("zip")) {
    return icon_file_zip;
  } else if (fileExtension.contains("xml")) {
    return icon_file_xml;
  } else if (fileExtension.contains("png") ||
      fileExtension.contains("jpg") ||
      fileExtension.contains("jpeg")) {
    return icon_file_photo;
  } else if (fileExtension.contains("mp4") ||
      fileExtension.contains("3gp") ||
      fileExtension.contains("mpeg") ||
      fileExtension.contains("avi")) {
    return icon_file_video;
  } else if (fileExtension.contains("mp3") ||
      fileExtension.contains("m4a") ||
      fileExtension.contains("m4p")) {
    return icon_file_audio;
  }

  return icon_file_unknown;
}

bool isSameDay(int time1, int time2) {
  DateTime date1 = DateTime.fromMillisecondsSinceEpoch(time1);

  DateTime date2 = DateTime.fromMillisecondsSinceEpoch(time2);

  return (date1.day == date2.day) &&
      (date1.month == date2.month) &&
      (date1.year == date2.year);
}

clickChat(context, BaseModel theUser, {bool isGroup = false}) {
  String chatID = chatExists(theUser, isGroup);
  if (chatID != null) {
//    pushAndResult(
//      context,
//      ChatMain(
//        chatID,
//        isGroup: isGroup,
//      ),
//    );
  } else {
    createChat(context, theUser, isGroup);
  }
}

BaseModel createChatModel(String chatId, BaseModel model, bool isGroup) {
  BaseModel myModel = new BaseModel();
  myModel.put(OBJECT_ID, chatId);
  myModel.put(CHAT_ID, chatId);
  myModel.put(USER_ID, model.getObjectId());
  if (isGroup) {
    myModel.put(GROUP_NAME, model.getString(GROUP_NAME));
    myModel.put(IMAGES, model.getList(IMAGES));
  } else {
    myModel.put(FULL_NAME, model.getString(FULL_NAME));
    myModel.put(USER_IMAGE, model.getString(USER_IMAGE));
  }
  return myModel;
}

String getLastSeen(BaseModel user) {
  int time = user.getInt(TIME_UPDATED);
  int now = DateTime.now().millisecondsSinceEpoch;
  int diff = now - time;
//  if (diff > (Duration.millisecondsPerDay * 77)) return null;
  return diff > (Duration.millisecondsPerDay * 30)
      ? "Last seen: some weeks ago"
      : "Last seen: ${timeAgo.format(DateTime.fromMillisecondsSinceEpoch(time), locale: "en")}";
}

String chatExists(BaseModel theUser, bool isGroup) {
  int existing = 0;
  String theId;
  String theUserId = theUser.getObjectId();
  List<Map> myChats = List.from(userModel.getList(MY_CHATS));
  List<Map> hisChat = List.from(theUser.getList(MY_CHATS));

  for (Map chat in myChats) {
    BaseModel bm = new BaseModel(items: chat);
    String chatId = bm.getString(CHAT_ID);
    if (chatId.contains(theUserId)) {
      existing++;
      theId = chatId;
      break;
    }
  }
  if (isGroup) {
    return existing != 1 ? null : theId;
  }

  for (Map chat in hisChat) {
    BaseModel bm = new BaseModel(items: chat);
    String chatId = bm.getString(CHAT_ID);
    if (chatId.contains(userModel.getUserId())) {
      existing++;
      theId = chatId;
      break;
    }
  }
  return existing != 2 ? null : theId;
}

createChat(context, BaseModel theUser, bool isGroup) {
//  String chatId = isGroup
//      ? theUser.getObjectId()
//      : "${theUser.getUserId()}${userModel.getUserId()}";

  String chatId = "";
  if (isGroup) {
    chatId = theUser.getObjectId();
  } else {
    List<String> ids = [theUser.getUserId(), userModel.getUserId()];
    ids.sort((s1, s2) => s1.compareTo(s2));

    chatId = "${ids[0]}${ids[1]}";
  }

  BaseModel myModel = createChatModel(chatId, theUser, isGroup);
  List<Map> myChats = List.from(userModel.getList(MY_CHATS));
  myChats.add(myModel.items);
  userModel.put(MY_CHATS, myChats);
  userModel.updateItems();

  if (!isGroup) {
    BaseModel hisModel = createChatModel(chatId, userModel, isGroup);
    List<Map> hisChat = List.from(theUser.getList(MY_CHATS));
    hisChat.add(hisModel.items);
    theUser.put(MY_CHATS, hisChat);
    theUser.updateItems(
        /*MY_CHATS, hisModel.items, true,*/
        updateTime: false);
  }

//  pushAndResult(
//    context,
//    ChatMain(chatId, isGroup: isGroup),
//  );
}

formatInThousands(String price) {
  if (price.contains("000000")) {
    price = price.replaceAll("000000", "");
    price = "${price}M";
  } else if (price.length > 6) {
    double pr = (int.parse(price)) / 1000000;
    return "${pr.toStringAsFixed(1)}M";
  } else if (price.contains("000")) {
    price = price.replaceAll("000", "");
    price = "${price}K";
  } else if (price.length > 3) {
    double pr = (int.parse(price)) / 1000;
    return "${pr.toStringAsFixed(1)}K";
  }

  return price;
}

tipBox(color, text, textColor) {
  return Container(
    //width: double.infinity,
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            Icons.info,
            size: 14,
            color: white,
          ),
          addSpaceWidth(10),
          Flexible(
            flex: 1,
            child: Text(
              text,
              style: textStyle(false, 15, textColor),
            ),
          )
        ],
      ),
    ),
  );
}

tipMessageItem(String title, String message, {Color color = red03}) {
  return Container(
    //width: 300,
    //height: 300,
    child: new Card(
        color: color,
        elevation: .5,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.info,
                    size: 14,
                    color: white,
                  ),
                  addSpaceWidth(5),
                  Text(
                    title,
                    style: textStyle(true, 12, white.withOpacity(.5)),
                  ),
                ],
              ),
              addSpace(5),
              Text(
                message,
                style: textStyle(false, 16, white),
                //overflow: TextOverflow.ellipsis,
              ),
              /*Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(3)),
                child: Text(
                  "APPLY",
                  style: textStyle(true, 9, black),
                ),
              ),*/
            ],
          ),
        )),
  );
}
