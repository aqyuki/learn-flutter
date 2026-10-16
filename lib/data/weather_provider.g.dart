// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(yumemiWeatherClient)
final yumemiWeatherClientProvider = YumemiWeatherClientProvider._();

final class YumemiWeatherClientProvider
    extends $FunctionalProvider<YumemiWeather, YumemiWeather, YumemiWeather>
    with $Provider<YumemiWeather> {
  YumemiWeatherClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yumemiWeatherClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yumemiWeatherClientHash();

  @$internal
  @override
  $ProviderElement<YumemiWeather> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  YumemiWeather create(Ref ref) {
    return yumemiWeatherClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(YumemiWeather value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<YumemiWeather>(value),
    );
  }
}

String _$yumemiWeatherClientHash() =>
    r'669234133a377277b2f4a7d0ba106dd9773b0a88';

@ProviderFor(weatherRepository)
final weatherRepositoryProvider = WeatherRepositoryProvider._();

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherRepository,
          WeatherRepository,
          WeatherRepository
        >
    with $Provider<WeatherRepository> {
  WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'5147f8e1f912415de12d32e07b665ee1ca8d5e3b';

@ProviderFor(WeatherController)
final weatherControllerProvider = WeatherControllerProvider._();

final class WeatherControllerProvider
    extends $NotifierProvider<WeatherController, Weather?> {
  WeatherControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherControllerHash();

  @$internal
  @override
  WeatherController create() => WeatherController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Weather? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Weather?>(value),
    );
  }
}

String _$weatherControllerHash() => r'daac407130565cce35daa219e66f4d9dc0c0bb4d';

abstract class _$WeatherController extends $Notifier<Weather?> {
  Weather? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Weather?, Weather?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Weather?, Weather?>,
              Weather?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
