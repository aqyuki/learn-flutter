import 'package:flutter/material.dart';

import 'package:flutter_training/feature/weather/model.dart';

abstract class WeatherRepository extends ChangeNotifier {
  Weather? get weather;

  void fetchWeather();
}
