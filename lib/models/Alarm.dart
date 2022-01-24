class Alarm {
  bool alarmEnabled;
  bool expanded;
  String time;
  String label;

  Alarm({this.alarmEnabled = false, required this.time, required this.label, this.expanded = false});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
      alarmEnabled: json['alarmEnabled'],
      time: json['time'],
      expanded: json['expanded'],
      label: json['time']);

  Map<String, dynamic> toJson() =>
      {'alarmEnabled': alarmEnabled, 'time': time, 'label': label, 'expanded' : expanded};
}
