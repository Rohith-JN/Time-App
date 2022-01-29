import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Themes {
  static final theme = ThemeData(
    cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.light,
        textTheme:
            CupertinoTextThemeData(textStyle: TextStyle(color: Colors.white))),
    timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.grey[800],
        dialTextColor: Colors.white70,
        helpTextStyle: const TextStyle(color: Colors.white70),
        hourMinuteTextColor: Colors.white70,
        dayPeriodTextColor: Colors.white70,
        entryModeIconColor: Colors.white70),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    hintColor: Colors.white70,
    scaffoldBackgroundColor: Colors.grey[900],
  );
}
