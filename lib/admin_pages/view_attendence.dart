import 'package:flutter/material.dart';
import 'package:ffa_app/main.dart';

class ViewAttendence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ReturnButton(),
        ]
      ),
    );
  }
}