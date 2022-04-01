// ignore_for_file: file_names

import 'package:Clock/Screens/ClockScreen.dart';
import 'package:Clock/Screens/StopWatchScreen.dart';
import 'package:Clock/Screens/WorldClockScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[800],
    ));
    return DefaultTabController(
        length: 3,
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Container(
              color: Colors.grey[800],
              height: 85.0,
              width: double.infinity,
              child: const TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        width: 5.0,
                        color: Colors.blue,
                        style: BorderStyle.solid),
                    insets: EdgeInsets.symmetric(horizontal: 30.0)),
                tabs: [
                  Tab(
                    icon: Icon(
                      FontAwesomeIcons.clock,
                      size: 20.0,
                    ),
                    text: "Clock",
                  ),
                  Tab(
                    icon: Icon(Icons.public),
                    text: "World",
                  ),
                  Tab(icon: Icon(Icons.timer), text: "Start-Stop"),
                ],
              ),
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              ClockScreen(),
              WorldClock(),
              StopWatchScreen(),
            ],
          ),
        )));
  }
}
