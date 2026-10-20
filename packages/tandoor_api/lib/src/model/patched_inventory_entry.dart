//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/date.dart';
import 'package:tandoor_api/src/model/inventory_location.dart';
import 'package:tandoor_api/src/model/food.dart';
import 'package:tandoor_api/src/model/unit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'patched_inventory_entry.g.dart';

/// Adds nested create feature
///
/// Properties:
/// * [amount]
/// * [code]
/// * [createdAt]
/// * [createdBy]
/// * [expires]
/// * [food]
/// * [id]
/// * [inventoryLocation]
/// * [label]
/// * [note]
/// * [subLocation]
/// * [unit]
@BuiltValue()
abstract class PatchedInventoryEntry
    implements Built<PatchedInventoryEntry, PatchedInventoryEntryBuilder> {
  @BuiltValueField(wireName: r'amount')
  double? get amount;

  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'created_by')
  int? get createdBy;

  @BuiltValueField(wireName: r'expires')
  Date? get expires;

  @BuiltValueField(wireName: r'food')
  Food? get food;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'inventory_location')
  InventoryLocation? get inventoryLocation;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'sub_location')
  String? get subLocation;

  @BuiltValueField(wireName: r'unit')
  Unit? get unit;

  PatchedInventoryEntry._();

  factory PatchedInventoryEntry([
    void updates(PatchedInventoryEntryBuilder b),
  ]) = _$PatchedInventoryEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PatchedInventoryEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PatchedInventoryEntry> get serializer =>
      _$PatchedInventoryEntrySerializer();
}

class _$PatchedInventoryEntrySerializer
    implements PrimitiveSerializer<PatchedInventoryEntry> {
  @override
  final Iterable<Type> types = const [
    PatchedInventoryEntry,
    _$PatchedInventoryEntry,
  ];

  @override
  final String wireName = r'PatchedInventoryEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PatchedInventoryEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.amount != null) {
      yield r'amount';
      yield serializers.serialize(
        object.amount,
        specifiedType: const FullType(double),
      );
    }
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType.nullable(String),
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
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.expires != null) {
      yield r'expires';
      yield serializers.serialize(
        object.expires,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.food != null) {
      yield r'food';
      yield serializers.serialize(
        object.food,
        specifiedType: const FullType(Food),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.inventoryLocation != null) {
      yield r'inventory_location';
      yield serializers.serialize(
        object.inventoryLocation,
        specifiedType: const FullType(InventoryLocation),
      );
    }
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.subLocation != null) {
      yield r'sub_location';
      yield serializers.serialize(
        object.subLocation,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.unit != null) {
      yield r'unit';
      yield serializers.serialize(
        object.unit,
        specifiedType: const FullType(Unit),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PatchedInventoryEntry object, {
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
    required PatchedInventoryEntryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
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
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.createdBy = valueDes;
          break;
        case r'expires':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.expires = valueDes;
          break;
        case r'food':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Food),
          ) as Food?;
          if (valueDes == null) continue;
          result.food.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'inventory_location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(InventoryLocation),
          ) as InventoryLocation?;
          if (valueDes == null) continue;
          result.inventoryLocation.replace(valueDes);
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'sub_location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subLocation = valueDes;
          break;
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Unit),
          ) as Unit?;
          if (valueDes == null) continue;
          result.unit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PatchedInventoryEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PatchedInventoryEntryBuilder();
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
