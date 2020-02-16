part of 'RaveApi.dart';

class Miscellaneous {
  final String pubKey;
  final String secKey;
  final String encKey;
  final bool liveMode;
  final String requestUrl;

  Miscellaneous(
      {@required this.pubKey,
      @required this.secKey,
      @required this.encKey,
      @required this.liveMode,
      @required this.requestUrl});

  List<RaveCountries> getSupportedCountries() {
    return [
      RaveCountries(RaveModel()
        ..put(RAVE_COUNTRY, "Nigeria")
        ..put(RAVE_COUNTRY_CODE, "NG")
        ..put(RAVE_COUNTRY_CURRENCY, "NGN")),
      RaveCountries(RaveModel()
        ..put(RAVE_COUNTRY, "Ghana")
        ..put(RAVE_COUNTRY_CODE, "GH")
        ..put(RAVE_COUNTRY_CURRENCY, "GHS")),
      RaveCountries(RaveModel()
        ..put(RAVE_COUNTRY, "Kenya")
        ..put(RAVE_COUNTRY_CODE, "KE")
        ..put(RAVE_COUNTRY_CURRENCY, "KES")),
      RaveCountries(RaveModel()
        ..put(RAVE_COUNTRY, "Uganda")
        ..put(RAVE_COUNTRY_CODE, "UG")
        ..put(RAVE_COUNTRY_CURRENCY, "UGX")),
      RaveCountries(RaveModel()
        ..put(RAVE_COUNTRY, "Zambia")
        ..put(RAVE_COUNTRY_CODE, "ZA")
        ..put(RAVE_COUNTRY_CURRENCY, "ZMW")),
      RaveCountries(RaveModel()
        ..put(RAVE_COUNTRY, "Tanzania")
        ..put(RAVE_COUNTRY_CODE, "TZ")
        ..put(RAVE_COUNTRY_CURRENCY, "TZS"))
    ];
  }

  Future<List<RaveBanks>> getSupportedBanks(String countryCode) async {
    String url = '${requestUrl}v2/banks/$countryCode?public_key=$pubKey';
    var response =
        await get(url, headers: {"content-type": "application/json"});
    var decodedResponse = jsonDecode(response.body);
    List banks = decodedResponse["data"][BANKS];
    return banks.map((b) {
      return RaveBanks(BaseModel(items: b));
    }).toList();
  }

  Future<RaveCardBinCheck> raveCardBinCheck(String cardBin) async {
    String url =
        '${requestUrl}i/v1/extras/bin_check?card_bin=$cardBin&public_key=$pubKey';
    var response =
        await get(url, headers: {"content-type": "application/json"});

    var decodedResponse = jsonDecode(response.body);
    Map data = decodedResponse["data"];
    return RaveCardBinCheck(RaveModel(items: data));
  }

  Future<RaveFees> raveChargeFee({
    @required String amount,
    @required String currency,
    String pType = "2",
    String cardFirstSix,
  }) async {
    String url = '${requestUrl}flwv3-pug/getpaidx/api/fee';

    Map<String, String> body = {
      AMOUNT: amount,
      PUBLIC_KEY: pubKey,
      CURRENCY: currency,
      CARD_FIRST_SIX: cardFirstSix,
      PARAMETER_TYPE: pType,
    };

    var response = await post(url,
        body: jsonEncode(body), headers: {"content-type": "application/json"});

    var decodedResponse = jsonDecode(response.body);
    Map data = decodedResponse["data"];
    return RaveFees(RaveModel(items: data));
  }

  Future<RaveTransactions> raveTransactions({
    String from,
    String to,
    String page,
    String customerEmail,
    String status,
    String customerFullName,
    String transactionReference,
    String currency,
  }) async {
    String url = '${requestUrl}v2/gpx/transactions/query';

    Map<String, String> body = {
      SEC_KEY: secKey,
      TRANSACTION_FROM: from,
      TRANSACTION_TO: to,
      TRANSACTION_PAGE: page,
      CUSTOMER_EMAIL: customerEmail,
      TRANSACTION_STATUS: status,
      CUSTOMER_FULL_NAME: customerFullName,
      TRANSACTION_REFERENCE: transactionReference,
      CURRENCY: currency,
    };

    var response = await post(url,
        body: jsonEncode(body), headers: {"content-type": "application/json"});

    var decodedResponse = jsonDecode(response.body);
    Map data = decodedResponse["data"];
    print(response.body);
    return RaveTransactions(RaveModel(items: data));
  }
}

class RaveBanks {
  final BaseModel model;

  RaveBanks(this.model);

  String get bankId => model.getString("Id");
  String get bankCode => model.getString("Code");
  String get bankName => model.getString("Name");
  String get bankMobVerified => model.getString("IsMobileVerified");
  String get bankBranches => model.getString("branches");
}

class RaveCountries {
  final RaveModel raveModel;

  RaveCountries(this.raveModel);

  String get country => raveModel.getString(RAVE_COUNTRY);
  String get countryCode => raveModel.getString(RAVE_COUNTRY_CODE);
  String get countryCurrency => raveModel.getString(RAVE_COUNTRY_CURRENCY);
}

class RaveCardBinCheck {
  final RaveModel raveModel;

  RaveCardBinCheck(this.raveModel);

  String get issuingCountry => raveModel.getString(CARD_ISSUING_COUNTRY);
  String get cardBin => raveModel.getString(CARD_BIN);
  String get cardType => raveModel.getString(CARD_TYPE);
  String get cardIssuerInfo => raveModel.getString(CARD_ISSUER_INFO);
}

class RaveFees {
  final RaveModel raveModel;

