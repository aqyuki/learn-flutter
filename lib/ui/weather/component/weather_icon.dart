import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:provider/provider.dart';

const double _aspectRatio = 1 / 1;

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = context.select<WeatherRepository, Weather?>(
      (repo) => repo.weather,
    );

    if (weather == null) {
      return const AspectRatio(aspectRatio: _aspectRatio, child: Placeholder());
    }

    switch (weather.condition) {
      case WeatherCondition.sunny:
        return AspectRatio(
          aspectRatio: _aspectRatio,
          child: SvgPicture.asset('assets/weather_icons/sunny.svg'),
        );
      case WeatherCondition.cloudy:
        return AspectRatio(
          aspectRatio: _aspectRatio,
          child: SvgPicture.asset('assets/weather_icons/cloudy.svg'),
        );
      case WeatherCondition.rainy:
        return AspectRatio(
          aspectRatio: _aspectRatio,
          child: SvgPicture.asset('assets/weather_icons/rainy.svg'),
        );
    }
  }
}
