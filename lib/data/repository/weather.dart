import 'dart:convert';

import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class YumemiWeatherApiClient({required final YumemiWeather _client})
    extends WeatherRepository {
  Weather? _weather;

  @override
  Weather? get weather => _weather;

  @override
  void fetchWeather() {
    try {
      const request = '{"area": "tokyo", "date": "2026-10-14T12:00:00+09:00"}';
      final rawResponse = _client.fetchWeather(request);
      final decodedResponse = jsonDecode(rawResponse) as Map<String, dynamic>;
      final response = YumemiWeatherApiResponse.fromJson(decodedResponse);

      final condition = WeatherCondition.fromString(response.weatherCondition);

      _weather = Weather(
        condition: condition,
        maxTemperature: response.maxTemperature,
        minTemperature: response.minTemperature,
      );

      notifyListeners();
    } on YumemiWeatherError catch (e) {
      switch (e) {
        case YumemiWeatherError.invalidParameter:
          throw WeatherRepositoryException(
            reason: WeatherRepositoryExceptionReason.invalidParameter,
          );
        case YumemiWeatherError.unknown:
          throw WeatherRepositoryException(
            reason: WeatherRepositoryExceptionReason.unknown,
          );
      }
    }
  }
}

class YumemiWeatherApiResponse {
  YumemiWeatherApiResponse({
    required this._weatherCondition,
    required this._maxTemperature,
    required this._minTemperature,
  });

  factory YumemiWeatherApiResponse.fromJson(Map<String, dynamic> json) {
    return YumemiWeatherApiResponse(
      weatherCondition: json['weather_condition'] as String,
      maxTemperature: json['max_temperature'] as int,
      minTemperature: json['min_temperature'] as int,
    );
  }

  final String _weatherCondition;
  final int _maxTemperature;
  final int _minTemperature;

  String get weatherCondition => _weatherCondition;
  int get maxTemperature => _maxTemperature;
  int get minTemperature => _minTemperature;
}
