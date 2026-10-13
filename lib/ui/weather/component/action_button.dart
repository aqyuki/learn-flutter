import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({required this._text, this._onPressed, super.key});

  final String _text;
  final VoidCallback? _onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge;

    return TextButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: textStyle?.copyWith(color: Colors.blue),
        textAlign: TextAlign.center,
      ),
    );
  }
}
