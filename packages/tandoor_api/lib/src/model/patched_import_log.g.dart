// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_import_log.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedImportLog extends PatchedImportLog {
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final int? id;
  @override
  final int? importedRecipes;
  @override
  final Keyword? keyword;
  @override
  final String? msg;
  @override
  final bool? running;
  @override
  final int? totalRecipes;
  @override
  final String? type;

  factory _$PatchedImportLog([
    void Function(PatchedImportLogBuilder)? updates,
  ]) => (PatchedImportLogBuilder()..update(updates))._build();

  _$PatchedImportLog._({
    this.createdAt,
    this.createdBy,
    this.id,
    this.importedRecipes,
    this.keyword,
    this.msg,
    this.running,
    this.totalRecipes,
    this.type,
  }) : super._();
  @override
  PatchedImportLog rebuild(void Function(PatchedImportLogBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedImportLogBuilder toBuilder() =>
      PatchedImportLogBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedImportLog &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        id == other.id &&
        importedRecipes == other.importedRecipes &&
        keyword == other.keyword &&
        msg == other.msg &&
        running == other.running &&
        totalRecipes == other.totalRecipes &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, importedRecipes.hashCode);
    _$hash = $jc(_$hash, keyword.hashCode);
    _$hash = $jc(_$hash, msg.hashCode);
    _$hash = $jc(_$hash, running.hashCode);
    _$hash = $jc(_$hash, totalRecipes.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedImportLog')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('importedRecipes', importedRecipes)
          ..add('keyword', keyword)
          ..add('msg', msg)
          ..add('running', running)
          ..add('totalRecipes', totalRecipes)
          ..add('type', type))
        .toString();
  }
}

class PatchedImportLogBuilder
    implements Builder<PatchedImportLog, PatchedImportLogBuilder> {
  _$PatchedImportLog? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _importedRecipes;
  int? get importedRecipes => _$this._importedRecipes;
  set importedRecipes(int? importedRecipes) =>
      _$this._importedRecipes = importedRecipes;

  KeywordBuilder? _keyword;
  KeywordBuilder get keyword => _$this._keyword ??= KeywordBuilder();
  set keyword(KeywordBuilder? keyword) => _$this._keyword = keyword;

  String? _msg;
  String? get msg => _$this._msg;
  set msg(String? msg) => _$this._msg = msg;

  bool? _running;
  bool? get running => _$this._running;
  set running(bool? running) => _$this._running = running;

  int? _totalRecipes;
  int? get totalRecipes => _$this._totalRecipes;
  set totalRecipes(int? totalRecipes) => _$this._totalRecipes = totalRecipes;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  PatchedImportLogBuilder() {
    PatchedImportLog._defaults(this);
  }

  PatchedImportLogBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _id = $v.id;
      _importedRecipes = $v.importedRecipes;
      _keyword = $v.keyword?.toBuilder();
      _msg = $v.msg;
      _running = $v.running;
      _totalRecipes = $v.totalRecipes;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedImportLog other) {
    _$v = other as _$PatchedImportLog;
  }

  @override
  void update(void Function(PatchedImportLogBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedImportLog build() => _build();

  _$PatchedImportLog _build() {
    _$PatchedImportLog _$result;
    try {
      _$result =
          _$v ??
          _$PatchedImportLog._(
            createdAt: createdAt,
            createdBy: createdBy,
            id: id,
            importedRecipes: importedRecipes,
            keyword: _keyword?.build(),
            msg: msg,
            running: running,
            totalRecipes: totalRecipes,
            type: type,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keyword';
        _keyword?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedImportLog',
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
