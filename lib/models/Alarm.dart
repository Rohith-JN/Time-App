class Alarm {
  bool alarmEnabled;
  String time;
  String label;

  Alarm({this.alarmEnabled = false, required this.time, required this.label});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
      alarmEnabled: json['alarmEnabled'],
      time: json['time'],
      label: json['time']);

  Map<String, dynamic> toJson() =>
      {'alarmEnabled': alarmEnabled, 'time': time, 'label': label};
}
