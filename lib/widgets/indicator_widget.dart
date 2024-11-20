import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndicatorWidget extends StatelessWidget {
  final Color color;
  final String text;

  IndicatorWidget({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}