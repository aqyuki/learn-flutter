import 'dart:isolate';

import 'package:flutter_training/data/repository/weather.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

part 'weather_provider.g.dart';

@riverpod
YumemiWeather yumemiWeatherClient(Ref ref) {
  return YumemiWeather();
}

@riverpod
WeatherRepository weatherRepository(Ref ref) {
  final client = ref.watch(yumemiWeatherClientProvider);

  return YumemiWeatherApiClient(client: client);
}

@riverpod
class WeatherController extends _$WeatherController {
  @override
  Weather? build() {
    return null;
  }

  Future<void> reload() async {
    final repo = ref.read(weatherRepositoryProvider);
    final weather = await Isolate.run(repo.fetchWeather);

    if (!ref.mounted) {
      return;
    }

    state = weather;
  }
}
