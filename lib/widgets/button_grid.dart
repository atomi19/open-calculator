import 'package:flutter/material.dart';

class ButtonGrid extends StatelessWidget {
  final Function(String) onButtonPressed;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onEquals;

  const ButtonGrid({
    super.key,
    required this.onButtonPressed,
    required this.onBackspace,
    required this.onClear,
    required this.onEquals,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(10),
      mainAxisSpacing: 10, // horizontal spacing between buttons
      crossAxisSpacing: 10, // vertical spacing between buttons
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        // first row
        TextButton(onPressed: () => onButtonPressed('('), child: const Text('(')),
        TextButton(onPressed: () => onButtonPressed(')'), child: const Text(')')),
        TextButton(onPressed: () => onBackspace(), onLongPress: () => onClear(),
            child: const Icon(Icons.backspace_outlined,
                color: Colors.black, size: 28)),
        TextButton(onPressed: () => onButtonPressed('÷'), child: Text('÷')),
        // second row
        TextButton(onPressed: () => onButtonPressed('7'), child: const Text('7')),
        TextButton(onPressed: () => onButtonPressed('8'), child: const Text('8')),
        TextButton(onPressed: () => onButtonPressed('9'), child: const Text('9')),
        TextButton(onPressed: () => onButtonPressed('×'), child: const Text('×')),
        // third row
        TextButton(onPressed: () => onButtonPressed('4'), child: const Text('4')),
        TextButton(onPressed: () => onButtonPressed('5'), child: const Text('5')),
        TextButton(onPressed: () => onButtonPressed('6'), child: const Text('6')),
        TextButton(onPressed: () => onButtonPressed('-'), child: const Text('−')),
        // fourth row
        TextButton(onPressed: () => onButtonPressed('1'), child: const Text('1')),
        TextButton(onPressed: () => onButtonPressed('2'), child: const Text('2')),
        TextButton(onPressed: () => onButtonPressed('3'), child: const Text('3')),
        TextButton(onPressed: () => onButtonPressed('+'), child: const Text('+')),
        // fifth row
        TextButton(onPressed: () => onButtonPressed('0'), child: const Text('0')),
        TextButton(onPressed: () => onButtonPressed('.'), child: const Text('.')),
        TextButton(onPressed: () => onButtonPressed('^'), child: const Text('^')),
        TextButton(onPressed: onEquals, child: const Text('=')),
      ],
    );
  }
}