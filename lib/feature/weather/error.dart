class UnknownWeatherConditionError extends Error {
  @override
  String toString() {
    return '未知の天候が返されました';
  }
}
