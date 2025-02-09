import 'package:flutter/material.dart';

class ExpressionField extends StatelessWidget {
  final TextEditingController expressionController;
  final TextEditingController quickResultController;

  const ExpressionField({
    super.key,
    required this.expressionController,
    required this.quickResultController
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.end,
          readOnly: true,
          controller: quickResultController,
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
          controller: expressionController,
          readOnly: true,
          showCursor: true,
          autofocus: true,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 30,
          ),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              border: InputBorder.none)
        ),
      ],
    );
  }
}