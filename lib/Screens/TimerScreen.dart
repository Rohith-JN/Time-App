import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      child: Center(
          child: CupertinoTheme(
        data: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(color: Colors.white70))),
        child: CupertinoTimerPicker(
          onTimerDurationChanged: (Duration value) {},
          mode: CupertinoTimerPickerMode.hms,
        ),
      )),
      width: 350.0,
      height: 450.0,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5.0),
          shape: BoxShape.circle),
    )));
  }
}
