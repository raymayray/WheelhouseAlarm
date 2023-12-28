import 'package:flutter/material.dart';
import 'package:wheelhousealarm/data.dart';

class DaySelector extends StatefulWidget {
  final ValueChanged<List<bool>> onChanged;
  DaySelector({required this.onChanged, Key? key}) : super(key: key);

  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  List<bool> isSelected = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected[index] = !isSelected[index];
            });
            widget.onChanged(isSelected);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected[index] ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.white),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              _dayName(index),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }),
    );
  }

  String _dayName(int index) {
    switch (index) {
      case 0:
        return 'S';
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      default:
        return '';
    }
  }
}