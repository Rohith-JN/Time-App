// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';

class Analog_Clock extends StatefulWidget {
  const Analog_Clock({Key? key}) : super(key: key);

  @override
  _Analog_ClockState createState() => _Analog_ClockState();
}

class _Analog_ClockState extends State<Analog_Clock> {
  @override
  Widget build(BuildContext context) {
    return AnalogClock(
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      width: 292.0,
      isLive: true,
      hourHandColor: Color(0xFFDC8B8B),
      minuteHandColor: Color(0xFFDC8B8B),
      showSecondHand: true,
      showNumbers: false,
      showTicks: true,
      digitalClockColor: Colors.white,
      showDigitalClock: true,
      datetime: DateTime.now(),
    );
  }
}
