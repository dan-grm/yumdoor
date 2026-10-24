// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Food _$FoodFromJson(Map<String, dynamic> json) => _Food(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  pluralName: json['pluralName'] as String?,
  parentId: (json['parentId'] as num?)?.toInt(),
  onHand: json['onHand'] as bool? ?? false,
  ignoreShopping: json['ignoreShopping'] as bool? ?? false,
);

Map<String, dynamic> _$FoodToJson(_Food instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'pluralName': instance.pluralName,
  'parentId': instance.parentId,
  'onHand': instance.onHand,
  'ignoreShopping': instance.ignoreShopping,
};
