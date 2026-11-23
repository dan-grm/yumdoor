// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeSummary _$RecipeSummaryFromJson(Map<String, dynamic> json) =>
    _RecipeSummary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] == null ? null : Uri.parse(json['image'] as String),
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => Keyword.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      foods:
          (json['foods'] as List<dynamic>?)
              ?.map((e) => Food.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$RecipeSummaryToJson(_RecipeSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image?.toString(),
      'keywords': instance.keywords.map((e) => e.toJson()).toList(),
      'foods': instance.foods.map((e) => e.toJson()).toList(),
      'servings': instance.servings,
      'servingsText': instance.servingsText,
      'workingTime': instance.workingTime.inMicroseconds,
      'waitingTime': instance.waitingTime.inMicroseconds,
      'rating': instance.rating,
      'lastCooked': instance.lastCooked?.toIso8601String(),
      'createdBy': instance.createdBy?.toJson(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
