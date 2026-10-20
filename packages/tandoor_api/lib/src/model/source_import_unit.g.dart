// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_unit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportUnit extends SourceImportUnit {
  @override
  final String name;

  factory _$SourceImportUnit([
    void Function(SourceImportUnitBuilder)? updates,
  ]) => (SourceImportUnitBuilder()..update(updates))._build();

  _$SourceImportUnit._({required this.name}) : super._();
  @override
  SourceImportUnit rebuild(void Function(SourceImportUnitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SourceImportUnitBuilder toBuilder() =>
      SourceImportUnitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportUnit && name == other.name;
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
      r'SourceImportUnit',
    )..add('name', name)).toString();
  }
}

class SourceImportUnitBuilder
    implements Builder<SourceImportUnit, SourceImportUnitBuilder> {
  _$SourceImportUnit? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SourceImportUnitBuilder() {
    SourceImportUnit._defaults(this);
  }

  SourceImportUnitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportUnit other) {
    _$v = other as _$SourceImportUnit;
  }

  @override
  void update(void Function(SourceImportUnitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportUnit build() => _build();

  _$SourceImportUnit _build() {
    final _$result =
        _$v ??
        _$SourceImportUnit._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'SourceImportUnit',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
