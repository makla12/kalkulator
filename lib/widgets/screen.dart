import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  const Screen({super.key, required this.text});
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 45),
      child:SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Text(text, style: TextStyle(fontSize: 70, color: Colors.white)),
      ),
    );
  }
}
