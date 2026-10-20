// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_bookmarklet_import.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedBookmarkletImport extends PatchedBookmarkletImport {
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final String? html;
  @override
  final int? id;
  @override
  final String? url;

  factory _$PatchedBookmarkletImport([
    void Function(PatchedBookmarkletImportBuilder)? updates,
  ]) => (PatchedBookmarkletImportBuilder()..update(updates))._build();

  _$PatchedBookmarkletImport._({
    this.createdAt,
    this.createdBy,
    this.html,
    this.id,
    this.url,
  }) : super._();
  @override
  PatchedBookmarkletImport rebuild(
    void Function(PatchedBookmarkletImportBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedBookmarkletImportBuilder toBuilder() =>
      PatchedBookmarkletImportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedBookmarkletImport &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        html == other.html &&
        id == other.id &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, html.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedBookmarkletImport')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('html', html)
          ..add('id', id)
          ..add('url', url))
        .toString();
  }
}

class PatchedBookmarkletImportBuilder
    implements
        Builder<PatchedBookmarkletImport, PatchedBookmarkletImportBuilder> {
  _$PatchedBookmarkletImport? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  String? _html;
  String? get html => _$this._html;
  set html(String? html) => _$this._html = html;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  PatchedBookmarkletImportBuilder() {
    PatchedBookmarkletImport._defaults(this);
  }

  PatchedBookmarkletImportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _html = $v.html;
      _id = $v.id;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedBookmarkletImport other) {
    _$v = other as _$PatchedBookmarkletImport;
  }

  @override
  void update(void Function(PatchedBookmarkletImportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedBookmarkletImport build() => _build();

  _$PatchedBookmarkletImport _build() {
    final _$result =
        _$v ??
        _$PatchedBookmarkletImport._(
          createdAt: createdAt,
          createdBy: createdBy,
          html: html,
          id: id,
          url: url,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
