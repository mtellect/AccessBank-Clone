part of 'RaveApi.dart';

enum BillerType { AIRTIME, DSTV, DSTV_BOX_OFFICE, DATA }

class BillPayments {
  final String pubKey;
  final String secKey;
  final String encKey;
  final bool liveMode;
  final String requestUrl;

  BillPayments(  {@required this.pubKey,
    @required this.secKey,
    @required this.encKey,
    @required this.liveMode,
    @required this.requestUrl});

  buyBillService(
      {@required String customerId,
      @required int amount,
      @required int recurringType,
      @required String reference,
      @required String countryShort,
      @required BillerType billerType,
      @required Function(RaveAirtime response) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/confluence';

    Map body = {
      "secret_key": secKey,
      "service": "fly_buy",
      "service_method": "post",
      "service_version": "v1",
      "service_channel": "rave",
      "service_payload": {
        "Country": countryShort,
        "CustomerId": customerId,
        "Reference": reference,
        "Amount": amount,
        "RecurringType": recurringType,
        "IsAirtime": billerType == BillerType.AIRTIME,
        "BillerName": billerType == BillerType.AIRTIME
            ? "AIRTIME"
            : billerType == BillerType.DSTV
                ? "DSTV"
                : billerType == BillerType.DSTV_BOX_OFFICE
                    ? "DSTV_BOX_OFFICE"
                    : "DATA"
      }
    };

    final encoded = json.encode(body);
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: encoded, headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      var requestResponse = BaseModel(items: data);
      //var raveValResp = RaveCardValidationResponse(requestResponse);
      print("\n\n bills resp ${requestResponse.items}");
      return onComplete(RaveAirtime(requestResponse));
    }, onError: (s) {
      return onError("Billing error $s");
    });
  }

  getBillingCategories(
      {@required Function(String msg, String token) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/confluence';

    Map body = {
      "secret_key": secKey,
      "service": "bills_categories",
      "service_method": "get",
      "service_version": "v1",
      "service_channel": "rave"
    };

    final encoded = json.encode(body);
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: encoded, headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      var requestResponse = BaseModel(items: data);
      //var raveValResp = RaveCardValidationResponse(requestResponse);
      print("\n\n fetch bills ${requestResponse.items}");

      for (var m in requestResponse.getList("Data")) {
        var name = m["Name"];
        var isAirtime = m["IsAirtime"];
        var isData = m["IsData"];
        print("N $name A $isAirtime D $isData");
      }
      return onComplete("good", "ok");
    }, onError: (s) {
      return onError("Validation error $s");
    });
  }

  getRemitaCategories(
      {@required Function(RaveRemitaBillers) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/confluence';

    Map body = {
      "secret_key": secKey,
      "service": "fly_remita_get-billers",
      "service_method": "get",
      "service_version": "v1",
      "service_channel": "rave",
    };

    final encoded = json.encode(body);
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: encoded, headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      var requestResponse = BaseModel(items: data);
      //var raveValResp = RaveCardValidationResponse(requestResponse);
      print("\n\n remita fetch bills ${requestResponse.items}");

      return onComplete(RaveRemitaBillers(requestResponse));
    }, onError: (s) {
      return onError("Validation error $s");
    });
  }

  getRemitaBillerProducts(
      {@required String billerId,
      @required Function(RaveRemitaBillers) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/confluence';

    Map body = {
      "secret_key": secKey,
      "service": "fly_remita_billers_${billerId}_products",
      "service_method": "get",
      "service_version": "v1",
      "service_channel": "rave",
    };

    final encoded = json.encode(body);
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: encoded, headers: headers);

    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      var requestResponse = BaseModel(items: data);
      //var raveValResp = RaveCardValidationResponse(requestResponse);
      print("\n\n remita fetch billers... ${requestResponse.items}");

      return onComplete(RaveRemitaBillers(requestResponse));
    }, onError: (s) {
      return onError("Validation error $s");
    });
  }
}

class RaveAirtime {
  final BaseModel model;
  RaveAirtime(this.model);
  String get mobileNumber => model.getString("MobileNumber");
  int get amount => model.getInt("Amount");
  String get network => model.getString("Network");
  String get transactionReference => model.getString("TransactionReference");
  String get paymentReference => model.getString("PaymentReference");
  String get batchReference => model.getString("BatchReference");
  String get extraData => model.getString("ExtraData");
  String get status => model.getString("Status");
  String get message => model.getString("Message");
  String get reference => model.getString("Reference");
}

class RaveBillCategories {
  final BaseModel model;
  RaveBillCategories(this.model);
  int get id => model.getInt("Id");
  String get BillerCode => model.getString("BillerCode");
  String get DefaultCommission => model.getString("DefaultCommission");
  String get DateAdded => model.getString("DateAdded");
  String get Country => model.getString("Country");
  String get IsAirtime => model.getString("IsAirtime");
  String get BillerName => model.getString("BillerName");
  String get ItemCode => model.getString("ItemCode");
  String get ShortName => model.getString("ShortName");
  String get Fee => model.getString("Fee");
  String get CommissionOnFee => model.getString("CommissionOnFee");
  String get reference => model.getString("Reference");

  // CommissionOnFee: false, RegExpression: ^[+]{1}[0-9]+$, LabelName: Mobile Number, Amount: 0, IsResolvable: true, GroupName: null, CategoryName: null, IsData: null};
}

class RaveRemitaBillers {
  final BaseModel model;
  RaveRemitaBillers(this.model);
  String get responseCode => model.getModel("data").getString("responsecode");
  String get serviceCode => model.getModel("data").getString("servicecode");
  String get responseMessage =>
      model.getModel("data").getString("responsemessage");
  String get description => model.getString("description");
  String get status => model.getString("status");
  List<RemitaBillers> get billers => model
      .getModel("data")
      .getList("billers")
      .map((b) => RemitaBillers(BaseModel(items: b)))
      .toList();
}

class RemitaBillers {
  final BaseModel model;

  RemitaBillers(this.model);

  String get code => model.getString("code");

  String get name => model.getString("name");
}
