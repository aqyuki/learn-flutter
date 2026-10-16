import 'dart:isolate';

import 'package:flutter_training/data/repository/weather.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

part 'weather_provider.g.dart';

typedef WeatherLoader = Future<Weather?> Function();

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
WeatherLoader weatherLoader(Ref ref) {
  final repo = ref.watch(weatherRepositoryProvider);

  return () => Isolate.run(repo.fetchWeather);
}

@riverpod
class WeatherController extends _$WeatherController {
  @override
  FutureOr<Weather?> build() {
    return null;
  }

  Future<void> reload() async {
    final load = ref.read(weatherLoaderProvider);

    // ロード中なら再取得しない
    if (state.isLoading) {
      return;
    }

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(load);

    if (!ref.mounted) {
      return;
    }

    state = result;
  }
}
