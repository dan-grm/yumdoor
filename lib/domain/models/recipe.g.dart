// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  image: json['image'] == null ? null : Uri.parse(json['image'] as String),
  keywords:
      (json['keywords'] as List<dynamic>?)
          ?.map((e) => Keyword.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  servings: (json['servings'] as num?)?.toInt() ?? 1,
  servingsText: json['servingsText'] as String? ?? '',
  workingTime: json['workingTime'] == null
      ? Duration.zero
      : Duration(microseconds: (json['workingTime'] as num).toInt()),
  waitingTime: json['waitingTime'] == null
      ? Duration.zero
      : Duration(microseconds: (json['waitingTime'] as num).toInt()),
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => RecipeStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sourceUrl: json['sourceUrl'] == null
      ? null
      : Uri.parse(json['sourceUrl'] as String),
  rating: (json['rating'] as num?)?.toDouble(),
  lastCooked: json['lastCooked'] == null
      ? null
      : DateTime.parse(json['lastCooked'] as String),
  createdBy: json['createdBy'] == null
      ? null
      : UserRef.fromJson(json['createdBy'] as Map<String, dynamic>),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'image': instance.image?.toString(),
  'keywords': instance.keywords.map((e) => e.toJson()).toList(),
  'servings': instance.servings,
  'servingsText': instance.servingsText,
  'workingTime': instance.workingTime.inMicroseconds,
  'waitingTime': instance.waitingTime.inMicroseconds,
  'steps': instance.steps.map((e) => e.toJson()).toList(),
  'sourceUrl': instance.sourceUrl?.toString(),
  'rating': instance.rating,
  'lastCooked': instance.lastCooked?.toIso8601String(),
  'createdBy': instance.createdBy?.toJson(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
