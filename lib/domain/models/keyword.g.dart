// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Keyword _$KeywordFromJson(Map<String, dynamic> json) => _Keyword(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  parentId: (json['parentId'] as num?)?.toInt(),
);

Map<String, dynamic> _$KeywordToJson(_Keyword instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'parentId': instance.parentId,
};
