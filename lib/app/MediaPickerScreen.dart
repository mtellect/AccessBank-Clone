//import 'package:flutter/material.dart';
//import 'package:flutter_multimedia_picker/data/MediaFile.dart';
//import 'package:flutter_multimedia_picker/fullter_multimedia_picker.dart';
//import 'package:flutter_multimedia_picker/widget/PickerWidget.dart';
//import 'package:odisharp/app/AppEngine.dart';
//
//enum PickType { videos, images, all }
//
//class PickerScreen extends StatefulWidget {
//  final PickType pickType;
//
//  const PickerScreen({this.pickType = PickType.all});
//
//  @override
//  _PickerScreenState createState() => _PickerScreenState();
//}
//
//class _PickerScreenState extends State<PickerScreen> {
//  bool hasMedia = false;
//  List<MediaFile> mediaFiles = [];
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    if (widget.pickType == PickType.all) {
//      FlutterMultiMediaPicker.getAll().then((media) {
//        setState(() {
//          mediaFiles = media;
//          hasMedia = true;
//        });
//      });
//    }
//
//    if (widget.pickType == PickType.videos) {
//      FlutterMultiMediaPicker.getVideo().then((media) {
//        setState(() {
//          mediaFiles = media;
//          hasMedia = true;
//        });
//      });
//    }
//
//    if (widget.pickType == PickType.images) {
//      FlutterMultiMediaPicker.getImage().then((media) {
//        setState(() {
//          mediaFiles = media;
//          hasMedia = true;
//        });
//      });
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: Text("Media Picker"),
//        ),
//        body: LayoutBuilder(
//          builder: (ctc, box) {
//            if (!hasMedia) return loadingLayout();
//            return PickerWidget(mediaFiles, onDone, onCancel);
//          },
//        ));
//  }
//
//  onDone(Set<MediaFile> selectedFiles) {
//    Navigator.pop(context, selectedFiles);
//  }
//
//  onCancel() {
//    Navigator.pop(context);
//  }
//}
