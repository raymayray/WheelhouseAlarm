import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wheelhousealarm/Item/lable.dart'; // Ensure all your imports are valid and required
import 'Item/am_pm.dart';
import 'Item/hours.dart';
import 'Item/minutes.dart';
import 'Item/snooze.dart';
import 'Item/weekday.dart';
import 'Item/sound.dart';
import 'alarm_info.dart';
import 'data.dart';

class AlarmSetting extends StatefulWidget {
  final VoidCallback onSaved;
  const AlarmSetting({Key? key, required this.onSaved}) : super(key: key);


  @override
  _AlarmSettingState createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  List<AlarmData> alarms = []; // Define the alarms list here
  List<bool> _selectedDays = [false, false, false, false, false, false, false];
  DateTime? selectedTime;
  String selectedSound = 'January'; // Default sound
  int selectedSnooze = 5;
  String? selectedLabel = 'Alarm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252934),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: SizedBox(
                    height: 30,), // This SizedBox seems unnecessary. You may consider removing it.
                ),
                Text(
                  'Set Your Alarm',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            AlarmPicker(
                onTimeChanged: (time) {
                  setState(() {
                    selectedTime = time;
                  });
                }
            ),
            SizedBox(height: 30,),
            DaySelector(
              onChanged: (selectedDays) {
                _selectedDays = selectedDays;
              },
            ),
            SizedBox(height: 25,),
            SoundSelector(
              onSoundSelected: (sound) {
                setState(() {
                  selectedSound = sound;
                });
              },
            ),
            SnoozeOption(
              onSnoozeSelected: (snoozeDuration) {
                setState(() {
                  selectedSnooze = snoozeDuration;
                });
              },
            ),
            SizedBox(height: 10,),
            LabelSelector(
              defaultLabel: selectedLabel!,
              onLabelChanged: (newLabel) {
                setState(() {
                  selectedLabel = newLabel;
                });
              },
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: saveAlarm,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveAlarm() {
    if (selectedTime != null) {
      final newAlarm = AlarmData(
        alarmDateTime: selectedTime,
        label: selectedLabel ?? 'Alarm',
        sound: selectedSound ?? 'Default Sound',
        snoozeDuration: selectedSnooze ?? 0,
        days: _selectedDays,
      );
      print(selectedTime);
      print(selectedLabel);
      print(selectedSound);
      print(selectedSnooze);
      print(_selectedDays);


      alarms.add(newAlarm); // Add to the global alarms list
      widget.onSaved(); // Trigger the callback
      Navigator.pop(context, true); // Go back to the previous screen
    }
  }
}


class AlarmPicker extends StatefulWidget {
  final Function(DateTime time) onTimeChanged;

  const AlarmPicker({Key? key, required this.onTimeChanged}) : super(key: key);

  @override
  _AlarmPickerState createState() => _AlarmPickerState();
}

class _AlarmPickerState extends State<AlarmPicker> {
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController amPmController;
  int? lastHour;

  List<int> extendedHours = List<int>.generate(1000, (index) => index % 12 + 1);
  List<int> extendedMinutes = List<int>.generate(6000, (index) => index % 60);

  late bool isAm;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    int currentHour = now.hour;
    isAm = currentHour < 12;
    currentHour = currentHour % 12;
    currentHour = currentHour == 0 ? 12 : currentHour; // Convert 0 to 12 for 12 AM
    lastHour = currentHour;  // Set the lastHour during initialization
    int currentMinute = now.minute;

    int initialHourPosition = (extendedHours.length ~/ 2)
        - (extendedHours.length ~/ 2) % 12
        + currentHour - 1; // Subtract 1 to adjust index

    int initialMinutePosition = (extendedMinutes.length ~/ 2)
        - (extendedMinutes.length ~/ 2) % 60
        + currentMinute;

    hourController = FixedExtentScrollController(
      initialItem: initialHourPosition,
    );

    minuteController = FixedExtentScrollController(
      initialItem: initialMinutePosition,
    );

    amPmController = FixedExtentScrollController(
      initialItem: isAm ? 0 : 1,
    );

    hourController.addListener(_handleHourScroll);
    minuteController.addListener(_handleMinuteScroll);
    amPmController.addListener(_handleAmPmChange);
  }

  void _handleHourScroll() {
    int currentHour = extendedHours[hourController.selectedItem!];

    if ((lastHour == 11 && currentHour == 12) || (lastHour == 12 && currentHour == 11)) {
      setState(() {
        isAm = !isAm;
        amPmController.jumpToItem(isAm ? 0 : 1);
      });
    }

    lastHour = currentHour;
    _notifyParentWidgetAboutTimeChange();
  }

  void _handleMinuteScroll() {
    if (minuteController.position.userScrollDirection == ScrollDirection.idle) {
      int currentMinute = extendedMinutes[minuteController.selectedItem!];
      int middlePosition = extendedMinutes.length ~/ 2;
      int difference = middlePosition % 60;
      minuteController.jumpToItem(middlePosition - difference + currentMinute);
    }
    _notifyParentWidgetAboutTimeChange();
  }

  void _handleAmPmChange() {
    if (amPmController.selectedItem != null) {
      setState(() {
        isAm = amPmController.selectedItem == 0;
      });
      _notifyParentWidgetAboutTimeChange();
    }
  }

  void _notifyParentWidgetAboutTimeChange() {
    int currentHour = extendedHours[hourController.selectedItem!];
    int selectedMinute = extendedMinutes[minuteController.selectedItem!];
    DateTime selectedTime = DateTime(
      DateTime.now().year,  // Use the current year
      DateTime.now().month, // Use the current month
      DateTime.now().day,   // Use the current day
      isAm ? currentHour : currentHour + 12, // Convert to 24-hour format if PM
      selectedMinute,
    );
    widget.onTimeChanged(selectedTime);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Color(0xFF252934),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                child: ListWheelScrollView.useDelegate(
                  controller: amPmController,
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 2,
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildListDelegate(
                    children: [
                      AmPm(isItAm: true),
                      AmPm(isItAm: false),
                    ],
                  ),
                ),
              ),
              Container(
                width: 70,
                child: ListWheelScrollView(
                  controller: hourController,
                  itemExtent: 50,
                  perspective: 0.001,
                  diameterRatio: 4,
                  physics: FixedExtentScrollPhysics(),
                  children: extendedHours.map((hour) => MyHours(hours: hour)).toList(),
                ),
              ),
              Text(
                ':',
                style: TextStyle(
                    color: Colors.white, fontSize: 40, fontWeight: FontWeight.w600),
              ),
              Container(
                width: 70,
                child: ListWheelScrollView(
                  controller: minuteController,
                  itemExtent: 50,
                  perspective: 0.001,
                  diameterRatio: 4,
                  physics: FixedExtentScrollPhysics(),
                  children: extendedMinutes.map((min) => MyMinutes(mins: min)).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    hourController.removeListener(_handleHourScroll);
    minuteController.removeListener(_handleMinuteScroll);
    amPmController.removeListener(_handleAmPmChange);
    hourController.dispose();
    minuteController.dispose();
    amPmController.dispose();
    super.dispose();
  }
}
