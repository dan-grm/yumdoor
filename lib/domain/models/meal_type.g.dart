// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealType _$MealTypeFromJson(Map<String, dynamic> json) => _MealType(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  color: (json['color'] as num?)?.toInt(),
  time: json['time'] == null
      ? null
      : Duration(microseconds: (json['time'] as num).toInt()),
);

Map<String, dynamic> _$MealTypeToJson(_MealType instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'order': instance.order,
  'color': instance.color,
  'time': instance.time?.inMicroseconds,
};
