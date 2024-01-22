import 'package:flutter/material.dart';

class MyTextWidget extends StatelessWidget {
  const MyTextWidget({super.key, required this.text, this.fontSize = 16, this.fontWeight = FontWeight.normal, this.color = Colors.black});
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(fontSize: fontSize,fontWeight: fontWeight,color: color));
  }
}