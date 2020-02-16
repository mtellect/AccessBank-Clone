import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'baseApp.dart';


class PlayVideo extends StatefulWidget {
  String id;
  String link;
  File videoFile;

  PlayVideo(this.id, this.link, {this.videoFile});
  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  File videoFile;
  String videoLink;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoFile = widget.videoFile;
    if (videoFile == null) checkVideo();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: black,
        child: Stack(children: [
          /* chewieControl == null
              ? Container()
              : Center(
                  child: Chewie(
                    controller: chewieControl,
                  ),
                ),*/
          videoLink == null && videoFile == null
              ? Container()
              : videoFile != null
              ? SimpleVideoPlayer(
            file: videoFile,
          )
              : SimpleVideoPlayer(
            source: videoLink,
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
          )
        ]));
  }

  void checkVideo() async {
    String videoFileName = "${widget.id}${widget.link.hashCode}.mp4";

    File file = await getLocalFile(videoFileName);
    bool exist = await file.exists();

    if (!exist) {
      downloadFile(file);
      videoLink = widget.link;
      setState(() {});
      //createVideo(true, link: widget.link);
    } else {
      //createVideo(false, file: file);
      videoFile = file;
      setState(() {});
    }
  }

  void downloadFile(File file) async {
    //toastInAndroid("Downloading...");

    QuerySnapshot shots = await Firestore.instance
        .collection(REFERENCE_BASE)
        .where(FILE_URL, isEqualTo: widget.link)
        .limit(1)
        .getDocuments();
    if (shots.documents.isEmpty) {
      //toastInAndroid("Link not found");
    } else {
      for (DocumentSnapshot doc in shots.documents) {
        if (!doc.exists || doc.data.isEmpty) continue;
        BaseModel model = BaseModel(doc: doc);
        String ref = model.getString(REFERENCE);
        StorageReference storageReference =
        FirebaseStorage.instance.ref().child(ref);
        storageReference.writeToFile(file).future.then((_) {
          //toastInAndroid("Download Complete");
        }, onError: (error) {
          //toastInAndroid(error);
        }).catchError((error) {
          //toastInAndroid(error);
        });

        break;
      }
    }
  }
}
