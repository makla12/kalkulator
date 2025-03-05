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
  bool _error = false;
  bool _isResult = false;

  void _updateDisplayText() {
    setState(() {
      _displayText = _operation.replaceAll(";", "");
    });
  }

  void _clear() {
    if(_isResult || _error) _clearAll();

    if (_operation.isEmpty) return;

    if (_operation.endsWith(";")) {
      _operation = _operation.substring(0, _operation.length - 3);
    } else {
      _operation = _operation = _operation.substring(0, _operation.length - 1);
    }

    _updateDisplayText();
  }

  void _clearAll() {
    _operation = "";
    _isResult = false;
    _error = false;

    _updateDisplayText();
  }

  void _enterDigit(String digit) {
    if(_isResult || _error) _clearAll();
    if(_operation.endsWith(")")) _operation += ";x;";
    _operation += digit;

    _updateDisplayText();
  }

  void _enterDecimalPoint() {
    if(_isResult || _error) _clearAll();
    if (_operation.endsWith(".")) return;

    if (_operation.substring(_operation.contains(";") ? _operation.lastIndexOf(";") : 0).contains(".")) return;

    _operation += ".";

    _updateDisplayText();
  }

  void _enterOperator(String operator) {
    if(_error) _clearAll();
    _isResult = false;
    if(_operation.isEmpty){
      if(operator == "-"){
        _operation += operator;
        _updateDisplayText();
      }
      return;
    }
    String lastInOperation = _operation[_operation.length - 1];
    if(lastInOperation == "("){
      if(operator == "-"){
        _operation += operator;
        _updateDisplayText();
        return;
      }
      _clear();
      return;
    }
    if(lastInOperation == "-"){
      if(operator != "-") _clear();
      return;
    }
    if (lastInOperation == ";"){
      if(operator == "-" && (_operation[_operation.length - 2] == "x" || _operation[_operation.length - 2] == "/")){
        _operation += operator;
        _updateDisplayText();
        return;
      }
      _clear();
    }
    _operation += ";$operator;";

    _updateDisplayText();
  }

  void _enterBracket() {
    if(_isResult || _error) _clearAll();
    String lastInOperation = _operation.isEmpty ? "" : _operation[_operation.length - 1];
    bool bracketIsUnclosed = _operation.lastIndexOf("(") > _operation.lastIndexOf(")") || "(".allMatches(_operation).length > ")".allMatches(_operation).length;
    if (lastInOperation == ";" || lastInOperation == "-" || lastInOperation == "" || lastInOperation == "(") {
      _operation += "(";
    } else {
      if(bracketIsUnclosed){
        _operation += ")";
      } else {
        _operation += ";x;(";
      }
    }
    _updateDisplayText();
  }

  void _negative() {
    if(_error) return;
    _isResult = false;
    if (_operation.contains(";") || _operation.isEmpty) return;
    if (_operation[0] == "-") {
      _operation = _operation.substring(1);
    } else {
      _operation = "-$_operation";
    }

    _updateDisplayText();
  }

  String _reduceBrackets(String operation) {
    if(!operation.contains("(")) return operation;
    List<int> openingBackets = [];
    for(int i = 0; i < operation.length; i++){
      if(operation[i] == "(") openingBackets.add(i);
      if(operation[i] != ")") continue;

      int reduceSize = i - openingBackets.last;
      String reduceResult = _claculate(operation.substring(openingBackets.last + 1, i));
      i -= reduceSize - reduceResult.length + 1;
      operation = operation.replaceRange(openingBackets.last, openingBackets.last + reduceSize + 1, reduceResult);
      openingBackets.removeLast();
    }
    return operation;
  }

  String _claculate(String operation) {
    if (operation.isEmpty || operation.endsWith(";") || operation.endsWith("-") || operation.endsWith("(")) return operation;

    List<String> operationList = operation.split(";");
    for (Map<String, double Function(double a, double b)> order in _operations) {
      for (int i = 0; i < operationList.length; i++) {
        if (order.keys.contains(operationList[i])) {
          String operator = operationList[i];
          double a;
          double b;
          try{
            a = double.parse(operationList[i - 1]);
            b = double.parse(operationList[i + 1]);
          }
          catch (error){
            _error = true;
            return "Error";
          }
          double newNumber = order[operator]!(a, b);
          operationList.removeRange(i - 1, i + 2);
          i--;
          operationList.insert(i, newNumber.toString());
        }
      }
    }

    String result = operationList.single;

    if (double.parse(result) % 1 == 0) return double.parse(result).toStringAsFixed(0);

    return double.parse(double.parse(result).toStringAsFixed(14)).toString();
  }

  void _evaluate() {
    if(_isResult || _error) return;
    _operation = _operation.replaceAll(RegExp("-\\("), "-1;x;(");
    int numOfUncosedBrackets = "(".allMatches(_operation).length - ")".allMatches(_operation).length;
    _operation += ")" * numOfUncosedBrackets;
    _operation = _reduceBrackets(_operation);

    _operation = _claculate(_operation);
    _isResult = true;

    _updateDisplayText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Screen(text: _displayText),
        
            CalculatorGrid(buttonsData: _buttonsData),
          ],
        ),
      ),
    );
  }

  late final List<Map<String, void Function()>> _buttonsData = [
    {
      "AC": _clearAll,
      "( )": _enterBracket,
      "+/-": _negative,
      "/": () => _enterOperator("/"),
    },
    {
      "7": () => _enterDigit("7"),
      "8": () => _enterDigit("8"),
      "9": () => _enterDigit("9"),
      "x": () => _enterOperator("x"),
    },
    {
      "4": () => _enterDigit("4"),
      "5": () => _enterDigit("5"),
      "6": () => _enterDigit("6"),
      "-": () => _enterOperator("-"),
    },
    {
      "1": () => _enterDigit("1"),
      "2": () => _enterDigit("2"),
      "3": () => _enterDigit("3"),
      "+": () => _enterOperator("+"),
    },
    {
      "0": () => _enterDigit("0"),
      ".": () => _enterDecimalPoint(),
      "C": _clear,
      "=": _evaluate,
    },
  ];
}
