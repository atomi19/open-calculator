import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key, required this.title});

  final String title;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  final TextEditingController _expressionFieldController = TextEditingController();
  final TextEditingController _quickResultController = TextEditingController();
  
  final List<String> _operators = ['÷', '×', '-', '+', '^'];

  void _addValue(String value) {
    String expression = _expressionFieldController.text;

    if (expression.isNotEmpty) {
      final String lastSymbol = expression.substring(expression.length - 1);

      if (_operators.contains(value) && _operators.contains(lastSymbol)) {
        // do not append if the last symbol in expression and current value are both operators
        return;
      }
    }

    _quickResultController.text = '';
    _expressionFieldController.text += value;
  }

  // clear expression field
  void _clearExpressionField() {
    _quickResultController.text = '';
    _expressionFieldController.text = '';
  }

  // remove last character in expression
  void _removeLastCharacter() {
    String expression = _expressionFieldController.text;

    if (expression.isNotEmpty) {
      _quickResultController.text = '';
      _expressionFieldController.text = expression.substring(0, expression.length - 1);
    }
  }

  // if there is a division or multiplication sign, replace them with / or *
  String _replaceOperatorsSymbols(String expression) {
    String replacedOperators = expression;

    if (expression.contains('÷') || expression.contains('×')) {
      replacedOperators = expression.replaceAll('÷', '/').replaceAll('×', '*');
    }

    return replacedOperators;
  }

  void _solveExpression() {
    Parser p = Parser();

    try {
      String replaceOperators = _replaceOperatorsSymbols(_expressionFieldController.text);
      Expression expression = p.parse(replaceOperators);

      double result = expression.evaluate(EvaluationType.REAL, ContextModel());

      // format result as a whole number if it's decimal is 0, otherwise keep decimals
      String formattedResult = (result % 1 == 0) ? result.toInt().toString() : result.toString();

      _quickResultController.text = '= $formattedResult';
    } catch (e) {
      _expressionFieldController.text = 'Invalid Expression';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: SizedBox()),
          Column(
            children: [
              TextField(
                textAlign: TextAlign.end,
                readOnly: true,
                controller: _quickResultController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 45),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    border: InputBorder.none),
              ),
              TextField(
                  textAlign: TextAlign.end,
                  controller: _expressionFieldController,
                  readOnly: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                  ),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      border: InputBorder.none)),
              GridView.count(
                padding: EdgeInsets.all(10),
                mainAxisSpacing: 10, // horizontal spacing between buttons
                crossAxisSpacing: 10, // vertical spacing between buttons
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // first row
                  TextButton(onPressed: () => _addValue('('), child: const Text('(')),
                  TextButton(onPressed: () => _addValue(')'), child: const Text(')')),
                  TextButton(
                      onPressed: () => _removeLastCharacter(),
                      onLongPress: () => _clearExpressionField(),
                      child: const Icon(Icons.backspace_outlined,
                          color: Colors.black, size: 28)),
                  TextButton(onPressed: () => _addValue('÷'), child: Text('÷')),
                  // second row
                  TextButton(onPressed: () => _addValue('7'), child: const Text('7')),
                  TextButton(onPressed: () => _addValue('8'), child: const Text('8')),
                  TextButton(onPressed: () => _addValue('9'), child: const Text('9')),
                  TextButton(onPressed: () => _addValue('×'), child: const Text('×')),
                  // third row
                  TextButton(onPressed: () => _addValue('4'), child: const Text('4')),
                  TextButton(onPressed: () => _addValue('5'), child: const Text('5')),
                  TextButton(onPressed: () => _addValue('6'), child: const Text('6')),
                  TextButton(onPressed: () => _addValue('-'), child: const Text('−')),
                  // fourth row
                  TextButton(onPressed: () => _addValue('1'), child: const Text('1')),
                  TextButton(onPressed: () => _addValue('2'), child: const Text('2')),
                  TextButton(onPressed: () => _addValue('3'), child: const Text('3')),
                  TextButton(onPressed: () => _addValue('+'), child: const Text('+')),
                  // fifth row
                  TextButton(onPressed: () => _addValue('0'), child: const Text('0')),
                  TextButton(onPressed: () => _addValue('.'), child: const Text('.')),
                  TextButton(onPressed: () => _addValue('^'), child: const Text('^')),
                  TextButton(onPressed: () => _solveExpression(), child: const Text('=')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}