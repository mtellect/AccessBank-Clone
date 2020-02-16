import 'package:credpal/dialogs/baseDialogs.dart';
import 'package:credpal/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:ravepay/ravepay.dart' as rave;

import 'MainHomePg.dart';
import 'app/baseApp.dart';
import 'rave/RaveApi.dart';

class TransactionSummary extends StatefulWidget {
  final int amountToPull;

  const TransactionSummary({Key key, this.amountToPull}) : super(key: key);

  @override
  _TransactionSummaryState createState() => _TransactionSummaryState();
}

class _TransactionSummaryState extends State<TransactionSummary> {
  inputField(
      {@required TextEditingController controller,
      String title,
      String hint,
      bool isPassword = false,
      bool showPassword = false,
      bool isBtn = false,
      bool isNumber = false,
      int maxLines = 1,
      onPassChanged,
      onBtnPressed,
      onChanged}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            child: Text(
              title,
              style: textStyle(false, 14, headerColor),
            ),
          ),
          addSpaceWidth(10),
          Flexible(
            child: CupertinoTextField(
              controller: controller,
              padding: EdgeInsets.all(18),
              maxLines: maxLines,
              onTap: isBtn ? onBtnPressed : null,
              keyboardType: isNumber ? TextInputType.number : null,
              placeholder: hint,
              readOnly: isBtn,
              obscureText: showPassword,
              onChanged: onChanged,
              suffix: isPassword
                  ? Container(
                      decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )),
                      child: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: white,
                          ),
                          onPressed: onPassChanged),
                    )
                  : isBtn
                      ? Container(
                          padding: EdgeInsets.all(3),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.arrow_drop_up,
                                color: black.withOpacity(.6),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: black.withOpacity(.6),
                              ),
                            ],
                          ),
                        )
                      : null,
              decoration: BoxDecoration(
                  color: black.withOpacity(.04),
                  borderRadius: BorderRadius.circular(8)),
            ),
          )
        ],
      ),
    );
  }

  bool accountRetrieved = false;
  bool otpRetrieved = false;
  String transactionRef;
  RaveBanks bankSelected;

  rave.Bank bankChosen;

  var bank = TextEditingController();
  var acctNum = TextEditingController();
  var otp = TextEditingController();
  RaveAccountVerification accountInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final progressId = getRandomId();

  verifyAccountNumber() async {
    raveApi.transfers.accountVerification(
        recipientAccount: acctNum.text,
        destBankCode: bankSelected.bankCode,
        currency: "NGN",
        country: "NG",
        onComplete: (account) {
          accountRetrieved = true;
          accountInfo = account;
          setState(() {});
          print(account.raveModel.items);
          showProgress(false, progressId, context);
        },
        onError: (e) {
          accountRetrieved = false;
          accountInfo = null;
          setState(() {});
          showProgress(false, progressId, context);
          showMessage(context, Icons.error, red, "Account Error", e,
              delayInMilli: 900, cancellable: false);
        });
  }

  loadAvailableBanks() async {
    raveApi.miscellaneous.getSupportedBanks("NG").then((banks) {
      raveBanks = banks;
      raveBanks.sort((a, b) => a.bankName.compareTo(b.bankName));
      if (mounted) setState(() {});
    }).catchError(onError);
  }

  onError(e) {
    showProgress(false, progressId, context);
    showMessage(context, Icons.error, red, "Transaction Error", e.message,
        delayInMilli: 900, cancellable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: blue3,
        title: Text("Account Information"),
      ),
      body: pageBody(),
    );
  }

  pageBody() {
    return ListView(
      padding: EdgeInsets.all(12),
      children: <Widget>[
        inputField(
            controller: bank,
            title: "Bank Name",
            hint: "Select your bank",
            isBtn: true,
            onBtnPressed: () {
              if (null == raveBanks) {
                showProgress(true, progressId, context,
                    msg: "Reteriving supported banks", cancellable: true);
                loadAvailableBanks();
                return;
              }
              pushAndResult(
                  context,
                  listDialog(
                    raveBanks.map((bm) => bm.bankName).toList(),
                    //usePosition: false,
                  ), result: (_) async {
                if (null == _) return;
                setState(() {
                  bankSelected = raveBanks[_];
                  bank.text = raveBanks[_].bankName;
                });
              });
            }),
        inputField(
            controller: acctNum,
            isNumber: true,
            title: "Account Number",
            hint: "Enter account number",
            onChanged: (String s) {
              if (s.length < 10) {
                setState(() {
                  accountRetrieved = false;
                  otp.clear();
                  accountInfo = null;
                });
                return;
              }

              if (s.length == 10) {
                showProgress(true, progressId, context,
                    msg: "Verifying Account");
                verifyAccountNumber();
              }
            }),
        if (accountRetrieved) retrievedAccountView(),
        addSpace(20),
        FlatButton(
          onPressed: chargeBankAccount,
          color: blue3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              otpRetrieved ? "Make Withdrawal" : "Generate OTP",
              style: textStyle(true, 16, white),
            ),
          ),
        )
      ],
    );
  }

  retrievedAccountView() {
    var formatted = FlutterMoneyFormatter(
        amount: widget.amountToPull.toDouble() + 50,
        settings: MoneyFormatterSettings(symbol: "NGN"));
    return Column(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                color: blue6, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        "Account Name",
                        style: textStyle(false, 12, white),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        accountInfo.accountName,
                        style: textStyle(true, 14, white),
                      ),
                    ),
                  ],
                ),
                addSpace(10),
                Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        "Account Number",
                        style: textStyle(false, 12, white),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        accountInfo.accountNumber,
                        style: textStyle(true, 14, white),
                      ),
                    ),
                  ],
                ),
              ],
            )),
        addSpace(10),
        tipMessageItem("Please note",
            "You are making a withdrawal of (${formatted.output.symbolOnLeft}) from your account. NGN 50 transaction charges."),
        addSpace(10),
        if (otpRetrieved)
          inputField(
              controller: otp,
              isNumber: true,
              title: "OTP Number",
              hint: "Enter OTP received"),
      ],
    );
  }

  chargeBankAccount() async {
    if (!accountRetrieved) return;

    if (otpRetrieved) {
      //Charge bank account
      showProgress(true, progressId, context, msg: "Charging Bank...");

      raveApi.charge.validatePayment(
          transactionRef: transactionRef,
          otp: otp.text,
          onComplete: (msg, token) {
            print("msg $msg tok $token");
            showProgress(false, progressId, context);
            showMessage(
                context, Icons.check, green_dark, "Transaction Successful", msg,
                delayInMilli: 900, cancellable: false, onClicked: () {
              Navigator.pop(context);
            });
          },
          onError: (e) {
            showProgress(false, progressId, context);
            showMessage(context, Icons.error, red, "Charge Error", e,
                delayInMilli: 900, cancellable: false);
          });
      return;
    }

    showProgress(true, progressId, context, msg: "Generating OTP...");
    raveApi.charge.initiateBankPayment(
        context: context,
        bankCode: bankSelected.bankCode,
        accountNumber: acctNum.text,
        currency: "NGN",
        country: "NG",
        amount: widget.amountToPull.toString(),
        email: "ammaugost@gmail.com",
        phoneNumber: "08143733836",
        firstName: accountInfo.accountName.split(" ")[0],
        lastName: accountInfo.accountName.split(" ")[1],
        txReference: progressId,
        onComplete: (status) {
          showProgress(false, progressId, context);
          showMessage(context, Icons.check, green_dark,
              "Transaction Successful", status,
              delayInMilli: 900, cancellable: false, onClicked: () {
            Navigator.pop(context);
          });
        },
        onError: (e) {
          showProgress(false, progressId, context);
          showMessage(context, Icons.error, red, "OTP Error", e,
              delayInMilli: 900, cancellable: false);
        },
        validatorBuilder: (bool otp, String respMsg, String flwRef) {
          print("otp $otp reps $respMsg tx $flwRef");
          showProgress(false, progressId, context);
          setState(() {
            otpRetrieved = otp;
            transactionRef = flwRef;
          });
        });
  }
}
