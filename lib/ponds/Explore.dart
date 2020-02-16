import 'package:cached_network_image/cached_network_image.dart';
import 'package:credpal/MainHomePg.dart';
import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        searchBar(),
        addLine(5, black.withOpacity(.02), 0, 10, 0, 0),
        exploreBody()
      ],
    );
  }

  searchBar() {
    return Container(
      decoration: BoxDecoration(
          color: black.withOpacity(.06),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 15),
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

  exploreBody() {
    return Flexible(
        child: ListView.builder(
            itemCount: 6,
            padding: EdgeInsets.all(0),
            itemBuilder: (ctx, p) {
              return exploreItem(p);
            }));
  }

  exploreItem(int p) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: EdgeInsets.all(14),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: "https://tinyurl.com/rueudsw",
              height: 220,
              fit: BoxFit.cover,
              width: screenW(context),
              placeholder: (ctx, s) {
                return placeHolder(220, width: double.infinity);
              },
            ),
            Container(
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "CatFish Farm in Umudike,Ikwuano L.G.A. Abia state",
                    style: textStyle(true, 16, black),
                  ),
                  addSpace(5),
                  Row(
                    children: <Widget>[
                      infoItem("25%", "5 months", hasColor: true),
                      infoItem("5,000", "P/Share", hasPrice: true),
                      infoItem("1048", "Investors"),
                      infoItem("ACTIVE", "Status", hasColor: true),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  infoItem(String title, String subTitle,
      {bool hasPrice = false, bool hasColor = false}) {
    return Flexible(
      child: Container(
        width: screenW(context) / 3,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (hasPrice)
              Text(
                "$NAIRA_SYMBOL$title",
                style: textStyle(true, 14, black),
              )
            else
              Text(
                title,
                style: textStyle(true, 14, hasColor ? green_dark : black),
              ),
            Text(
              subTitle,
              style: textStyle(false, 12, black.withOpacity(.6)),
            ),
          ],
        ),
      ),
    );
  }
}
