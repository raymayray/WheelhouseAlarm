import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:wheelhousealarm/data.dart';
import 'alarm_info.dart';
import 'alarmSetting.dart';
import 'package:intl/intl.dart';

void main() {
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Clock(),
    );
  }
}

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    final String currentTimeZone = tz.local.name;
    setState(() {
      _now = tz.TZDateTime.now(tz.getLocation(currentTimeZone));
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedTime = "${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}";
    return Scaffold(
      backgroundColor: Color(0xFF252934),
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    formattedTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 110,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 225, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _navigateToAlarmSetting,
                  icon: Icon(Icons.add, color: Colors.white, size: 30),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 200),
            child: alarmListview(),
          ),
        ],
      ),
    );
  }

  void _navigateToAlarmSetting() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmSetting(
          onSaved: () => setState(() {}),
        ),
      ),
    );
    // setState called here to refresh the list after returning from AlarmSetting
    setState(() {});
  }
}

class alarmListview extends StatefulWidget {
  const alarmListview({Key? key}) : super(key: key);

  @override
  _alarmListviewState createState() => _alarmListviewState();
}

class _alarmListviewState extends State<alarmListview> {
  List<bool> _isCheckedList = [];

  @override
  void initState() {
    super.initState();
    _isCheckedList = List.generate(alarms.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: alarms.length + 1, // Plus 1 for the 'add new alarm' button
              itemBuilder: (BuildContext context, int index) {
                if (index == alarms.length) {
                  // Render 'add new alarm' button
                  return Container(
                    child: IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AlarmSetting(onSaved: () {  },)),
                        );
                        setState(() {}); // This will rebuild the alarm list with the updated alarms list
                      },
                      icon: Icon(Icons.add_circle_rounded),
                      iconSize: 75,
                      color: Colors.white,
                    ),
                  );
                } else {
                  // Render alarm list
                  AlarmData alarm = alarms[index];
                  return Column(
                    children: [
                      Divider(height: 1, color: Color(0xFF313644)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                        height: 112,
                        decoration: BoxDecoration(color: Color(0xFF252934)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alarm.label,
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('h:mm a').format(alarm.alarmDateTime!),
                                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w700),
                                ),
                                Transform.scale(
                                  scale: 1.5,
                                  child: Switch(
                                    value: _isCheckedList[index],
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedList[index] = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.music_note, color: Colors.white, size: 10),
                                Text(
                                  alarm.sound,
                                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Color(0xFF313644)),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
