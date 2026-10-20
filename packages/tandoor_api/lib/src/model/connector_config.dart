//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/connector_config_type_enum.dart';
import 'package:tandoor_api/src/model/connector_config_url.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'connector_config.g.dart';

/// ConnectorConfig
///
/// Properties:
/// * [createdBy]
/// * [enabled] - Is Connector Enabled
/// * [id]
/// * [name]
/// * [onShoppingListEntryCreatedEnabled]
/// * [onShoppingListEntryDeletedEnabled]
/// * [onShoppingListEntryUpdatedEnabled]
/// * [supportsDescriptionField] - Does the todo entity support the description field
/// * [todoEntity]
/// * [token]
/// * [type]
/// * [url]
@BuiltValue()
abstract class ConnectorConfig
    implements Built<ConnectorConfig, ConnectorConfigBuilder> {
  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  /// Is Connector Enabled
  @BuiltValueField(wireName: r'enabled')
  bool? get enabled;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'on_shopping_list_entry_created_enabled')
  bool? get onShoppingListEntryCreatedEnabled;

  @BuiltValueField(wireName: r'on_shopping_list_entry_deleted_enabled')
  bool? get onShoppingListEntryDeletedEnabled;

  @BuiltValueField(wireName: r'on_shopping_list_entry_updated_enabled')
  bool? get onShoppingListEntryUpdatedEnabled;

  /// Does the todo entity support the description field
  @BuiltValueField(wireName: r'supports_description_field')
  bool? get supportsDescriptionField;

  @BuiltValueField(wireName: r'todo_entity')
  String? get todoEntity;

  @BuiltValueField(wireName: r'token')
  String? get token;

  @BuiltValueField(wireName: r'type')
  ConnectorConfigTypeEnum? get type;
  // enum typeEnum {  HomeAssistant,  };

  @BuiltValueField(wireName: r'url')
  ConnectorConfigUrl? get url;

  ConnectorConfig._();

  factory ConnectorConfig([void updates(ConnectorConfigBuilder b)]) =
      _$ConnectorConfig;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConnectorConfigBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConnectorConfig> get serializer =>
      _$ConnectorConfigSerializer();
}

class _$ConnectorConfigSerializer
    implements PrimitiveSerializer<ConnectorConfig> {
  @override
  final Iterable<Type> types = const [ConnectorConfig, _$ConnectorConfig];

  @override
  final String wireName = r'ConnectorConfig';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConnectorConfig object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.createdBy != null) {
      yield r'created_by';
      yield serializers.serialize(
        object.createdBy,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.enabled != null) {
      yield r'enabled';
      yield serializers.serialize(
        object.enabled,
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
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.onShoppingListEntryCreatedEnabled != null) {
      yield r'on_shopping_list_entry_created_enabled';
      yield serializers.serialize(
        object.onShoppingListEntryCreatedEnabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.onShoppingListEntryDeletedEnabled != null) {
      yield r'on_shopping_list_entry_deleted_enabled';
      yield serializers.serialize(
        object.onShoppingListEntryDeletedEnabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.onShoppingListEntryUpdatedEnabled != null) {
      yield r'on_shopping_list_entry_updated_enabled';
      yield serializers.serialize(
        object.onShoppingListEntryUpdatedEnabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.supportsDescriptionField != null) {
      yield r'supports_description_field';
      yield serializers.serialize(
        object.supportsDescriptionField,
        specifiedType: const FullType(bool),
      );
    }
    if (object.todoEntity != null) {
      yield r'todo_entity';
      yield serializers.serialize(
        object.todoEntity,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.token != null) {
      yield r'token';
      yield serializers.serialize(
        object.token,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(ConnectorConfigTypeEnum),
      );
    }
    if (object.url != null) {
      yield r'url';
      yield serializers.serialize(
        object.url,
        specifiedType: const FullType.nullable(ConnectorConfigUrl),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ConnectorConfig object, {
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
    required ConnectorConfigBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'created_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.enabled = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'on_shopping_list_entry_created_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.onShoppingListEntryCreatedEnabled = valueDes;
          break;
        case r'on_shopping_list_entry_deleted_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.onShoppingListEntryDeletedEnabled = valueDes;
          break;
        case r'on_shopping_list_entry_updated_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.onShoppingListEntryUpdatedEnabled = valueDes;
          break;
        case r'supports_description_field':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.supportsDescriptionField = valueDes;
          break;
        case r'todo_entity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.todoEntity = valueDes;
          break;
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.token = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ConnectorConfigTypeEnum),
          ) as ConnectorConfigTypeEnum?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ConnectorConfigUrl),
          ) as ConnectorConfigUrl?;
          if (valueDes == null) continue;
          result.url.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConnectorConfig deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConnectorConfigBuilder();
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
