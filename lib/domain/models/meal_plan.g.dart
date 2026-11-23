// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealPlan _$MealPlanFromJson(Map<String, dynamic> json) => _MealPlan(
  id: (json['id'] as num).toInt(),
  recipe: json['recipe'] == null
      ? null
      : RecipeSummary.fromJson(json['recipe'] as Map<String, dynamic>),
  title: json['title'] as String? ?? '',
  servings: (json['servings'] as num).toDouble(),
  note: json['note'] as String? ?? '',
  fromDay: const CalendarDayConverter().fromJson(json['fromDay'] as String),
  toDay: const CalendarDayConverter().fromJson(json['toDay'] as String),
  mealType: MealType.fromJson(json['mealType'] as Map<String, dynamic>),
  onShoppingList: json['onShoppingList'] as bool? ?? false,
  createdBy: (json['createdBy'] as num).toInt(),
);

Map<String, dynamic> _$MealPlanToJson(_MealPlan instance) => <String, dynamic>{
  'id': instance.id,
  'recipe': instance.recipe?.toJson(),
  'title': instance.title,
  'servings': instance.servings,
  'note': instance.note,
  'fromDay': const CalendarDayConverter().toJson(instance.fromDay),
  'toDay': const CalendarDayConverter().toJson(instance.toDay),
  'mealType': instance.mealType.toJson(),
  'onShoppingList': instance.onShoppingList,
  'createdBy': instance.createdBy,
};
