// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InventoryLog extends InventoryLog {
  @override
  final BookingTypeEnum? bookingType;
  @override
  final DateTime? createdAt;
  @override
  final InventoryEntry entry;
  @override
  final int? id;
  @override
  final double? newAmount;
  @override
  final InventoryLocation newInventoryLocation;
  @override
  final String? note;
  @override
  final double? oldAmount;
  @override
  final InventoryLocation oldInventoryLocation;

  factory _$InventoryLog([void Function(InventoryLogBuilder)? updates]) =>
      (InventoryLogBuilder()..update(updates))._build();

  _$InventoryLog._({
    this.bookingType,
    this.createdAt,
    required this.entry,
    this.id,
    this.newAmount,
    required this.newInventoryLocation,
    this.note,
    this.oldAmount,
    required this.oldInventoryLocation,
  }) : super._();
  @override
  InventoryLog rebuild(void Function(InventoryLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InventoryLogBuilder toBuilder() => InventoryLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InventoryLog &&
        bookingType == other.bookingType &&
        createdAt == other.createdAt &&
        entry == other.entry &&
        id == other.id &&
        newAmount == other.newAmount &&
        newInventoryLocation == other.newInventoryLocation &&
        note == other.note &&
        oldAmount == other.oldAmount &&
        oldInventoryLocation == other.oldInventoryLocation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingType.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, entry.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, newAmount.hashCode);
    _$hash = $jc(_$hash, newInventoryLocation.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, oldAmount.hashCode);
    _$hash = $jc(_$hash, oldInventoryLocation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InventoryLog')
          ..add('bookingType', bookingType)
          ..add('createdAt', createdAt)
          ..add('entry', entry)
          ..add('id', id)
          ..add('newAmount', newAmount)
          ..add('newInventoryLocation', newInventoryLocation)
          ..add('note', note)
          ..add('oldAmount', oldAmount)
          ..add('oldInventoryLocation', oldInventoryLocation))
        .toString();
  }
}

class InventoryLogBuilder
    implements Builder<InventoryLog, InventoryLogBuilder> {
  _$InventoryLog? _$v;

  BookingTypeEnum? _bookingType;
  BookingTypeEnum? get bookingType => _$this._bookingType;
  set bookingType(BookingTypeEnum? bookingType) =>
      _$this._bookingType = bookingType;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  InventoryEntryBuilder? _entry;
  InventoryEntryBuilder get entry => _$this._entry ??= InventoryEntryBuilder();
  set entry(InventoryEntryBuilder? entry) => _$this._entry = entry;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  double? _newAmount;
  double? get newAmount => _$this._newAmount;
  set newAmount(double? newAmount) => _$this._newAmount = newAmount;

  InventoryLocationBuilder? _newInventoryLocation;
  InventoryLocationBuilder get newInventoryLocation =>
      _$this._newInventoryLocation ??= InventoryLocationBuilder();
  set newInventoryLocation(InventoryLocationBuilder? newInventoryLocation) =>
      _$this._newInventoryLocation = newInventoryLocation;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  double? _oldAmount;
  double? get oldAmount => _$this._oldAmount;
  set oldAmount(double? oldAmount) => _$this._oldAmount = oldAmount;

  InventoryLocationBuilder? _oldInventoryLocation;
  InventoryLocationBuilder get oldInventoryLocation =>
      _$this._oldInventoryLocation ??= InventoryLocationBuilder();
  set oldInventoryLocation(InventoryLocationBuilder? oldInventoryLocation) =>
      _$this._oldInventoryLocation = oldInventoryLocation;

  InventoryLogBuilder() {
    InventoryLog._defaults(this);
  }

  InventoryLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingType = $v.bookingType;
      _createdAt = $v.createdAt;
      _entry = $v.entry.toBuilder();
      _id = $v.id;
      _newAmount = $v.newAmount;
      _newInventoryLocation = $v.newInventoryLocation.toBuilder();
      _note = $v.note;
      _oldAmount = $v.oldAmount;
      _oldInventoryLocation = $v.oldInventoryLocation.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InventoryLog other) {
    _$v = other as _$InventoryLog;
  }

  @override
  void update(void Function(InventoryLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InventoryLog build() => _build();

  _$InventoryLog _build() {
    _$InventoryLog _$result;
    try {
      _$result =
          _$v ??
          _$InventoryLog._(
            bookingType: bookingType,
            createdAt: createdAt,
            entry: entry.build(),
            id: id,
            newAmount: newAmount,
            newInventoryLocation: newInventoryLocation.build(),
            note: note,
            oldAmount: oldAmount,
            oldInventoryLocation: oldInventoryLocation.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entry';
        entry.build();

        _$failedField = 'newInventoryLocation';
        newInventoryLocation.build();

        _$failedField = 'oldInventoryLocation';
        oldInventoryLocation.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'InventoryLog',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
