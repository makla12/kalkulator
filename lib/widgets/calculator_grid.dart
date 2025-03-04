import 'package:flutter/material.dart';
import 'button.dart';

class CalculatorGrid extends StatelessWidget {
  const CalculatorGrid({super.key, required this.buttonsData});
  final List<Map<String, void Function()>> buttonsData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            for(var row in buttonsData)
              Expanded(
                child:Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for(var button in row.keys)
                      Expanded(child: Button(text: button, onPressed: row[button]!))
                  ],
                ) 
              )
          ],
        ),
      ),
    );
  }
}
