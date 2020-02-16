part of 'RaveApi.dart';

class Transfers {
  final String pubKey;
  final String secKey;
  final String encKey;
  final bool liveMode;
  final String requestUrl;

  Transfers(
      {@required this.pubKey,
      @required this.secKey,
      @required this.encKey,
      @required this.liveMode,
      @required this.requestUrl});

  /// [currency] This is only available for the following currencies NGN, KES,
  /// UGX, TZS, ZAR, GHS & XOF

  transferToAfrica(
      {@required String bankName,
      @required String accountNumber,
      @required String recipient,
      @required String amount,
      @required String narration,
      @required String currency,
      @required String reference,
      @required String beneficiaryName,
      @required String destinationBranchCode,
      @required String debitCurrency,
      String callbackUrl,
      @required Function(RaveTransfer) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/gpx/transfers/create';

    Map<String, String> body = {
      "account_bank": destinationBranchCode,
      "account_number": accountNumber,
      "amount": amount,
      "seckey": secKey,
      "narration": narration,
      "currency": currency,
      "reference": reference,
      //"beneficiary_name": beneficiaryName
    };

    bool netCheck = await isConnected();

    if (!netCheck) return onError("Failed to connect to internet");

    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveTransfer(RaveModel(items: data)));
        },
        onError: onError);
  }

  transferToAbroad(
      {@required String bankName,
      @required String accountNumber,
      @required String recipient,
      @required String amount,
      @required String narration,
      @required String currency,
      @required String reference,
      @required String beneficiaryName,
      @required String destinationBranchCode,
      @required String debitCurrency,
      @required String routingNumber,
      @required String swiftCode,
      @required String beneficiaryAddress,
      @required String beneficiaryCountry,
      String callbackUrl,
      @required Function(RaveTransfer) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/gpx/transfers/create';

    Map meta = {
      "amount": amount,
      "seckey": secKey,
      "narration": narration,
      "currency": currency,
      "reference": reference,
      "beneficiary_name": beneficiaryName,
      "meta": [
        {
          "AccountNumber": accountNumber,
          "RoutingNumber": routingNumber,
          "SwiftCode": swiftCode,
          "BankName": bankName,
          "BeneficiaryName": beneficiaryName,
          "BeneficiaryAddress": beneficiaryAddress,
          "BeneficiaryCountry": "US"
        }
      ]
    };

    Map<String, String> body = {
      AMOUNT: amount,
      SECRET_KEY: secKey,
      NARRATION: narration,
      CURRENCY: currency,
      "reference": reference,
      BENEFICIARY_NAME: beneficiaryName,
      META: jsonEncode(meta)
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveTransfer(RaveModel(items: data)));
        },
        onError: onError);
  }

  transferToMpesaMobile(
      {@required String accountNumber,
      @required String amount,
      @required String narration,
      @required String currency,
      @required String reference,
      @required String beneficiaryName,
      String callbackUrl,
      @required Function(RaveTransfer) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/gpx/transfers/create';

    Map<String, String> body = {
      AMOUNT: amount,
      ACCOUNT_NUMBER: accountNumber,
      ACCOUNT_BANK: "MPS",
      SECRET_KEY: secKey,
      NARRATION: narration,
      CURRENCY: currency,
      "reference": reference,
      BENEFICIARY_NAME: beneficiaryName,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveTransfer(RaveModel(items: data)));
        },
        onError: onError);
  }

  transferToGhanaMobile(
      {@required String accountNumber,
      @required String amount,
      @required String narration,
      @required String currency,
      @required String reference,
      @required String beneficiaryName,
      String callbackUrl,
      @required Function(RaveTransfer) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/gpx/transfers/create';

    Map<String, String> body = {
      AMOUNT: amount,
      ACCOUNT_NUMBER: accountNumber,
      ACCOUNT_BANK: "MTN",
      SECRET_KEY: secKey,
      NARRATION: narration,
      CURRENCY: currency,
      "reference": reference,
      BENEFICIARY_NAME: beneficiaryName,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveTransfer(RaveModel(items: data)));
        },
        onError: onError);
  }

  transferToUgandanMobile(
      {@required String accountNumber,
      @required String amount,
      @required String narration,
      @required String currency,
      @required String reference,
      @required String beneficiaryName,
      String callbackUrl,
      @required Function(RaveTransfer) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/gpx/transfers/create';

    Map<String, String> body = {
      AMOUNT: amount,
      ACCOUNT_NUMBER: accountNumber,
      ACCOUNT_BANK: "MPS",
      SECRET_KEY: secKey,
      NARRATION: narration,
      CURRENCY: currency,
      "reference": reference,
      BENEFICIARY_NAME: beneficiaryName,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveTransfer(RaveModel(items: data)));
        },
        onError: onError);
  }

  transferToBeneficiary(
      {@required String amount,
      @required String narration,
      @required String currency,
      @required String reference,
      @required String beneficiaryName,
      String callbackUrl,
      @required Function(RaveTransfer) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/gpx/transfers/create';

    Map<String, String> body = {
      AMOUNT: amount,
      SECRET_KEY: secKey,
      NARRATION: narration,
      CURRENCY: currency,
      "reference": reference,
      BENEFICIARY_NAME: beneficiaryName,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveTransfer(RaveModel(items: data)));
        },
        onError: onError);
  }

  transferToBulk(
      {@required String title,
      @required List<RaveBulkTransfer> bulkData,
      String callbackUrl,
      @required Function(String, RaveTransfer) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/gpx/transfers/create_bulk';

    Map<String, String> body = {
      BULK_TITLE: title,
      BULK_DATA: jsonEncode(bulkData
          .map((bulk) => RaveModel()
            ..put(BANK, bulk.bank)
            ..put(ACCOUNT_NUMBER, bulk.accountNumber)
            ..put(AMOUNT, bulk.amountToSend)
            ..put(CURRENCY, bulk.currency)
            ..put(BULK_NARRATION, bulk.narration)
            ..put(BULK_REFERENCE, bulk.reference)
            ..items)
          .toList()),
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(msg, RaveTransfer(RaveModel(items: data)));
        },
        onError: onError);
  }

  listTransfers(
      {bool failedTransaction = false,
      String page,
      @required
          Function(String msg, RavePageInfo pageInfo,
                  List<RaveTransfer> transfers)
              onComplete,
      @required
          Function(String) onError}) async {
//    String url =
//        '${requestUrl}v2/gpx/transfers?seckey=$secKey?page=$page?status=${failedTransaction ? "failed" : "successful"}';
    var url =
        "${requestUrl}v2/gpx/transfers?seckey=$secKey&page=$page&status=${failedTransaction ? "failed" : "successful"}";
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await get(url, headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          RavePageInfo ravePageInfo = RavePageInfo(
              RaveModel(items: RaveModel(items: data).getMap(PAGE_INFO)));
          List<RaveTransfer> transfers = RaveModel(items: data)
              .getList(failedTransaction ? TRANSFERS : PAYOUTS)
              .map((data) => RaveTransfer(RaveModel(items: data)))
              .toList();
          return onComplete(msg, ravePageInfo, transfers);
        },
        onError: onError);
  }

  fetchATransfer(
      {@required
          String id,
      @required
          String accountNameOrNumber,
      @required
          String reference,
      @required
          Function(String msg, RavePageInfo pageInfo,
                  List<RaveTransfer> transfers)
              onComplete,
      @required
          Function(String) onError}) async {
    var url =
        "${requestUrl}v2/gpx/transfers?seckey=$secKey&q=$accountNameOrNumber&reference=$reference";

//    String url =
//        '${requestUrl}v2/gpx/transfers?seckey=$secKey?q=$accountNameOrNumber?reference=$reference';
    print(secKey);
    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await get(url, headers: headers);
    print(response.body);
    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          RavePageInfo ravePageInfo = RavePageInfo(
              RaveModel(items: RaveModel(items: data).getMap(PAGE_INFO)));
          List<RaveTransfer> transfers = RaveModel(items: data)
              .getList(TRANSFERS)
              .map((data) => RaveTransfer(RaveModel(items: data)))
              .toList();
          return onComplete(msg, ravePageInfo, transfers);
        },
        onError: onError);
  }

  retrieveBulkTransferStatus(
      {@required
          String batchId,
      @required
          Function(String msg, RavePageInfo pageInfo,
                  List<RaveTransfer> transfers)
              onComplete,
      @required
          Function(String) onError}) async {
    String url =
        '${requestUrl}v2/gpx/transfers?seckey=$secKey?batch_id=$batchId';

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await get(url, headers: headers);
    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          RavePageInfo ravePageInfo = RavePageInfo(
              RaveModel(items: RaveModel(items: data).getMap(PAGE_INFO)));
          List<RaveTransfer> transfers = RaveModel(items: data)
              .getList(TRANSFERS)
              .map((data) => RaveTransfer(RaveModel(items: data)))
              .toList();
          return onComplete(msg, ravePageInfo, transfers);
        },
        onError: onError);
  }

  applicableTransferFee(
      {@required String currency,
      @required Function(String msg, List<RaveFees> fees) onComplete,
      @required Function(String) onError}) async {
    String url =
        '${requestUrl}v2/gpx/transfers/fee?seckey=$secKey?currency=$currency';

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await get(url, headers: headers);
    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          List<RaveFees> fees = List.from(data).map((items) {
            print(items);
            return RaveFees(RaveModel(items: items));
          }).toList();

          return onComplete(msg, fees);
        },
        onError: onError);
  }

  walletTransferBalance(
      {@required String currency,
      @required Function(RaveTransferBalance) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}v2/gpx/balance';

    Map<String, String> body = {
      SECRET_KEY: secKey,
      CURRENCY: currency,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          return onComplete(RaveTransferBalance(RaveModel(items: data)));
        },
        onError: onError);
  }

  accountVerification(
      {@required String recipientAccount,
      @required String destBankCode,
      @required String currency,
      @required String country,
      @required Function(RaveAccountVerification) onComplete,
      @required Function(String) onError}) async {
    String url = '${requestUrl}flwv3-pug/getpaidx/api/resolve_account';

    Map<String, String> body = {
      PUBLIC_KEY: pubKey,
      CURRENCY: currency,
      "country": country,
      RECIPIENT_ACCOUNT: recipientAccount,
      DEST_BANK_CODE: destBankCode,
    };

    Map<String, String> headers = {"content-type": "application/json"};

    bool netCheck = await isConnected();

    if (!netCheck) {
      return onError("Failed to connect to internet");
    }
    var response = await post(url, body: jsonEncode(body), headers: headers);

    RaveRequest(response).validateRequest(
        onSuccessful: (msg, data) {
          RaveModel rm =
              RaveModel(items: RaveModel(items: data).getMap("data"));
          String responseCode = rm.getString(RESPONSE_CODE);
          String responseMsg = rm.getString(RESPONSE_MESSAGE);

          print("ressp c $responseCode m $responseMsg");
          if (responseCode == RESPONSE_CODE_NOT_APPROVED) {
            return onError(responseMsg);
          }

          return onComplete(RaveAccountVerification(rm));
        },
        onError: onError);
  }
}

