// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ingredient _$IngredientFromJson(Map<String, dynamic> json) => _Ingredient(
  id: (json['id'] as num).toInt(),
  food: json['food'] == null
      ? null
      : Food.fromJson(json['food'] as Map<String, dynamic>),
  unit: json['unit'] == null
      ? null
      : Unit.fromJson(json['unit'] as Map<String, dynamic>),
  amount: (json['amount'] as num?)?.toDouble() ?? 0,
  noAmount: json['noAmount'] as bool? ?? false,
  isHeader: json['isHeader'] as bool? ?? false,
  note: json['note'] as String? ?? '',
  originalText: json['originalText'] as String?,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$IngredientToJson(_Ingredient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'food': instance.food?.toJson(),
      'unit': instance.unit?.toJson(),
      'amount': instance.amount,
      'noAmount': instance.noAmount,
      'isHeader': instance.isHeader,
      'note': instance.note,
      'originalText': instance.originalText,
      'order': instance.order,
    };
