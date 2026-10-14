class UnknownWeatherConditionError extends Error {
  @override
  String toString() {
    return '未知の天候が返されました';
  }
}

enum WeatherRepositoryExceptionReason {
  invalidParameter,
  unknown,
}

class WeatherRepositoryException implements Exception {
  const WeatherRepositoryException(this._reason);

  final WeatherRepositoryExceptionReason _reason;

  WeatherRepositoryExceptionReason get reason => _reason;

  @override
  String toString() =>
      'WeatherRepositoryException: ${switch (_reason) {
        .invalidParameter => 'invalid parameter',
        .unknown => 'unknown error',
      }}';
}
