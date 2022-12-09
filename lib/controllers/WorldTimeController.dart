import "package:clock_app/models/WorldTime.dart";
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WorldTimeController extends GetxController {
  var WorldTimeList = <WorldTime>[].obs;

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
