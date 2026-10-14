// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YumemiWeatherApiRequest _$YumemiWeatherApiRequestFromJson(
  Map<String, dynamic> json,
) => YumemiWeatherApiRequest(
  area: json['area'] as String,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$YumemiWeatherApiRequestToJson(
  YumemiWeatherApiRequest instance,
) => <String, dynamic>{
  'area': instance.area,
  'date': instance.date.toIso8601String(),
};

YumemiWeatherApiResponse _$YumemiWeatherApiResponseFromJson(
  Map<String, dynamic> json,
) => YumemiWeatherApiResponse(
  weatherCondition: json['weather_condition'] as String,
  maxTemperature: (json['max_temperature'] as num).toInt(),
  minTemperature: (json['min_temperature'] as num).toInt(),
);

Map<String, dynamic> _$YumemiWeatherApiResponseToJson(
  YumemiWeatherApiResponse instance,
) => <String, dynamic>{
  'weather_condition': instance.weatherCondition,
  'max_temperature': instance.maxTemperature,
  'min_temperature': instance.minTemperature,
};
