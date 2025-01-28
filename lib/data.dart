import 'package:shared_preferences/shared_preferences.dart';

List<String> expressionHistory = [];
const String historyKey = 'history';

// save an expression to history
Future<List<String>> saveHistory(String expression) async {
  final prefs = await SharedPreferences.getInstance();
  expressionHistory.add(expression);
  await prefs.setStringList(historyKey, expressionHistory);
  return expressionHistory;
}

// load history from shared_preferences
Future<List<String>> loadHistory() async {
  final prefs = await SharedPreferences.getInstance();
  expressionHistory = prefs.getStringList(historyKey) ?? [];
  return expressionHistory;
}

// clear history
Future<void> clearHistory() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(historyKey);
  expressionHistory.clear();
}
