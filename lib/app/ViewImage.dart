import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'assets.dart';

class ViewImage extends StatelessWidget {
  List images;
  int position;
  bool local;
  ValueNotifier vpIndexNotifier;
  ViewImage(this.images, this.position, {this.local = false});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: position);
    List<PhotoViewGalleryPageOptions> list = List();
    vpIndexNotifier = ValueNotifier<int>(0);
    for (String image in images) {
      list.add(PhotoViewGalleryPageOptions(
        imageProvider: local ? FileImage(File(image)) : NetworkImage(image),
        //maxScale: PhotoViewComputedScale.contained * 0.3
      ));
    }
    // TODO: implement build
    return Container(
      color: black,
      child: Stack(children: <Widget>[
        PhotoViewGallery(
          pageController: controller,
          pageOptions: list,
          onPageChanged: (p) {
            vpIndexNotifier.value = p;
          },
        ),
        new Container(
          margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
          width: 50,
          height: 50,
          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Center(
                child: Icon(
              Icons.keyboard_backspace,
              color: white,
              size: 25,
            )),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(flex: 1, child: Container()),
            new Padding(
              padding: const EdgeInsets.all(20),
              child: new PageViewIndicator(
                alignment: MainAxisAlignment.center,
                indicatorPadding: EdgeInsets.all(2),
                currentPage: position,
                pageIndexNotifier: vpIndexNotifier,
                length: images.length,
                normalBuilder: (animationController) => Circle(
                  size: 8.0,
                  color: white.withOpacity(.6),
                ),
                highlightedBuilder: (animationController) => ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animationController,
                    curve: Curves.ease,
                  ),
                  child: Circle(
                    size: 10.0,
                    color: white,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
