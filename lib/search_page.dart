// Search Page
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List countries;
  late final List _searchResult = [];
  String selectCountry = '';

  TextEditingController controller = TextEditingController();

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/json/countries.json');
    setState(() {
      countries = json.decode(jsonText);
    });
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    countries = [];
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets/images/cities.jpg",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      ClipRRect(
        // Clip it cleanly.
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.grey.withOpacity(0.1),
            alignment: Alignment.center,
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            // The search area here
            title:



            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: TextField(
                  controller: controller,
                  onChanged: onSearchTextChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        onSearchTextChanged('');
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              const SizedBox(
                height: 120,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)),
                  child: _searchResult.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _searchResult.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                selectCountry = _searchResult[index]["name"];
                                print("selectCountry : $selectCountry");

                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) => WeatherAppCurrentPage(selectCity: selectCountry)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_searchResult[index]["name"]}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: countries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                selectCountry = countries[index]["name"];
                                print("selectCountry : $selectCountry");

                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) => WeatherAppCurrentPage(selectCity: selectCountry)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${countries[index]["name"]}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {
      });
      return;
    }

    for (var country in countries) {
      if (country["name"].toLowerCase().contains(text.toLowerCase())) _searchResult.add(country);
    }

    setState(() {


    });
  }
}
