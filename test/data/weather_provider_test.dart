import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/weather_provider.dart';
import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_provider_test.mocks.dart';

@GenerateMocks([WeatherRepository])
void main() {
  group('WeatherController', () {
    group('正常系', () {
      test('初期状態ではnullを返すこと', () {
        final repo = MockWeatherRepository();
        final container = ProviderContainer.test(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
        );
        final subscription = container.listen(
          weatherControllerProvider,
          (_, _) => {},
        );

        final actual = subscription.read();

        expect(actual, isNull);
        verifyNever(repo.fetchWeather());
      });

      test('reloadを呼び出すとリポジトリから取得した天気を取得できること', () async {
        const weather = Weather(
          condition: WeatherCondition.sunny,
          maxTemperature: 25,
          minTemperature: 15,
        );

        final repo = MockWeatherRepository();
        when(repo.fetchWeather()).thenReturn(weather);

        final container = ProviderContainer.test(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
        );

        final notifications = <Weather?>[];
        final subscription = container.listen(
          weatherControllerProvider,
          (_, next) => notifications.add(next),
        );
        final controller = container.read(weatherControllerProvider.notifier);

        await controller.reload();
        final actual = subscription.read();

        expect(actual, _matchesWeather(weather));
        expect(notifications, [_matchesWeather(weather)]);
      });

      test('再取得すると新しい天気に更新され、購読側へ通知されること', () async {
        const firstWeather = Weather(
          condition: WeatherCondition.sunny,
          maxTemperature: 25,
          minTemperature: 15,
        );
        const nextWeather = Weather(
          condition: WeatherCondition.rainy,
          maxTemperature: 20,
          minTemperature: 10,
        );
        final repo = MockWeatherRepository();
        when(repo.fetchWeather()).thenReturn(firstWeather);

        final container = ProviderContainer.test(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
        );
        final notifications = <Weather?>[];
        final subscription = container.listen(
          weatherControllerProvider,
          (_, next) => notifications.add(next),
        );
        final controller = container.read(weatherControllerProvider.notifier);

        await controller.reload();
        expect(subscription.read(), _matchesWeather(firstWeather));

        when(repo.fetchWeather()).thenReturn(nextWeather);
        await controller.reload();

        expect(subscription.read(), _matchesWeather(nextWeather));
        expect(notifications, [
          _matchesWeather(firstWeather),
          _matchesWeather(nextWeather),
        ]);
      });
    });

    group('異常系', () {
      test('リポジトリが例外を投げた場合、内部状態が変化しないこと', () async {
        final error = WeatherRepositoryException(reason: .unknown);
        final repo = MockWeatherRepository();
        when(repo.fetchWeather()).thenThrow(error);

        final container = ProviderContainer.test(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
        );
        final notifications = <Weather?>[];
        final subscription = container.listen(
          weatherControllerProvider,
          (_, next) => notifications.add(next),
        );

        final actualBefore = subscription.read();
        final controller = container.read(weatherControllerProvider.notifier);

        await expectLater(
          controller.reload(),
          throwsA(
            isA<WeatherRepositoryException>().having(
              (e) => e.reason,
              'reason',
              error.reason,
            ),
          ),
        );

        final actualAfter = subscription.read();

        expect(actualBefore, isNull);
        expect(actualAfter, isNull);
        expect(notifications, isEmpty);
      });

      for (final reason in WeatherRepositoryExceptionReason.values) {
        test('再取得が${reason.name}で失敗しても取得済みの天気を維持し、通知しないこと', () async {
          const weather = Weather(
            condition: WeatherCondition.sunny,
            maxTemperature: 25,
            minTemperature: 15,
          );
          final error = WeatherRepositoryException(reason: reason);
          final repo = MockWeatherRepository();
          when(repo.fetchWeather()).thenReturn(weather);

          final container = ProviderContainer.test(
            overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
          );
          final notifications = <Weather?>[];
          final subscription = container.listen(
            weatherControllerProvider,
            (_, next) => notifications.add(next),
          );
          final controller = container.read(weatherControllerProvider.notifier);

          await controller.reload();
          expect(subscription.read(), _matchesWeather(weather));
          expect(notifications, [_matchesWeather(weather)]);
          notifications.clear();

          when(repo.fetchWeather()).thenThrow(error);

          await expectLater(
            controller.reload(),
            throwsA(
              isA<WeatherRepositoryException>().having(
                (e) => e.reason,
                'reason',
                error.reason,
              ),
            ),
          );
          expect(subscription.read(), _matchesWeather(weather));
          expect(notifications, isEmpty);
        });
      }
    });
  });
}

// Isolateをまたぐ結果は、同一性ではなく各プロパティで比較する。
Matcher _matchesWeather(Weather expected) => isA<Weather>()
    .having((w) => w.condition, 'condition', expected.condition)
    .having((w) => w.maxTemperature, 'maxTemperature', expected.maxTemperature)
    .having((w) => w.minTemperature, 'minTemperature', expected.minTemperature);
