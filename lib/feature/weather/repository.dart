import 'package:flutter_training/feature/weather/model.dart';

abstract class WeatherRepository {
  Weather fetchWeather();
}
