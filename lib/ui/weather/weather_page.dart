import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:flutter_training/ui/weather/component/action_display.dart';
import 'package:flutter_training/ui/weather/component/action_error_dialog.dart';
import 'package:flutter_training/ui/weather/component/temperature_display.dart';
import 'package:flutter_training/ui/weather/component/weather_icon.dart';

const _viewWidthFactor = 0.5;

class WeatherPage extends StatefulWidget {
  const WeatherPage({required this._repo, super.key});

  final WeatherRepository _repo;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;

  void _onClose() {
    Navigator.pop(context);
  }

  void _onReload() {
    try {
      widget._repo.fetchWeather();
      setState(() => _weather = widget._repo.weather);
    } on WeatherRepositoryException catch (e) {
      final message = switch (e.reason) {
        .invalidParameter => 'リクエストが不正です。',
        .unknown => '天気情報の取得に失敗しました。',
      };

      unawaited(
        ActionErrorDialog.show(
          context: context,
          title: 'エラー',
          message: message,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        child: FractionallySizedBox(
          alignment: Alignment.topCenter,
          widthFactor: _viewWidthFactor,
          child: Column(
            children: [
              const Spacer(),
              WeatherIcon(
                condition: _weather?.condition,
              ),
              TemperatureDisplay(weather: _weather),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    ActionDisplay(onClose: _onClose, onReload: _onReload),
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
