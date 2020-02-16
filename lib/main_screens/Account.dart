import 'package:cached_network_image/cached_network_image.dart';
import 'package:credpal/MainHomePg.dart';
import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int currentPage = 0;
  final vp = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: pageBody(),
    );
  }

  pageHeader() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "My Account",
                      style: textStyle(true, HEADER_HEIGHT, black),
                    ),
                    Text(
                      "Maugost Okore",
                      style: textStyle(
                          false, HEADER_HEIGHT_SMALL, black.withOpacity(.6)),
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
          addSpace(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: [
                headerTab("Get Xendam Number", "Add BVN"),
                addSpaceWidth(10),
                headerTab("0", "Xendam Points"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  headerTab(String title, String subTitle, {onClicked}) {
    return Flexible(
      child: GestureDetector(
        onTap: () {},
        child: Container(
            width: screenW(context) / 2,
            alignment: Alignment.center,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: black.withOpacity(.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: textStyle(true, 14, white),
                ),
                addSpace(5),
                Text(
                  subTitle,
                  style: textStyle(false, 12, white),
                ),
              ],
            )),
      ),
    );
  }

  accountBody() {
    return Flexible(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          checkViewItem("Enable Finger Print/Face.ID", onClicked: (b) {}),
          checkViewItem("Show Dashboard Account Balances", onClicked: (b) {}),
          Column(
            children: List.generate(accountViews.length, (p) {
              return accountItem(p, onClicked: () {});
            }),
          )
        ],
      ),
    );
  }

  checkViewItem(String title, {bool active = false, onClicked}) {
    return InkWell(
      onTap: () {
        onClicked(!active);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: textStyle(true, 14, black),
            ),
            Switch(
              onChanged: onClicked,
              value: active,
            )
          ],
        ),
      ),
    );
  }

  List<AccountViews> accountViews = [
    AccountViews(icon: FontAwesome.user_o, title: "Account Settings"),
    AccountViews(icon: Entypo.attachment, title: "Self Help"),
    AccountViews(icon: Octicons.unverified, title: "Verify your email"),
    AccountViews(icon: AntDesign.lock, title: "Add your BVN"),
    AccountViews(
        icon: AntDesign.sharealt, title: "Refer & Earn ${NAIRA_SYMBOL}1000.00"),
    AccountViews(icon: Feather.dollar_sign, title: "Withdraw Funds"),
    AccountViews(icon: AntDesign.creditcard, title: "My card & Bank Settings"),
    AccountViews(icon: Feather.phone_call, title: "Contact us"),
    AccountViews(icon: AntDesign.logout, title: "Logout", color: red),
  ];

  accountItem(int p, {onClicked}) {
    AccountViews views = accountViews[p];
    IconData icon = views.icon;
    String title = views.title;
    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(10),
            border: Border.all(color: black.withOpacity(.04))),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Container(
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: APP_COLOR),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      icon,
                      color: white,
                      size: 15,
                    ),
                  ),
                  addSpaceWidth(10),
                  Text(
                    title,
                    style: textStyle(
                        false, 14, views.color.withOpacity(p == 9 ? 1 : .7)),
                  )
                ],
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: black.withOpacity(.5),
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  pageBody() {
    return Column(
      children: <Widget>[pageHeader(), accountBody()],
    );
  }
}

class AccountViews {
  final IconData icon;
  final String title;
  final Color color;

  AccountViews({@required this.icon, @required this.title, this.color = black});
}
