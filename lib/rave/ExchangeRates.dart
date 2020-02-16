part of 'RaveApi.dart';

class ExchangeRates {
  final String pubKey;
  final String secKey;
  final String encKey;
  final bool liveMode;
  final String requestUrl;

  ExchangeRates(
      {@required this.pubKey,
      @required this.secKey,
      @required this.encKey,
      @required this.liveMode,
      @required this.requestUrl});

  fetchRealTimeRates(
      {@required String fromCurrency,
      @required String toCurrency,
      @required int amount,
      @required Function(RaveRates) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/services/confluence';

    //print(secKey);
    Map chargePayload = {
      "secret_key": secKey,
      "service": "rates_convert",
      "service_method": "post",
      "service_version": "v1",
      "service_channel": "transactions",
      "service_channel_group": "merchants",
      "service_payload": {
        "FromCurrency": fromCurrency,
        "ToCurrency": toCurrency,
        "Amount": amount
      }
    };

    final encoded = json.encode(chargePayload);

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: encoded, headers: headers);
    //print(response.body);
    //print(response.statusCode);
    RaveRequest(response).validateRequest(onSuccessful: (msg, data) async {
      print("Rates ${response.body}");
      var model = BaseModel(items: data);
      var rates = RaveRates(model);

      return onComplete(rates);
    }, onError: (e) {
      onError("Rates-Err $e");
    });
  }
}

class RaveRates {
  final BaseModel model;
  RaveRates(this.model);
  int get toAmount => model.getInt("ToAmount");
  String get toCurrencyName => model.getString("ToCurrencyName");
  String get toCurrencyShortName => model.getString("ToCurrencyShortName");
  int get fromCurrencyId => model.getInt("FromCurrencyId");
  int get toCurrencyId => model.getInt("ToCurrencyId");
  int get fromAmount => model.getInt("FromAmount");
  double get fee => model.getDouble("Fee");
  double get rate => model.getDouble("Rate");
  double get baseFee => model.getDouble("BaseFee");
  int get markup => model.getInt("Markup");
  String get status => model.getString("Status");
  String get message => model.getString("Message");
  dynamic get data => model.getString("Data");
}
