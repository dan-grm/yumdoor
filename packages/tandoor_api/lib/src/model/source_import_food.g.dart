// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_food.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportFood extends SourceImportFood {
  @override
  final String name;

  factory _$SourceImportFood([
    void Function(SourceImportFoodBuilder)? updates,
  ]) => (SourceImportFoodBuilder()..update(updates))._build();

  _$SourceImportFood._({required this.name}) : super._();
  @override
  SourceImportFood rebuild(void Function(SourceImportFoodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SourceImportFoodBuilder toBuilder() =>
      SourceImportFoodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportFood && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'SourceImportFood',
    )..add('name', name)).toString();
  }
}

class SourceImportFoodBuilder
    implements Builder<SourceImportFood, SourceImportFoodBuilder> {
  _$SourceImportFood? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SourceImportFoodBuilder() {
    SourceImportFood._defaults(this);
  }

  SourceImportFoodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportFood other) {
    _$v = other as _$SourceImportFood;
  }

  @override
  void update(void Function(SourceImportFoodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportFood build() => _build();

  _$SourceImportFood _build() {
    final _$result =
        _$v ??
        _$SourceImportFood._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'SourceImportFood',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