class RaveTransfer {
  final RaveModel raveModel;

  RaveTransfer(this.raveModel);

  int get transferId => raveModel.getInt("id");
  String get accountNumber => raveModel.getString("account_number");
  String get bankCode => raveModel.getString("bank_code");
  String get fullName => raveModel.getString("fullname");
  String get dateCreated => raveModel.getString("date_created");
  String get currency => raveModel.getString("currency");
  int get amount => raveModel.getInt("amount");
  int get fee => raveModel.getInt("fee");
  String get status => raveModel.getString("status");
  String get reference => raveModel.getString("reference");
  String get narration => raveModel.getString("narration");
  String get completeMessage => raveModel.getString("complete_message");
  int get requiresApproval => raveModel.getInt("requires_approval");
  int get isApproved => raveModel.getInt("is_approved");
  String get bankName => raveModel.getString("bank_name");
  List<RaveTransferMeta> get meta => raveModel
      .getList(META)
      .map((data) => RaveTransferMeta(RaveModel(items: data)))
      .toList();
}

class RaveTransferMeta {
  final RaveModel raveModel;

  RaveTransferMeta(this.raveModel);

  String get accountNumber => raveModel.getString(ABROAD_ACCOUNT_NUMBER);
  String get routingNumber => raveModel.getString(ROUTING_NUMBER);
  String get swiftCode => raveModel.getString(SWIFT_CODE);
  String get bankName => raveModel.getString(ABROAD_BANK_NAME);
  String get beneficiaryName => raveModel.getString(ABROAD_BENEFICIARY_NAME);
  String get beneficiaryAddress =>
      raveModel.getString(ABROAD_BENEFICIARY_ADDRESS);
  String get beneficiaryCountry =>
      raveModel.getString(ABROAD_BENEFICIARY_COUNTRY);
}

