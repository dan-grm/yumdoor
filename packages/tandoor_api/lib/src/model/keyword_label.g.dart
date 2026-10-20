// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword_label.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$KeywordLabel extends KeywordLabel {
  @override
  final int? id;
  @override
  final String? label;

  factory _$KeywordLabel([void Function(KeywordLabelBuilder)? updates]) =>
      (KeywordLabelBuilder()..update(updates))._build();

  _$KeywordLabel._({this.id, this.label}) : super._();
  @override
  KeywordLabel rebuild(void Function(KeywordLabelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  KeywordLabelBuilder toBuilder() => KeywordLabelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is KeywordLabel && id == other.id && label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'KeywordLabel')
          ..add('id', id)
          ..add('label', label))
        .toString();
  }
}

class KeywordLabelBuilder
    implements Builder<KeywordLabel, KeywordLabelBuilder> {
  _$KeywordLabel? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  KeywordLabelBuilder() {
    KeywordLabel._defaults(this);
  }

  KeywordLabelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(KeywordLabel other) {
    _$v = other as _$KeywordLabel;
  }

  @override
  void update(void Function(KeywordLabelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  KeywordLabel build() => _build();

  _$KeywordLabel _build() {
    final _$result = _$v ?? _$KeywordLabel._(id: id, label: label);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
