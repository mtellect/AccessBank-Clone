part of 'RaveApi.dart';

class Charge {
  final String pubKey;
  final String secKey;
  final String encKey;
  final bool liveMode;
  final String requestUrl;

  Charge(
      {@required this.pubKey,
      @required this.secKey,
      @required this.encKey,
      @required this.liveMode,
      @required this.requestUrl});

  encryptPayLoad(key, Map<String, dynamic> payload) {
    final _encryption = Encryption(secretKey: secKey);
    RaveModel loadModel = RaveModel(items: payload);
    if (loadModel.getBoolean(INCLUDED_INTEGRITY_HASH)) {
      loadModel.remove(INCLUDED_INTEGRITY_HASH);
      final integrityHash = _encryption.integrityHash(payload);
//      var queryStringData = loadModel.items
//        ..putIfAbsent(INTEGRITY_HASH, () => integrityHash);
      final queryStringData = loadModel..put(INTEGRITY_HASH, integrityHash);
      loadModel.put(QueryStringData, queryStringData.items);
    }
    return _encryption.encrypt(loadModel.items);
  }

  initiateBankPayment(
      {@required
          BuildContext context,
      @required
          String bankCode,
      @required
          String accountNumber,
      @required
          String currency,
      @required
          String country,
      @required
          String amount,
      @required
          String email,
      @required
          String phoneNumber,
      @required
          String firstName,
      @required
          String lastName,
      @required
          String txReference,
      String suggestAuth = "PIN",
      String cardPin,
      bool pinRequested = false,
      @required
          Function(String) onComplete,
      @required
          Function(String) onError,
      @required
          Function(bool otp, String respMsg, String flwRef)
              validatorBuilder}) async {
    String url = '${requestUrl}flwv3-pug/getpaidx/api/charge';

    Map<String, dynamic> payload = {
      "PBFPubKey": pubKey,
      "accountbank": bankCode,
      "accountnumber": accountNumber,
      "currency": currency,
      "payment_type": "account",
      "country": country,
      "amount": amount,
      "email": email,
      //"bvn": "22178438481",
      "txRef": txReference,
      "currency": "NGN",
      "phonenumber": "08143733836",
      "firstname": firstName,
      "lastname": lastName,
    };

    final encrypted = encryptPayLoad(encKey, payload);

    final newData = {
      "PBFPubKey": pubKey,
      "client": encrypted,
      "alg": "3DES-24"
    };

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(newData), headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      print("charge ${response.body}");
      var chargeResponse = RaveModel(items: data);
      var suggestedAuth = chargeResponse.getString(SUGGESTED_AUTH);

      var chargeResponseCode = chargeResponse.getString(CHARGE_RESPONSE_CODE);
      var chargeResponseMsg = chargeResponse.getString(CHARGE_RESPONSE_MESSAGE);
      var flwRef = chargeResponse.getString(FLUTTER_WAVE_REF);

      if (suggestedAuth == SUGGESTED_AUTH_PIN) {
        return validatorBuilder(false, "", "");
      }

      if (suggestedAuth == SUGGESTED_AUTH_AVS_VBVSECURECODE) {
        //here should be loading into a url using the redirect url
        //return validatorBuilder(false, "", "");
      }

      if (suggestedAuth == SUGGESTED_AUTH_NOAUTH_INTERNATIONAL) {
        //return validatorBuilder(false, "", "");
      }

      if (chargeResponseCode == CHARGE_RESPONSE_OTP) {
        return validatorBuilder(true, chargeResponseMsg, flwRef);
      }

      return onComplete("Payment was successful");
    }, onError: (e) {
      onError("Init-Err $e");
    });
  }

  initiateCardPayment(
      {@required
          BuildContext context,
      @required
          String cardNumber,
      @required
          String cardCVV,
      @required
          String cardExpMonth,
      @required
          String cardExpYear,
      @required
          String currency,
      @required
          String country,
      @required
          String amount,
      @required
          String email,
      @required
          String phoneNumber,
      @required
          String firstName,
      @required
          String lastName,
      @required
          String txReference,
      String suggestAuth = "PIN",
      String cardPin,
      bool pinRequested = false,
      @required
          Function(String) onComplete,
      @required
          Function(String) onError,
      @required
          Function(bool otp, String respMsg, String flwRef)
              validatorBuilder}) async {
    String url = '${requestUrl}flwv3-pug/getpaidx/api/charge';

    Map chargeCardPayload = {
      "PBFPubKey": pubKey,
      "cardno": cardNumber,
      "cvv": cardCVV,
      "expirymonth": cardExpMonth,
      "expiryyear": cardExpYear,
      "currency": currency,
      "country": country,
      "amount": amount,
      "email": email,
      "phonenumber": phoneNumber,
      "firstname": firstName,
      "lastname": lastName,
      "txRef": txReference,
      if (pinRequested) "pin": cardPin,
      if (pinRequested) "suggested_auth": suggestAuth,
    };

    final encoded = json.encode(chargeCardPayload);
    final encrypted = encryptPayLoad(encKey, chargeCardPayload);
    final newData = {
      "PBFPubKey": pubKey,
      "client": encrypted,
      "alg": "3DES-24"
    };

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(newData), headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      print("charge ${response.body}");
      var chargeResponse = RaveModel(items: data);
      var suggestedAuth = chargeResponse.getString(SUGGESTED_AUTH);

      var chargeResponseCode = chargeResponse.getString(CHARGE_RESPONSE_CODE);
      var chargeResponseMsg = chargeResponse.getString(CHARGE_RESPONSE_MESSAGE);
      var flwRef = chargeResponse.getString(FLUTTER_WAVE_REF);

      if (suggestedAuth == SUGGESTED_AUTH_PIN) {
        return validatorBuilder(false, "", "");
      }

      if (suggestedAuth == SUGGESTED_AUTH_AVS_VBVSECURECODE) {
        //here should be loading into a url using the redirect url
        //return validatorBuilder(false, "", "");
      }

      if (suggestedAuth == SUGGESTED_AUTH_NOAUTH_INTERNATIONAL) {
        //return validatorBuilder(false, "", "");
      }

      if (chargeResponseCode == CHARGE_RESPONSE_OTP) {
        return validatorBuilder(true, chargeResponseMsg, flwRef);
      }

      return onComplete("Payment was successful");
    }, onError: (e) {
      onError("Init-Err $e");
    });
  }

  validatePayment(
      {@required String transactionRef,
      @required String otp,
      @required Function(String msg, String token) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}flwv3-pug/getpaidx/api/validatecharge';

    Map<String, String> body = {
      "PBFPubKey": pubKey,
      "transaction_reference": transactionRef,
      "otp": otp
    };

    final encoded = json.encode(body);
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: encoded, headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      var requestResponse = BaseModel(items: data);
      var raveValResp = RaveCardValidationResponse(requestResponse);
      print("\n\n validation ${requestResponse.items}");
      print("check...${requestResponse.getModel("data").items}");
      print("check code...${raveValResp.responseCode}");
      print("check txref ...${raveValResp.txRef}");
      if (raveValResp.responseCode == RESPONSE_CODE_APPROVED) {
        //validated charge of rave backend
        return verifyPayment(
            transactionRef: raveValResp.txRef,
            onComplete: onComplete,
            onError: onError);
      }
      return onError("Validation error ${raveValResp.responseMessage}");
    }, onError: (s) {
      return onError("Validation error $s");
    });
  }

  verifyPayment(
      {bool tokenVerification = false,
      @required String transactionRef,
      @required Function(String msg, String token) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}flwv3-pug/getpaidx/api/v2/verify';

    Map<String, String> body = {
      "SECKEY": secKey,
      "txref": transactionRef,
    };

    final encoded = json.encode(body);
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: encoded, headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      var chargeData = BaseModel(items: data);
      var verificationResp = RavePaymentVerification(chargeData);
      print("\n\nverification ${chargeData.items}");

      return onComplete("Payment received!",
          verificationResp.raveChargedCard.cardTokens[0].embedToken);
    }, onError: (s) {
      onError("Verification error $s");
    });
  }

  chargeToken(
      {@required String token,
      @required String currency,
      @required String transactionRef,
      @required String lastName,
      @required String firstName,
      @required String email,
      @required String country,
      @required int amount,
      @required Function(String msg, String token) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}flwv3-pug/getpaidx/api/tokenized/charge';

    Map body = {
      "SECKEY": secKey,
      "txref": transactionRef,
      "currency": currency,
      "SECKEY": secKey,
      "token": token,
      "country": country,
      "amount": amount,
      "email": email,
      "firstname": firstName,
      "lastname": lastName,
      //"IP": "190.233.222.1",
      "txRef": transactionRef
    };

    final encoded = json.encode(body);
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: encoded, headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      var chargeData = BaseModel(items: data);
      var tokenResp = RaveTokenChargeResponse(chargeData);
      print("\n\charging token ${chargeData.items}");

      //verify the charge was successful on rave before adding value

      verifyPayment(
          tokenVerification: true,
          transactionRef: tokenResp.txRef,
          onComplete: (msg, token) {
            onComplete("Payment received! $msg", token);
          },
          onError: (e) {
            return onError("Tok-Verify error $e");
          });
    }, onError: (s) {
      onError("Tok-Charge error $s");
    });
  }
}