  RaveFees(this.raveModel);

  String get chargeAmount => raveModel.getString(CHARGE_AMOUNT);
  String get chargeFee => raveModel.getString(CHARGE_FEE);
  String get merchantFee => raveModel.getString(MERCHANT_FEE);
  String get raveFee => raveModel.getString(RAVE_FEE);
}

class RaveTransactions {
  final RaveModel raveModel;
  final int pageNo;

  RaveTransactions(this.raveModel, {this.pageNo = 0});

  RavePageInfo get pageInfo =>
      RavePageInfo(RaveModel(items: raveModel.getMap(PAGE_INFO)));

  RaveTransaction get transaction => RaveTransaction(
      RaveModel(items: raveModel.getList(TRANSACTIONS)[pageNo]));

  List<RaveTransaction> get transactions => raveModel
      .getList(TRANSACTIONS)
      .map((items) => RaveTransaction(RaveModel(items: items)))
      .toList();
}

class RavePageInfo {
  final RaveModel raveModel;

  RavePageInfo(this.raveModel);

  String get total => raveModel.getString(TOTAL);
  String get currentPage => raveModel.getString(CURRENT_PAGE);
  String get totalPages => raveModel.getString(TOTAL_PAGES);
}

class RaveTransaction {
  final RaveModel raveModel;

  RaveTransaction(this.raveModel);

  String get transactionId => raveModel.getString(RAVE_ID);
  String get transactionReference => raveModel.getString(TRANSACTION_REFERENCE);
  String get processorReference => raveModel.getString(PROCESSOR_REFERENCE);
  String get deviceFingerPrint => raveModel.getString(DEVICE_FINGER_PRINT);
  String get transactionCycle => raveModel.getString(TRANSACTION_CYCLE);
  String get transactionAmount => raveModel.getString(AMOUNT);
  String get currency => raveModel.getString(CURRENCY);
  String get amountCharged => raveModel.getString(AMOUNT_CHARGED);
  String get raveFee => raveModel.getString(RAVE_FEE);
  String get merchantFee => raveModel.getString(MERCHANT_FEE);
  String get merchantBoreFee => raveModel.getString(MERCHANT_BORE_FEE);
  String get processorResponseCode =>
      raveModel.getString(PROCESSOR_RESPONSE_CODE);
  String get processorResponseMessage =>
      raveModel.getString(PROCESSOR_RESPONSE_MESSAGE);
  String get authModel => raveModel.getString(AUTH_MODEL);
  String get customerIp => raveModel.getString(CUSTOMER_IP);
  String get narration => raveModel.getString(NARRATION);
  String get status => raveModel.getString(STATUS);
  String get processorVerificationUrl =>
      raveModel.getString(PROCESSOR_VERIFICATION_URL);
  String get processorVbvResponseCode =>
      raveModel.getString(PROCESSOR_VBV_RESPONSE_CODE);
  String get processorVbvResponseMessage =>
      raveModel.getString(PROCESSOR_VBV_RESPONSE_MESSAGE);
  String get processorAcctResponseCode =>
      raveModel.getString(PROCESSOR_ACCT_RESPONSE_CODE);
  String get processorAcctResponseMessage =>
      raveModel.getString(PROCESSOR_ACCT_RESPONSE_MESSAGE);

  String get paymentEntity => raveModel.getString(PAYMENT_ENTITY);
  String get paymentEntityId => raveModel.getString(PAYMENT_ENTITY_ID);
  String get fraudStatus => raveModel.getString(FRAUD_STATUS);
  String get dateCreated => raveModel.getString(DATE_CREATED);
  String get uniqueReference => raveModel.getString(UNIQUE_REFERENCE);
  String get amountDueMerchant => raveModel.getString(AMOUNT_DUE_MERCHANT);

  RaveCard get chargeAmount =>
      RaveCard(RaveModel(items: raveModel.getMap(CARD)));
  RaveMerchant get merchant =>
      RaveMerchant(RaveModel(items: raveModel.getMap(MERCHANT)));
  RaveCustomer get customer =>
      RaveCustomer(RaveModel(items: raveModel.getMap(CUSTOMER)));
}

class RaveCard {
  final RaveModel raveModel;

  RaveCard(this.raveModel);

  String get cardId => raveModel.getString(RAVE_ID);
  String get cardMaskedPan => raveModel.getString(CARD_MASKED_PAN);
  String get cardExpYear => raveModel.getString(CARD_EXP_YEAR);
  String get cardExpMonth => raveModel.getString(CARD_EXP_MONTH);
  String get cardBin => raveModel.getString(CARD_BIN);
  String get cardType => raveModel.getString(RAVE_CARD_TYPE);
  String get cardCountry => raveModel.getString("country");
  String get cardIssuerInfo => raveModel.getString(CONTACT_PERSON);
  String get dateCreated => raveModel.getString(DATE_CREATED);
}

class RaveMerchant {
  final RaveModel raveModel;

  RaveMerchant(this.raveModel);

  String get merchantId => raveModel.getString(RAVE_ID);
  String get businessName => raveModel.getString(BUSINESS_NAME);
  String get contactPerson => raveModel.getString(CONTACT_PERSON);
  String get merchantCountry => raveModel.getString("country");
}

class RaveCustomer {
  final RaveModel raveModel;

  RaveCustomer(this.raveModel);

  String get customerId => raveModel.getString(RAVE_ID);
  String get customerEmail => raveModel.getString(CUSTOMER_EMAIL);
  String get customerPhone => raveModel.getString(CUSTOMER_PHONE_NUMBER);
  String get dateCreated => raveModel.getString(DATE_CREATED);
}
