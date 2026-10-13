import 'package:flutter/material.dart';
import 'package:flutter_training/data/repository/weather.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:provider/provider.dart';

class WeatherProvider extends StatelessWidget {
  const WeatherProvider({
    this._child,
    super.key,
  });

  final Widget? _child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherRepository>(
      create: (context) => YumemiWeatherAPIClient(),
      child: _child,
    );
  }
}
