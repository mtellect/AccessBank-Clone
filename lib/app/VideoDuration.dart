import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'AppEngine.dart';
import 'assets.dart';

class VideoDuration extends StatefulWidget {
  final File videoFile;
  final bool useNetwork,useAsset;
  final String videoLink;
  final Color color;
  final Function(String duration) videoDuration;

  const VideoDuration(
      {Key key,
      this.videoFile,
      this.useNetwork = false,
      this.useAsset = false,
      this.videoLink,
      this.videoDuration,
      this.color = black})
      : super(key: key);
  @override
  _VideoDurationState createState() => _VideoDurationState();
}

class _VideoDurationState extends State<VideoDuration>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController _videoPlayerController;
  String duration = "--:--:--";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.useNetwork == false) {
      _videoPlayerController = VideoPlayerController.asset(widget.videoLink)
        ..initialize().then((_) {
          //duration = getVideoDuration();
          if (mounted) setState(() {});
        });
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.videoLink)
        ..initialize().then((_) {
          if (mounted) setState(() {});
        });
    }
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.initialized) {
        duration = getVideoDuration();
        if (mounted) setState(() {});
      }
      print("DURAION LISTENER $duration");
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      padding: EdgeInsets.all(5),
      //margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: white.withOpacity(.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: widget.color.withOpacity(.5))),
      child: Text(
        duration,
        style: textStyle(false, 12, white.withOpacity(.5)),
      ),
    );
  }

  String getVideoDuration() {
    int hours = _videoPlayerController.value.duration.inHours;
    int mins = _videoPlayerController.value.duration.inMinutes % 60;
    int secs = _videoPlayerController.value.duration.inSeconds % 60;

    String minutesStr = (mins % 60).toString().padLeft(2, '0');
    String secondsStr = (secs % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
