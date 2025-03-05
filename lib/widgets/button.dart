import 'package:flutter/material.dart';
import 'dart:math';

class Button extends StatelessWidget {
  Button({super.key, required this.text, required this.onPressed});
  final String text;
  final void Function() onPressed;

  final Map<String, Color> _buttonColors = {
    "AC": Colors.red[900]!,
    "+/-" : Colors.grey[700]!,
    "( )": Colors.grey[700]!,
    "/": Colors.orange,
    "x": Colors.orange,
    "-": Colors.orange,
    "C": Colors.red,
    "+": Colors.orange,
    "=": Colors.blue,
  };

  final Map<String, num> _buttonTextSize = {
    "AC": 4.5,
    "+/-": 4,
  };
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrain) {
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColors[text] ?? Colors.grey[900],
            textStyle: TextStyle(fontSize: min(constrain.maxHeight, constrain.maxWidth) / (_buttonTextSize[text] ?? 3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(text, style: TextStyle(color: Colors.white)),
        );
      },
    );
  }
}
