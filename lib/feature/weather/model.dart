enum WeatherCondition {
  sunny,
  cloudy,
  rainy,
}

class Weather {
  const Weather(this._condition);

  final WeatherCondition _condition;

  WeatherCondition get condition => _condition;
}
