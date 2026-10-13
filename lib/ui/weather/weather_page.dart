import 'package:flutter/material.dart';
import 'package:flutter_training/data/weather_provider.dart';
import 'package:flutter_training/ui/weather/component/action_display.dart';
import 'package:flutter_training/ui/weather/component/temperature_display.dart';
import 'package:flutter_training/ui/weather/component/weather_icon.dart';

const _viewWidthFactor = 0.5;

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeatherProvider(
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: _viewWidthFactor,
          child: Column(
            children: [
              Spacer(),
              WeatherIcon(),
              TemperatureDisplay(),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    ActionDisplay(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
