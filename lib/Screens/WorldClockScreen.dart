import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:clock_app/Screens/RegionSelectScreen.dart';
import 'package:clock_app/controllers/WorldTimeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WorldClock extends StatefulWidget {
  const WorldClock({Key? key}) : super(key: key);

  @override
  _WorldClockState createState() => _WorldClockState();
}

class _WorldClockState extends State<WorldClock> {
  final WorldTimeController worldTimeController =
      Get.put(WorldTimeController());
  String formattedTime = DateFormat('h:mm').format(DateTime.now());
  String hour = DateFormat('a').format(DateTime.now());
  late Timer _timer;
  var location;
  var time;

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
  }

  void _update() {
    setState(() {
      formattedTime = DateFormat('h:mm').format(DateTime.now());
      hour = DateFormat('a').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  var newUrl;
  var newResponse;

  Future<dynamic> getTime(location) async {
    newUrl = "http://worldtimeapi.org/api/timezone/$location";
    newResponse = await get(Uri.parse(newUrl));
    Map newData = jsonDecode(newResponse.body);
    var time = newData['datetime'];
    String dateTime = newData["utc_datetime"];
    String offset = newData["utc_offset"];
    DateTime now = DateTime.parse(dateTime);
    now = now.add(Duration(
        hours: int.parse(offset.substring(1, 3)),
        minutes: int.parse(offset.substring(4))));
    String newtime = DateFormat.jm().format(now);
    return newtime;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(formattedTime,
                        style: GoogleFonts.lato(
                            fontSize: 80.0,
                            color: Colors.blue,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 5.0)),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 5.0),
                      child: Text(
                        hour,
                        style: GoogleFonts.lato(
                          color: Colors.blue,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  DateFormat('EE,  MMM d').format(DateTime.now()),
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 20.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                child: Divider(
                  color: Colors.white,
                  height: 2.0,
                ),
              ),
              Container(
                height: 600.0,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 29.0, right: 29.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: worldTimeController.WorldTimeList.length,
                    itemBuilder: (BuildContext context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: FutureBuilder(
                          future: getTime(worldTimeController
                              .WorldTimeList[index].location),
                          builder: (context, AsyncSnapshot snapshot) {
                            return Slidable(
                              startActionPane: ActionPane(
                                  extentRatio: 0.20,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (v) {
                                        worldTimeController.WorldTimeList
                                            .removeAt(index);
                                      },
                                      spacing: 15.0,
                                      label: 'Delete',
                                      backgroundColor: Colors.redAccent,
                                    )
                                  ]),
                              child: ListTile(
                                  leading: Container(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minWidth: 10.0, maxWidth: 300.0),
                                      child: Text(
                                          worldTimeController
                                              .WorldTimeList[index].location,
                                          style: GoogleFonts.lato(
                                              color: Colors.white70,
                                              fontSize: 23)),
                                    ),
                                  ),
                                  trailing: Text(
                                    '${snapshot.data}',
                                    style: GoogleFonts.lato(
                                        color: Colors.white, fontSize: 35.0),
                                  )),
                            );
                          }),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            onPressed: () {
              Get.to(() => const RegionSelectScreen());
            },
            child: const Icon(Icons.public),
          ),
        ),
      ),
    );
  }
}
