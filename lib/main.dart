import 'package:flutter/material.dart';
import 'package:open_calculator/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
          textSelectionTheme: TextSelectionThemeData(
              selectionColor: Colors.blue[100], cursorColor: Colors.black),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll<Color>(Colors.grey.shade300),
              foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
              textStyle: WidgetStateProperty.all(
                  TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.grey[500];
                  }
                  return Colors.grey[400];
                },
              ),
            ),
          )),
      home: const MyMainPage(title: 'Open Calculator'),
    );
  }
}