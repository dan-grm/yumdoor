// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_file.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserFile extends UserFile {
  @override
  final DateTime? createdAt;
  @override
  final User? createdBy;
  @override
  final String? file;
  @override
  final String? fileDownload;
  @override
  final int? fileSizeKb;
  @override
  final int? id;
  @override
  final String name;
  @override
  final String? preview;

  factory _$UserFile([void Function(UserFileBuilder)? updates]) =>
      (UserFileBuilder()..update(updates))._build();

  _$UserFile._({
    this.createdAt,
    this.createdBy,
    this.file,
    this.fileDownload,
    this.fileSizeKb,
    this.id,
    required this.name,
    this.preview,
  }) : super._();
  @override
  UserFile rebuild(void Function(UserFileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserFileBuilder toBuilder() => UserFileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserFile &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        file == other.file &&
        fileDownload == other.fileDownload &&
        fileSizeKb == other.fileSizeKb &&
        id == other.id &&
        name == other.name &&
        preview == other.preview;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, file.hashCode);
    _$hash = $jc(_$hash, fileDownload.hashCode);
    _$hash = $jc(_$hash, fileSizeKb.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, preview.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserFile')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('file', file)
          ..add('fileDownload', fileDownload)
          ..add('fileSizeKb', fileSizeKb)
          ..add('id', id)
          ..add('name', name)
          ..add('preview', preview))
        .toString();
  }
}

class UserFileBuilder implements Builder<UserFile, UserFileBuilder> {
  _$UserFile? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

  String? _file;
  String? get file => _$this._file;
  set file(String? file) => _$this._file = file;

  String? _fileDownload;
  String? get fileDownload => _$this._fileDownload;
  set fileDownload(String? fileDownload) => _$this._fileDownload = fileDownload;

  int? _fileSizeKb;
  int? get fileSizeKb => _$this._fileSizeKb;
  set fileSizeKb(int? fileSizeKb) => _$this._fileSizeKb = fileSizeKb;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _preview;
  String? get preview => _$this._preview;
  set preview(String? preview) => _$this._preview = preview;

  UserFileBuilder() {
    UserFile._defaults(this);
  }

  UserFileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy?.toBuilder();
      _file = $v.file;
      _fileDownload = $v.fileDownload;
      _fileSizeKb = $v.fileSizeKb;
      _id = $v.id;
      _name = $v.name;
      _preview = $v.preview;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserFile other) {
    _$v = other as _$UserFile;
  }

  @override
  void update(void Function(UserFileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserFile build() => _build();

  _$UserFile _build() {
    _$UserFile _$result;
    try {
      _$result =
          _$v ??
          _$UserFile._(
            createdAt: createdAt,
            createdBy: _createdBy?.build(),
            file: file,
            fileDownload: fileDownload,
            fileSizeKb: fileSizeKb,
            id: id,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'UserFile',
              'name',
            ),
            preview: preview,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'createdBy';
        _createdBy?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UserFile',
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
