import 'dart:convert';

import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

part 'weather.g.dart';

class YumemiWeatherApiClient({required final YumemiWeather _client})
    extends WeatherRepository {
  Weather? _weather;

  @override
  Weather? get weather => _weather;

  @override
  void fetchWeather() {
    try {
      final request = YumemiWeatherApiRequest(
        area: 'Tokyo',
        date: DateTime(2026, 10, 14, 12),
      );

      final rawResponse = _client.fetchWeather(jsonEncode(request.toJson()));
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
    } on FormatException catch (_) {
      throw WeatherRepositoryException(
        reason: WeatherRepositoryExceptionReason.apiError,
      );
    }
  }
}

@JsonSerializable()
class YumemiWeatherApiRequest {
  YumemiWeatherApiRequest({
    required this.area,
    required this.date,
  });

  factory YumemiWeatherApiRequest.fromJson(Map<String, dynamic> json) =>
      _$YumemiWeatherApiRequestFromJson(json);

  @JsonKey(name: 'area')
  final String area;

  @JsonKey(name: 'date')
  final DateTime date;

  Map<String, dynamic> toJson() => _$YumemiWeatherApiRequestToJson(this);
}

@JsonSerializable()
class YumemiWeatherApiResponse {
  YumemiWeatherApiResponse({
    required this.weatherCondition,
    required this.maxTemperature,
    required this.minTemperature,
  });

  factory YumemiWeatherApiResponse.fromJson(Map<String, dynamic> json) =>
      _$YumemiWeatherApiResponseFromJson(json);

  @JsonKey(name: 'weather_condition')
  final String weatherCondition;

  @JsonKey(name: 'max_temperature')
  final int maxTemperature;

  @JsonKey(name: 'min_temperature')
  final int minTemperature;

  Map<String, dynamic> toJson() => _$YumemiWeatherApiResponseToJson(this);
}
