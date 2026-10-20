// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SyncLog extends SyncLog {
  @override
  final DateTime? createdAt;
  @override
  final int? id;
  @override
  final String? msg;
  @override
  final String status;
  @override
  final ModelSync? sync_;

  factory _$SyncLog([void Function(SyncLogBuilder)? updates]) =>
      (SyncLogBuilder()..update(updates))._build();

  _$SyncLog._({
    this.createdAt,
    this.id,
    this.msg,
    required this.status,
    this.sync_,
  }) : super._();
  @override
  SyncLog rebuild(void Function(SyncLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SyncLogBuilder toBuilder() => SyncLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SyncLog &&
        createdAt == other.createdAt &&
        id == other.id &&
        msg == other.msg &&
        status == other.status &&
        sync_ == other.sync_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, msg.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, sync_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SyncLog')
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('msg', msg)
          ..add('status', status)
          ..add('sync_', sync_))
        .toString();
  }
}

class SyncLogBuilder implements Builder<SyncLog, SyncLogBuilder> {
  _$SyncLog? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _msg;
  String? get msg => _$this._msg;
  set msg(String? msg) => _$this._msg = msg;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  ModelSyncBuilder? _sync_;
  ModelSyncBuilder get sync_ => _$this._sync_ ??= ModelSyncBuilder();
  set sync_(ModelSyncBuilder? sync_) => _$this._sync_ = sync_;

  SyncLogBuilder() {
    SyncLog._defaults(this);
  }

  SyncLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _id = $v.id;
      _msg = $v.msg;
      _status = $v.status;
      _sync_ = $v.sync_?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SyncLog other) {
    _$v = other as _$SyncLog;
  }

  @override
  void update(void Function(SyncLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SyncLog build() => _build();

  _$SyncLog _build() {
    _$SyncLog _$result;
    try {
      _$result =
          _$v ??
          _$SyncLog._(
            createdAt: createdAt,
            id: id,
            msg: msg,
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'SyncLog',
              'status',
            ),
            sync_: _sync_?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sync_';
        _sync_?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SyncLog',
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
