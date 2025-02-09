import 'package:flutter/material.dart';
import 'package:open_calculator/pages/history_page.dart';
import 'package:open_calculator/utils/calculator_logic.dart';
import 'package:open_calculator/widgets/button_grid.dart';
import 'package:open_calculator/widgets/expression_field.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key, required this.title});

  final String title;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  final TextEditingController _expressionController = TextEditingController();
  final TextEditingController _quickResultController = TextEditingController();

  final List<String> _operators = ['÷', '×', '-', '+', '^'];
  bool _isError = false;

  void _addValue(String value) {
    String expression = _expressionController.text;

    if (expression.isNotEmpty) {
      final String lastSymbol = expression.substring(expression.length - 1);

      // do not append if the last symbol in expression and current value are both operators
      if (_operators.contains(value) && _operators.contains(lastSymbol)) {
        return;
      }
    }

    if(_isError) {
      _expressionController.text = value;
      _isError = false;
    } else {
      _quickResultController.text = '';
      _insertValueAtCursor(value);
    }
  }

  // insert value into the expression field at the current cursor position
  void _insertValueAtCursor(String value) {
    final expression = _expressionController.text;
    final selection = _expressionController.selection;

    // make sure that selection is valid
    if (selection.start >= 0 && selection.end >= 0) {
      final newExpression = expression.replaceRange(selection.start, selection.end, value);

      // update the expression field controller with the new text and move the cursor
      _expressionController.value = TextEditingValue(
        text: newExpression,
        selection: TextSelection.collapsed(offset: selection.start + value.length));
    }
  }

  // clear expression field
  void _clearExpressionField() {
    _quickResultController.text = '';
    _expressionController.text = '';
  }

  // remove character(s) in expression
  void _removeLastCharacter() {
    final expression = _expressionController.text;
    final selection = _expressionController.selection;

    _quickResultController.text = '';

    if(selection.start == selection.end) {
      // remove one character to the left from cursor
      if(selection.start > 0) {
        final newExpression = 
        expression.substring(0, selection.start - 1) + 
        expression.substring(selection.start);

        _expressionController.value = TextEditingValue(
          text: newExpression,
          selection: TextSelection.collapsed(offset: selection.start - 1)
        );
      }
    } else {
      // remove selected text
      final newExpression = expression.substring(0, selection.start) + expression.substring(selection.end);

      _expressionController.value = TextEditingValue(
        text: newExpression,
        selection: TextSelection.collapsed(offset: selection.start)
      );
    }
  }

  void _solveExpression() {
    String result = CalculatorLogic.solveExpression(_expressionController.text);

    setState(() {
      if(result == 'Invalid Expression') {
        _isError = true;
      }
      _quickResultController.text = '= $result';
    });

    CalculatorLogic.saveExpressionToHistory('${_expressionController.text} = $result');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(
                          insertExpressionIntoExpressionField: (expression) {
                            _expressionController.text = expression;
                          }
                        )));
                  },
                  style: ButtonStyle(
                    iconColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if(states.contains(WidgetState.pressed)) {
                          return Colors.grey[400];
                        }
                        return Colors.black;
                      }
                    ),
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent)
                  ),
                  child: const Icon(Icons.history, size: 24)
                )
              )),
            Expanded(child: SizedBox()),
            Column(
              children: [
                ExpressionField(
                  expressionController: _expressionController, 
                  quickResultController: _quickResultController
                ),
                ButtonGrid(
                  onButtonPressed: _addValue,
                  onBackspace: _removeLastCharacter,
                  onClear: _clearExpressionField,
                  onEquals: _solveExpression,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}