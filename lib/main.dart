import 'package:clock_app/Screens/mainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await GetStorage.init();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MainScreen(),
    theme: ThemeData(
      cupertinoOverrideTheme: const CupertinoThemeData(
          brightness: Brightness.light,
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(color: Colors.white))),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.grey[800],
        dialTextColor: Colors.white70,
        helpTextStyle: TextStyle(color: Colors.white70),
        hourMinuteTextColor: Colors.white70,
        dayPeriodTextColor: Colors.white70,
        entryModeIconColor: Colors.white70
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      hintColor: Colors.white70,
      scaffoldBackgroundColor: Colors.grey[900],
    ),
  ));
}
