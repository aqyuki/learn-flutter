import 'package:flutter/material.dart';
import 'package:flutter_training/ui/weather/component/temperature_text.dart';

class TemperatureDisplay extends StatelessWidget {
  const TemperatureDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: TemperatureText(text: '** ℃', color: Colors.blue),
        ),
        Expanded(
          child: TemperatureText(text: '** ℃', color: Colors.red),
        ),
      ],
    );
  }
}
