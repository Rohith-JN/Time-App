import 'package:clock_app/Screens/mainScreen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MainScreen(),
    theme: ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      hintColor: Colors.white70,
      scaffoldBackgroundColor: Colors.grey[900],
    ),
  ));
}