//START...........................CARD..VALIDATION
class RaveCardValidationResponse {
  final BaseModel model;

  RaveCardValidationResponse(this.model);

  String get responseCode => model.getModel("data").getString("responsecode");
  String get responseMessage =>
      model.getModel("data").getString("responsemessage");

  int get id => model.getInt("id");

  String get txRef => model.getModel("tx").getString("txRef");
  String get orderRef => model.getModel("tx").getString("orderref");
  String get flwRef => model.getModel("tx").getString("flwRef");
  String get deviceFingerprint =>
      model.getModel("tx").getString("device_fingerprint");
  String get settlementToken =>
      model.getModel("tx").getString("settlement_token");
  String get cycle => model.getModel("tx").getString("cycle");
  int get amount => model.getModel("tx").getInt("amount");
  int get chargedAmount => model.getModel("tx").getInt("charged_amount");
  int get appFee => model.getModel("tx").getInt("appfee");
  int get merchantFee => model.getModel("tx").getInt("merchantfee");
  int get merchantBearsFee => model.getModel("tx").getInt("merchantbearsfee");
  String get chargeResponseCode =>
      model.getModel("tx").getString("chargeResponseCode");
  String get chargeResponseMessage =>
      model.getModel("tx").getString("chargeResponseMessage");
  String get authModelUsed => model.getModel("tx").getString("authModelUsed");
  String get currency => model.getModel("tx").getString("currency");
  String get ip => model.getModel("tx").getString("IP");
  String get narration => model.getModel("tx").getString("narration");
  String get status => model.getModel("tx").getString("status");
  String get vbvRespMessage => model.getModel("tx").getString("vbvrespmessage");
  String get authUrl => model.getModel("tx").getString("authurl");
  String get vbvRespCode => model.getModel("tx").getString("vbvrespcode");
  String get acctValRespMsg => model.getModel("tx").getString("acctvalrespmsg");
  String get acctValRespCode =>
      model.getModel("tx").getString("acctvalrespcode");

