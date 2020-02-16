import 'package:credpal/app/baseApp.dart';
import 'package:credpal/app/basemodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryChooser extends StatefulWidget {
  @override
  _CountryChooserState createState() => _CountryChooserState();
}

class _CountryChooserState extends State<CountryChooser>
    with TickerProviderStateMixin {
  bool hasLoaded = false;
  List<BaseModel> countriesList = [];
  List<BaseModel> mainCountriesList = [];
  var searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCountries();
  }

  loadCountries() async {
    var flags = countriesAndFlags().getList(COUNTRY_FLAG);
    var countries = countriesAndFlags().getList(COUNTRY);

    for (int i = 0; i < countries.length; i++) {
      BaseModel bm = BaseModel();
      bm.put(COUNTRY, countries[i]);
      bm.put(COUNTRY_FLAG, flags[i]);
      countriesList.add(bm);
      //print(bm.items);
      setState(() {
        hasLoaded = true;
      });
    }
    setState(() {});

    mainCountriesList = countriesList;
    mainCountriesList
        .sort((a, b) => a.getString(COUNTRY).compareTo(b.getString(COUNTRY)));
    countriesList
        .sort((a, b) => a.getString(COUNTRY).compareTo(b.getString(COUNTRY)));

    if (countriesList.isEmpty) {
      if (mounted)
        setState(() {
          hasLoaded = true;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: Text(
          "Select Country",
          style: textStyle(true, HEADER_SIZE, black),
        ),
        iconTheme: IconThemeData(color: black),
      ),
      body: Column(
        children: <Widget>[mainSearch(), mainPages()],
      ),
    );
  }

  mainSearch() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: <Widget>[
          Text(
            "Hello,Welcome!\nPlease choose your domicle country.",
            textAlign: TextAlign.center,
            style: textStyle(false, 14, black.withOpacity(.7)),
          ),
          addSpace(15),
          TextField(
            controller: searchController,
            onChanged: performFilter,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: light_grey.withOpacity(.1), width: .7)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: light_grey.withOpacity(.1), width: .7)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: light_grey.withOpacity(.1), width: .7)),
                hintText: "Search",
                fillColor: light_grey,
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    filtering ? Icons.clear : Icons.search,
                    size: 30,
                    color: black.withOpacity(.3),
                  ),
                  onPressed: () {
                    if (filtering) {
                      countriesList = mainCountriesList;
                      filtering = false;
                      searchController.clear();
                      setState(() {});
                      return;
                    }
                  },
                )),
          )
        ],
      ),
    );
  }

  bool filtering = false;

  void performFilter(String value) {
    String text = value.toLowerCase();
    countriesList = mainCountriesList
        .where((b) => b.getString(COUNTRY).toLowerCase().startsWith(text))
        .toList();
    //countriesList.sort((a, b) => a.getUserName().compareTo(b.getUserName()));

    countriesList
        .sort((a, b) => a.getString(COUNTRY).compareTo(b.getString(COUNTRY)));

    setState(() {
      filtering = true;
    });
  }

  mainPages() {
    if (!hasLoaded)
      return Container(
        height: screenH(context) / 2,
        child: loadingLayout(),
      );

    if (!hasLoaded && countriesList.isEmpty)
      return Container(
        height: screenH(context) / 2,
        child: emptyLayout(
            Unicons.no_entry, "No Result", "No search for country found"),
      );

    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: countriesList.length,
        itemBuilder: (ctx, p) {
          return countryLayout(p);
        },
      ),
    );
  }

  countryLayout(int p) {
    BaseModel theCountry = countriesList[p];
    String country = theCountry.getString(COUNTRY);
    String countryFlag = theCountry.getString(COUNTRY_FLAG);

    return GestureDetector(
      onTap: () {
        print(country);
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.pop(context, theCountry);
      },
      child: Container(
        padding: EdgeInsets.all(14),
        color: white,
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 60,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 1, color: light_grey)),
              child: Image.asset(
                countryFlag,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            addSpaceWidth(15),
            Text(
              country,
              style: textStyle(true, 16, black),
            ),
          ],
        ),
      ),
    );
  }
}
