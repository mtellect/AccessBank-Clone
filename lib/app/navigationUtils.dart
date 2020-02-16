import 'package:flutter/material.dart';

goToWidget(BuildContext context, Widget myWidget, {result}) async {
  return await Navigator.of(context)
      .push(new MaterialPageRoute(builder: (context) {
    return myWidget;
  })).then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}

goToWidgetAndDisposeCurrent(BuildContext context, Widget myWidget,
    {result}) async {
  return await Navigator.of(context)
      .pushReplacement(new MaterialPageRoute(builder: (context) {
    return myWidget;
  })).then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}

goBackUntilFirstWidget(BuildContext context, {var result}) {
//  return Navigator.of(context).pushAndRemoveUntil(
//      new MaterialPageRoute(builder: (BuildContext context) => myWidget),
//      (Route<dynamic> route) => false);
}

popUpWidget(BuildContext context, Widget myWidget, {result}) async {
  return await Navigator.of(context)
      .push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return myWidget;
          }))
      .then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}

popUpWidgetAndDisposeCurrent(BuildContext context, Widget myWidget,
    {result}) async {
  return await Navigator.of(context)
      .pushReplacement(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return myWidget;
          }))
      .then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}

clearScreenUntil(BuildContext context, Widget myWidget, {result}) {
  Navigator.of(context)
      .pushAndRemoveUntil(
          new MaterialPageRoute(builder: (BuildContext context) => myWidget),
          (Route<dynamic> route) => false)
      .then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}

popUpWidgetScreenUntil(BuildContext context, Widget myWidget, {result}) async {
  Navigator.of(context)
      .pushAndRemoveUntil(
          new PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return myWidget;
              }),
          (Route<dynamic> route) => false)
      .then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });
}
