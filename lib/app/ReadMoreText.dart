import 'package:credpal/app/AppEngine.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_text_view/smart_text_view.dart';

import 'assets.dart';

//import 'package:smart_text/smart_text.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final bool full;
  final bool poll;
  final toggle;
  final int minLength;
  final double fontSize;
  final textColor;
  final moreColor;

  ReadMoreText(this.text,
      {this.full = false,
      this.minLength = 150,
      this.fontSize = 14,
      this.toggle,
      this.textColor = black,
      this.moreColor = blue0,
      this.poll = false});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool expanded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    expanded = widget.full;
  }

  @override
  Widget build(BuildContext context) {
    return text();
  }

  text() {
    bool readMore = widget.text.length > widget.minLength;
    String text = widget.text;
    String readMoreText =
        widget.text.substring(0, readMore ? widget.minLength : text.length);
    bool poll = widget.poll;

    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
          if (widget.toggle != null) widget.toggle(expanded);
        });
      },
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //if (expanded)
          new SmartText(
            text: expanded ? text : readMore ? readMoreText : text,
            //text: readMoreText,
            style: textStyle(false, widget.fontSize, widget.textColor),
            onTagClick: (hashTag) {
//              goToWidget(
//                  context,
//                  HashTagScreen(
//                    hashTag: hashTag.toLowerCase(),
//                    userModel: userModel,
//                  ));
            },

            tagStyle: TextStyle(
                color: APP_COLOR, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          //if (readMore && !expanded)
          new Text(
            //"continue to read more.....",
            widget.text.length < widget.minLength
                ? ""
                : expanded ? " Read Less" : "Read More",
            style: TextStyle(color: APP_COLOR, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, VoidCallback onPressed, String text})
      : super(
          style: style,
          text: text,
          recognizer: new TapGestureRecognizer()..onTap = onPressed,
        );
}

final _linkRegex = RegExp(
    r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
    caseSensitive: false);
final _tagRegex = RegExp(r"\B#\w*[a-zA-Z]+\w*", caseSensitive: false);

/// Turns [text] into a list of [SmartTextElement]
List<SmartTextElement> _smartify(String text) {
  final sentences = text.split('\n');
  List<SmartTextElement> span = [];
  sentences.forEach((sentence) {
    final words = sentence.split(' ');
    words.forEach((word) {
      if (_linkRegex.hasMatch(word)) {
        span.add(LinkElement(word));
      } else if (_tagRegex.hasMatch(word)) {
        span.add(HashTagElement(word));
      } else {
        span.add(TextElement(word));
      }
      span.add(TextElement(' '));
    });
    if (words.isNotEmpty) {
      span.removeLast();
    }
    span.add(TextElement('\n'));
  });
  if (sentences.isNotEmpty) {
    span.removeLast();
  }
  return span;
}
