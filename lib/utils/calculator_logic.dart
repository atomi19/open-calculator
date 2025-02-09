import 'package:math_expressions/math_expressions.dart';
import 'package:open_calculator/data.dart';

class CalculatorLogic {
  // if there is a division or multiplication sign, replace them with / or *
  static String replaceOperatorsSymbols(String expression) {
    String replacedOperators = expression;

    if (expression.contains('÷') || expression.contains('×')) {
      replacedOperators = expression.replaceAll('÷', '/').replaceAll('×', '*');
    }

    return replacedOperators;
  }

  static String solveExpression(String expression) {
    Parser p = Parser();

    try {
      String replacedOperators = replaceOperatorsSymbols(expression);
      Expression parsedExpression = p.parse(replacedOperators);
      double result = parsedExpression.evaluate(EvaluationType.REAL, ContextModel());

      // format result as a whole number if it's decimal is 0, otherwise keep decimals
      return (result % 1 == 0) ? result.toInt().toString() : result.toString();
    } catch (e) {
      return 'Invalid Expression';
    }
  }

  static Future<void> saveExpressionToHistory(String expression) async {
    await saveHistory(expression);
  }
}