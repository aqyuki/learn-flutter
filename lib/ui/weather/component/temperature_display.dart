import 'package:flutter/material.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/ui/weather/component/temperature_text.dart';

class TemperatureDisplay extends StatelessWidget {
  const TemperatureDisplay({required this._weather, super.key});

  final Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TemperatureText(
            text: '${_weather?.minTemperature ?? '**'} ℃',
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: TemperatureText(
            text: '${_weather?.maxTemperature ?? '**'} ℃',
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
