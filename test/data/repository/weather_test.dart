import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/repository/weather.dart';
import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yumemi_weather/yumemi_weather.dart';

import 'weather_test.mocks.dart';

@GenerateMocks([YumemiWeather])
void main() {
  group('YumemiWeatherApiClient', () {
    group('正常系', () {
      group('天候の変換', () {
        // conditions はAPIから返される文字列と、対応する WeatherCondition のマッピングを保持する
        const conditions = {
          'sunny': WeatherCondition.sunny,
          'cloudy': WeatherCondition.cloudy,
          'rainy': WeatherCondition.rainy,
        };

        for (final condition in conditions.keys) {
          test('$conditionが適切に変換されること', () {
            final client = MockYumemiWeather();
            when(
              client.fetchWeather(any),
            ).thenReturn(
              '''{"weather_condition":"$condition","max_temperature":25,"min_temperature": 15}''',
            );

            final repo = YumemiWeatherApiClient(client: client);

            final result = repo.fetchWeather();

            expect(result.condition, conditions[condition]);
            verify(
              client.fetchWeather(any),
            ).called(1);
          });
        }
      });

      test('APIが返す気温を対応したプロパティに保存すること', () {
        final client = MockYumemiWeather();
        when(
          client.fetchWeather(any),
        ).thenReturn(
          '''{"weather_condition":"sunny","max_temperature":25,"min_temperature":15}''',
        );

        final repo = YumemiWeatherApiClient(client: client);

        final result = repo.fetchWeather();

        expect(result.maxTemperature, 25);
        expect(result.minTemperature, 15);
        verify(
          client.fetchWeather(any),
        ).called(1);
      });
    });

    group('異常系', () {
      test(
        'APIが未知のweather_conditionを返した際にUnknownWeatherConditionErrorが投げられる',
        () {
          final client = MockYumemiWeather();
          when(
            client.fetchWeather(any),
          ).thenReturn(
            '''{"weather_condition":"unknown_condition","max_temperature":25,"min_temperature":15}''',
          );

          final repo = YumemiWeatherApiClient(client: client);

          expect(
            repo.fetchWeather,
            throwsA(const TypeMatcher<UnknownWeatherConditionError>()),
          );
          verify(
            client.fetchWeather(any),
          ).called(1);
        },
      );

      test('APIがInvalid Parameterを返した際に、WeatherRepositoryExceptionを投げること', () {
        final client = MockYumemiWeather();
        when(
          client.fetchWeather(any),
        ).thenThrow(
          YumemiWeatherError.invalidParameter,
        );

        final repo = YumemiWeatherApiClient(client: client);

        expect(
          repo.fetchWeather,
          throwsA(
            const TypeMatcher<WeatherRepositoryException>().having(
              (error) => error.reason,
              'reason',
              WeatherRepositoryExceptionReason.invalidParameter,
            ),
          ),
        );
        verify(
          client.fetchWeather(any),
        ).called(1);
      });

      test('APIがUnknownを返した際に、WeatherRepositoryExceptionを投げること', () {
        final client = MockYumemiWeather();
        when(
          client.fetchWeather(any),
        ).thenThrow(
          YumemiWeatherError.unknown,
        );

        final repo = YumemiWeatherApiClient(client: client);

        expect(
          repo.fetchWeather,
          throwsA(
            const TypeMatcher<WeatherRepositoryException>().having(
              (error) => error.reason,
              'reason',
              WeatherRepositoryExceptionReason.unknown,
            ),
          ),
        );
        verify(
          client.fetchWeather(any),
        ).called(1);
      });
    });
  });
}
