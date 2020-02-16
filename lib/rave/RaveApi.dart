library rave_api;

import 'dart:convert';
import 'dart:math';

import 'package:credpal/app/baseApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tripledes/tripledes.dart';
import 'Encryption.dart';

export 'RaveApi.dart';

part 'BillPayments.dart';
part 'Charge.dart';
part 'CreditCardForm.dart';
part 'CreditCardModel.dart';
part 'CreditCardWiget.dart';
part 'EBills.dart';
part 'ExchangeRates.dart';
part 'Miscellaneous.dart';
part 'PaymentPlan.dart';
part 'RaveModel.dart';
part 'RaveRequest.dart';
part 'RaveUtils.dart';
part 'Settlements.dart';
part 'SubAccounts.dart';
part 'TransferRecipients.dart';
part 'Transfers.dart';
part 'Verification.dart';
part 'VirtualCards.dart';

class RaveApi {
  final String livePubKey;
  final String liveSecKey;

  final String testPubKey;
  final String testSecKey;

  final String liveEncKey;
  final String testEncKey;
  final bool liveMode;

  Miscellaneous __miscellaneous;
  Verification __verification;
  VirtualCards __virtualCards;
  Transfers __transfers;
  Charge __charge;
  ExchangeRates __exchangeRates;
  BillPayments __billPayments;

  RaveApi({
    @required this.liveMode,
    @required this.liveEncKey,
    @required this.testEncKey,
    @required this.liveSecKey,
    @required this.testSecKey,
    @required this.livePubKey,
    @required this.testPubKey,
  }) {
    __miscellaneous = Miscellaneous(
        pubKey: publicKey,
        secKey: secretKey,
        encKey: encryptionKey,
        liveMode: liveMode,
        requestUrl: requestUrl);

    __verification = Verification(
        pubKey: publicKey,
        secKey: secretKey,
        encKey: encryptionKey,
        liveMode: liveMode,
        requestUrl: requestUrl);

    __virtualCards = VirtualCards(
        pubKey: publicKey,
        secKey: secretKey,
        encKey: encryptionKey,
        liveMode: liveMode,
        requestUrl: requestUrl);

    __transfers = Transfers(
        pubKey: publicKey,
        secKey: secretKey,
        encKey: encryptionKey,
        liveMode: liveMode,
        requestUrl: requestUrl);

    __charge = Charge(
        pubKey: publicKey,
        secKey: secretKey,
        encKey: encryptionKey,
        liveMode: liveMode,
        requestUrl: requestUrl);

    __exchangeRates = ExchangeRates(
        pubKey: publicKey,
        secKey: secretKey,
        encKey: encryptionKey,
        liveMode: liveMode,
        requestUrl: requestUrl);

    __billPayments = BillPayments(
        pubKey: publicKey,
        secKey: secretKey,
        encKey: encryptionKey,
        liveMode: liveMode,
        requestUrl: requestUrl);
  }

  String get requestUrl => apiMode ? LIVE_BASE_URL : TEST_BASE_URL;
  String get publicKey => apiMode ? this.livePubKey : this.testPubKey;
  String get secretKey => apiMode ? this.liveSecKey : this.testSecKey;
  String get encryptionKey => apiMode ? this.liveEncKey : this.testEncKey;
  bool get apiMode => this.liveMode;

  Verification get verification => __verification;
  Miscellaneous get miscellaneous => __miscellaneous;
  VirtualCards get virtualCards => __virtualCards;
  Transfers get transfers => __transfers;
  Charge get charge => __charge;
  ExchangeRates get exchangeRates => __exchangeRates;
  BillPayments get billPayments => __billPayments;
}
