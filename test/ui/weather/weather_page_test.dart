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

      final repo = MockWeatherRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [weatherRepositoryProvider.overrideWith((ref) => repo)],
          child: const MaterialApp(home: WeatherPage()),
        ),
      );

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

      // 初期状態では画像、最低気温、最高気温は表示されていない
      expect(find.byType(Placeholder), findsOne);
      expect(find.text('** ℃'), findsExactly(2));

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

      // 初期状態では画像、最低気温、最高気温は表示されていない
      expect(find.byType(Placeholder), findsOne);
      expect(find.text('** ℃'), findsExactly(2));

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

      // 初期状態では画像、最低気温、最高気温は表示されていない
      expect(find.byType(Placeholder), findsOne);
      expect(find.text('** ℃'), findsExactly(2));

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

      // Give
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

      expect(find.byType(AlertDialog), findsNothing);

      // When: Reloadを押し、ダイアログのアニメーションを進める。
      await tester.tap(find.text('Reload'));
      await tester.pumpAndSettle();

      // Then: ダイアログ内に適切なメッセージが表示される。
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOne);
      expect(
        find.descendant(
          of: dialog,
          matching: find.text('天気情報の取得に失敗しました。'),
        ),
        findsOne,
      );

      // ダイアログを閉じる
      await tester.tap(
        find.descendant(
          of: dialog,
          matching: find.text('OK'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
