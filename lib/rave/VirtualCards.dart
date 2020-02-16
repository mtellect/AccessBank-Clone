part of 'RaveApi.dart';

class VirtualCards {
  final String pubKey;
  final String secKey;
  final String encKey;
  final bool liveMode;
  final String requestUrl;

  VirtualCards(
      {@required this.pubKey,
      @required this.secKey,
      @required this.encKey,
      @required this.liveMode,
      @required this.requestUrl});

  /// [currency] This is the currency the card would be denominated in, possible values are NGN and USD
  /// [amount] This is the amount to prefund the card with on card creation.
  /// [billingName] This is the Name on the card.
  /// [billingAddress] This is the registered address for the card. e.g. Your house address where you would receive your card statements.
  /// [billingCity] This is the City / District / Suburb / Town / Village. registered for the card.
  /// [billingState] This is the State / County / Province / Region.
  /// [billingPostalCode] ZIP or postal code.
  /// [billingCountry] Billing address country code, if provided. (e.g. "NG", "US").
  /// [callbackUrl] This is a callback endpoint you provide where we send actions that happen on a card such as a card being charged, a card being terminated etc.

  createVirtualCard(
      {@required String currency,
      @required String amount,
      @required String billingName,
      @required String billingAddress,
      @required String billingCity,
      @required String billingState,
      @required String billingPostalCode,
      @required String billingCountry,
      String callbackUrl,
      @required Function(RaveVirtualCard) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/virtualcards/new';

    Map<String, String> body = {
      SECRET_KEY: secKey,
      CURRENCY: currency,
      AMOUNT: amount,
      BILLING_NAME: billingName,
      BILLING_ADDRESS: billingAddress,
      BILLING_CITY: billingCity,
      BILLING_STATE: billingState,
      BILLING_POSTAL_CODE: billingPostalCode,
      BILLING_COUNTRY: billingCountry,
      CALL_BACK_URL: ""
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveVirtualCard(BaseModel(items: data)));
        },
        onError: onError);
  }

  listVirtualCards(
      {String startFrom = "1",
      @required Function(List<RaveVirtualCard>) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/virtualcards/search';

    Map<String, String> body = {PAGE: startFrom, SECRET_KEY: secKey};

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);
    //print(response.body);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          List<RaveVirtualCard> cards = List.from(data).map((items) {
            print(items);
            return RaveVirtualCard(BaseModel(items: items));
          }).toList();
          return onComplete(cards);
        },
        onError: onError);

//    RaveRequest(response).validateRequest(
//        onSuccessful: (raveModel) {
//          return onComplete(raveModel
//              .getList(DATA)
//              .map((r) => RaveVirtualCard(RaveModel(items: r)))
//              .toList());
//        },
//        onError: onError);
  }

  getVirtualCard(
      {@required String cardId,
      @required Function(List<RaveVirtualCard>) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/virtualcards/search';

    Map<String, String> body = {
      SECRET_KEY: secKey,
      RAVE_ID: cardId,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          print("Card requested $data");
          return onComplete(List.from(data)
              .map((card) => RaveVirtualCard(BaseModel(items: card)))
              .toList());
        },
        onError: onError);
  }

  terminateVirtualCard(
      {@required String cardId,
      @required Function(RaveVirtualCard) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/virtualcards/$cardId/terminate';

    Map<String, String> body = {
      SECRET_KEY: secKey,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

//    RaveRequest(response).validateRequest(
//        onSuccessful: (raveModel) {
//          return onComplete(RaveVirtualCard(raveModel));
//        },
//        onError: onError);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveVirtualCard(BaseModel(items: data)));
        },
        onError: onError);
  }

  fundVirtualCard(
      {@required String cardId,
      @required String amount,
      @required String debitCurrency,
      @required Function(String) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/virtualcards/fund';

    Map<String, String> body = {
      RAVE_ID: cardId,
      AMOUNT: amount,
      DEBIT_CURRENCY: debitCurrency,
      SECRET_KEY: secKey,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(msg);
        },
        onError: onError);
  }

  fetchCardTransactions() async {
    //TODO fetchCardTransactions
  }

  withdrawFromCard(
      {@required String cardId,
      @required String amount,
      @required Function(String) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/virtualcards/withdraw';

    Map<String, String> body = {
      RAVE_ID: cardId,
      AMOUNT: amount,
      SECRET_KEY: secKey,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

//    RaveRequest(response).validateRequest(
//        onSuccessful: (raveModel) {
//          String message = RaveRequest(response).message;
//          return onComplete(message);
//        },
//        onError: onError);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(msg);
        },
        onError: onError);
  }

  freezeVirtualCard(
      {@required String cardId,
      @required bool blockCard,
      @required Function(String) onComplete,
      @required Function(String) onError}) async {
    String url =
        '${requestUrl}v2/services/virtualcards/$cardId/status/${blockCard ? "block" : "unblock"}';

    Map<String, String> body = {
      SECRET_KEY: secKey,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

//    RaveRequest(response).validateRequest(
//        onSuccessful: (raveModel) {
//          String message = RaveRequest(response).message;
//          return onComplete(message);
//        },
//        onError: onError);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(msg);
        },
        onError: onError);
  }
}

class RaveVirtualCard {
  final BaseModel model;

  RaveVirtualCard(this.model);

  String get virtualId => model.getString(RAVE_ID);
  int get accountId => model.getInt(ACCOUNT_ID);
  String get amount => model.getString(AMOUNT);
  String get currency => model.getString(CURRENCY);
  String get cardHash => model.getString(CARD_HASH);
  String get cardPan => model.getString(CARD_PAN);
  String get maskedPan => model.getString(MASKED_PAN);
  String get city => model.getString(CITY);
  String get state => model.getString(STATE);
  String get address1 => model.getString(ADDRESS_1);
  String get address2 => model.getString(ADDRESS_2);
  String get zipCode => model.getString(ZIP_CODE);
  String get cvv => model.getString(CARD_CVV);
  String get expiration => model.getString(CARD_EXP);
  String get sendTo => model.getString(SEND_TO);
  String get binCheckName => model.getString(BIN_CHECK_NAME);
  String get cardType => model.getString(CARD_TYPE);
  String get nameOnCard => model.getString(NAME_ON_CARD);
  String get dateCreated => model.getString(DATE_CREATED);
  bool get isActive => model.getBoolean(IS_ACTIVE);
}