  String get paymentType => model.getModel("tx").getString("paymentType");
  String get paymentId => model.getModel("tx").getString("paymentId");
  String get fraudStatus => model.getModel("tx").getString("fraud_status");
  String get chargeType => model.getModel("tx").getString("charge_type");
  int get isLive => model.getModel("tx").getInt("is_live");
  String get createdAt => model.getModel("tx").getString("createdAt");
  String get updatedAt => model.getModel("tx").getString("updatedAt");
  String get deletedAt => model.getModel("tx").getString("deletedAt");

  int get customerId => model.getModel("tx").getInt("customerId");
  int get accountId => model.getModel("tx").getInt("AccountId");
  RaveCardCustomer get customer =>
      RaveCardCustomer(model.getModel("tx").getModel("customer"));
  RaveChargeTokens get chargeToken =>
      RaveChargeTokens(model.getModel("tx").getModel("chargeToken"));
}

class RaveCardCustomer {
  final BaseModel model;
  RaveCardCustomer(this.model);
  int get id => model.getInt("id");
  int get accountId => model.getInt("AccountId");
  String get phone => model.getString("phone");
  String get fullName => model.getString("fullName");
  String get customerToken => model.getString("customerToken");
  String get email => model.getString("email");
  String get createdAt => model.getString("createdAt");
  String get updatedAt => model.getString("updatedAt");
  String get deletedAt => model.getString("deletedAt");
  String get expiry => model.getString("expiry");
}

