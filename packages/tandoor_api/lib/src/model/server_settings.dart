//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'server_settings.g.dart';

/// ServerSettings
///
/// Properties:
/// * [customSpaceTheme]
/// * [debug]
/// * [disableExternalConnectors]
/// * [forceThemeFromSpace]
/// * [hosted]
/// * [imprintUrl]
/// * [logoColor128]
/// * [logoColor144]
/// * [logoColor180]
/// * [logoColor192]
/// * [logoColor32]
/// * [logoColor512]
/// * [logoColorSvg]
/// * [navBgColor]
/// * [navLogo]
/// * [privacyUrl]
/// * [shoppingMinAutosyncInterval]
/// * [termsUrl]
/// * [unauthenticatedThemeFromSpace]
/// * [version]
@BuiltValue()
abstract class ServerSettings
    implements Built<ServerSettings, ServerSettingsBuilder> {
  @BuiltValueField(wireName: r'custom_space_theme')
  String? get customSpaceTheme;

  @BuiltValueField(wireName: r'debug')
  bool get debug;

  @BuiltValueField(wireName: r'disable_external_connectors')
  bool get disableExternalConnectors;

  @BuiltValueField(wireName: r'force_theme_from_space')
  int get forceThemeFromSpace;

  @BuiltValueField(wireName: r'hosted')
  bool get hosted;

  @BuiltValueField(wireName: r'imprint_url')
  String get imprintUrl;

  @BuiltValueField(wireName: r'logo_color_128')
  String? get logoColor128;

  @BuiltValueField(wireName: r'logo_color_144')
  String? get logoColor144;

  @BuiltValueField(wireName: r'logo_color_180')
  String? get logoColor180;

  @BuiltValueField(wireName: r'logo_color_192')
  String? get logoColor192;

  @BuiltValueField(wireName: r'logo_color_32')
  String? get logoColor32;

  @BuiltValueField(wireName: r'logo_color_512')
  String? get logoColor512;

  @BuiltValueField(wireName: r'logo_color_svg')
  String? get logoColorSvg;

  @BuiltValueField(wireName: r'nav_bg_color')
  String? get navBgColor;

  @BuiltValueField(wireName: r'nav_logo')
  String? get navLogo;

  @BuiltValueField(wireName: r'privacy_url')
  String get privacyUrl;

  @BuiltValueField(wireName: r'shopping_min_autosync_interval')
  String get shoppingMinAutosyncInterval;

  @BuiltValueField(wireName: r'terms_url')
  String get termsUrl;

  @BuiltValueField(wireName: r'unauthenticated_theme_from_space')
  int get unauthenticatedThemeFromSpace;

  @BuiltValueField(wireName: r'version')
  String get version;

  ServerSettings._();

  factory ServerSettings([void updates(ServerSettingsBuilder b)]) =
      _$ServerSettings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ServerSettingsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ServerSettings> get serializer =>
      _$ServerSettingsSerializer();
}

class _$ServerSettingsSerializer
    implements PrimitiveSerializer<ServerSettings> {
  @override
  final Iterable<Type> types = const [ServerSettings, _$ServerSettings];

  @override
  final String wireName = r'ServerSettings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ServerSettings object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.customSpaceTheme != null) {
      yield r'custom_space_theme';
      yield serializers.serialize(
        object.customSpaceTheme,
        specifiedType: const FullType(String),
      );
    }
    yield r'debug';
    yield serializers.serialize(
      object.debug,
      specifiedType: const FullType(bool),
    );
    yield r'disable_external_connectors';
    yield serializers.serialize(
      object.disableExternalConnectors,
      specifiedType: const FullType(bool),
    );
    yield r'force_theme_from_space';
    yield serializers.serialize(
      object.forceThemeFromSpace,
      specifiedType: const FullType(int),
    );
    yield r'hosted';
    yield serializers.serialize(
      object.hosted,
      specifiedType: const FullType(bool),
    );
    yield r'imprint_url';
    yield serializers.serialize(
      object.imprintUrl,
      specifiedType: const FullType(String),
    );
    if (object.logoColor128 != null) {
      yield r'logo_color_128';
      yield serializers.serialize(
        object.logoColor128,
        specifiedType: const FullType(String),
      );
    }
    if (object.logoColor144 != null) {
      yield r'logo_color_144';
      yield serializers.serialize(
        object.logoColor144,
        specifiedType: const FullType(String),
      );
    }
    if (object.logoColor180 != null) {
      yield r'logo_color_180';
      yield serializers.serialize(
        object.logoColor180,
        specifiedType: const FullType(String),
      );
    }
    if (object.logoColor192 != null) {
      yield r'logo_color_192';
      yield serializers.serialize(
        object.logoColor192,
        specifiedType: const FullType(String),
      );
    }
    if (object.logoColor32 != null) {
      yield r'logo_color_32';
      yield serializers.serialize(
        object.logoColor32,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.logoColor512 != null) {
      yield r'logo_color_512';
      yield serializers.serialize(
        object.logoColor512,
        specifiedType: const FullType(String),
      );
    }
    if (object.logoColorSvg != null) {
      yield r'logo_color_svg';
      yield serializers.serialize(
        object.logoColorSvg,
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
        specifiedType: const FullType(String),
      );
    }
    yield r'privacy_url';
    yield serializers.serialize(
      object.privacyUrl,
      specifiedType: const FullType(String),
    );
    yield r'shopping_min_autosync_interval';
    yield serializers.serialize(
      object.shoppingMinAutosyncInterval,
      specifiedType: const FullType(String),
    );
    yield r'terms_url';
    yield serializers.serialize(
      object.termsUrl,
      specifiedType: const FullType(String),
    );
    yield r'unauthenticated_theme_from_space';
    yield serializers.serialize(
      object.unauthenticatedThemeFromSpace,
      specifiedType: const FullType(int),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ServerSettings object, {
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
    required ServerSettingsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'custom_space_theme':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customSpaceTheme = valueDes;
          break;
        case r'debug':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.debug = valueDes;
          break;
        case r'disable_external_connectors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.disableExternalConnectors = valueDes;
          break;
        case r'force_theme_from_space':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.forceThemeFromSpace = valueDes;
          break;
        case r'hosted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hosted = valueDes;
          break;
        case r'imprint_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imprintUrl = valueDes;
          break;
        case r'logo_color_128':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoColor128 = valueDes;
          break;
        case r'logo_color_144':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoColor144 = valueDes;
          break;
        case r'logo_color_180':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoColor180 = valueDes;
          break;
        case r'logo_color_192':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoColor192 = valueDes;
          break;
        case r'logo_color_32':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoColor32 = valueDes;
          break;
        case r'logo_color_512':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoColor512 = valueDes;
          break;
        case r'logo_color_svg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoColorSvg = valueDes;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.navLogo = valueDes;
          break;
        case r'privacy_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.privacyUrl = valueDes;
          break;
        case r'shopping_min_autosync_interval':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shoppingMinAutosyncInterval = valueDes;
          break;
        case r'terms_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.termsUrl = valueDes;
          break;
        case r'unauthenticated_theme_from_space':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unauthenticatedThemeFromSpace = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ServerSettings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ServerSettingsBuilder();
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
