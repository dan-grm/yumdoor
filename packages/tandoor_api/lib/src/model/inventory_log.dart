//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:tandoor_api/src/model/booking_type_enum.dart';
import 'package:tandoor_api/src/model/inventory_location.dart';
import 'package:tandoor_api/src/model/inventory_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_log.g.dart';

/// InventoryLog
///
/// Properties:
/// * [bookingType]
/// * [createdAt]
/// * [entry]
/// * [id]
/// * [newAmount]
/// * [newInventoryLocation]
/// * [note]
/// * [oldAmount]
/// * [oldInventoryLocation]
@BuiltValue()
abstract class InventoryLog
    implements Built<InventoryLog, InventoryLogBuilder> {
  @BuiltValueField(wireName: r'booking_type')
  BookingTypeEnum? get bookingType;
  // enum bookingTypeEnum {  add,  remove,  move,  };

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'entry')
  InventoryEntry get entry;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'new_amount')
  double? get newAmount;

  @BuiltValueField(wireName: r'new_inventory_location')
  InventoryLocation get newInventoryLocation;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'old_amount')
  double? get oldAmount;

  @BuiltValueField(wireName: r'old_inventory_location')
  InventoryLocation get oldInventoryLocation;

  InventoryLog._();

  factory InventoryLog([void updates(InventoryLogBuilder b)]) = _$InventoryLog;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryLogBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryLog> get serializer => _$InventoryLogSerializer();
}

class _$InventoryLogSerializer implements PrimitiveSerializer<InventoryLog> {
  @override
  final Iterable<Type> types = const [InventoryLog, _$InventoryLog];

  @override
  final String wireName = r'InventoryLog';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryLog object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.bookingType != null) {
      yield r'booking_type';
      yield serializers.serialize(
        object.bookingType,
        specifiedType: const FullType(BookingTypeEnum),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'entry';
    yield serializers.serialize(
      object.entry,
      specifiedType: const FullType(InventoryEntry),
    );
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.newAmount != null) {
      yield r'new_amount';
      yield serializers.serialize(
        object.newAmount,
        specifiedType: const FullType(double),
      );
    }
    yield r'new_inventory_location';
    yield serializers.serialize(
      object.newInventoryLocation,
      specifiedType: const FullType(InventoryLocation),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.oldAmount != null) {
      yield r'old_amount';
      yield serializers.serialize(
        object.oldAmount,
        specifiedType: const FullType(double),
      );
    }
    yield r'old_inventory_location';
    yield serializers.serialize(
      object.oldInventoryLocation,
      specifiedType: const FullType(InventoryLocation),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InventoryLog object, {
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
    required InventoryLogBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'booking_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BookingTypeEnum),
          ) as BookingTypeEnum?;
          if (valueDes == null) continue;
          result.bookingType = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'entry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryEntry),
          ) as InventoryEntry;
          result.entry.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'new_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.newAmount = valueDes;
          break;
        case r'new_inventory_location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryLocation),
          ) as InventoryLocation;
          result.newInventoryLocation.replace(valueDes);
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'old_amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.oldAmount = valueDes;
          break;
        case r'old_inventory_location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryLocation),
          ) as InventoryLocation;
          result.oldInventoryLocation.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InventoryLog deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryLogBuilder();
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
