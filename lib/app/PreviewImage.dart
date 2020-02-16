import 'package:credpal/app/baseApp.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PreviewImage extends StatelessWidget {
  final String imageURL;
  final List imagesUrl;
  final int initialPicture;
  PreviewImage({this.imageURL, this.imagesUrl, this.initialPicture});

  @override
  Widget build(BuildContext context) {
    //FlutterStatusbarTextColor.setTextColor(FlutterStatusbarTextColor.light);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          if (imagesUrl != null)
            Container(
                child: PhotoViewGallery.builder(
              pageController: PageController(initialPage: initialPicture),
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                BaseModel model = BaseModel(items: imagesUrl[index]);
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(model.getString(IMAGE_URL)),
                  //initialScale: PhotoViewComputedScale.contained * 0.8,
                  heroTag: index,
                );
              },
              itemCount: imagesUrl.length,
              loadingChild:
                  loadingLayout(color: Colors.transparent, load: white),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ))
          else
            Container(
                child: PhotoView(
              imageProvider: NetworkImage(imageURL),
              loadingChild:
                  loadingLayout(color: Colors.transparent, load: white),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            )),
          new SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
