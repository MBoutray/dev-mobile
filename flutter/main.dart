import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color displayContainerBackground = Color(0xFF3E606F);
  static const Color inputContainerBackground = Color(0xFF193441);
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculatrice',
      theme: ThemeData(
        primaryColor: AppColors.inputContainerBackground,
        accentColor: AppColors.displayContainerBackground,
        primaryColorBrightness: Brightness.light,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  static const List<List<String>> grid = <List<String>>[
    <String>["C", "CE", "", ""],
    <String>["7", "8", "9", "-"],
    <String>["4", "5", "6", "*"],
    <String>["1", "2", "3", "/"],
    <String>[".", "0", "=", "+"],
  ];

  double? input;
  double? previousInput;
  String? symbol;
  bool isResultShowing = false;
  bool isFloating = false;

  void onItemClicked(String value) {
    print('On Click $value');

    switch (value) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        onNewDigit(value);
        break;
      case '+':
      case '-':
      case '/':
      case '*':
        onNewSymbol(value);
        break;
      case '.':
        onNewDot();
        break;
      case 'C':
        reset();
        break;
      case 'CE':
        resetAll();
        break;
      case '=':
        onEquals();
    }

    // Force l'interface à se redessiner
    setState(() {});
  }

  void onNewDigit(String digit) {
    if (this.isResultShowing) {
      this.input = 0;
      this.isResultShowing = true;
    }
    if (this.input == null) {
      this.input = 0;
    }

    List<String> splitInputValue = this.input.toString().split('.');
    int doubleDigitCount =
        splitInputValue.length > 1 ? splitInputValue[1].length : 0;

    this.input = this.isFloating
        ? double.parse((this.input! + (double.parse(digit) * pow(0.1, doubleDigitCount + 1))).toStringAsFixed(doubleDigitCount + 1))
        : (this.input! * 10) + double.parse(digit);
  }

  void onNewSymbol(String digit) {
    this.symbol = digit;
    this.previousInput = this.input;
    this.input = 0;
    this.isFloating = false;
  }

  void onNewDot() {
    this.isFloating = true;
  }

  void reset() {
    if (this.isFloating) {
      int floatingDigitsCount = this.input.toString().split('.')[1].length;
      String inputValue = this.input.toString();

      this.input = double.parse(inputValue.substring(0, inputValue.length - 1));

      if (floatingDigitsCount == 1) {
        this.isFloating = false;
      }
    } else {
      this.input = (input! / 10).floor().toDouble();
    }
  }

  void resetAll() {
    this.input = null;
    this.previousInput = null;
    this.symbol = null;
    this.isResultShowing = false;
    this.isFloating = false;
  }

  void onEquals() {
    if (this.previousInput == null || this.input == null || this.symbol == null) {
      return;
    }
    if (this.input == 0 && this.symbol == '/') {
      resetAll();
      return;
    }

    switch (this.symbol) {
      case '+':
        this.input = this.previousInput! + this.input!;
        break;
      case '-':
        this.input = this.previousInput! - this.input!;
        break;
      case '/':
        this.input = this.previousInput! / this.input!;
        break;
      case '*':
        this.input = this.previousInput! * this.input!;
        break;
    }

    this.isResultShowing = true;
    this.previousInput = null;
    this.symbol = null;
    this.isFloating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: TextStyle(color: AppColors.white, fontSize: 22.0),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                color: AppColors.displayContainerBackground,
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.all(22.0),
                child: Text(input?.toString() ?? "0"),
              ),
            ),
            Flexible(
              flex: 8,

              // Column = vertical
              child: Column(
                // Pour chaque nouvelle ligne, on itère sur chaque cellule
                children: grid.map((List<String> line) {
                  return Expanded(
                    child: Row(
                        children: line
                            .map(
                              (String cell) => Expanded(
                                child: InputButton(
                                  label: cell,
                                  onTap: onItemClicked,
                                ),
                              ),
                            )
                            .toList(growable: false)),
                  );
                }).toList(growable: false),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InputButton extends StatelessWidget {
  final String label;
  final ValueChanged<String>? onTap;

  InputButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(label),
      child: Ink(
        height: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.white, width: 0.5),
            color: AppColors.inputContainerBackground),
        child: Center(
          child: Text(
            label,
          ),
        ),
      ),
    );
  }
}
