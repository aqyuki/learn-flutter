import 'package:flutter_training/feature/weather/error.dart';

enum WeatherCondition {
  sunny,
  cloudy,
  rainy;

  factory WeatherCondition.fromString(String value) {
    return switch (value) {
      'sunny' => WeatherCondition.sunny,
      'cloudy' => WeatherCondition.cloudy,
      'rainy' => WeatherCondition.rainy,
      _ => throw UnknownWeatherConditionError(),
    };
  }
}

class Weather {
  const Weather({
    required this._condition,
    required this._maxTemperature,
    required this._minTemperature,
  });

  final WeatherCondition _condition;
  final int _maxTemperature;
  final int _minTemperature;

  WeatherCondition get condition => _condition;
  int get maxTemperature => _maxTemperature;
  int get minTemperature => _minTemperature;
}
