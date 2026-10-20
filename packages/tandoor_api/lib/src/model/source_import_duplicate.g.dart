// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_duplicate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportDuplicate extends SourceImportDuplicate {
  @override
  final int? id;
  @override
  final String name;

  factory _$SourceImportDuplicate([
    void Function(SourceImportDuplicateBuilder)? updates,
  ]) => (SourceImportDuplicateBuilder()..update(updates))._build();

  _$SourceImportDuplicate._({this.id, required this.name}) : super._();
  @override
  SourceImportDuplicate rebuild(
    void Function(SourceImportDuplicateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SourceImportDuplicateBuilder toBuilder() =>
      SourceImportDuplicateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportDuplicate &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SourceImportDuplicate')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SourceImportDuplicateBuilder
    implements Builder<SourceImportDuplicate, SourceImportDuplicateBuilder> {
  _$SourceImportDuplicate? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SourceImportDuplicateBuilder() {
    SourceImportDuplicate._defaults(this);
  }

  SourceImportDuplicateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportDuplicate other) {
    _$v = other as _$SourceImportDuplicate;
  }

  @override
  void update(void Function(SourceImportDuplicateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportDuplicate build() => _build();

  _$SourceImportDuplicate _build() {
    final _$result =
        _$v ??
        _$SourceImportDuplicate._(
          id: id,
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'SourceImportDuplicate',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
