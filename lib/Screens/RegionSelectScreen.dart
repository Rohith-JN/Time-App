// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'package:clock_app/controllers/WorldTimeController.dart';
import 'package:clock_app/models/WorldTime.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/standalone.dart';

class RegionSelectScreen extends StatefulWidget {
  const RegionSelectScreen({Key? key}) : super(key: key);

  @override
  _RegionSelectScreenState createState() => _RegionSelectScreenState();
}

class _RegionSelectScreenState extends State<RegionSelectScreen> {
  final WorldTimeController worldTimeController = Get.find();
  List _countries = [];
  List _filteredCountries = [];
  TextEditingController _textEditingController = TextEditingController();

  Future<void> fetchData() async {
    const url = "http://worldtimeapi.org/api/timezone";
    final respone = await get(Uri.parse(url));
    final data = jsonDecode(respone.body);

    setState(() {
      _countries = data;
    });
  }

  void _runFilter(String enteredKeyword) {
    List results = [];

    if (enteredKeyword.isEmpty) {
      results = _countries;
    } else {
      results = _countries
          .where((u) => u.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredCountries = results;
    });
  }

  var location;
  var newUrl;
  var newResponse;
  var newData;

  @override
  void initState() {
    _filteredCountries = _countries;
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: null,
            backgroundColor: Colors.grey[900],
            title: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[900],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.5),
                  child: TextField(
                      onChanged: (value) => _runFilter(value),
                      autofocus: true,
                      style: GoogleFonts.lato(color: Colors.white70),
                      controller: _textEditingController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            icon: const Center(
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _textEditingController..text = '';
                                _filteredCountries = [];
                              });
                            },
                          ),
                          hintText: 'Search...',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: InputBorder.none)),
                ),
              ),
            )),
        body: (_filteredCountries.isEmpty)
            ? Padding(
                padding: const EdgeInsets.only(top: 210.0),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search,
                        size: 160.0,
                        color: Colors.white24,
                      ),
                      Text(
                        "Search for a city",
                        style: GoogleFonts.lato(
                            fontSize: 25.0, color: Colors.white24),
                      )
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: _filteredCountries.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () async {
                            location = _filteredCountries[index];
                            newUrl =
                                "http://worldtimeapi.org/api/timezone/${location}";
                            newResponse = await get(Uri.parse(newUrl));
                            Map newData = jsonDecode(newResponse.body);
                            var time = newData['datetime'];
                            String dateTime = newData["utc_datetime"];
                            String offset = newData["utc_offset"];
                            DateTime now = DateTime.parse(dateTime);
                            now = now.add(Duration(
                                hours: int.parse(offset.substring(1, 3)),
                                minutes: int.parse(offset.substring(4))));
                            time = DateFormat.jm().format(now);
                            worldTimeController.WorldTimeList.add(
                                WorldTime(location: location, time: time));
                            Get.back();
                          },
                          child: ListTile(
                            leading: Text(
                              '${_filteredCountries[index]}',
                              style: GoogleFonts.lato(
                                  color: Colors.white70, fontSize: 15.0),
                            ),
                          ),
                        )),
              ));
  }
}
