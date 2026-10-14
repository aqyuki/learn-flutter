import 'package:flutter/material.dart';
import 'package:flutter_training/data/repository/weather.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:flutter_training/ui/initial/initial_page.dart';
import 'package:flutter_training/ui/weather/weather_page.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

void main() {
  final weatherRepository = YumemiWeatherApiClient(client: YumemiWeather());

  runApp(MainApp(weatherRepository: weatherRepository));
}

class MainApp extends StatelessWidget {
  const MainApp({required this._weatherRepository, super.key});

  final WeatherRepository _weatherRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const InitialPage(),
      routes: {
        '/weather': (BuildContext context) =>
            WeatherPage(repo: _weatherRepository),
      },
    );
  }
}
