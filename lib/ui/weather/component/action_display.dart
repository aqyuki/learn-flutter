import 'package:flutter/material.dart';
import 'package:flutter_training/ui/weather/component/action_button.dart';

class ActionDisplay extends StatelessWidget {
  const ActionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: ActionButton(text: 'Close'),
        ),
        Expanded(
          child: ActionButton(text: 'Reload'),
        ),
      ],
    );
  }
}
