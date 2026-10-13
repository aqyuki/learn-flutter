import 'package:flutter/material.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:flutter_training/ui/weather/component/action_button.dart';
import 'package:provider/provider.dart';

class ActionDisplay extends StatelessWidget {
  const ActionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: ActionButton(text: 'Close'),
        ),
        Expanded(
          child: ActionButton(
            text: 'Reload',
            onPressed: () => onReloadPressed(context),
          ),
        ),
      ],
    );
  }

  // Reloadボタンが押されたときの処理
  void onReloadPressed(BuildContext context) {
    final repo = context.read<WeatherRepository>();
    repo.fetchWeather();
  }
}
