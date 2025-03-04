import 'package:flutter/material.dart';
import 'button.dart';

class CalculatorGrid extends StatelessWidget {
  const CalculatorGrid({super.key, required this.buttonsData});
  final Map<String, void Function()> buttonsData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            for (var button in buttonsData.keys)
              Button(text: button, onPressed: buttonsData[button]!),
          ],
        ),
      ),
    );
  }
}
