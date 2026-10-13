import 'package:flutter/material.dart';

const _verticalPadding = 16.0;

class TemperatureText extends StatelessWidget {
  const TemperatureText({required this._text, required this._color, super.key});

  final String _text;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
      child: Text(
        _text,
        style: textStyle?.copyWith(color: _color),
        textAlign: TextAlign.center,
      ),
    );
  }
}
