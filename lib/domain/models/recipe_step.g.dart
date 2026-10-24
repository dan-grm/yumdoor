// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeStep _$RecipeStepFromJson(Map<String, dynamic> json) => _RecipeStep(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
  instruction: json['instruction'] as String? ?? '',
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  time: json['time'] == null
      ? Duration.zero
      : Duration(microseconds: (json['time'] as num).toInt()),
  order: (json['order'] as num?)?.toInt() ?? 0,
  showAsHeader: json['showAsHeader'] as bool? ?? false,
);

Map<String, dynamic> _$RecipeStepToJson(_RecipeStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'instruction': instance.instruction,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'time': instance.time.inMicroseconds,
      'order': instance.order,
      'showAsHeader': instance.showAsHeader,
    };
