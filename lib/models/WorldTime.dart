import 'package:timezone/timezone.dart';
import 'package:timezone/standalone.dart';

class WorldTime {
  String? location;
  String? time;
  WorldTime({this.location, this.time});

  factory WorldTime.fromJson(Map<String, dynamic> json) => WorldTime(
    location: json['location'],
    time: json['time']
  );

  Map<String, dynamic> toJson() => {
        'location': location,
        'time': time,
      };
}
