import 'dart:async';
import 'dart:developer';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:clock_app/controllers/AlarmController.dart';
import 'package:clock_app/models/Alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:system_settings/system_settings.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final AlarmController alarmController = Get.put(AlarmController());
  bool _repeatExpanded = false;
  TextEditingController textEditingController = TextEditingController();

  var removedLabel;
  var removedTime;
  var switchEnabled;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Obx(
          () => Container(
            child: (alarmController.alarmList.isEmpty)
                ? Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.notifications_off,
                            size: 100.0,
                            color: Colors.white38,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "No Alarms",
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 20.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0),
                                  color: (alarmController
                                          .alarmList[index].expanded)
                                      ? Colors.grey[850]
                                      : Colors.transparent),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            DatePicker.showTime12hPicker(
                                                context,
                                                theme: const DatePickerTheme(
                                                    cancelStyle: TextStyle(
                                                        color: Colors.white),
                                                    backgroundColor:
                                                        Color(0xFF424242),
                                                    containerHeight: 220.0,
                                                    itemStyle: TextStyle(
                                                        color: Colors.white)),
                                                onConfirm: (time) {
                                              var selectedTime =
                                                  DateFormat.jm().format(time);
                                              setState(() {
                                                alarmController.alarmList[index]
                                                    .time = selectedTime;
                                              });
                                              Future.delayed(
                                                  Duration(milliseconds: 500),
                                                  () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0,
                                                                top: 10.0),
                                                        height: 40.0,
                                                        child: Text(
                                                          "Alarm set at $selectedTime",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .white70),
                                                        ),
                                                      );
                                                    });
                                              });
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1900), () {
                                                Navigator.pop(context);
                                              });
                                            });
                                          },
                                          child: Text(
                                            alarmController
                                                .alarmList[index].time,
                                            style: GoogleFonts.lato(
                                                color: (alarmController
                                                        .alarmList[index]
                                                        .alarmEnabled)
                                                    ? Colors.blue
                                                    : Colors.white70,
                                                fontSize: 38.0),
                                          ),
                                        ),
                                        Switch(
                                            value: alarmController
                                                .alarmList[index].alarmEnabled,
                                            inactiveThumbColor: Colors.white,
                                            inactiveTrackColor: Colors.grey,
                                            onChanged: (value) {
                                              setState(() {
                                                var changed = alarmController
                                                    .alarmList[index];
                                                changed.alarmEnabled = value;
                                                alarmController
                                                    .alarmList[index] = changed;
                                              });
                                            })
                                      ],
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        initiallyExpanded: alarmController
                                            .alarmList[index].expanded,
                                        backgroundColor: Colors.transparent,
                                        children: [
                                          ListTile(
                                            minLeadingWidth: 30.0,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0.0),
                                            leading: const Icon(
                                              Icons.notifications_active,
                                              color: Colors.white70,
                                            ),
                                            title: GestureDetector(
                                              onTap: SystemSettings.sound,
                                              child: Text(
                                                "Sound",
                                                style: GoogleFonts.lato(
                                                    color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            minLeadingWidth: 30.0,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0.0),
                                            leading: const Icon(
                                              Icons.label_outline,
                                              color: Colors.white70,
                                            ),
                                            title: GestureDetector(
                                              onTap: () {                              
                                              },
                                              child: Text(
                                                (alarmController.alarmList[index]
                                                        .label.isEmpty)
                                                    ? "Label"
                                                    : alarmController
                                                        .alarmList[index].label,
                                                style: GoogleFonts.lato(
                                                    color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                removedTime = alarmController
                                                    .alarmList[index].time;
                                                removedLabel = alarmController
                                                    .alarmList[index].label;
                                                switchEnabled = alarmController
                                                    .alarmList[index]
                                                    .alarmEnabled;
                                                alarmController.alarmList
                                                    .removeAt(index);
                                              });
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500),
                                                  () async {
                                                await showModalBottomSheet(
                                                    context: _scaffoldKey
                                                        .currentContext!,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[800],
                                                        ),
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 10.0,
                                                                top: 4.0),
                                                        height: 40.0,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Deleted the task",
                                                              style: GoogleFonts
                                                                  .lato(
                                                                      fontSize:
                                                                          16.0,
                                                                      color: Colors
                                                                          .white70),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  alarmController.alarmList.add(Alarm(
                                                                      time:
                                                                          removedTime,
                                                                      label:
                                                                          removedLabel,
                                                                      alarmEnabled:
                                                                          switchEnabled,
                                                                      expanded:
                                                                          true));
                                                                },
                                                                child:
                                                                    Text("Undo"))
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              });
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1900), () {
                                                Navigator.pop(
                                                    _scaffoldKey.currentContext!);
                                              });
                                            },
                                            child: ListTile(
                                              minLeadingWidth: 30.0,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              leading: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.white70,
                                              ),
                                              title: Text(
                                                "Delete",
                                                style: GoogleFonts.lato(
                                                    color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                          Opacity(
                                            opacity: 0.5,
                                            child: const Divider(
                                              thickness: 2.0,
                                              color: Colors.white24,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: ListTile(
                                              minLeadingWidth: 30.0,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              leading: const Icon(
                                                Icons.calendar_today,
                                                color: Colors.white70,
                                              ),
                                              title: Text(
                                                "Repeat",
                                                style: GoogleFonts.lato(
                                                    color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                        ],
                                        tilePadding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        title: Text(
                                          "Today",
                                          style: GoogleFonts.lato(
                                              color: Colors.white70),
                                        ),
                                        trailing: Icon(
                                          alarmController
                                                  .alarmList[index].expanded
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                        onExpansionChanged: (bool expanded) {
                                          setState(() => alarmController
                                              .alarmList[index]
                                              .expanded = expanded);
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: (alarmController.alarmList[index].expanded) ? false : true,
                                      child: Divider(
                                          thickness: 2.0,
                                          color: Colors.white24,
                                        ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: alarmController.alarmList.length,
                    ),
                  ),
          ),
        ),
        floatingActionButton: Container(
          height: 90.0,
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 29.0, bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () {
                  DatePicker.showTime12hPicker(context,
                      theme: const DatePickerTheme(
                          cancelStyle: TextStyle(color: Colors.white),
                          backgroundColor: Color(0xFF424242),
                          containerHeight: 220.0,
                          itemStyle: TextStyle(color: Colors.white)),
                      onConfirm: (time) {
                    var selectedTime = DateFormat.jm().format(time);
                    setState(() {
                      alarmController.alarmList.add(Alarm(
                          time: selectedTime,
                          label: "Label",
                          expanded: true,
                          alarmEnabled: true));
                    });
                    Future.delayed(Duration(milliseconds: 500), () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                              ),
                              padding: EdgeInsets.only(left: 10.0, top: 10.0),
                              height: 40.0,
                              child: Text(
                                "Alarm set at $selectedTime",
                                style: GoogleFonts.lato(
                                    fontSize: 16.0, color: Colors.white70),
                              ),
                            );
                          });
                    });
                    Future.delayed(const Duration(milliseconds: 1900), () {
                      Navigator.pop(context);
                    });
                  });
                },
                child: const Icon(Icons.add, size: 30.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}