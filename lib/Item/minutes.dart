import 'package:flutter/material.dart';
import 'package:wheelhousealarm/data.dart';

class MyMinutes extends StatelessWidget {
  int mins;

  MyMinutes({required this.mins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            mins < 10 ? '0'+ mins.toString() : mins.toString(),
            style: TextStyle(
              fontFamily: 'inter',
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),),
        ),
      ),
    );
  }
}
