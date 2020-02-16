import 'package:credpal/MainHomePg.dart';
import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:credpal/ponds/Explore.dart';
import 'package:credpal/ponds/MyPonds.dart';
import 'package:flutter/material.dart';

int currentPage = 0;
final vp = PageController();

class Ponds extends StatefulWidget {
  final Color pgColor;

  const Ponds({Key key, this.pgColor}) : super(key: key);
  @override
  _PondsState createState() => _PondsState();
}

class _PondsState extends State<Ponds> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Ponds",
            style: textStyle(true, HEADER_HEIGHT, black),
          ),
          Text(
            "${NAIRA_SYMBOL}0.00 ",
            style: textStyle(true, HEADER_HEIGHT_MEDIUM, widget.pgColor),
          ),
          addSpace(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: List.generate(2, (index) => headerTab(index)),
            ),
          ),
          //if (currentPage == 1) searchBar()
        ],
      ),
    );
  }

  searchBar() {
    return Container(
      decoration: BoxDecoration(
          color: black.withOpacity(.06),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            color: black.withOpacity(.2),
            size: 18,
          ),
          addSpaceWidth(10),
          Text(
            "Search for ponds to invest in",
            style: textStyle(false, 16, black.withOpacity(.4)),
          )
        ],
      ),
    );
  }

  headerTab(int index) {
    String title = index == 0 ? "My Ponds" : "Explore";
    bool active = currentPage == index;
    return Flexible(
      child: GestureDetector(
        onTap: () {
          currentPage = index;
          vp.jumpToPage(index);
          setState(() {});
        },
        child: Container(
            width: screenW(context) / 2,
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: active ? widget.pgColor : black.withOpacity(.1)),
            child: Text(
              title,
              style: textStyle(active, 14, active ? white : black),
            )),
      ),
    );
  }

  pageBody() {
    return Column(
      children: <Widget>[pageHeader(), pageViews()],
    );
  }

  pageViews() {
    return Flexible(
      child: PageView(
        controller: vp,
        onPageChanged: (p) {
          setState(() {
            currentPage = p;
          });
        },
        children: <Widget>[
          MyPonds(
            pgColor: widget.pgColor,
          ),
          Explore()
        ],
      ),
    );
  }
}
