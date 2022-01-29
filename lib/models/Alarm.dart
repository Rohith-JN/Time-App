class Alarm {
  bool alarmEnabled;
  bool repeat;
  String time;
  String label;
  int id;

  Alarm(
      {this.alarmEnabled = false,
      this.repeat = false,
      required this.time,
      required this.id,
      required this.label,
      });

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
      id: json['id'],
      repeat: json['repeat'],
      alarmEnabled: json['alarmEnabled'],
      time: json['time'],
      label: json['time']);

  Map<String, dynamic> toJson() => {
        'repeat': repeat,
        'id': id,
        'alarmEnabled': alarmEnabled,
        'time': time,
        'label': label,
      };
}
