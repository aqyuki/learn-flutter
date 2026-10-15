import 'package:flutter/material.dart';

class ActionErrorDialog extends StatelessWidget {
  const ActionErrorDialog._({
    required this._title,
    required this._message,
  });

  final String _title;
  final String _message;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
  }) => showDialog(
    context: context,
    builder: (_) => ActionErrorDialog._(
      title: title,
      message: message,
    ),
  );

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
