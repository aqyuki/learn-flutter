import 'package:flutter/material.dart';

class ActionErrorDialog extends StatelessWidget {
  const ActionErrorDialog({
    required this._title,
    required this._message,
    super.key,
  });

  final String _title;
  final String _message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
