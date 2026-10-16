import 'dart:convert';

import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

part 'weather.g.dart';

class YumemiWeatherApiClient({required final YumemiWeather _client})
    extends WeatherRepository {
  @override
  Weather fetchWeather() {
    try {
      final request = YumemiWeatherApiRequest(
        area: 'Tokyo',
        date: DateTime(2026, 10, 14, 12),
      );

      final rawResponse = _client.syncFetchWeather(
        jsonEncode(request.toJson()),
      );
      final decodedResponse = jsonDecode(rawResponse) as Map<String, dynamic>;
      final response = YumemiWeatherApiResponse.fromJson(decodedResponse);

      final condition = WeatherCondition.fromString(response.weatherCondition);

      return Weather(
        condition: condition,
        maxTemperature: response.maxTemperature,
        minTemperature: response.minTemperature,
      );
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
    } on CheckedFromJsonException catch (_) {
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

  final String area;
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

  final String weatherCondition;
  final int maxTemperature;
  final int minTemperature;

  Map<String, dynamic> toJson() => _$YumemiWeatherApiResponseToJson(this);
}