class RaveChargeTokens {
  final BaseModel model;
  RaveChargeTokens(this.model);
  String get userToken => model.getString("user_token");
  String get embedToken => model.getString("embed_token");
}

//END..............................CARD..VALIDATION

//START................................CARD VERIFICATION
class RavePaymentVerification {
  final BaseModel model;

  RavePaymentVerification(this.model);

  int get txId => model.getInt("txid");

  int get amount => model.getInt("amount");

  int get chargedAmount => model.getInt("chargedamount");

  int get appFee => model.getInt("appfee");

  int get merchantFee => model.getInt("merchantfee");

  int get merchantBearsFee => model.getInt("merchantbearsfee");

  String get txRef => model.getString("txref");

  String get flwRef => model.getString("flwref");

  String get deviceFingerprint => model.getString("devicefingerprint");

  String get cycle => model.getString("cycle");

  String get currency => model.getString("currency");

  String get chargeCode => model.getString("chargecode");

  String get chargeMessage => model.getString("chargemessage");

  String get authModel => model.getString("authmodel");

  String get ip => model.getString("ip");

  String get narration => model.getString("narration");

  String get status => model.getString("status");

  String get vbvCode => model.getString("vbvcode");

  String get vbvMessage => model.getString("vbvmessage");

  String get authUrl => model.getString("authurl");

  String get acctCode => model.getString("acctcode");

  String get acctMessage => model.getString("acctmessage");

  String get paymentType => model.getString("paymenttype");

  String get paymentId => model.getString("paymentid");

  String get fraudStatus => model.getString("fraudstatus");

  String get chargeType => model.getString("chargetype");

  int get createdDay => model.getInt("createdday");

  String get createdDayName => model.getString("createddayname");

  int get createdMonth => model.getInt("createdmonth");

  int get createdWeek => model.getInt("createdweek");

  String get createdMonthName => model.getString("createdmonthname");

  int get createdQuarter => model.getInt("createdquarter");

  int get createdYear => model.getInt("createdyear");

  bool get createdYearIsLeap => model.getBoolean("createdyearisleap");

  int get createdDayIsPublicHoliday =>
      model.getInt("createddayispublicholiday");

  int get createdHour => model.getInt("createdhour");

  int get createdMinute => model.getInt("createdminute");

  String get createdPmAm => model.getString("createdpmam");

  String get created => model.getString("created");

  int get customerId => model.getInt("customerid");

  String get custPhone => model.getString("custphone");

  String get custNetworkProvider => model.getString("custnetworkprovider");

  String get custName => model.getString("custname");

  String get custEmail => model.getString("custemail");

  String get custEmailProvider => model.getString("custemailprovider");

  String get custCreated => model.getString("custcreated");

  int get accountId => model.getInt("accountid");

  String get acctBusinessName => model.getString("acctbusinessname");

  String get acctContactPerson => model.getString("acctcontactperson");

  String get acctCountry => model.getString("acctcountry");

