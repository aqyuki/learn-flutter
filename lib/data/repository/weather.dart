import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

class YumemiWeatherApiClient extends WeatherRepository {
  YumemiWeatherApiClient();

  final _client = YumemiWeather();

  Weather? _weather;

  @override
  Weather? get weather => _weather;

  @override
  void fetchWeather() {
    final res = _client.fetchSimpleWeather();

    switch (res) {
      case 'sunny':
        _weather = const Weather(WeatherCondition.sunny);
      case 'cloudy':
        _weather = const Weather(WeatherCondition.cloudy);
      case 'rainy':
        _weather = const Weather(WeatherCondition.rainy);
    }

    notifyListeners();
  }
}
