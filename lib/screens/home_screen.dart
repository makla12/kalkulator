import 'package:flutter/material.dart';
import 'package:kalkulator/widgets/screen.dart';
import 'package:kalkulator/widgets/calculator_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, double Function(double a, double b)>> _operations = [
    {"x": (a, b) => a * b, "/": (a, b) => a / b},
    {"+": (a, b) => a + b, "-": (a, b) => a - b},
  ];

  String _operation = "";
  String _displayText = "";

  void _updateDisplayText() {
    setState(() {
      _displayText = _operation.replaceAll(";", "");
    });
  }

  void _clear() {
    if (_operation.isEmpty) return;

    if (_operation[_operation.length - 1] == ";") {
      _operation = _operation.substring(0, _operation.length - 3);
    } else {
      _operation = _operation = _operation.substring(0, _operation.length - 1);
    }

    _updateDisplayText();
  }

  void _clearAll() {
    _operation = "";

    _updateDisplayText();
  }

  void _enterDigit(String digit) {
    _operation += digit;

    _updateDisplayText();
  }

  void _enterDecimalPoint() {
    if ((_operation.isEmpty ? false : _operation[_operation.length - 1] == "."))
      return;
    if (_operation
        .substring(_operation.contains(";") ? _operation.lastIndexOf(";") : 0)
        .contains("."))
      return;

    _operation += ".";

    _updateDisplayText();
  }

  void _enterOperator(String operator) {
    if (_operation.isEmpty || _operation[_operation.length - 1] == ";")
      _clear();
    _operation += ";$operator;";

    _updateDisplayText();
  }

  void _negative() {
    if (_operation.contains(";") || _operation.isEmpty) return;
    if (_operation[0] == "-") {
      _operation = _operation.substring(1);
    } else {
      _operation = "-$_operation";
    }

    _updateDisplayText();
  }

  String _claculate(String operation) {
    if (operation.isEmpty || operation[operation.length - 1] == ";") return operation;
    List<String> operationList = operation.split(";");

    for (Map<String, double Function(double a, double b)> order in _operations) {
      for (int i = 0; i < operationList.length; i++) {
        if (order.keys.contains(operationList[i])) {
          String operator = operationList[i];
          double a = double.parse(operationList[i - 1]);
          double b = double.parse(operationList[i + 1]);
          double newNumber = order[operator]!(a, b);
          operationList.removeRange(i - 1, i + 2);
          i--;
          operationList.insert(i, newNumber.toString());
        }
      }
    }

    String result = operationList.single;
    
    if (double.parse(result) % 1 == 0) return double.parse(result).toStringAsFixed(0);

    return result;
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

          CalculatorGrid(buttonsData: _buttonsData),
        ],
      ),
    );
  }

  late final List<Map<String, void Function()>> _buttonsData = [
    {
      "AC": _clearAll,
      "+/-": _negative,
      "( )": () {},
      "/": () {
        _enterOperator("/");
      },
    },
    {
      "7": () {
        _enterDigit("7");
      },
      "8": () {
        _enterDigit("8");
      },
      "9": () {
        _enterDigit("9");
      },
      "x": () {
        _enterOperator("x");
      },
    },
    {
      "4": () {
        _enterDigit("4");
      },
      "5": () {
        _enterDigit("5");
      },
      "6": () {
        _enterDigit("6");
      },
      "-": () {
        _enterOperator("-");
      },
    },
    {
      "1": () {
        _enterDigit("1");
      },
      "2": () {
        _enterDigit("2");
      },
      "3": () {
        _enterDigit("3");
      },
      "+": () {
        _enterOperator("+");
      },
    },
    {
      "0": () {
        _enterDigit("0");
      },
      ".": () {
        _enterDecimalPoint();
      },
      "C": _clear,
      "=": () {
        _operation = _claculate(_operation);
        _updateDisplayText();
      },
    },
  ];
}