class RaveBulkTransfer {
  final String bank;
  final String accountNumber;
  final String amountToSend;
  final String currency;
  final String narration;
  final String reference;

  RaveBulkTransfer(
      {@required this.bank,
      @required this.accountNumber,
      @required this.amountToSend,
      @required this.currency,
      @required this.narration,
      @required this.reference});
}

class RaveTransferFee {
  final RaveModel raveModel;

  RaveTransferFee(this.raveModel);

  int get accountId => raveModel.getInt(ACCOUNT_ID);
  int get feeId => raveModel.getInt(RAVE_ID);
  String get feeType => raveModel.getString(FEE_TYPE);
  int get fee => raveModel.getInt(FEE);
  String get createdAt => raveModel.getString(CREATED_AT);
  String get updatedAt => raveModel.getString(UPDATED_AT);
  String get deletedAt => raveModel.getString(DELETED_AT);
}

class RaveTransferBalance {
  final RaveModel raveModel;

  RaveTransferBalance(this.raveModel);

  int get walletId => raveModel.getInt(WALLET_ID);
  String get shortName => raveModel.getString(SHORT_NAME);
  String get walletNumber => raveModel.getString(WALLET_NUMBER);
  int get availableBalance => raveModel.getInt(AVAILABLE_BALANCE);
  int get ledgerBalance => raveModel.getInt(LEDGER_BALANCE);
}

class RaveAccountVerification {
  final RaveModel raveModel;

  RaveAccountVerification(this.raveModel);

  String get responseCode => raveModel.getString(RESPONSE_CODE);
  String get accountNumber => raveModel.getString(VERIFY_ACCOUNT_NUMBER);
  String get accountName => raveModel.getString(ACCOUNT_NAME);
  String get responseMessage => raveModel.getString(RESPONSE_MESSAGE);
  String get phoneNumber => raveModel.getString(PHONE_NUMBER);
  String get uniqueReference => raveModel.getString(VERIFY_UNIQUE_REFERENCE);
  String get internalReference => raveModel.getString(INTERNAL_REFERENCE);
}
