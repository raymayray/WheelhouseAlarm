import 'package:wheelhousealarm/data.dart';

class AlarmData {
  int? id;
  String label;
  DateTime? alarmDateTime;
  String sound;
  int snoozeDuration;
  List<bool> days; // To store the selection of days

  AlarmData({
    this.id,
    required this.label,
    required this.alarmDateTime,
    required this.sound,
    required this.snoozeDuration,
    required this.days,
  });

  factory AlarmData.fromMap(Map<String, dynamic> json) => AlarmData(
    id: json["id"],
    label: json["label"] ?? 'Alarm',
    alarmDateTime: json["alarmDateTime"] != null
        ? DateTime.parse(json["alarmDateTime"])
        : null,
    sound: json["sound"],
    snoozeDuration: json["snoozeDuration"],
    days: json["days"].cast<bool>(), // Assuming `days` is stored as a list of booleans
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "label": label,
    "alarmDateTime": alarmDateTime?.toIso8601String(),
    "sound": sound,
    "snoozeDuration": snoozeDuration,
    "days": days,
  };
}