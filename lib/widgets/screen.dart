import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  const Screen({super.key, required this.text});
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(10),
      child: Text(text, style: TextStyle(fontSize: 50, color: Colors.white)),
    );
  }
}
