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
      final res = _client.fetchThrowsWeather('tokyo');

      _weather = Weather(WeatherCondition.fromString(res));

      notifyListeners();
    } on YumemiWeatherError catch (e) {
      switch (e) {
        case YumemiWeatherError.invalidParameter:
          throw const WeatherRepositoryException(
            WeatherRepositoryExceptionReason.invalidParameter,
          );
        case YumemiWeatherError.unknown:
          throw const WeatherRepositoryException(
            WeatherRepositoryExceptionReason.unknown,
          );
      }
    }
  }
}
