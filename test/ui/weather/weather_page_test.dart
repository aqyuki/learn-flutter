import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_training/data/weather_provider.dart';
import 'package:flutter_training/feature/weather/error.dart';
import 'package:flutter_training/feature/weather/model.dart';
import 'package:flutter_training/feature/weather/repository.dart';
import 'package:flutter_training/ui/weather/weather_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'weather_page_test.mocks.dart';

void _setDevicePixelRatioAndPhysicalSize(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(402, 874);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

@GenerateMocks([WeatherRepository])
void main() {
  group('WeatherPage', () {
    testWidgets('初期状態ではプレースホルダーが表示されること', (tester) async {
      _setDevicePixelRatioAndPhysicalSize(tester);

      // Given
      final repo = MockWeatherRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
          child: const MaterialApp(home: WeatherPage()),
        ),
      );

      // Then
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(Placeholder), findsOne);
      expect(find.text('** ℃'), findsExactly(2));
    });

    testWidgets('天気情報が晴れのときに晴れの画像が表示されること', (tester) async {
      _setDevicePixelRatioAndPhysicalSize(tester);

      // Given
      const weather = Weather(
        condition: .sunny,
        maxTemperature: 25,
        minTemperature: 15,
      );

      final repo = MockWeatherRepository();
      when(repo.fetchWeather()).thenReturn(weather);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
          child: const MaterialApp(home: WeatherPage()),
        ),
      );

      final sunnyImage = find.byWidgetPredicate((widget) {
        if (widget is! SvgPicture) {
          return false;
        }

        final loader = widget.bytesLoader;
        return loader is SvgAssetLoader &&
            loader.assetName == 'assets/weather_icons/sunny.svg';
      });

      // When
      // Reloadボタンをタップすることでデータの取得が行われ、画面が更新される
      await tester.tap(find.text('Reload'));
      await tester.pumpAndSettle();

      // Then
      // 晴れの画像が表示されており、最低気温と最高気温が正しく表示される
      expect(find.byType(SvgPicture), findsOne);
      expect(sunnyImage, findsOneWidget);
      expect(find.text('15 ℃'), findsOne);
      expect(find.text('25 ℃'), findsOne);
    });

    testWidgets('天気情報が曇りのときに曇りの画像が表示されること', (tester) async {
      _setDevicePixelRatioAndPhysicalSize(tester);

      // Given
      const weather = Weather(
        condition: .cloudy,
        maxTemperature: 25,
        minTemperature: 15,
      );

      final repo = MockWeatherRepository();
      when(repo.fetchWeather()).thenReturn(weather);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
          child: const MaterialApp(home: WeatherPage()),
        ),
      );

      final cloudyImage = find.byWidgetPredicate((widget) {
        if (widget is! SvgPicture) {
          return false;
        }

        final loader = widget.bytesLoader;
        return loader is SvgAssetLoader &&
            loader.assetName == 'assets/weather_icons/cloudy.svg';
      });

      // When
      // Reloadボタンをタップすることでデータの取得が行われ、画面が更新される
      await tester.tap(find.text('Reload'));
      await tester.pumpAndSettle();

      // Then
      // 曇りの画像が表示されており、最低気温と最高気温が正しく表示される
      expect(find.byType(SvgPicture), findsOne);
      expect(cloudyImage, findsOneWidget);
      expect(find.text('15 ℃'), findsOne);
      expect(find.text('25 ℃'), findsOne);
    });

    testWidgets('天気情報が雨のときに雨の画像が表示されること', (tester) async {
      _setDevicePixelRatioAndPhysicalSize(tester);

      // Given
      const weather = Weather(
        condition: .rainy,
        maxTemperature: 25,
        minTemperature: 15,
      );

      final repo = MockWeatherRepository();
      when(repo.fetchWeather()).thenReturn(weather);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
          child: const MaterialApp(home: WeatherPage()),
        ),
      );

      final rainyImage = find.byWidgetPredicate((widget) {
        if (widget is! SvgPicture) {
          return false;
        }

        final loader = widget.bytesLoader;
        return loader is SvgAssetLoader &&
            loader.assetName == 'assets/weather_icons/rainy.svg';
      });

      // When
      // Reloadボタンをタップすることでデータの取得が行われ、画面が更新される
      await tester.tap(find.text('Reload'));
      await tester.pumpAndSettle();

      // Then
      // 雨の画像が表示されており、最低気温と最高気温が正しく表示される
      expect(find.byType(SvgPicture), findsOne);
      expect(rainyImage, findsOneWidget);
      expect(find.text('15 ℃'), findsOne);
      expect(find.text('25 ℃'), findsOne);
    });

    testWidgets('エラー発生時にダイアログを表示する', (tester) async {
      _setDevicePixelRatioAndPhysicalSize(tester);

      // Given
      final repo = MockWeatherRepository();
      when(repo.fetchWeather()).thenThrow(
        WeatherRepositoryException(reason: .unknown),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weatherRepositoryProvider.overrideWith((ref) => repo),
          ],
          child: const MaterialApp(home: WeatherPage()),
        ),
      );

      // When
      await tester.tap(find.text('Reload'));
      await tester.pumpAndSettle();

      // Then
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOne);
      expect(
        find.descendant(
          of: dialog,
          matching: find.text('天気情報の取得に失敗しました。'),
        ),
        findsOne,
      );

      // NOTE:
      // 本来であればダイアログを閉じるテストは別のテストとして切り出すべきだが、
      // 切り出した場合、重複箇所が多くなってしまうため同じテストの中で実施している

      // test: OKをタップしたらダイアログが閉じること
      // Given: ダイアログが表示されている状態（前段のテストでこの状態になっている）

      // When
      await tester.tap(
        find.descendant(
          of: dialog,
          matching: find.text('OK'),
        ),
      );
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
