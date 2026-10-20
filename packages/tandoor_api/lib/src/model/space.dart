//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/ai_provider.dart';
import 'package:tandoor_api/src/model/user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tandoor_api/src/model/user_file_view.dart';
import 'package:tandoor_api/src/model/space_nav_text_color_enum.dart';
import 'package:tandoor_api/src/model/space_theme_enum.dart';
import 'package:tandoor_api/src/model/food_inherit_field.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'space.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [aiCreditsBalance]
/// * [aiCreditsMonthly]
/// * [aiDefaultProvider]
/// * [aiEnabled]
/// * [aiMonthlyCreditsUsed]
/// * [allowSharing]
/// * [createdAt]
/// * [createdBy]
/// * [customSpaceTheme]
/// * [demo]
/// * [fileSizeMb]
/// * [foodInherit]
/// * [householdSetupCompleted]
/// * [id]
/// * [image]
/// * [logoColor128]
/// * [logoColor144]
/// * [logoColor180]
/// * [logoColor192]
/// * [logoColor32]
/// * [logoColor512]
/// * [logoColorSvg]
/// * [maxFileStorageMb] - Maximum file storage for space in MB. 0 for unlimited, -1 to disable file upload.
/// * [maxRecipes]
/// * [maxUsers]
/// * [message]
/// * [name]
/// * [navBgColor]
/// * [navLogo]
/// * [navTextColor]
/// * [recipeCount]
/// * [spaceSetupCompleted]
/// * [spaceTheme]
/// * [userCount]
@BuiltValue()
abstract class Space implements Built<Space, SpaceBuilder> {
  @BuiltValueField(wireName: r'ai_credits_balance')
  double? get aiCreditsBalance;

  @BuiltValueField(wireName: r'ai_credits_monthly')
  int? get aiCreditsMonthly;

  @BuiltValueField(wireName: r'ai_default_provider')
  AiProvider? get aiDefaultProvider;

  @BuiltValueField(wireName: r'ai_enabled')
  bool? get aiEnabled;

  @BuiltValueField(wireName: r'ai_monthly_credits_used')
  int? get aiMonthlyCreditsUsed;

  @BuiltValueField(wireName: r'allow_sharing')
  bool? get allowSharing;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  User? get createdBy;

  @BuiltValueField(wireName: r'custom_space_theme')
  UserFileView? get customSpaceTheme;

  @BuiltValueField(wireName: r'demo')
  bool? get demo;

  @BuiltValueField(wireName: r'file_size_mb')
  double? get fileSizeMb;

  @BuiltValueField(wireName: r'food_inherit')
  BuiltList<FoodInheritField>? get foodInherit;

  @BuiltValueField(wireName: r'household_setup_completed')
  bool? get householdSetupCompleted;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'image')
  UserFileView? get image;

  @BuiltValueField(wireName: r'logo_color_128')
  UserFileView? get logoColor128;

  @BuiltValueField(wireName: r'logo_color_144')
  UserFileView? get logoColor144;

  @BuiltValueField(wireName: r'logo_color_180')
  UserFileView? get logoColor180;

  @BuiltValueField(wireName: r'logo_color_192')
  UserFileView? get logoColor192;

  @BuiltValueField(wireName: r'logo_color_32')
  UserFileView? get logoColor32;

  @BuiltValueField(wireName: r'logo_color_512')
  UserFileView? get logoColor512;

  @BuiltValueField(wireName: r'logo_color_svg')
  UserFileView? get logoColorSvg;

  /// Maximum file storage for space in MB. 0 for unlimited, -1 to disable file upload.
  @BuiltValueField(wireName: r'max_file_storage_mb')
  int? get maxFileStorageMb;

  @BuiltValueField(wireName: r'max_recipes')
  int? get maxRecipes;

  @BuiltValueField(wireName: r'max_users')
  int? get maxUsers;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'nav_bg_color')
  String? get navBgColor;

  @BuiltValueField(wireName: r'nav_logo')
  UserFileView? get navLogo;

  @BuiltValueField(wireName: r'nav_text_color')
  SpaceNavTextColorEnum? get navTextColor;
  // enum navTextColorEnum {  BLANK,  LIGHT,  DARK,  };

  @BuiltValueField(wireName: r'recipe_count')
  int? get recipeCount;

  @BuiltValueField(wireName: r'space_setup_completed')
  bool? get spaceSetupCompleted;

  @BuiltValueField(wireName: r'space_theme')
  SpaceThemeEnum? get spaceTheme;
  // enum spaceThemeEnum {  BLANK,  TANDOOR,  BOOTSTRAP,  DARKLY,  FLATLY,  SUPERHERO,  TANDOOR_DARK,  };

  @BuiltValueField(wireName: r'user_count')
  int? get userCount;

  Space._();

  factory Space([void updates(SpaceBuilder b)]) = _$Space;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SpaceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Space> get serializer => _$SpaceSerializer();
}

