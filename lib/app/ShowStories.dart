//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:odisharp/app/AppEngine.dart';
//import 'package:odisharp/app/basemodel.dart';
//import 'package:odisharp/assets.dart';
//import 'package:flutter/material.dart';
//import 'package:story_view/story_view.dart';
//
//class ShowStories extends StatelessWidget {
//  final List<BaseModel> imgBM;
//
//  const ShowStories({Key key, this.imgBM}) : super(key: key);
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      color: black,
//      child: Stack(
//        alignment: Alignment.bottomCenter,
//        children: <Widget>[
//          StoryView(
//            imgBM.map((bm) {
//              int type = bm.getType();
//              String pType =
//                  type == PRODUCT_TYPE_VIDEO ? THUMBNAIL_URL : IMAGE_URL;
//              String imageOne = bm.getString(pType);
//              bool video = type == PRODUCT_TYPE_VIDEO;
//
//              return StoryItem.pageImage(
//                CachedNetworkImageProvider(imageOne),
//              );
//            }).toList(),
//            onComplete: () {
//              Navigator.pop(context);
//            },
//          ),
//          Container(
//            height: 50,
//            //padding: const EdgeInsets.all(12.0),
//            margin: const EdgeInsets.all(12.0),
//            child: RaisedButton(
//              onPressed: () {
//                Navigator.pop(context);
//              },
//              color: red,
//              padding: EdgeInsets.all(12),
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(15)),
//              child: Center(
//                child: Text(
//                  "CLOSE",
//                  style: textStyle(false, 12, white),
//                ),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
