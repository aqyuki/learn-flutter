class UnknownWeatherConditionError extends Error {
  @override
  String toString() {
    return '未知の天候が返されました';
  }
}

enum WeatherRepositoryExceptionReason {
  invalidParameter,
  unknown,
  apiError,
}

class WeatherRepositoryException({
  required final WeatherRepositoryExceptionReason reason,
}) implements Exception {
  @override
  String toString() =>
      'WeatherRepositoryException: ${switch (reason) {
        .invalidParameter => 'invalid parameter',
        .unknown => 'unknown error',
        .apiError => 'API error',
      }}';
}
