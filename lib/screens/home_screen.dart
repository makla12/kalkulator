import 'package:flutter/material.dart';
import 'package:kalkulator/widgets/screen.dart';
import 'package:kalkulator/widgets/calculator_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _operation = "";
  String _displayText = "";

  void updateDisplayText(){
    setState(() {
      _displayText = _operation.replaceAll(";", "");
    });
  }

  void _clear() {
    if (_operation[_operation.length - 1] == ";") {
      _operation = _operation.substring(0, _operation.length - 3);
    } else {
      _operation = _operation = _operation.substring(0, _operation.length - 1);
    }

    updateDisplayText();
  }

  void _clearAll(){
    _operation = "";

    updateDisplayText();
  }

  void _enterDigit(String digit) {
    if(digit == "." && _operation[_operation.length - 1] == ".") return;
    _operation += digit;

    updateDisplayText();
  }

  void _enterOperator(String operator) {
    if(_operation.isEmpty || _operation[_operation.length - 1] == ";") _clear();
    _operation += ";$operator;";

    updateDisplayText();
  }

  void _negative(){
    if (_operation.contains(";") || _operation.isEmpty) return;
    if (_operation[0] == "-") {
      _operation = _operation.substring(1);
    } else {
      _operation = "-$_operation";
    }

    updateDisplayText();
  }

  void _claculate(String operation){
    print(operation.split(";"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.white),
        title: Text("Calculator"),
      ),

      body: Column(
        children: <Widget>[
          Screen(text: _displayText),

          CalculatorGrid(buttonsData: _buttonsData)
        ],
      ),
    );
  }

  late final Map<String, void Function()> _buttonsData = {
    "AC": _clearAll, "C": _clear, "( )": () {}, "/": () {_enterOperator("/");},
    "7": (){_enterDigit("7");}, "8": () {_enterDigit("8");}, "9": () {_enterDigit("9");}, "x": () {_enterOperator("x");},
    "4": () {_enterDigit("4");}, "5": () {_enterDigit("5");}, "6": () {_enterDigit("6");}, "-": () {_enterOperator("-");},
    "1": () {_enterDigit("1");}, "2": () {_enterDigit("2");}, "3": () {_enterDigit("3");}, "+": () {_enterOperator("+");},
    "+/-": _negative, "0": () {_enterDigit("0");}, ".": () {_enterDigit(".");}, "=": (){_claculate(_operation);},
  };
}
