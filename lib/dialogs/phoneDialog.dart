import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:credpal/app/AppEngine.dart';
import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class phoneDialog extends StatefulWidget {
  String title;

  phoneDialog(this.title);

  @override
  _phoneDialogState createState() => _phoneDialogState();
}

class _phoneDialogState extends State<phoneDialog> {
  String title;

  TextEditingController editingController = new TextEditingController();

  int clickBack = 0;

  String countryCode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.title;

    Country c =
        CountryPickerUtils.getCountryByIsoCode(userModel.getString(COUNTRY));
    if (c != null) {
      countryCode = "+${c.phoneCode}";
    }
  }

  @override
  Widget build(BuildContext c) {
    return WillPopScope(
        onWillPop: () {
          int now = DateTime.now().millisecondsSinceEpoch;
          if ((now - clickBack) > 5000) {
            clickBack = now;
            toast(context, "Click back again to exit");
            return;
          }
          Navigator.pop(context);
        },
        child: Scaffold(backgroundColor: white, body: page()));
  }

  BuildContext context;

  Builder page() {
    return Builder(builder: (context) {
      this.context = context;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          addSpace(30),
          new Container(
            width: double.infinity,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                          child: Icon(
                        Icons.keyboard_backspace,
                        color: black,
                        size: 25,
                      )),
                    )),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: new Text(
                    title,
                    style: textStyle(true, 17, black),
                  ),
                ),
                addSpaceWidth(10),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: blue3,
                    onPressed: () {
                      String text = editingController.text.trim();
                      if (countryCode.isEmpty) {
                        toast(context, "Choose country code");
                        return;
                      }
                      if (text.length < 3) {
                        toast(context, "Add phone number");
                        return;
                      }

                      String phone = text.startsWith("0")
                          ? text.substring(1, text.length)
                          : text;
                      String phoneText = "$countryCode$phone";
                      Navigator.pop(context, phoneText);
                    },
                    child: Text(
                      "OK",
                      style: textStyle(true, 14, white),
                    )),
                addSpaceWidth(15)
              ],
            ),
          ),
          addLine(1, black.withOpacity(.1), 0, 5, 0, 0),
          new Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: new Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  height: 100,
                  decoration: BoxDecoration(
                      color: blue09,
                      border:
                          Border.all(color: black.withOpacity(.1), width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "Country Code",
                              style: textStyle(true, 12, black.withOpacity(.5)),
                            ),
                            addSpace(5),
                            InkWell(
                              onTap: () {
                                pickPhoneCountry(context, (Country _) {
                                  countryCode = "+${_.phoneCode}";
                                  setState(() {});
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 80,
                                color: black.withOpacity(.1),
                                child: Center(
                                  child: Text(
                                    countryCode,
                                    style: textStyle(
                                        false, 20, black.withOpacity(.7)),
                                  ),
                                ),
                              ),
                            ),
                            // addLine(1, black.withOpacity(.1), 0, 0, 0, 0),
                          ],
                        ),
                      ),
                      addSpaceWidth(10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "Phone",
                              style: textStyle(true, 12, black.withOpacity(.5)),
                            ),
                            addSpace(5),
                            Container(
                              height: 50,
                              child: new TextField(
                                textInputAction: TextInputAction.done,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autofocus: true,
                                //maxLength: 20,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                style: textStyle(false, 20, black),
                                controller: editingController,
                                cursorColor: black,
                                cursorWidth: 1,
                                maxLines: 1,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            addLine(1, black.withOpacity(.1), 0, 0, 0, 0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

pickPhoneCountry(context, onPicked) {
  showDialog(
      context: context,
      builder: (c) {
        return CountryPickerDialog(
          title:
              /*Text(
                                      "Select Country",textAlign: ,
                                      style: textStyle(true, 15, black),
                                    )*/
              Container(),
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(0),
          searchCursorColor: blue0,
          isSearchable: true,
          searchInputDecoration: InputDecoration(
              hintText: "Search country",
              hintStyle: textStyle(false, 17, black.withOpacity(.3))),
          onValuePicked: (country) {
            onPicked(country);
          },
          itemBuilder: (country) {
            return Container(
                child: Row(children: [
              CountryPickerUtils.getDefaultFlagImage(country),
              addSpaceWidth(8),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(country.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle(false, 16, black)),
              ),
              addSpaceWidth(8),
              Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                decoration: BoxDecoration(
                    color: blue09,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: black.withOpacity(.1), width: 1)),
                child: Text(
                  "+${country.phoneCode}",
                  style: textStyle(true, 10, black.withOpacity(.5)),
                ),
              )
            ]));
          },
        );
      });
}
