import 'package:flutter/material.dart';

const _weatherViewWidthFactor = 0.5;
const double _weatherIconAspectRatio = 1 / 1;

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: _weatherViewWidthFactor,
        child: Column(
          children: [
            Spacer(),
            _WeatherIcon(),
            _TemperatureDisplay(),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  _WeatherActionDisplay(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon();

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: _weatherIconAspectRatio,
      child: Placeholder(),
    );
  }
}

class _TemperatureDisplay extends StatelessWidget {
  const _TemperatureDisplay();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _TemperatureDisplayText(text: '** ℃', color: Colors.blue),
        ),
        Expanded(
          child: _TemperatureDisplayText(text: '** ℃', color: Colors.red),
        ),
      ],
    );
  }
}

class _TemperatureDisplayText extends StatelessWidget {
  const _TemperatureDisplayText({
    required this._text,
    required this._color,
  });

  final String _text;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.labelLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        _text,
        style: textTheme?.copyWith(color: _color),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _WeatherActionDisplay extends StatelessWidget {
  const _WeatherActionDisplay();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: null,
            child: _WeatherActionButtonText(text: 'Close'),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: null,
            child: _WeatherActionButtonText(text: 'Reload'),
          ),
        ),
      ],
    );
  }
}

class _WeatherActionButtonText extends StatelessWidget {
  const _WeatherActionButtonText({
    required this._text,
  });

  final String _text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.labelLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        _text,
        style: textTheme?.copyWith(color: Colors.blue),
        textAlign: TextAlign.center,
      ),
    );
  }
}
