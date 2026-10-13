import 'package:flutter/material.dart';

const double _aspectRatio = 1 / 1;

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(aspectRatio: _aspectRatio, child: Placeholder());
  }
}
