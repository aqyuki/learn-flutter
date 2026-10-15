import 'package:flutter/material.dart';
import 'package:flutter_training/ui/weather/component/action_button.dart';

class ActionDisplay extends StatelessWidget {
  const ActionDisplay({this._onClose, this._onReload, super.key});

  final VoidCallback? _onClose;
  final VoidCallback? _onReload;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(text: 'Close', onPressed: _onClose),
        ),
        Expanded(
          child: ActionButton(
            text: 'Reload',
            onPressed: _onReload,
          ),
        ),
      ],
    );
  }
}
