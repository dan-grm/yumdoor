// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Unit _$UnitFromJson(Map<String, dynamic> json) => _Unit(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  pluralName: json['pluralName'] as String?,
);

Map<String, dynamic> _$UnitToJson(_Unit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'pluralName': instance.pluralName,
};
