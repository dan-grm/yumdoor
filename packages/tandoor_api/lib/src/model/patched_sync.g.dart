// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_sync.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedSync extends PatchedSync {
  @override
  final bool? active;
  @override
  final DateTime? createdAt;
  @override
  final int? id;
  @override
  final DateTime? lastChecked;
  @override
  final String? path;
  @override
  final Storage? storage;
  @override
  final DateTime? updatedAt;

  factory _$PatchedSync([void Function(PatchedSyncBuilder)? updates]) =>
      (PatchedSyncBuilder()..update(updates))._build();

  _$PatchedSync._({
    this.active,
    this.createdAt,
    this.id,
    this.lastChecked,
    this.path,
    this.storage,
    this.updatedAt,
  }) : super._();
  @override
  PatchedSync rebuild(void Function(PatchedSyncBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedSyncBuilder toBuilder() => PatchedSyncBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedSync &&
        active == other.active &&
        createdAt == other.createdAt &&
        id == other.id &&
        lastChecked == other.lastChecked &&
        path == other.path &&
        storage == other.storage &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, lastChecked.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, storage.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedSync')
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('lastChecked', lastChecked)
          ..add('path', path)
          ..add('storage', storage)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PatchedSyncBuilder implements Builder<PatchedSync, PatchedSyncBuilder> {
  _$PatchedSync? _$v;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  DateTime? _lastChecked;
  DateTime? get lastChecked => _$this._lastChecked;
  set lastChecked(DateTime? lastChecked) => _$this._lastChecked = lastChecked;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  StorageBuilder? _storage;
  StorageBuilder get storage => _$this._storage ??= StorageBuilder();
  set storage(StorageBuilder? storage) => _$this._storage = storage;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PatchedSyncBuilder() {
    PatchedSync._defaults(this);
  }

  PatchedSyncBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _active = $v.active;
      _createdAt = $v.createdAt;
      _id = $v.id;
      _lastChecked = $v.lastChecked;
      _path = $v.path;
      _storage = $v.storage?.toBuilder();
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedSync other) {
    _$v = other as _$PatchedSync;
  }

  @override
  void update(void Function(PatchedSyncBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedSync build() => _build();

  _$PatchedSync _build() {
    _$PatchedSync _$result;
    try {
      _$result =
          _$v ??
          _$PatchedSync._(
            active: active,
            createdAt: createdAt,
            id: id,
            lastChecked: lastChecked,
            path: path,
            storage: _storage?.build(),
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'storage';
        _storage?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedSync',
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
