import 'dart:async';

import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
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

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var timeZoneString =
        DateTime.now().timeZoneOffset.toString().split('').first;
    var offsetSign = '';
    if (!timeZoneString.startsWith('-')) offsetSign = '+';
    
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SingleChildScrollView(
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
                    padding:
                        EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                    child: Divider(
                      color: Colors.white,
                      height: 2.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: AnalogClock(
                decoration: BoxDecoration(
                    border: Border.all(width: 5.0, color: Colors.white),
                    color: Colors.transparent,
                    shape: BoxShape.circle),
                isLive: true,
                height: 400,
                width: 500,
                hourHandColor: Colors.white,
                minuteHandColor: Colors.white,
                showSecondHand: true,
                numberColor: Colors.white,
                secondHandColor: Colors.blue,
                showDigitalClock: false,
                tickColor: Colors.white,
                showNumbers: true,
                showAllNumbers: true,
                textScaleFactor: 1.4,
                showTicks: true,
                datetime: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
