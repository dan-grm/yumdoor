//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/meal_type.dart';
import 'package:tandoor_api/src/model/user.dart';
import 'package:tandoor_api/src/model/theme_enum.dart';
import 'package:tandoor_api/src/model/user_file_view.dart';
import 'package:tandoor_api/src/model/default_page_enum.dart';
import 'package:tandoor_api/src/model/food_inherit_field.dart';
import 'package:tandoor_api/src/model/user_preference_nav_text_color_enum.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_user_preference.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [comments]
/// * [csvDelim]
/// * [csvPrefix]
/// * [defaultDelay]
/// * [defaultMealType]
/// * [defaultPage]
/// * [defaultUnit]
/// * [filterToSupermarket]
/// * [foodChildrenExist]
/// * [foodInheritDefault]
/// * [image]
/// * [ingredientDecimals]
/// * [leftHanded]
/// * [mealplanAutoaddShopping]
/// * [mealplanAutoexcludeOnhand]
/// * [mealplanAutoincludeRelated]
/// * [navBgColor]
/// * [navShowLogo]
/// * [navSticky]
/// * [navTextColor]
/// * [shoppingAddOnhand]
/// * [shoppingAutoSync]
/// * [shoppingRecentDays]
/// * [shoppingUpdateFoodLists]
/// * [showStepIngredients]
/// * [theme]
/// * [useFractions]
/// * [useKj]
/// * [user]
@BuiltValue()
abstract class PatchedUserPreference
    implements Built<PatchedUserPreference, PatchedUserPreferenceBuilder> {
  @BuiltValueField(wireName: r'comments')
  bool? get comments;

  @BuiltValueField(wireName: r'csv_delim')
  String? get csvDelim;

  @BuiltValueField(wireName: r'csv_prefix')
  String? get csvPrefix;

  @BuiltValueField(wireName: r'default_delay')
  double? get defaultDelay;

  @BuiltValueField(wireName: r'default_meal_type')
  MealType? get defaultMealType;

  @BuiltValueField(wireName: r'default_page')
  DefaultPageEnum? get defaultPage;
  // enum defaultPageEnum {  SEARCH,  PLAN,  BOOKS,  SHOPPING,  };

  @BuiltValueField(wireName: r'default_unit')
  String? get defaultUnit;

  @BuiltValueField(wireName: r'filter_to_supermarket')
  bool? get filterToSupermarket;

  @BuiltValueField(wireName: r'food_children_exist')
  bool? get foodChildrenExist;

  @BuiltValueField(wireName: r'food_inherit_default')
  FoodInheritField? get foodInheritDefault;

  @BuiltValueField(wireName: r'image')
  UserFileView? get image;

  @BuiltValueField(wireName: r'ingredient_decimals')
  int? get ingredientDecimals;

  @BuiltValueField(wireName: r'left_handed')
  bool? get leftHanded;

  @BuiltValueField(wireName: r'mealplan_autoadd_shopping')
  bool? get mealplanAutoaddShopping;

  @BuiltValueField(wireName: r'mealplan_autoexclude_onhand')
  bool? get mealplanAutoexcludeOnhand;

  @BuiltValueField(wireName: r'mealplan_autoinclude_related')
  bool? get mealplanAutoincludeRelated;

  @BuiltValueField(wireName: r'nav_bg_color')
  String? get navBgColor;

  @BuiltValueField(wireName: r'nav_show_logo')
  bool? get navShowLogo;

  @BuiltValueField(wireName: r'nav_sticky')
  bool? get navSticky;

  @BuiltValueField(wireName: r'nav_text_color')
  UserPreferenceNavTextColorEnum? get navTextColor;
  // enum navTextColorEnum {  LIGHT,  DARK,  };

  @BuiltValueField(wireName: r'shopping_add_onhand')
  bool? get shoppingAddOnhand;

  @BuiltValueField(wireName: r'shopping_auto_sync')
  int? get shoppingAutoSync;

  @BuiltValueField(wireName: r'shopping_recent_days')
  int? get shoppingRecentDays;

  @BuiltValueField(wireName: r'shopping_update_food_lists')
  bool? get shoppingUpdateFoodLists;

  @BuiltValueField(wireName: r'show_step_ingredients')
  bool? get showStepIngredients;

  @BuiltValueField(wireName: r'theme')
  ThemeEnum? get theme;
  // enum themeEnum {  TANDOOR,  BOOTSTRAP,  DARKLY,  FLATLY,  SUPERHERO,  TANDOOR_DARK,  };

  @BuiltValueField(wireName: r'use_fractions')
  bool? get useFractions;

  @BuiltValueField(wireName: r'use_kj')
  bool? get useKj;

  @BuiltValueField(wireName: r'user')
  User? get user;

  PatchedUserPreference._();

  factory PatchedUserPreference([
    void updates(PatchedUserPreferenceBuilder b),
  ]) = _$PatchedUserPreference;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedUserPreferenceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedUserPreference> get serializer =>
      _$PatchedUserPreferenceSerializer();
}

