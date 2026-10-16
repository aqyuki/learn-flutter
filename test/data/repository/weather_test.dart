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
              client.syncFetchWeather(any),
            ).thenReturn(
              '''{"weather_condition":"$condition","max_temperature":25,"min_temperature": 15}''',
            );

            final repo = YumemiWeatherApiClient(client: client);

            final result = repo.fetchWeather();

            expect(result.condition, conditions[condition]);
            verify(
              client.syncFetchWeather(any),
            ).called(1);
          });
        }
      });

      test('APIが返す気温を対応したプロパティに保存すること', () {
        final client = MockYumemiWeather();
        when(
          client.syncFetchWeather(any),
        ).thenReturn(
          '''{"weather_condition":"sunny","max_temperature":25,"min_temperature":15}''',
        );

        final repo = YumemiWeatherApiClient(client: client);

        final result = repo.fetchWeather();

        expect(result.maxTemperature, 25);
        expect(result.minTemperature, 15);
        verify(
          client.syncFetchWeather(any),
        ).called(1);
      });
    });

    group('異常系', () {
      test(
        'APIが未知のweather_conditionを返した際にUnknownWeatherConditionErrorが投げられる',
        () {
          final client = MockYumemiWeather();
          when(
            client.syncFetchWeather(any),
          ).thenReturn(
            '''{"weather_condition":"unknown_condition","max_temperature":25,"min_temperature":15}''',
          );

          final repo = YumemiWeatherApiClient(client: client);

          expect(
            repo.fetchWeather,
            throwsA(const TypeMatcher<UnknownWeatherConditionError>()),
          );
          verify(
            client.syncFetchWeather(any),
          ).called(1);
        },
      );

      test('APIがInvalid Parameterを返した際に、WeatherRepositoryExceptionを投げること', () {
        final client = MockYumemiWeather();
        when(
          client.syncFetchWeather(any),
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
          client.syncFetchWeather(any),
        ).called(1);
      });

      test('APIがUnknownを返した際に、WeatherRepositoryExceptionを投げること', () {
        final client = MockYumemiWeather();
        when(
          client.syncFetchWeather(any),
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
          client.syncFetchWeather(any),
        ).called(1);
      });
    });
  });

  group('YumemiWeatherApiRequest', () {
    test('jsonに変換できること', () {
      final request = YumemiWeatherApiRequest(
        area: 'Tokyo',
        date: DateTime.parse('2024-06-01T00:00:00.000Z'),
      );

      final json = request.toJson();
      expect(json['area'], 'Tokyo');
      expect(json['date'], '2024-06-01T00:00:00.000Z');
    });

    test('jsonから復元できること', () {
      final json = {
        'area': 'Tokyo',
        'date': '2024-06-01T00:00:00.000Z',
      };

      final request = YumemiWeatherApiRequest.fromJson(json);
      expect(request.area, 'Tokyo');
      expect(request.date, DateTime.parse('2024-06-01T00:00:00.000Z'));
    });
  });
  group('YumemiWeatherApiResponse', () {
    test('jsonに変換できること', () {
      final response = YumemiWeatherApiResponse(
        weatherCondition: 'sunny',
        maxTemperature: 30,
        minTemperature: 20,
      );

      final json = response.toJson();
      expect(json['weather_condition'], 'sunny');
      expect(json['max_temperature'], 30);
      expect(json['min_temperature'], 20);
    });

    test('jsonから復元できること', () {
      final json = {
        'weather_condition': 'sunny',
        'max_temperature': 30,
        'min_temperature': 20,
      };

      final response = YumemiWeatherApiResponse.fromJson(json);
      expect(response.weatherCondition, 'sunny');
      expect(response.maxTemperature, 30);
      expect(response.minTemperature, 20);
    });
  });
}
