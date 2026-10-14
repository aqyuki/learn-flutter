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
    final res = _client.fetchSimpleWeather();

    _weather = Weather(WeatherCondition.fromString(res));

    notifyListeners();
  }
}