  String get acctBearsFeeAtTransactionTime =>
      model.getString("acctbearsfeeattransactiontime");

  int get acctParent => model.getInt("acctparent");

  String get acctVpcMerchant => model.getString("acctvpcmerchant");

  String get acctAlias => model.getString("acctalias");

  int get acctIsLiveApproved => model.getInt("acctisliveapproved");

  String get orderRef => model.getString("orderref");

  String get paymentPlan => model.getString("paymentplan");

  String get raveRef => model.getString("raveref");

  BaseModel get cardModel => model.getModel("card");

  RaveChargedCard get raveChargedCard => RaveChargedCard(cardModel);

  List get meta => model.getList("meta");
}

class RaveChargedCard {
  final BaseModel model;

  RaveChargedCard(this.model);

  String get cardExpiryMonth => model.getString("expirymonth");

  String get cardExpiryYear => model.getString("expiryyear");

  String get cardBIN => model.getString("cardBIN");

  String get cardLast4Digits => model.getString("last4digits");

  String get cardBrand => model.getString("brand");

  String get cardType => model.getString("type");

  String get cardLifeTimeToken => model.getString("life_time_token");

  List<RaveCardTokens> get cardTokens => model
      .getList("card_tokens")
      .map((tok) => RaveCardTokens(BaseModel(items: tok)))
      .toList();
}

class RaveCardTokens {
  final BaseModel model;
  RaveCardTokens(this.model);
  String get embedToken => model.getString("embedtoken");
  String get shortCode => model.getString("shortcode");
  String get expiry => model.getString("expiry");
}

//END...............................CARD .VERIFICATION

//START ..........................TOKEN CHARGE
class RaveTokenChargeResponse {
  final BaseModel model;
  RaveTokenChargeResponse(this.model);
  int get id => model.getInt("id");
  String get txRef => model.getString("txRef");
  String get orderRef => model.getString("orderRef");
  String get flwRef => model.getString("flwRef");
  String get redirectUrl => model.getString("redirectUrl");
  String get device_fingerprint => model.getString("device_fingerprint");
  String get settlement_token => model.getString("settlement_token");
  String get cycle => model.getString("cycle");
  int get amount => model.getInt("amount");
  int get charged_amount => model.getInt("charged_amount");
  int get appfee => model.getInt("appfee");
  int get merchantfee => model.getInt("merchantfee");
  int get merchantbearsfee => model.getInt("merchantbearsfee");
  String get chargeResponseCode => model.getString("chargeResponseCode");
  String get raveRef => model.getString("raveRef");
  String get chargeResponseMessage => model.getString("chargeResponseMessage");
  String get authModelUsed => model.getString("authModelUsed");
  String get currency => model.getString("currency");
  String get IP => model.getString("IP");
  String get narration => model.getString("narration");
  String get status => model.getString("status");
  String get vbvrespmessage => model.getString("vbvrespmessage");
  String get authurl => model.getString("authurl");
  String get vbvrespcode => model.getString("vbvrespcode");
  String get acctvalrespmsg => model.getString("acctvalrespmsg");
  String get acctvalrespcode => model.getString("acctvalrespcode");
  String get paymentType => model.getString("paymentType");
  String get paymentPlan => model.getString("paymentPlan");
  String get paymentPage => model.getString("paymentPage");
  String get paymentId => model.getString("paymentId");
  String get fraud_status => model.getString("fraud_status");
  String get charge_type => model.getString("charge_type");
  int get is_live => model.getInt("is_live");
  String get createdAt => model.getString("createdAt");
  String get updatedAt => model.getString("updatedAt");
  String get deletedAt => model.getString("deletedAt");
  int get customerId => model.getInt("customerId");
  int get accountId => model.getInt("AccountId");

  RaveCardCustomer get customer => RaveCardCustomer(model.getModel("customer"));
  RaveChargeTokens get chargeToken =>
      RaveChargeTokens(model.getModel("chargeToken"));
}
