import 'package:credpal/main_screens/Account.dart';
import 'package:credpal/main_screens/Ponds.dart';
import 'package:credpal/rave/RaveApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ravepay/ravepay.dart';

import 'app/baseApp.dart';
import 'main.dart';
import 'main_screens/Home.dart';
import 'main_screens/Savings.dart';

const double HEADER_HEIGHT = 30;
const double HEADER_HEIGHT_MEDIUM = 18;
const double HEADER_HEIGHT_SMALL = 15;
const String NAIRA_SYMBOL = "₦";

List<RaveBanks> raveBanks;
List<Bank> banks;

class MainHomePg extends StatefulWidget {
  @override
  _MainHomePgState createState() => _MainHomePgState();
}

class _MainHomePgState extends State<MainHomePg> {
  int currentPage = 0;
  final vp = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAvailableBanks();
  }

  loadAvailableBanks() async {
    Banks().fetch().then((b) {
      banks = b.data;
      banks.sort((a, b) => a.name.compareTo(b.name));
    });

    raveApi.miscellaneous.getSupportedBanks("NG").then((banks) {
      raveBanks = banks;
      raveBanks.sort((a, b) => a.bankName.compareTo(b.bankName));
      print("pulled!!!");
      if (mounted) setState(() {});
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: <Widget>[pageViews(), btmTabs()],
      ),
    );
  }

  pageViews() {
    return Flexible(
      child: PageView(
        controller: vp,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (p) {
          setState(() {
            currentPage = p;
          });
        },
        children: <Widget>[
          Home(),
          Savings(
            pgColor: homeTabs[currentPage].color,
          ),
          Ponds(
            pgColor: homeTabs[currentPage].color,
          ),
          Account()
        ],
      ),
    );
  }

  btmTabs() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
          border: Border.all(color: black.withOpacity(.02), width: 4)),
      child: Row(
        children: List.generate(4, (p) {
          return tabItems(p, homeTabs[p]);
        }),
      ),
    );
  }

  List<HomeTab> homeTabs = [
    HomeTab(title: "Home", icon: AntDesign.home),
    HomeTab(title: "Payments", icon: FontAwesome.send_o),
    HomeTab(
        title: "Services", icon: AntDesign.customerservice, color: plinkdColor),
    HomeTab(
      title: "Profile",
      icon: FontAwesome.user_o,
    )
  ];

  tabItems(int p, HomeTab tab) {
    bool active = currentPage == p;
    return Flexible(
      child: GestureDetector(
        onTap: () {
          currentPage = p;
          vp.jumpToPage(p);
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {});
        },
        child: Container(
          height: 60,
          width: screenW(context) / 3,
          color: transparent,
          //padding: EdgeInsets.all(active ? 0 : 8),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                tab.icon,
                size: active ? 25 : 22,
                color: active ? tab.color : black.withOpacity(.5),
              ),
              addSpace(4),
              Text(
                tab.title,
                style: textStyle(true, 13, black.withOpacity(active ? 1 : .6)),
              ),
              if (active)
                Container(
                  height: 8,
                  width: 8,
                  decoration:
                      BoxDecoration(color: tab.color, shape: BoxShape.circle),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTab {
  final IconData icon;
  final String title;
  final Color color;

  HomeTab({@required this.icon, @required this.title, this.color = APP_COLOR});
}
