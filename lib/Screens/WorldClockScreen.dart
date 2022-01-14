import 'dart:async';

import 'package:clock_app/Screens/RegionSelectScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String formattedTime = DateFormat('h:mm').format(DateTime.now());
  String hour = DateFormat('a').format(DateTime.now());
  late Timer _timer;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Padding(
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
                    padding: const EdgeInsets.only(top: 41.0, left: 10.0),
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
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 192.0, bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegionSelectScreen()));
          },
          child: const Icon(Icons.public),
        ),
      ),
    );
  }
}
