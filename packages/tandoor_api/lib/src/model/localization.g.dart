// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Localization extends Localization {
  @override
  final String? code;
  @override
  final String? language;

  factory _$Localization([void Function(LocalizationBuilder)? updates]) =>
      (LocalizationBuilder()..update(updates))._build();

  _$Localization._({this.code, this.language}) : super._();
  @override
  Localization rebuild(void Function(LocalizationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocalizationBuilder toBuilder() => LocalizationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Localization &&
        code == other.code &&
        language == other.language;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, language.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Localization')
          ..add('code', code)
          ..add('language', language))
        .toString();
  }
}

class LocalizationBuilder
    implements Builder<Localization, LocalizationBuilder> {
  _$Localization? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _language;
  String? get language => _$this._language;
  set language(String? language) => _$this._language = language;

  LocalizationBuilder() {
    Localization._defaults(this);
  }

  LocalizationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _language = $v.language;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Localization other) {
    _$v = other as _$Localization;
  }

  @override
  void update(void Function(LocalizationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Localization build() => _build();

  _$Localization _build() {
    final _$result = _$v ?? _$Localization._(code: code, language: language);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
