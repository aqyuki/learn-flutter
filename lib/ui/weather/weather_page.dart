import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_training/data/weather_provider.dart';
import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/ui/weather/component/action_display.dart';
import 'package:flutter_training/ui/weather/component/action_error_dialog.dart';
import 'package:flutter_training/ui/weather/component/temperature_display.dart';
import 'package:flutter_training/ui/weather/component/weather_icon.dart';

const _viewWidthFactor = 0.5;

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  void _onClose(BuildContext context) {
    Navigator.pop(context);
  }

  void _onReload(BuildContext context, WidgetRef ref) {
    try {
      ref.read(weatherControllerProvider.notifier).reload();
    } on WeatherRepositoryException catch (e) {
      final message = switch (e.reason) {
        .invalidParameter => 'リクエストが不正です。',
        .unknown => '天気情報の取得に失敗しました。',
        .apiError => '天気情報の取得に失敗しました。',
      };

      unawaited(
        ActionErrorDialog.show(
          context: context,
          title: 'エラー',
          message: message,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherControllerProvider);

    return Scaffold(
      body: Align(
        child: FractionallySizedBox(
          alignment: Alignment.topCenter,
          widthFactor: _viewWidthFactor,
          child: Column(
            children: [
              const Spacer(),
              WeatherIcon(
                condition: weather?.condition,
              ),
              TemperatureDisplay(weather: weather),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    ActionDisplay(
                      onClose: () => _onClose(context),
                      onReload: () => _onReload(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
