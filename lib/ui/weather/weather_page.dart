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

  Future<void> _onReload(WidgetRef ref) async {
    final weather = ref.read(weatherControllerProvider.notifier);
    await weather.reload();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherControllerProvider);
    ref.listen(weatherControllerProvider, (_, next) {
      if (next.isLoading) {
        return;
      }

      if (next.error case WeatherRepositoryException(:final reason)) {
        unawaited(
          ActionErrorDialog.show(
            context: context,
            title: 'エラー',
            message: switch (reason) {
              .invalidParameter => 'リクエストが不正です。',
              .unknown => '天気情報の取得に失敗しました。',
              .apiError => '天気情報の取得に失敗しました。',
            },
          ),
        );
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            child: FractionallySizedBox(
              alignment: Alignment.topCenter,
              widthFactor: _viewWidthFactor,
              child: Column(
                children: [
                  const Spacer(),
                  WeatherIcon(
                    condition: weather.value?.condition,
                  ),
                  TemperatureDisplay(weather: weather.value),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        ActionDisplay(
                          onClose: () => _onClose(context),
                          onReload: () => _onReload(ref),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (weather.isLoading) ...[
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
