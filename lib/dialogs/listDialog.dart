import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: must_be_immutable
class listDialog extends StatelessWidget {
  String title;
  var items;
  List images;
  bool isIcon;
  bool useTint;
  bool usePosition;
  BuildContext context;

  listDialog(items,
      {title,
      images,
      bool isIcon = false,
      bool useTint = true,
      bool usePosition = true}) {
    this.title = title;
    this.items = items;
    this.images = images == null ? List() : images;
    this.isIcon = isIcon;
    this.useTint = useTint;
    this.usePosition = usePosition;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Stack(fit: StackFit.expand, children: <Widget>[
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: black.withOpacity(.8),
        ),
      ),
      page()
    ]);
  }

  page() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 45, 25, 25),
        child: new Container(
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  width: double.infinity,
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      addSpaceWidth(15),
                      Image.asset(
                        ic_launcher,
                        height: 20,
                        width: 20,
                      ),
                      addSpaceWidth(10),
                      new Flexible(
                        flex: 1,
                        child: title == null
                            ? new Text(
                                APP_NAME,
                                style:
                                    textStyle(false, 11, black.withOpacity(.1)),
                              )
                            : new Text(
                                title,
                                style: textStyle(true, 20, black),
                              ),
                      ),
                      addSpaceWidth(15),
                    ],
                  ),
                ),
                addSpace(5),
                addLine(.5, black.withOpacity(.1), 0, 0, 0, 0),
                Container(
                  color: white,
                  child: new ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: (MediaQuery.of(context).size.height / 2) +
                            (MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? 0
                                : (MediaQuery.of(context).size.height / 5))),
                    child: Scrollbar(
                      child: new ListView.builder(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        itemBuilder: (context, position) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              position == 0
                                  ? Container()
                                  : addLine(
                                      .5, black.withOpacity(.1), 0, 0, 0, 0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(
                                      usePosition ? position : items[position]);
                                },
                                child: new Container(
                                  color: white,
                                  width: double.infinity,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        images.isEmpty
                                            ? Container()
                                            : isIcon
                                                ? Icon(
                                                    images[position],
                                                    size: 17,
                                                    color: !useTint
                                                        ? null
                                                        : black.withOpacity(.3),
                                                  )
                                                : Image.asset(
                                                    images[position],
                                                    width: 17,
                                                    height: 17,
                                                    color: !useTint
                                                        ? null
                                                        : black.withOpacity(.3),
                                                  ),
                                        images.isNotEmpty
                                            ? addSpaceWidth(10)
                                            : Container(),
                                        Flexible(
                                          child: Text(
                                            items[position],
                                            style: textStyle(false, 15,
                                                black.withOpacity(.8)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: items.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                ),
                addLine(.5, black.withOpacity(.1), 0, 0, 0, 0)
                //gradientLine(alpha: .1)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
