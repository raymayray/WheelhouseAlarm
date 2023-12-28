import 'package:flutter/material.dart';
import 'package:wheelhousealarm/data.dart';

class AmPm extends StatelessWidget {
  final bool isItAm;


  const AmPm({required this.isItAm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            isItAm ? 'AM' : 'PM',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
