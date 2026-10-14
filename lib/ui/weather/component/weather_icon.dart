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

    final image = switch (weather?.condition) {
      .sunny => SvgPicture.asset('assets/weather_icons/sunny.svg'),
      .cloudy => SvgPicture.asset('assets/weather_icons/cloudy.svg'),
      .rainy => SvgPicture.asset('assets/weather_icons/rainy.svg'),
      null => const Placeholder(),
    };

    return AspectRatio(aspectRatio: _aspectRatio, child: image);
  }
}
