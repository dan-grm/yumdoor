// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_file_view.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserFileView extends UserFileView {
  @override
  final DateTime? createdAt;
  @override
  final User? createdBy;
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

  factory _$UserFileView([void Function(UserFileViewBuilder)? updates]) =>
      (UserFileViewBuilder()..update(updates))._build();

  _$UserFileView._({
    this.createdAt,
    this.createdBy,
    this.fileDownload,
    this.fileSizeKb,
    this.id,
    required this.name,
    this.preview,
  }) : super._();
  @override
  UserFileView rebuild(void Function(UserFileViewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserFileViewBuilder toBuilder() => UserFileViewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserFileView &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
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
    return (newBuiltValueToStringHelper(r'UserFileView')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('fileDownload', fileDownload)
          ..add('fileSizeKb', fileSizeKb)
          ..add('id', id)
          ..add('name', name)
          ..add('preview', preview))
        .toString();
  }
}

class UserFileViewBuilder
    implements Builder<UserFileView, UserFileViewBuilder> {
  _$UserFileView? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  UserBuilder? _createdBy;
  UserBuilder get createdBy => _$this._createdBy ??= UserBuilder();
  set createdBy(UserBuilder? createdBy) => _$this._createdBy = createdBy;

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

  UserFileViewBuilder() {
    UserFileView._defaults(this);
  }

  UserFileViewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy?.toBuilder();
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
  void replace(UserFileView other) {
    _$v = other as _$UserFileView;
  }

  @override
  void update(void Function(UserFileViewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserFileView build() => _build();

  _$UserFileView _build() {
    _$UserFileView _$result;
    try {
      _$result =
          _$v ??
          _$UserFileView._(
            createdAt: createdAt,
            createdBy: _createdBy?.build(),
            fileDownload: fileDownload,
            fileSizeKb: fileSizeKb,
            id: id,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'UserFileView',
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
          r'UserFileView',
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
