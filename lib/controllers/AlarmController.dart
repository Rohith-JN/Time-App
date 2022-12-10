import 'package:clock_app/models/Alarm.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AlarmController extends GetxController {
  var alarmList = <Alarm>[].obs;

  @override
  void onInit() {
    List? storedAlarms = GetStorage().read<List>('Alarm');

    if (storedAlarms != null) {
      alarmList.assignAll(storedAlarms.map((e) => Alarm.fromJson(e)).toList());
    }
    ever(alarmList, (_) {
      GetStorage().write('Alarm', alarmList.toList());
    });
    super.onInit();
  }
}
