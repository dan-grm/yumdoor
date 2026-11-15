// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeDraft _$RecipeDraftFromJson(Map<String, dynamic> json) => _RecipeDraft(
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  servings: (json['servings'] as num?)?.toInt() ?? 1,
  servingsText: json['servingsText'] as String? ?? '',
  workingTime: json['workingTime'] == null
      ? Duration.zero
      : Duration(microseconds: (json['workingTime'] as num).toInt()),
  waitingTime: json['waitingTime'] == null
      ? Duration.zero
      : Duration(microseconds: (json['waitingTime'] as num).toInt()),
  keywords:
      (json['keywords'] as List<dynamic>?)
          ?.map((e) => NamedRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sourceUrl: json['sourceUrl'] == null
      ? null
      : Uri.parse(json['sourceUrl'] as String),
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => StepDraft.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$RecipeDraftToJson(_RecipeDraft instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'servings': instance.servings,
      'servingsText': instance.servingsText,
      'workingTime': instance.workingTime.inMicroseconds,
      'waitingTime': instance.waitingTime.inMicroseconds,
      'keywords': instance.keywords.map((e) => e.toJson()).toList(),
      'sourceUrl': instance.sourceUrl?.toString(),
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };

_StepDraft _$StepDraftFromJson(Map<String, dynamic> json) => _StepDraft(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String? ?? '',
  instruction: json['instruction'] as String? ?? '',
  time: json['time'] == null
      ? Duration.zero
      : Duration(microseconds: (json['time'] as num).toInt()),
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => IngredientDraft.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$StepDraftToJson(_StepDraft instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'instruction': instance.instruction,
      'time': instance.time.inMicroseconds,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
    };

_IngredientDraft _$IngredientDraftFromJson(Map<String, dynamic> json) =>
    _IngredientDraft(
      id: (json['id'] as num?)?.toInt(),
      food: json['food'] == null
          ? null
          : NamedRef.fromJson(json['food'] as Map<String, dynamic>),
      unit: json['unit'] == null
          ? null
          : NamedRef.fromJson(json['unit'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      noAmount: json['noAmount'] as bool? ?? false,
      isHeader: json['isHeader'] as bool? ?? false,
      note: json['note'] as String? ?? '',
      originalText: json['originalText'] as String?,
    );

Map<String, dynamic> _$IngredientDraftToJson(_IngredientDraft instance) =>
    <String, dynamic>{
      'id': instance.id,
      'food': instance.food?.toJson(),
      'unit': instance.unit?.toJson(),
      'amount': instance.amount,
      'noAmount': instance.noAmount,
      'isHeader': instance.isHeader,
      'note': instance.note,
      'originalText': instance.originalText,
    };

_NamedRef _$NamedRefFromJson(Map<String, dynamic> json) =>
    _NamedRef(id: (json['id'] as num?)?.toInt(), name: json['name'] as String);

Map<String, dynamic> _$NamedRefToJson(_NamedRef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
