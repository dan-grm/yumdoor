// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExportLog extends ExportLog {
  @override
  final int? cacheDuration;
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final int? exportedRecipes;
  @override
  final int? id;
  @override
  final String? msg;
  @override
  final bool? possiblyNotExpired;
  @override
  final bool? running;
  @override
  final int? totalRecipes;
  @override
  final String type;

  factory _$ExportLog([void Function(ExportLogBuilder)? updates]) =>
      (ExportLogBuilder()..update(updates))._build();

  _$ExportLog._({
    this.cacheDuration,
    this.createdAt,
    this.createdBy,
    this.exportedRecipes,
    this.id,
    this.msg,
    this.possiblyNotExpired,
    this.running,
    this.totalRecipes,
    required this.type,
  }) : super._();
  @override
  ExportLog rebuild(void Function(ExportLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExportLogBuilder toBuilder() => ExportLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExportLog &&
        cacheDuration == other.cacheDuration &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        exportedRecipes == other.exportedRecipes &&
        id == other.id &&
        msg == other.msg &&
        possiblyNotExpired == other.possiblyNotExpired &&
        running == other.running &&
        totalRecipes == other.totalRecipes &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cacheDuration.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, exportedRecipes.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, msg.hashCode);
    _$hash = $jc(_$hash, possiblyNotExpired.hashCode);
    _$hash = $jc(_$hash, running.hashCode);
    _$hash = $jc(_$hash, totalRecipes.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExportLog')
          ..add('cacheDuration', cacheDuration)
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('exportedRecipes', exportedRecipes)
          ..add('id', id)
          ..add('msg', msg)
          ..add('possiblyNotExpired', possiblyNotExpired)
          ..add('running', running)
          ..add('totalRecipes', totalRecipes)
          ..add('type', type))
        .toString();
  }
}

class ExportLogBuilder implements Builder<ExportLog, ExportLogBuilder> {
  _$ExportLog? _$v;

  int? _cacheDuration;
  int? get cacheDuration => _$this._cacheDuration;
  set cacheDuration(int? cacheDuration) =>
      _$this._cacheDuration = cacheDuration;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  int? _exportedRecipes;
  int? get exportedRecipes => _$this._exportedRecipes;
  set exportedRecipes(int? exportedRecipes) =>
      _$this._exportedRecipes = exportedRecipes;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _msg;
  String? get msg => _$this._msg;
  set msg(String? msg) => _$this._msg = msg;

  bool? _possiblyNotExpired;
  bool? get possiblyNotExpired => _$this._possiblyNotExpired;
  set possiblyNotExpired(bool? possiblyNotExpired) =>
      _$this._possiblyNotExpired = possiblyNotExpired;

  bool? _running;
  bool? get running => _$this._running;
  set running(bool? running) => _$this._running = running;

  int? _totalRecipes;
  int? get totalRecipes => _$this._totalRecipes;
  set totalRecipes(int? totalRecipes) => _$this._totalRecipes = totalRecipes;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ExportLogBuilder() {
    ExportLog._defaults(this);
  }

  ExportLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cacheDuration = $v.cacheDuration;
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _exportedRecipes = $v.exportedRecipes;
      _id = $v.id;
      _msg = $v.msg;
      _possiblyNotExpired = $v.possiblyNotExpired;
      _running = $v.running;
      _totalRecipes = $v.totalRecipes;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExportLog other) {
    _$v = other as _$ExportLog;
  }

  @override
  void update(void Function(ExportLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExportLog build() => _build();

  _$ExportLog _build() {
    final _$result =
        _$v ??
        _$ExportLog._(
          cacheDuration: cacheDuration,
          createdAt: createdAt,
          createdBy: createdBy,
          exportedRecipes: exportedRecipes,
          id: id,
          msg: msg,
          possiblyNotExpired: possiblyNotExpired,
          running: running,
          totalRecipes: totalRecipes,
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'ExportLog',
            'type',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
