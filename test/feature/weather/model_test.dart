import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/feature/weather/model.dart';

void main() {
  group('WeatherCondition', () {
    group('文字列からの変換', () {
      const conditions = {
        'sunny': WeatherCondition.sunny,
        'cloudy': WeatherCondition.cloudy,
        'rainy': WeatherCondition.rainy,
      };

      for (final entry in conditions.entries) {
        test('${entry.key}が適切に変換されること', () {
          final result = WeatherCondition.fromString(entry.key);
          expect(result, entry.value);
        });
      }
    });

    test('未知の文字列が入力されたら例外を投げる', () {
      expect(
        () => WeatherCondition.fromString('unknown_condition'),
        throwsA(const TypeMatcher<UnknownWeatherConditionError>()),
      );
    });
  });
}
