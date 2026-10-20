// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarklet_import.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookmarkletImport extends BookmarkletImport {
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final String html;
  @override
  final int? id;
  @override
  final String? url;

  factory _$BookmarkletImport([
    void Function(BookmarkletImportBuilder)? updates,
  ]) => (BookmarkletImportBuilder()..update(updates))._build();

  _$BookmarkletImport._({
    this.createdAt,
    this.createdBy,
    required this.html,
    this.id,
    this.url,
  }) : super._();
  @override
  BookmarkletImport rebuild(void Function(BookmarkletImportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookmarkletImportBuilder toBuilder() =>
      BookmarkletImportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookmarkletImport &&
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
    return (newBuiltValueToStringHelper(r'BookmarkletImport')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('html', html)
          ..add('id', id)
          ..add('url', url))
        .toString();
  }
}

class BookmarkletImportBuilder
    implements Builder<BookmarkletImport, BookmarkletImportBuilder> {
  _$BookmarkletImport? _$v;

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

  BookmarkletImportBuilder() {
    BookmarkletImport._defaults(this);
  }

  BookmarkletImportBuilder get _$this {
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
  void replace(BookmarkletImport other) {
    _$v = other as _$BookmarkletImport;
  }

  @override
  void update(void Function(BookmarkletImportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookmarkletImport build() => _build();

  _$BookmarkletImport _build() {
    final _$result =
        _$v ??
        _$BookmarkletImport._(
          createdAt: createdAt,
          createdBy: createdBy,
          html: BuiltValueNullFieldError.checkNotNull(
            html,
            r'BookmarkletImport',
            'html',
          ),
          id: id,
          url: url,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