class _$SpaceSerializer implements PrimitiveSerializer<Space> {
  @override
  final Iterable<Type> types = const [Space, _$Space];

  @override
  final String wireName = r'Space';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Space object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.aiCreditsBalance != null) {
      yield r'ai_credits_balance';
      yield serializers.serialize(
        object.aiCreditsBalance,
        specifiedType: const FullType(double),
      );
    }
    if (object.aiCreditsMonthly != null) {
      yield r'ai_credits_monthly';
      yield serializers.serialize(
        object.aiCreditsMonthly,
        specifiedType: const FullType(int),
      );
    }
    if (object.aiDefaultProvider != null) {
      yield r'ai_default_provider';
      yield serializers.serialize(
        object.aiDefaultProvider,
        specifiedType: const FullType.nullable(AiProvider),
      );
    }
    if (object.aiEnabled != null) {
      yield r'ai_enabled';
      yield serializers.serialize(
        object.aiEnabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.aiMonthlyCreditsUsed != null) {
      yield r'ai_monthly_credits_used';
      yield serializers.serialize(
        object.aiMonthlyCreditsUsed,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.allowSharing != null) {
      yield r'allow_sharing';
      yield serializers.serialize(
        object.allowSharing,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(User),
      );
    }
    if (object.customSpaceTheme != null) {
      yield r'custom_space_theme';
      yield serializers.serialize(
        object.customSpaceTheme,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.demo != null) {
      yield r'demo';
      yield serializers.serialize(
        object.demo,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.fileSizeMb != null) {
      yield r'file_size_mb';
      yield serializers.serialize(
        object.fileSizeMb,
        specifiedType: const FullType.nullable(double),
      );
    }
    if (object.foodInherit != null) {
      yield r'food_inherit';
      yield serializers.serialize(
        object.foodInherit,
        specifiedType: const FullType(BuiltList, [FullType(FoodInheritField)]),
      );
    }
    if (object.householdSetupCompleted != null) {
      yield r'household_setup_completed';
      yield serializers.serialize(
        object.householdSetupCompleted,
        specifiedType: const FullType(bool),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.logoColor128 != null) {
      yield r'logo_color_128';
      yield serializers.serialize(
        object.logoColor128,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.logoColor144 != null) {
      yield r'logo_color_144';
      yield serializers.serialize(
        object.logoColor144,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.logoColor180 != null) {
      yield r'logo_color_180';
      yield serializers.serialize(
        object.logoColor180,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.logoColor192 != null) {
      yield r'logo_color_192';
      yield serializers.serialize(
        object.logoColor192,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.logoColor32 != null) {
      yield r'logo_color_32';
      yield serializers.serialize(
        object.logoColor32,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.logoColor512 != null) {
      yield r'logo_color_512';
      yield serializers.serialize(
        object.logoColor512,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.logoColorSvg != null) {
      yield r'logo_color_svg';
      yield serializers.serialize(
        object.logoColorSvg,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.maxFileStorageMb != null) {
      yield r'max_file_storage_mb';
      yield serializers.serialize(
        object.maxFileStorageMb,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.maxRecipes != null) {
      yield r'max_recipes';
      yield serializers.serialize(
        object.maxRecipes,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.maxUsers != null) {
      yield r'max_users';
      yield serializers.serialize(
        object.maxUsers,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.navBgColor != null) {
      yield r'nav_bg_color';
      yield serializers.serialize(
        object.navBgColor,
        specifiedType: const FullType(String),
      );
    }
    if (object.navLogo != null) {
      yield r'nav_logo';
      yield serializers.serialize(
        object.navLogo,
        specifiedType: const FullType.nullable(UserFileView),
      );
    }
    if (object.navTextColor != null) {
      yield r'nav_text_color';
      yield serializers.serialize(
        object.navTextColor,
        specifiedType: const FullType(SpaceNavTextColorEnum),
      );
    }
    if (object.recipeCount != null) {
      yield r'recipe_count';
      yield serializers.serialize(
        object.recipeCount,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.spaceSetupCompleted != null) {
      yield r'space_setup_completed';
      yield serializers.serialize(
        object.spaceSetupCompleted,
        specifiedType: const FullType(bool),
      );
    }
    if (object.spaceTheme != null) {
      yield r'space_theme';
      yield serializers.serialize(
        object.spaceTheme,
        specifiedType: const FullType(SpaceThemeEnum),
      );
    }
    if (object.userCount != null) {
      yield r'user_count';
      yield serializers.serialize(
        object.userCount,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Space object, {
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
    required SpaceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ai_credits_balance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.aiCreditsBalance = valueDes;
          break;
        case r'ai_credits_monthly':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.aiCreditsMonthly = valueDes;
          break;
        case r'ai_default_provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AiProvider),
          ) as AiProvider?;
          if (valueDes == null) continue;
          result.aiDefaultProvider.replace(valueDes);
          break;
        case r'ai_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.aiEnabled = valueDes;
          break;
        case r'ai_monthly_credits_used':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.aiMonthlyCreditsUsed = valueDes;
          break;
        case r'allow_sharing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.allowSharing = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(User),
          ) as User?;
          if (valueDes == null) continue;
          result.createdBy.replace(valueDes);
          break;
        case r'custom_space_theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.customSpaceTheme.replace(valueDes);
          break;
        case r'demo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.demo = valueDes;
          break;
        case r'file_size_mb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.fileSizeMb = valueDes;
          break;
        case r'food_inherit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(FoodInheritField),
            ]),
          ) as BuiltList<FoodInheritField>?;
          if (valueDes == null) continue;
          result.foodInherit.replace(valueDes);
          break;
        case r'household_setup_completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.householdSetupCompleted = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        case r'logo_color_128':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.logoColor128.replace(valueDes);
          break;
        case r'logo_color_144':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.logoColor144.replace(valueDes);
          break;
        case r'logo_color_180':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.logoColor180.replace(valueDes);
          break;
        case r'logo_color_192':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.logoColor192.replace(valueDes);
          break;
        case r'logo_color_32':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.logoColor32.replace(valueDes);
          break;
        case r'logo_color_512':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.logoColor512.replace(valueDes);
          break;
        case r'logo_color_svg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.logoColorSvg.replace(valueDes);
          break;
        case r'max_file_storage_mb':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxFileStorageMb = valueDes;
          break;
        case r'max_recipes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxRecipes = valueDes;
          break;
        case r'max_users':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxUsers = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'nav_bg_color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.navBgColor = valueDes;
          break;
        case r'nav_logo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserFileView),
          ) as UserFileView?;
          if (valueDes == null) continue;
          result.navLogo.replace(valueDes);
          break;
        case r'nav_text_color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SpaceNavTextColorEnum),
          ) as SpaceNavTextColorEnum?;
          if (valueDes == null) continue;
          result.navTextColor = valueDes;
          break;
        case r'recipe_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.recipeCount = valueDes;
          break;
        case r'space_setup_completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.spaceSetupCompleted = valueDes;
          break;
        case r'space_theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SpaceThemeEnum),
          ) as SpaceThemeEnum?;
          if (valueDes == null) continue;
          result.spaceTheme = valueDes;
          break;
        case r'user_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.userCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Space deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SpaceBuilder();
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
