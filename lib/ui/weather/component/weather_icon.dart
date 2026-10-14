import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_training/feature/weather/model.dart';

const double _aspectRatio = 1 / 1;

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({this._condition, super.key});

  final WeatherCondition? _condition;

  @override
  Widget build(BuildContext context) {
    final image = switch (_condition) {
      .sunny => SvgPicture.asset('assets/weather_icons/sunny.svg'),
      .cloudy => SvgPicture.asset('assets/weather_icons/cloudy.svg'),
      .rainy => SvgPicture.asset('assets/weather_icons/rainy.svg'),
      null => const Placeholder(),
    };

    return AspectRatio(aspectRatio: _aspectRatio, child: image);
  }
}
