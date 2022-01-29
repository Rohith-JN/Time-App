import 'dart:async';
import 'package:clock_app/services/notification_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:clock_app/controllers/AlarmController.dart';
import 'package:clock_app/models/Alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:system_settings/system_settings.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final AlarmController alarmController = Get.put(AlarmController());
  TextEditingController textEditingController = TextEditingController();

  var removedLabel;
  var removedTime;
  var switchEnabled;
  var id;
  int selected = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      key: Key('builder ${selected.toString()}'),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, left: 10.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0),
                                  color: (index == selected)
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
                                                currentTime: DateTime.now()
                                                    .add(Duration(minutes: 5)),
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
                                              tz.TZDateTime finalTime =
                                                  tz.TZDateTime.from(
                                                      time, tz.local);
                                              setState(() {
                                                alarmController.alarmList[index]
                                                    .time = selectedTime;
                                                alarmController.alarmList[index]
                                                    .alarmEnabled = true;
                                              });
                                              showNotification(finalTime);
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
                                                            const EdgeInsets
                                                                    .only(
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
                                              if (alarmController
                                                      .alarmList[index]
                                                      .alarmEnabled ==
                                                  false) {
                                                NotificationService()
                                                    .flutterLocalNotificationsPlugin
                                                    .cancel(alarmController
                                                        .alarmList[index].id);
                                              } else {}
                                            })
                                      ],
                                    ),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        key: Key(index.toString()),
                                        initiallyExpanded: index == selected,
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
                                                showBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                TextButton(
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        alarmController
                                                                            .alarmList[index]
                                                                            .label = textEditingController.text;
                                                                      });
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        "Done"))
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                      top: 20.0,
                                                                      left: 10.0,
                                                                      right: 10.0
                                                              ),
                                                              child: TextField(
                                                                maxLength: 25,
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .white),
                                                                controller:
                                                                    textEditingController,
                                                                autofocus: true,
                                                                decoration: const InputDecoration(
                                                                    labelText:
                                                                        "Label",
                                                                    border: OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.blue))),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        height: 180.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .grey[800]),
                                                      );
                                                    });
                                              },
                                              child: Text(
                                                (alarmController
                                                        .alarmList[index]
                                                        .label
                                                        .isEmpty)
                                                    ? "Alarm"
                                                    : alarmController
                                                        .alarmList[index].label,
                                                style: GoogleFonts.lato(
                                                    color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              NotificationService()
                                                  .flutterLocalNotificationsPlugin
                                                  .cancel(alarmController
                                                      .alarmList[index].id);
                                              setState(() {
                                                removedTime = alarmController
                                                    .alarmList[index].time;
                                                removedLabel = alarmController
                                                    .alarmList[index].label;
                                                switchEnabled = alarmController
                                                    .alarmList[index]
                                                    .alarmEnabled;
                                                id = alarmController
                                                    .alarmList[index].id;
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
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
                                                              style: GoogleFonts.lato(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .white70),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  alarmController
                                                                      .alarmList
                                                                      .add(Alarm(
                                                                          time:
                                                                              removedTime,
                                                                          label:
                                                                              removedLabel,
                                                                          alarmEnabled:
                                                                              switchEnabled,
                                                                          id: id));
                                                                },
                                                                child: Text(
                                                                  "Undo",
                                                                  style: GoogleFonts.lato(
                                                                      fontSize:
                                                                          17.0),
                                                                ))
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              });
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1900), () {
                                                Navigator.pop(_scaffoldKey
                                                    .currentContext!);
                                              });
                                              selected = -1;
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
                                          const Opacity(
                                            opacity: 0.5,
                                            child: Divider(
                                              thickness: 2.0,
                                              color: Colors.white24,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: ListTile(
                                              trailing: Switch(
                                                value: alarmController
                                                    .alarmList[index].repeat,
                                                inactiveThumbColor:
                                                    Colors.white,
                                                inactiveTrackColor: Colors.grey,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    var changed =
                                                        alarmController
                                                            .alarmList[index];
                                                    changed.repeat = value;
                                                    alarmController
                                                            .alarmList[index] =
                                                        changed;
                                                  });
                                                },
                                              ),
                                              minLeadingWidth: 30.0,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              leading: const Icon(
                                                Icons.calendar_today,
                                                size: 23.0,
                                                color: Colors.white70,
                                              ),
                                              title: Text(
                                                "Repeat daily",
                                                style: GoogleFonts.lato(
                                                    color: Colors.white70),
                                              ),
                                            ),
                                          ),
                                        ],
                                        tilePadding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        title: Text(
                                          getExpansionTitleInfo(
                                              alarmController
                                                  .alarmList[index].repeat,
                                              alarmController
                                                  .alarmList[index].label),
                                          style: GoogleFonts.lato(
                                              color: Colors.white70),
                                        ),
                                        trailing: Icon(
                                          index == selected
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                        onExpansionChanged: (bool expanded) {
                                          Duration(milliseconds: 500);
                                          if (expanded) {
                                            setState(() {
                                              selected = index;
                                            });
                                          } else {
                                            setState(() {
                                              selected = -1;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          (index == selected) ? false : true,
                                      child: const Divider(
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            onPressed: () {
              DatePicker.showTime12hPicker(context,
                  currentTime: DateTime.now().add(Duration(minutes: 5)),
                  theme: const DatePickerTheme(
                      cancelStyle: TextStyle(color: Colors.white),
                      backgroundColor: Color(0xFF424242),
                      containerHeight: 220.0,
                      itemStyle: TextStyle(color: Colors.white)),
                  onConfirm: (time) {
                String selectedTime = DateFormat.jm().format(time);
                tz.TZDateTime finalTime = tz.TZDateTime.from(time, tz.local);
                setState(() {
                  alarmController.alarmList.add(Alarm(
                      id: UniqueKey().hashCode,
                      time: selectedTime,
                      label: "Alarm",
                      repeat: false,
                      alarmEnabled: true));
                });
                if (finalTime.isBefore(tz.TZDateTime.now(tz.local))) {
                  var newTime = finalTime.add(Duration(days: 1));
                  showNotification(newTime);
                } else {
                  showNotification(finalTime);
                }
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
                            finalTime.isBefore(tz.TZDateTime.now(tz.local))
                                ? "Alarm set at $selectedTime tomorrow"
                                : "Alarm set at $selectedTime",
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
    );
  }
}

showNotification(time) {
  AlarmController alarmController = Get.put(AlarmController());
  for (var i = 0; i < alarmController.alarmList.length; i++) {
    NotificationService().showNotification(alarmController.alarmList[i].id,
        'Clock', alarmController.alarmList[i].label, time);
  }
}

getExpansionTitleInfo(repeat, label) {
  if (repeat == true && label == '') {
    return 'Alarm,  Everyday';
  } else if (repeat == false && label == '') {
    return 'Alarm';
  } else if (repeat == true && label != '') {
    return '${label},  Everyday';
  } else if (repeat == false && label != '') {
    return '${label}';
  }
}