class _$PatchedUserPreferenceSerializer
    implements PrimitiveSerializer<PatchedUserPreference> {
  @override
  final Iterable<Type> types = const [
    PatchedUserPreference,
    _$PatchedUserPreference,
  ];

  @override
  final String wireName = r'PatchedUserPreference';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedUserPreference object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.comments != null) {
      yield r'comments';
      yield serializers.serialize(
        object.comments,
        specifiedType: const FullType(bool),
      );
    }
    if (object.csvDelim != null) {
      yield r'csv_delim';
      yield serializers.serialize(
        object.csvDelim,
        specifiedType: const FullType(String),
      );
    }
    if (object.csvPrefix != null) {
      yield r'csv_prefix';
      yield serializers.serialize(
        object.csvPrefix,
        specifiedType: const FullType(String),
      );
    }
    if (object.defaultDelay != null) {
      yield r'default_delay';
      yield serializers.serialize(
        object.defaultDelay,
        specifiedType: const FullType(double),
      );
    }
    if (object.defaultMealType != null) {
      yield r'default_meal_type';
      yield serializers.serialize(
        object.defaultMealType,
        specifiedType: const FullType.nullable(MealType),
      );
    }
    if (object.defaultPage != null) {
      yield r'default_page';
      yield serializers.serialize(
        object.defaultPage,
        specifiedType: const FullType(DefaultPageEnum),
      );
    }
    if (object.defaultUnit != null) {
      yield r'default_unit';
      yield serializers.serialize(
        object.defaultUnit,
        specifiedType: const FullType(String),
      );
    }
    if (object.filterToSupermarket != null) {
      yield r'filter_to_supermarket';
      yield serializers.serialize(
        object.filterToSupermarket,
        specifiedType: const FullType(bool),
      );
    }
    if (object.foodChildrenExist != null) {
      yield r'food_children_exist';
      yield serializers.serialize(
        object.foodChildrenExist,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.foodInheritDefault != null) {
      yield r'food_inherit_default';
      yield serializers.serialize(
        object.foodInheritDefault,
        specifiedType: const FullType.nullable(FoodInheritField),
      );
    }
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.ingredientDecimals != null) {
      yield r'ingredient_decimals';
      yield serializers.serialize(
        object.ingredientDecimals,
        specifiedType: const FullType(int),
      );
    }
    if (object.leftHanded != null) {
      yield r'left_handed';
      yield serializers.serialize(
        object.leftHanded,
        specifiedType: const FullType(bool),
      );
    }
    if (object.mealplanAutoaddShopping != null) {
      yield r'mealplan_autoadd_shopping';
      yield serializers.serialize(
        object.mealplanAutoaddShopping,
        specifiedType: const FullType(bool),
      );
    }
    if (object.mealplanAutoexcludeOnhand != null) {
      yield r'mealplan_autoexclude_onhand';
      yield serializers.serialize(
        object.mealplanAutoexcludeOnhand,
        specifiedType: const FullType(bool),
      );
    }
    if (object.mealplanAutoincludeRelated != null) {
      yield r'mealplan_autoinclude_related';
      yield serializers.serialize(
        object.mealplanAutoincludeRelated,
        specifiedType: const FullType(bool),
      );
    }
    if (object.navBgColor != null) {
      yield r'nav_bg_color';
      yield serializers.serialize(
        object.navBgColor,
        specifiedType: const FullType(String),
      );
    }
    if (object.navShowLogo != null) {
      yield r'nav_show_logo';
      yield serializers.serialize(
        object.navShowLogo,
        specifiedType: const FullType(bool),
      );
    }
    if (object.navSticky != null) {
      yield r'nav_sticky';
      yield serializers.serialize(
        object.navSticky,
        specifiedType: const FullType(bool),
      );
    }
    if (object.navTextColor != null) {
      yield r'nav_text_color';
      yield serializers.serialize(
        object.navTextColor,
        specifiedType: const FullType(UserPreferenceNavTextColorEnum),
      );
    }
    if (object.shoppingAddOnhand != null) {
      yield r'shopping_add_onhand';
      yield serializers.serialize(
        object.shoppingAddOnhand,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shoppingAutoSync != null) {
      yield r'shopping_auto_sync';
      yield serializers.serialize(
        object.shoppingAutoSync,
        specifiedType: const FullType(int),
      );
    }
    if (object.shoppingRecentDays != null) {
      yield r'shopping_recent_days';
      yield serializers.serialize(
        object.shoppingRecentDays,
        specifiedType: const FullType(int),
      );
    }
    if (object.shoppingUpdateFoodLists != null) {
      yield r'shopping_update_food_lists';
      yield serializers.serialize(
        object.shoppingUpdateFoodLists,
        specifiedType: const FullType(bool),
      );
    }
    if (object.showStepIngredients != null) {
      yield r'show_step_ingredients';
      yield serializers.serialize(
        object.showStepIngredients,
        specifiedType: const FullType(bool),
      );
    }
    if (object.theme != null) {
      yield r'theme';
      yield serializers.serialize(
        object.theme,
        specifiedType: const FullType(ThemeEnum),
      );
    }
    if (object.useFractions != null) {
      yield r'use_fractions';
      yield serializers.serialize(
        object.useFractions,
        specifiedType: const FullType(bool),
      );
    }
    if (object.useKj != null) {
      yield r'use_kj';
      yield serializers.serialize(
        object.useKj,
        specifiedType: const FullType(bool),
      );
    }
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType.nullable(User),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedUserPreference object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PatchedUserPreferenceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'comments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.comments = valueDes;
          break;
        case r'csv_delim':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.csvDelim = valueDes;
          break;
        case r'csv_prefix':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.csvPrefix = valueDes;
          break;
        case r'default_delay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.defaultDelay = valueDes;
          break;
        case r'default_meal_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MealType),
          ) as MealType?;
          if (valueDes == null) continue;
          result.defaultMealType.replace(valueDes);
          break;
        case r'default_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DefaultPageEnum),
          ) as DefaultPageEnum?;
          if (valueDes == null) continue;
          result.defaultPage = valueDes;
          break;
        case r'default_unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.defaultUnit = valueDes;
          break;
        case r'filter_to_supermarket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.filterToSupermarket = valueDes;
          break;
        case r'food_children_exist':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.foodChildrenExist = valueDes;
          break;
        case r'food_inherit_default':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FoodInheritField),
          ) as FoodInheritField?;
          if (valueDes == null) continue;
          result.foodInheritDefault.replace(valueDes);
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        case r'ingredient_decimals':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ingredientDecimals = valueDes;
          break;
        case r'left_handed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.leftHanded = valueDes;
          break;
        case r'mealplan_autoadd_shopping':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.mealplanAutoaddShopping = valueDes;
          break;
        case r'mealplan_autoexclude_onhand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.mealplanAutoexcludeOnhand = valueDes;
          break;
        case r'mealplan_autoinclude_related':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.mealplanAutoincludeRelated = valueDes;
          break;
        case r'nav_bg_color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.navBgColor = valueDes;
          break;
        case r'nav_show_logo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.navShowLogo = valueDes;
          break;
        case r'nav_sticky':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.navSticky = valueDes;
          break;
        case r'nav_text_color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
              UserPreferenceNavTextColorEnum,
            ),
          ) as UserPreferenceNavTextColorEnum?;
          if (valueDes == null) continue;
          result.navTextColor = valueDes;
          break;
        case r'shopping_add_onhand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.shoppingAddOnhand = valueDes;
          break;
        case r'shopping_auto_sync':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.shoppingAutoSync = valueDes;
          break;
        case r'shopping_recent_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.shoppingRecentDays = valueDes;
          break;
        case r'shopping_update_food_lists':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.shoppingUpdateFoodLists = valueDes;
          break;
        case r'show_step_ingredients':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.showStepIngredients = valueDes;
          break;
        case r'theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ThemeEnum),
          ) as ThemeEnum?;
          if (valueDes == null) continue;
          result.theme = valueDes;
          break;
        case r'use_fractions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.useFractions = valueDes;
          break;
        case r'use_kj':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.useKj = valueDes;
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedUserPreference deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedUserPreferenceBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
