import 'package:flutter/material.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _buttonColors[text] ?? Colors.grey[900],
        alignment: Alignment.center,
        textStyle: TextStyle(fontSize: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}