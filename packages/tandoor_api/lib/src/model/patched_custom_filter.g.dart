// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_custom_filter.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedCustomFilter extends PatchedCustomFilter {
  @override
  final int? createdBy;
  @override
  final int? id;
  @override
  final String? name;
  @override
  final String? search;
  @override
  final BuiltList<User>? shared;

  factory _$PatchedCustomFilter([
    void Function(PatchedCustomFilterBuilder)? updates,
  ]) => (PatchedCustomFilterBuilder()..update(updates))._build();

  _$PatchedCustomFilter._({
    this.createdBy,
    this.id,
    this.name,
    this.search,
    this.shared,
  }) : super._();
  @override
  PatchedCustomFilter rebuild(
    void Function(PatchedCustomFilterBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedCustomFilterBuilder toBuilder() =>
      PatchedCustomFilterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedCustomFilter &&
        createdBy == other.createdBy &&
        id == other.id &&
        name == other.name &&
        search == other.search &&
        shared == other.shared;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, search.hashCode);
    _$hash = $jc(_$hash, shared.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedCustomFilter')
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('name', name)
          ..add('search', search)
          ..add('shared', shared))
        .toString();
  }
}

class PatchedCustomFilterBuilder
    implements Builder<PatchedCustomFilter, PatchedCustomFilterBuilder> {
  _$PatchedCustomFilter? _$v;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _search;
  String? get search => _$this._search;
  set search(String? search) => _$this._search = search;

  ListBuilder<User>? _shared;
  ListBuilder<User> get shared => _$this._shared ??= ListBuilder<User>();
  set shared(ListBuilder<User>? shared) => _$this._shared = shared;

  PatchedCustomFilterBuilder() {
    PatchedCustomFilter._defaults(this);
  }

  PatchedCustomFilterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdBy = $v.createdBy;
      _id = $v.id;
      _name = $v.name;
      _search = $v.search;
      _shared = $v.shared?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedCustomFilter other) {
    _$v = other as _$PatchedCustomFilter;
  }

  @override
  void update(void Function(PatchedCustomFilterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedCustomFilter build() => _build();

  _$PatchedCustomFilter _build() {
    _$PatchedCustomFilter _$result;
    try {
      _$result =
          _$v ??
          _$PatchedCustomFilter._(
            createdBy: createdBy,
            id: id,
            name: name,
            search: search,
            shared: _shared?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'shared';
        _shared?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedCustomFilter',
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
