import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:clock_app/models/WorldTime.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTimeController extends GetxController {
  var WorldTimeList = <WorldTime>[].obs;
  var newUrl;
  var newResponse;

  Future<String> getTime(location) async {
    newUrl = "http://worldtimeapi.org/api/timezone/$location";
    newResponse = await get(Uri.parse(newUrl));
    Map newData = jsonDecode(newResponse.body);
    var time = newData['datetime'];
    String dateTime = newData["utc_datetime"];
    String offset = newData["utc_offset"];
    DateTime now = DateTime.parse(dateTime);
    now = now.add(Duration(
        hours: int.parse(offset.substring(1, 3)),
        minutes: int.parse(offset.substring(4))));
    final newtime = DateFormat.jm().format(now);
    log('$newtime - $location');
    update(['clockid']);
    return newtime;
  }

  @override
  void onInit() {
    List? storedWorldTime = GetStorage().read<List>('WorldTime');

    if (storedWorldTime != null) {
      WorldTimeList.assignAll(
          storedWorldTime.map((e) => WorldTime.fromJson(e)).toList());
    }
    ever(WorldTimeList, (_) {
      GetStorage().write('WorldTime', WorldTimeList.toList());
    });
    super.onInit();
  }
}
