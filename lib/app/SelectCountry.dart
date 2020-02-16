import 'package:credpal/app/assets.dart';
import 'package:flutter/material.dart';
import 'package:ola_like_country_picker/ola_like_country_picker.dart';

class SelectCountry extends StatelessWidget {
  final Function(Country) onCountrySelected;

  const SelectCountry({Key key, this.onCountrySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this.context = context;
    return Material(
      color: black.withOpacity(.3),
      child: Stack(fit: StackFit.expand, children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: black.withOpacity(.8),
          ),
        ),
        page()
      ]),
    );
  }

  page() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 65, 25, 65),
        child: Container(
          color: white,
          child: CountryListView(
            onSelected: onCountrySelected,
          ),
        ),
      ),
    );
  }
}
