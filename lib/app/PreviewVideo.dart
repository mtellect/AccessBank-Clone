import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewVideo extends StatefulWidget {
  final File videoFile;
  final bool useNetwork;
  final bool showAppBar;
  final bool autoPlay;
  final bool showControls, useFile;
  final bool fullScreenByDefault;
  final String videoLink;
  final Function(String duration) videoDuration;

  const PreviewVideo(
      {Key key,
      this.videoFile,
      this.useNetwork = false,
      this.useFile = false,
      this.autoPlay = true,
      this.showControls = true,
      this.fullScreenByDefault = true,
      this.videoLink,
      this.showAppBar = true,
      this.videoDuration})
      : super(key: key);
  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.useNetwork) {
      if (widget.useFile) {
        _videoPlayerController = VideoPlayerController.file(widget.videoFile)
          ..initialize().then((_) {
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              aspectRatio: _videoPlayerController.value.aspectRatio,
              autoPlay: widget.autoPlay,
              showControls: widget.showControls,
              fullScreenByDefault: widget.fullScreenByDefault,
            );
            if (mounted) setState(() {});
          });
        return;
      }

      _videoPlayerController = VideoPlayerController.asset(widget.videoLink)
        ..initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: widget.autoPlay,
            showControls: true,
            fullScreenByDefault: widget.fullScreenByDefault,
          );
          if (mounted) setState(() {});
        });
    } else {
      _videoPlayerController = VideoPlayerController.network(widget.videoLink)
        ..initialize().then((_) {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: widget.autoPlay,
            showControls: widget.showControls,
            fullScreenByDefault: widget.fullScreenByDefault,
          );
          if (mounted) setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    FlutterStatusbarTextColor.setTextColor(FlutterStatusbarTextColor.light);

    print(widget.videoLink);
    if (widget.showAppBar) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: widget.showAppBar
            ? AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.black,
                elevation: 0,
              )
            : null,
        body: Center(
          child: _chewieController == null
              ? SizedBox(
                  height: 30,
                  width: 30,
                  child: new CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Chewie(
                  controller: _chewieController,
                ),
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: _chewieController == null
            ? SizedBox(
                height: 30,
                width: 30,
                child: new CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 5,
                    child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          getVideoDuration(),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )),
                  )
                ],
              ),
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
