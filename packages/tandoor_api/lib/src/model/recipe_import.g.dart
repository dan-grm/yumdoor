// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_import.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeImport extends RecipeImport {
  @override
  final DateTime? createdAt;
  @override
  final String? filePath;
  @override
  final String? fileUid;
  @override
  final int? id;
  @override
  final String name;
  @override
  final Storage storage;

  factory _$RecipeImport([void Function(RecipeImportBuilder)? updates]) =>
      (RecipeImportBuilder()..update(updates))._build();

  _$RecipeImport._({
    this.createdAt,
    this.filePath,
    this.fileUid,
    this.id,
    required this.name,
    required this.storage,
  }) : super._();
  @override
  RecipeImport rebuild(void Function(RecipeImportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeImportBuilder toBuilder() => RecipeImportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeImport &&
        createdAt == other.createdAt &&
        filePath == other.filePath &&
        fileUid == other.fileUid &&
        id == other.id &&
        name == other.name &&
        storage == other.storage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, filePath.hashCode);
    _$hash = $jc(_$hash, fileUid.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, storage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeImport')
          ..add('createdAt', createdAt)
          ..add('filePath', filePath)
          ..add('fileUid', fileUid)
          ..add('id', id)
          ..add('name', name)
          ..add('storage', storage))
        .toString();
  }
}

class RecipeImportBuilder
    implements Builder<RecipeImport, RecipeImportBuilder> {
  _$RecipeImport? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _filePath;
  String? get filePath => _$this._filePath;
  set filePath(String? filePath) => _$this._filePath = filePath;

  String? _fileUid;
  String? get fileUid => _$this._fileUid;
  set fileUid(String? fileUid) => _$this._fileUid = fileUid;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  StorageBuilder? _storage;
  StorageBuilder get storage => _$this._storage ??= StorageBuilder();
  set storage(StorageBuilder? storage) => _$this._storage = storage;

  RecipeImportBuilder() {
    RecipeImport._defaults(this);
  }

  RecipeImportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _filePath = $v.filePath;
      _fileUid = $v.fileUid;
      _id = $v.id;
      _name = $v.name;
      _storage = $v.storage.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeImport other) {
    _$v = other as _$RecipeImport;
  }

  @override
  void update(void Function(RecipeImportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeImport build() => _build();

  _$RecipeImport _build() {
    _$RecipeImport _$result;
    try {
      _$result =
          _$v ??
          _$RecipeImport._(
            createdAt: createdAt,
            filePath: filePath,
            fileUid: fileUid,
            id: id,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'RecipeImport',
              'name',
            ),
            storage: storage.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'storage';
        storage.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'RecipeImport',
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
