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

      test('reloadを呼び出すとリポジトリから取得した天気を取得できること', () {
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

        controller.reload();
        final actual = subscription.read();

        expect(actual, same(weather));
        expect(notifications, [same(weather)]);
        verify(repo.fetchWeather()).called(1);
      });

      test('再取得すると新しい天気に更新され、購読側へ通知されること', () {
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

        controller.reload();
        expect(subscription.read(), same(firstWeather));

        when(repo.fetchWeather()).thenReturn(nextWeather);
        controller.reload();

        expect(subscription.read(), same(nextWeather));
        expect(notifications, [same(firstWeather), same(nextWeather)]);
        verify(repo.fetchWeather()).called(2);
      });
    });

    group('異常系', () {
      test('リポジトリが例外を投げた場合、内部状態が変化しないこと', () {
        const error = WeatherRepositoryException(.unknown);
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

        expect(
          controller.reload,
          throwsA(same(error)),
        );

        final actualAfter = subscription.read();

        expect(actualBefore, isNull);
        expect(actualAfter, isNull);
        expect(notifications, isEmpty);

        verify(repo.fetchWeather()).called(1);
      });

      for (final reason in WeatherRepositoryExceptionReason.values) {
        test('再取得が${reason.name}で失敗しても取得済みの天気を維持し、通知しないこと', () {
          const weather = Weather(
            condition: WeatherCondition.sunny,
            maxTemperature: 25,
            minTemperature: 15,
          );
          final error = WeatherRepositoryException(reason);
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

          controller.reload();
          expect(subscription.read(), same(weather));
          expect(notifications, [same(weather)]);
          notifications.clear();

          when(repo.fetchWeather()).thenThrow(error);

          expect(controller.reload, throwsA(same(error)));
          expect(subscription.read(), same(weather));
          expect(notifications, isEmpty);
          verify(repo.fetchWeather()).called(2);
        });
      }
    });
  });
}
