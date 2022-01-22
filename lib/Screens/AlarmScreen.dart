import 'dart:async';
import 'dart:developer';

import 'package:clock_app/controllers/AlarmController.dart';
import 'package:clock_app/controllers/WorldTimeController.dart';
import 'package:clock_app/models/Alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system_settings/system_settings.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final AlarmController alarmController = Get.put(AlarmController());
  bool _tileExpanded = false;
  bool _repeatExpanded = false;
  TextEditingController textEditingController =
      TextEditingController(); //textEditingController for lable

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final TimeOfDay? picked =
                                              await showTimePicker(
                                                  initialEntryMode:
                                                      TimePickerEntryMode.input,
                                                  context: context,
                                                  initialTime: TimeOfDay.now());
                                          var selectedTime =
                                              MaterialLocalizations.of(context)
                                                  .formatTimeOfDay(picked!);
                                          setState(() {
                                            alarmController.alarmList[index]
                                                .time = selectedTime;
                                          });
                                        },
                                        child: Text(
                                          alarmController.alarmList[index].time,
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
                                              alarmController.alarmList[index] =
                                                  changed;
                                            });
                                          })
                                    ],
                                  ),
                                  ExpansionTile(
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
                                            "Default",
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
                                          onTap: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                      title: TextField(
                                                        autofocus: true,
                                                        controller:
                                                            textEditingController,
                                                        decoration: const InputDecoration(
                                                            labelText: "Label",
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .blue))),
                                                      ),
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        20.0),
                                                              )),
                                                          TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  alarmController
                                                                          .alarmList[
                                                                              index]
                                                                          .label =
                                                                      textEditingController
                                                                          .text; //issue here
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                "Done",
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        20.0),
                                                              ))
                                                        ],
                                                      ),
                                                    ));
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
                                          alarmController.alarmList
                                              .removeAt(index);
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: ExpansionTile(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _dateAndTime('S', () {}),
                                                _dateAndTime('M', () {}),
                                                _dateAndTime('T', () {}),
                                                _dateAndTime('W', () {}),
                                                _dateAndTime('T', () {}),
                                                _dateAndTime('F', () {}),
                                                _dateAndTime('S', () {}),
                                              ],
                                            )
                                          ],
                                          trailing: Icon(
                                            _repeatExpanded
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          onExpansionChanged: (bool expanded) {
                                            setState(() =>
                                                _repeatExpanded = expanded);
                                          },
                                          tilePadding:
                                              const EdgeInsets.only(left: 1.0),
                                          title: Text("Repeat",
                                              style: GoogleFonts.lato(
                                                  color: Colors.white70)),
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
                                      _tileExpanded
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    onExpansionChanged: (bool expanded) {
                                      setState(() => _tileExpanded = expanded);
                                    },
                                  ),
                                  const Divider(
                                    thickness: 2.0,
                                    color: Colors.white24,
                                  )
                                ],
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
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                      initialEntryMode: TimePickerEntryMode.input,
                      context: context,
                      initialTime: TimeOfDay.now());
                  var selectedTime = MaterialLocalizations.of(context)
                      .formatTimeOfDay(picked!);
                  setState(() {
                    alarmController.alarmList.add(Alarm(
                        alarmEnabled: true,
                        time: selectedTime,
                        label: "Label"));
                  });
                  Future.delayed(Duration(milliseconds: 500), () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.only(left: 10.0, top: 10.0),
                            height: 40.0,
                            color: Colors.grey[800],
                            child: Text(
                              "Alarm set at $selectedTime",
                              style: GoogleFonts.lato(fontSize: 16.0, color: Colors.white70),
                            ),
                          );
                        });
                  });
                  Future.delayed(Duration(milliseconds: 1900), () {
                    Navigator.pop(context);
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

Widget _dateAndTime(time, callBack) {
  return GestureDetector(
    onTap: callBack,
    child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
            child: Text(time,
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 21.0))),
        width: 40.0,
        height: 40.0),
  );
}
