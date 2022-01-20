import 'package:timezone/timezone.dart';
import 'package:timezone/standalone.dart';

class WorldTime {
  String location;
  
  WorldTime({required this.location});

  factory WorldTime.fromJson(Map<String, dynamic> json) =>
      WorldTime(location: json['location']);

  Map<String, dynamic> toJson() => {
        'location': location,
        
      };
}
