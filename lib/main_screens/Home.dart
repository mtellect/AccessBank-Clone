import 'package:cached_network_image/cached_network_image.dart';
import 'package:credpal/EnterAmount.dart';
import 'package:credpal/MainHomePg.dart';
import 'package:credpal/SendMoney.dart';
import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:credpal/app/baseApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final vp = PageController(viewportFraction: .85);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: white,
      body: pageBody(),
    );
  }

  pageHeader() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Maugost,",
                  style: textStyle(true, HEADER_HEIGHT, white),
                ),
                Text(
                  "Welcome to Access Bank",
                  style: textStyle(
                      false, HEADER_HEIGHT_SMALL, white.withOpacity(.9)),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CachedNetworkImage(
              imageUrl: maugostImage,
              height: 40,
              width: 40,
              placeholder: (ctx, s) {
                return Container(
                  height: 40,
                  width: 40,
                  color: APP_COLOR,
                  child: Image.asset("assets/images/ic_launcher.png"),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  List<AccountBalances> acctBalances = [
    AccountBalances(
        title: "PREPAID CARD-BASIC",
        amount: "14,000,0000",
        accountNumber: "0054000001",
        icon: SimpleLineIcons.wallet),
    AccountBalances(
        title: "PREMIER SAVINGS",
        amount: "105,000",
        accountNumber: "0054250001",
        icon: AntDesign.rocket1,
        color: plinkdColor),
  ];

  accountBalances() {
    return Column(
      children: <Widget>[
        Container(
          height: 150,
          child: PageView.builder(
              itemCount: acctBalances.length,
              onPageChanged: (p) {
                setState(() {
                  currentPage = p;
                });
              },
              controller: vp,
              itemBuilder: (ctx, p) {
                return balanceItem(p);
              }),
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: black.withOpacity(.7)),
                child: new DotsIndicator(
                  dotsCount: acctBalances.length,
                  position: currentPage,
                  decorator: DotsDecorator(
                    size: const Size.square(5.0),
                    color: white,
                    activeColor: acctBalances[currentPage].color,
                    activeSize: const Size(10.0, 7.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  balanceItem(int p) {
    AccountBalances bal = acctBalances[p];
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
      child: Container(
        margin: EdgeInsets.all(8),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    //bottomRight: Radius.circular(18),
                  ),
                  color: APP_COLOR2 //bal.color.withOpacity(.1),
                  ),
            ),
            Opacity(
              opacity: .2,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      //bottomRight: Radius.circular(18),
                    ),
                    color: APP_COLOR2,
                    image: DecorationImage(
                      image: AssetImage("assets/bank/trans_banner.png"),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(
                    bal.icon,
                    size: 25,
                    color: white,
                  ),
                  addSpaceWidth(15),
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        bal.title,
                        style: textStyle(true, 14, white),
                      ),
                      addSpace(5),
                      Text(
                        bal.accountNumber,
                        style: textStyle(false, 12, white),
                      ),
                      addSpace(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "$NAIRA_SYMBOL${bal.amount}",
                            style: textStyle(true, 20, white),
                          ),
//                          Image.asset(
//                            "assets/bank/logo-white.png",
//                            height: 40,
//                            width: 100,
//                          )
                          Image.asset(
                            "assets/bank/logo_transparent.png",
                            height: 40,
                            width: 100,
                          )
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BaseModel> payData = [
    BaseModel()
      ..put(TYPE, PAY_TYPE_FUND)
      ..put(COLORS, Colors.purple.value)
      ..put(IMAGE, "assets/images/fund.png")
      ..put(TITLE, "Add"),
    BaseModel()
      ..put(TYPE, PAY_TYPE_SEND)
      ..put(IMAGE, "assets/images/send.png")
      ..put(TITLE, "Send"),
    BaseModel()
      ..put(TYPE, PAY_TYPE_WITHDRAW)
      ..put(IMAGE, "assets/images/request.png")
      ..put(TITLE, "Withdraw"),
    BaseModel()
      ..put(TYPE, HOME_TYPE_BUNDLES)
      ..put(COLORS, Colors.green.value)
      ..put(IMAGE, "assets/images/transaction.png")
      ..put(TITLE, "Transaction")
  ];

  payItem(int p, {bool active = false, onSelected}) {
    BaseModel bm = payData[p];
    Color color = Color(bm.getInt(COLORS));
    String title = bm.getString(TITLE);
    String icon = bm.getImage();
    int type = bm.getType();

    return Flexible(
      child: GestureDetector(
        onTap: onSelected,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 5, right: 5),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: white.withOpacity(active ? 1 : .5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: black.withOpacity(.05))
              //shape: BoxShape.circle
              ),
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  icon,
                  color: white.withOpacity(active ? 1 : .6),
                ),
                decoration: BoxDecoration(
                    color: APP_COLOR.withOpacity(active ? 1 : .5),
                    //borderRadius: BorderRadius.circular(4)
                    shape: BoxShape.circle),
              ),
              addSpace(5),
              Text(
                title,
                style: textStyle(false, active ? 15 : 14,
                    black.withOpacity(active ? 1 : .7)),
              ),
              addSpace(2),
              Text(
                "money",
                style: textStyle(false, 12, black.withOpacity(.5)),
              )
            ],
          ),
        ),
      ),
    );
  }

  mainFeatures() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(payData.length - 1, (p) {
          return payItem(p,
              //active: currentPage == p,
              active: true, onSelected: () {
            setState(() {
              //currentPage = p;
            });
            if (p == 0) {
              pushAndResult(context, EnterAmount());
              return;
            }
            if (p == 1) {
              pushAndResult(context, SendMoney());
              return;
            }

            pushAndResult(context, EnterAmount());
          });
        }),
      ),
    );
  }

  List<Transactions> transactions = [
    Transactions(
        toAccount: "Terry Kerrangar",
        narration: "Payment for Moon Milestone",
        amount: "300,000.00",
        isDebit: false,
        color: null,
        date: "Jan 19,2019"),
    Transactions(
        toAccount: "Stella Aniugbo",
        narration: "Payment for Moon Milestone",
        amount: "3,000.00",
        isDebit: true,
        color: null,
        date: "Jan 19,2019"),
    Transactions(
        toAccount: "John Okore",
        narration: "Payment for Fb Milestone",
        amount: "15,0000.00",
        isDebit: false,
        color: null,
        date: "Jan 19,2019"),
    Transactions(
        toAccount: "Nkechi Aniugbo",
        narration: "Payment for Moon Milestone",
        amount: "3000.00",
        isDebit: true,
        color: null,
        date: "Jan 19,2019"),
    Transactions(
        toAccount: "Nkechi Aniugbo",
        narration: "Payment for Moon Milestone",
        amount: "300.00",
        isDebit: false,
        color: null,
        date: "Jan 19,2019"),
    Transactions(
        toAccount: "Nkechi Aniugbo",
        narration: "Payment for Moon Milestone",
        amount: "300.00",
        isDebit: true,
        color: null,
        date: "Jan 19,2019"),
    Transactions(
        toAccount: "Nkechi Aniugbo",
        narration: "Payment for Moon Milestone",
        amount: "300.00",
        isDebit: false,
        color: null,
        date: "Jan 19,2019"),
  ];

  transactionItem(Transactions trans) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(15),
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    "assets/images/${trans.isDebit ? "send" : "request"}.png",
                    color: (trans.isDebit ? red : green_dark),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          (trans.isDebit ? red : green_dark).withOpacity(.2)),
                ),
                addSpaceWidth(10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        trans.toAccount,
                        style: textStyle(true, 16, black),
                      ),
                      addSpace(10),
                      Text(
                        trans.narration,
                        style: textStyle(false, 14, black.withOpacity(.7)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "$NAIRA_SYMBOL ${trans.amount}",
                style: textStyle(true, 16, (trans.isDebit ? red : green_dark)),
              ),
              addSpace(10),
              Text(
                trans.date,
                style: textStyle(false, 12, black.withOpacity(.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pageBody() {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bank/banner.png"),
                      fit: BoxFit.cover)),
              child: Column(
                children: <Widget>[
                  pageHeader(),
                  accountBalances(),
                ],
              ),
            ),
          ],
        ),
        Flexible(
          child: ListView(
            padding: EdgeInsets.only(top: 10),
            children: <Widget>[
              mainFeatures(),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Recent Activities",
                  style: textStyle(true, 16, black.withOpacity(.6)),
                ),
              ),
              Column(
                children: List.generate(transactions.length,
                    (index) => transactionItem(transactions[index])),
              )
            ],
          ),
        )
      ],
    );
  }
}

class AccountBalances {
  final String title;
  final String accountNumber;
  final String amount;
  final IconData icon;
  final Color color;

  AccountBalances(
      {@required this.title,
      @required this.amount,
      @required this.accountNumber,
      @required this.icon,
      this.color = APP_COLOR});
}

class Transactions {
  final String toAccount;
  final String narration;
  final String amount;
  final String date;
  final isDebit;
  final Color color;

  Transactions(
      {@required this.toAccount,
      @required this.narration,
      @required this.amount,
      @required this.isDebit,
      @required this.date,
      @required this.color});
}
