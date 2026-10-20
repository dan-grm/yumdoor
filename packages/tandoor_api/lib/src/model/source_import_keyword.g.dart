// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_import_keyword.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SourceImportKeyword extends SourceImportKeyword {
  @override
  final int? id;
  @override
  final bool? importKeyword;
  @override
  final String label;
  @override
  final String name;

  factory _$SourceImportKeyword([
    void Function(SourceImportKeywordBuilder)? updates,
  ]) => (SourceImportKeywordBuilder()..update(updates))._build();

  _$SourceImportKeyword._({
    this.id,
    this.importKeyword,
    required this.label,
    required this.name,
  }) : super._();
  @override
  SourceImportKeyword rebuild(
    void Function(SourceImportKeywordBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SourceImportKeywordBuilder toBuilder() =>
      SourceImportKeywordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceImportKeyword &&
        id == other.id &&
        importKeyword == other.importKeyword &&
        label == other.label &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, importKeyword.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SourceImportKeyword')
          ..add('id', id)
          ..add('importKeyword', importKeyword)
          ..add('label', label)
          ..add('name', name))
        .toString();
  }
}

class SourceImportKeywordBuilder
    implements Builder<SourceImportKeyword, SourceImportKeywordBuilder> {
  _$SourceImportKeyword? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  bool? _importKeyword;
  bool? get importKeyword => _$this._importKeyword;
  set importKeyword(bool? importKeyword) =>
      _$this._importKeyword = importKeyword;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SourceImportKeywordBuilder() {
    SourceImportKeyword._defaults(this);
  }

  SourceImportKeywordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _importKeyword = $v.importKeyword;
      _label = $v.label;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceImportKeyword other) {
    _$v = other as _$SourceImportKeyword;
  }

  @override
  void update(void Function(SourceImportKeywordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SourceImportKeyword build() => _build();

  _$SourceImportKeyword _build() {
    final _$result =
        _$v ??
        _$SourceImportKeyword._(
          id: id,
          importKeyword: importKeyword,
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'SourceImportKeyword',
            'label',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'SourceImportKeyword',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
