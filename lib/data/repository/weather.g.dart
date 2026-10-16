// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: document_ignores, cast_nullable_to_non_nullable

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YumemiWeatherApiRequest _$YumemiWeatherApiRequestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('YumemiWeatherApiRequest', json, ($checkedConvert) {
  final val = YumemiWeatherApiRequest(
    area: $checkedConvert('area', (v) => v as String),
    date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$YumemiWeatherApiRequestToJson(
  YumemiWeatherApiRequest instance,
) => <String, dynamic>{
  'area': instance.area,
  'date': instance.date.toIso8601String(),
};

YumemiWeatherApiResponse _$YumemiWeatherApiResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'YumemiWeatherApiResponse',
  json,
  ($checkedConvert) {
    final val = YumemiWeatherApiResponse(
      weatherCondition: $checkedConvert(
        'weather_condition',
        (v) => v as String,
      ),
      maxTemperature: $checkedConvert(
        'max_temperature',
        (v) => (v as num).toInt(),
      ),
      minTemperature: $checkedConvert(
        'min_temperature',
        (v) => (v as num).toInt(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'weatherCondition': 'weather_condition',
    'maxTemperature': 'max_temperature',
    'minTemperature': 'min_temperature',
  },
);

Map<String, dynamic> _$YumemiWeatherApiResponseToJson(
  YumemiWeatherApiResponse instance,
) => <String, dynamic>{
  'weather_condition': instance.weatherCondition,
  'max_temperature': instance.maxTemperature,
  'min_temperature': instance.minTemperature,
};
