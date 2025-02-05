import 'package:flutter/material.dart';
import 'package:open_calculator/data.dart';
import 'package:flutter/services.dart';

class HistoryPage extends StatefulWidget {
  final Function(String) insertExpressionIntoExpressionField;

  const HistoryPage({super.key, required this.insertExpressionIntoExpressionField});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final loadedHistory = await loadHistory();
    setState(() {
      history = loadedHistory;
    });
  }

  Future<void> _clearHistory() async {
    await clearHistory();
    setState(() {
      history.clear();
    });
  }

  // take expression from history and insert it into expression field 
  void _takeExpression(String expression) {
    String expressionPart = _getExpressionParts(expression)[0].trim();
    widget.insertExpressionIntoExpressionField(expressionPart);
    Navigator.pop(context);
  }

  // copy expression to clipboard
  void _copyExpression(String expression) {
    Clipboard.setData(ClipboardData(text: expression));

    // show Snackbar
    _showSnackBar();
  }

  // copy result to clipboard
  void _copyResult(String expression) {
    String resultPart = _getExpressionParts(expression)[1].trim();
    Clipboard.setData(ClipboardData(text: resultPart.trim()));

    // show Snackbar
    _showSnackBar();
  }

  // get expression and result parts from expression
  List<String> _getExpressionParts(String expression) {
    List<String> parts = expression.split('=');
    return parts;
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Copied to clipboard'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('History'),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
                iconColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if(states.contains(WidgetState.pressed)) {
                      return Colors.red.shade900;
                    }
                    return Colors.red.shade600;
                  }
                )
              ),
              onPressed: () => showDialog(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Clear history?'),
                  content: const Text('Do you want to delete all history? This action cannot be undone'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')
                    ),
                    TextButton(
                      onPressed: () {
                        _clearHistory();
                        Navigator.pop(context);
                      }, 
                      child: const Text('OK')
                    ),
                  ],
                )), 
              child: Icon(Icons.delete_outline, size: 23))
              )
        ],
      ),
      body: history.isEmpty
      ? const Center(child: Text('No history available', style: TextStyle(fontSize: 25)))
      : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300)
              )
            ),
            child: ListTile(
              leading: PopupMenuButton<String>(
                onSelected: (action) {
                  switch (action) {
                    case 'take_expression':
                      _takeExpression(history[index]);
                      break;
                    case 'copy_expression':
                      _copyExpression(history[index]);
                      break;
                    case 'copy_result':
                      _copyResult(history[index]);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(value: 'take_expression', child: const Text('Take expression')),
                    PopupMenuItem(value: 'copy_expression', child: const Text('Copy')),
                    PopupMenuItem(value: 'copy_result', child: const Text('Copy result'))
                  ];
                }),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText(history[index], style: const TextStyle(fontSize: 20))
                ],
              ),
            ),
          );
        })
    );
  }
}