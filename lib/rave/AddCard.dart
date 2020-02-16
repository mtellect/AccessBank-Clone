import 'package:credpal/app/assets.dart';
import 'package:credpal/app/baseApp.dart';
import 'package:credpal/main.dart';
import 'package:flutter/material.dart';

import 'OtpScreen.dart';
import 'RaveApi.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String cardNumber = '';
  String expiryDate = '';
  String expiryYear = '';
  String expiryMonth = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final progressId = getRandomId();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: blue3,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BackButton(
                  color: white,
                ),
                Row(
                  children: <Widget>[addSpaceWidth(15)],
                ),
              ],
            ),
            //addSpace(5),

//            Container(
//              padding: EdgeInsets.symmetric(horizontal: 15),
//              child: tipMessageItem("Please Note",
//                  "We would deduct a refundable fee of N100 to test your card and make sure it's active"),
//            ),
//            addSpace(5),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardWidget(
                      cardNumber: cardNumber,
                      height: 200,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      showBackView: isCvvFocused,
                      cardBgColor: blue3,
                    ),
                    CreditCardForm(
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    addSpace(20),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: RaisedButton(
                          onPressed: () {
                            chargeCard();
                          },
                          color: green_dark,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "SAVE CARD",
                            style: textStyle(true, 14, white),
                          ))),
                    ),
                  ],
                ),
              ),
            ),
            //addSpace(30),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;

      if (expiryDate.isNotEmpty && expiryDate.length == 5) {
        expiryMonth = expiryDate.split("/")[0];
        expiryYear = expiryDate.split("/")[1];
      }
    });
  }

  chargeCard() {
    if (cardNumber.isEmpty) {
      toast(scaffoldKey, "Please enter card number", color: red);
      return;
    }

    if (expiryDate.isEmpty || expiryDate.length != 5) {
      toast(scaffoldKey, "Please enter card expiry date", color: red);
      return;
    }

    if (cvvCode.isEmpty) {
      toast(scaffoldKey, "Please enter the cvv code behind the card",
          color: red);
      return;
    }

    if (cardHolderName.isEmpty) {
      toast(scaffoldKey, "Please enter name on the card", color: red);
      return;
    }
    //toast(scaffoldKey, "${expiryDate}", color: red);
    //return;

    showProgress(true, progressId, context, msg: "Adding Card");
    chargeRave();
  }

  chargeRave(
      {String suggestAuth = "PIN",
      String cardPin = "PIN",
      bool pinRequested = false}) {
    //print(userModel.getString(FULL_NAME));
    //return;
    raveApi.charge.initiateCardPayment(
        context: context,
        cardNumber: cardNumber.replaceAll(" ", ""),
        cardCVV: cvvCode,
        cardExpMonth: expiryMonth,
        cardExpYear: expiryYear,
        currency: "NGN",
        country: "NG",
        amount: "100",
        email: userModel.getEmail(),
        phoneNumber: userModel.getString(PHONE_NUMBER),
        firstName: userModel.getString(FULL_NAME).split(" ")[0],
        lastName: userModel.getString(FULL_NAME).split(" ")[0],
        suggestAuth: suggestAuth,
        cardPin: cardPin,
        pinRequested: pinRequested,
        txReference: DateTime.now().millisecondsSinceEpoch.toString(),
        validatorBuilder: (bool otp, String respMsg, String flwRef) {
          if (otp) {
            pushAndResult(
                context,
                OtpScreen(
                  isPin: false,
                  title: "Enter OTP",
                  message: respMsg,
                ), result: (_) {
              if (_.toString().isEmpty) {
                showProgress(false, progressId, context);
                Future.delayed(Duration(milliseconds: 15), () {
                  toast(scaffoldKey, "Transaction was forcefully terminated!",
                      color: red);
                });
                return;
              }
              print("flwRef $flwRef");
              raveApi.charge.validatePayment(
                  transactionRef: flwRef,
                  otp: _,
                  onComplete: (msg, token) {
                    BaseModel bm = BaseModel();
                    bm.put(MY_CARD_NAME, cardHolderName);
                    bm.put(MY_CARD_NUMBER, cardNumber);
                    bm.put(MY_CARD_EXP_MONTH, expiryMonth);
                    bm.put(MY_CARD_EXP_YEAR, expiryYear);
                    bm.put(MY_CARD_EXP_DATE, expiryDate);
                    bm.put(MY_CARD_CVV, cvvCode);
                    bm.put(EMAIL, userModel.getEmail());
                    bm.put(RAVE_TOKEN, token);

                    List<BaseModel> myCards = userModel
                        .getList(MY_CARDS)
                        .map((m) => BaseModel(items: m))
                        .toList();

                    int p = myCards.indexWhere((b) =>
                        b.getString(MY_CARD_NUMBER) ==
                        bm.getString(MY_CARD_NUMBER));

                    bool exists = p != -1;
                    if (!exists) {
                      myCards.add(bm);
                    } else {
                      myCards[p] = bm;
                    }

//                    setState(() {
//                      cardNumber = "";
//                      expiryDate = "";
//                      cvvCode = "";
//                      cardHolderName = "";
//                      expiryYear = "";
//                      expiryMonth = "";
//                    });

                    userModel
                      ..put(MY_CARDS, myCards.map((bm) => bm.items).toList())
                      ..updateItems();

                    showMessage(context, Icons.check, green, "Card Saved!",
                        "You have successfully saved your card: $msg",
                        delayInMilli: 800, cancellable: true, onClicked: (_) {
                      showProgress(false, progressId, context);
                    });
                  },
                  onError: (e) {
                    showProgress(false, progressId, context);
                    showMessage(context, Icons.error, red, "Error", e,
                        delayInMilli: 1000, cancellable: true);
                  });
            });
            return;
          }

          pushAndResult(
              context,
              OtpScreen(
                isPin: true,
                title: "Card Pin",
                message: "Enter the card pin",
              ), result: (_) {
            if (_.toString().isEmpty) {
              showProgress(false, progressId, context);
              Future.delayed(Duration(milliseconds: 15), () {
                toast(scaffoldKey, "Transaction was forcefully terminated!",
                    color: red);
              });
              return;
            }
            chargeRave(
                cardPin: _,
                pinRequested: true,
                suggestAuth: SUGGESTED_AUTH_PIN);
          });
        },
        onComplete: (msg) {
          showProgress(false, progressId, context);
          showMessage(context, Icons.check, green, "Payment Successful",
              "Payment was successful: MSG $msg",
              delayInMilli: 900, cancellable: true);
        },
        onError: (e) {
          showProgress(false, progressId, context);
          showMessage(context, Icons.error, red, "Error", e,
              delayInMilli: 900, cancellable: true);
        });
  }
}
