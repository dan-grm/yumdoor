// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupermarketCategory _$SupermarketCategoryFromJson(Map<String, dynamic> json) =>
    _SupermarketCategory(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$SupermarketCategoryToJson(
  _SupermarketCategory instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_Supermarket _$SupermarketFromJson(Map<String, dynamic> json) => _Supermarket(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  categoryIds:
      (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$SupermarketToJson(_Supermarket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryIds': instance.categoryIds,
    };

_ShoppingFood _$ShoppingFoodFromJson(Map<String, dynamic> json) =>
    _ShoppingFood(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      pluralName: json['pluralName'] as String?,
      category: json['category'] == null
          ? null
          : SupermarketCategory.fromJson(
              json['category'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ShoppingFoodToJson(_ShoppingFood instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pluralName': instance.pluralName,
      'category': instance.category?.toJson(),
    };

_ShoppingEntrySource _$ShoppingEntrySourceFromJson(Map<String, dynamic> json) =>
    _ShoppingEntrySource(
      listRecipeId: (json['listRecipeId'] as num).toInt(),
      recipeId: (json['recipeId'] as num?)?.toInt(),
      recipeName: json['recipeName'] as String? ?? '',
      servings: (json['servings'] as num).toDouble(),
      mealPlan: json['mealPlan'] == null
          ? null
          : MealPlan.fromJson(json['mealPlan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShoppingEntrySourceToJson(
  _ShoppingEntrySource instance,
) => <String, dynamic>{
  'listRecipeId': instance.listRecipeId,
  'recipeId': instance.recipeId,
  'recipeName': instance.recipeName,
  'servings': instance.servings,
  'mealPlan': instance.mealPlan?.toJson(),
};

_ShoppingEntry _$ShoppingEntryFromJson(Map<String, dynamic> json) =>
    _ShoppingEntry(
      id: (json['id'] as num).toInt(),
      food: ShoppingFood.fromJson(json['food'] as Map<String, dynamic>),
      unit: json['unit'] == null
          ? null
          : Unit.fromJson(json['unit'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      checked: json['checked'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: UserRef.fromJson(json['createdBy'] as Map<String, dynamic>),
      source: json['source'] == null
          ? null
          : ShoppingEntrySource.fromJson(
              json['source'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ShoppingEntryToJson(_ShoppingEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'food': instance.food.toJson(),
      'unit': instance.unit?.toJson(),
      'amount': instance.amount,
      'checked': instance.checked,
      'completedAt': instance.completedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy.toJson(),
      'source': instance.source?.toJson(),
    };
