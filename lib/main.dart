import 'package:flutter/material.dart';
import 'package:ravepay/ravepay.dart';

import 'MainHomePg.dart';
import 'rave/RaveApi.dart';

var raveApi = RaveApi(
    liveMode: true,
    liveEncKey: "fd4172f2b7fc4ea54666c712",
    testEncKey: "fd4172f2b7fc4ea54666c712",
    liveSecKey: "FLWSECK-d8cb090bc6edeb52da7a5772cbbe8f29-X",
    testSecKey: "FLWSECK-fd4172f2b7fc2935adbf67e8e60d6dbc-X",
    livePubKey: "FLWPUBK-700ffcdaff4cb60ef07ecfc384be2aff-X",
    testPubKey: "FLWPUBK-9768585b355bc716fd3343688a0df49b-X");

void main() {
  Ravepay.init(
      production: true,
      publicKey: "FLWPUBK-700ffcdaff4cb60ef07ecfc384be2aff-X",
      secretKey: "FLWSECK-d8cb090bc6edeb52da7a5772cbbe8f29-X");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CredPal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: "Lato"),
      home: MainHomePg(),
    );
  }
}
