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
  const Weather(this._condition);

  final WeatherCondition _condition;

  WeatherCondition get condition => _condition;
}
