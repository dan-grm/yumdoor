// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarklet_import_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookmarkletImportList extends BookmarkletImportList {
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final int? id;
  @override
  final String? url;

  factory _$BookmarkletImportList([
    void Function(BookmarkletImportListBuilder)? updates,
  ]) => (BookmarkletImportListBuilder()..update(updates))._build();

  _$BookmarkletImportList._({this.createdAt, this.createdBy, this.id, this.url})
    : super._();
  @override
  BookmarkletImportList rebuild(
    void Function(BookmarkletImportListBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  BookmarkletImportListBuilder toBuilder() =>
      BookmarkletImportListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookmarkletImportList &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        id == other.id &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookmarkletImportList')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('url', url))
        .toString();
  }
}

class BookmarkletImportListBuilder
    implements Builder<BookmarkletImportList, BookmarkletImportListBuilder> {
  _$BookmarkletImportList? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  BookmarkletImportListBuilder() {
    BookmarkletImportList._defaults(this);
  }

  BookmarkletImportListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _id = $v.id;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookmarkletImportList other) {
    _$v = other as _$BookmarkletImportList;
  }

  @override
  void update(void Function(BookmarkletImportListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookmarkletImportList build() => _build();

  _$BookmarkletImportList _build() {
    final _$result =
        _$v ??
        _$BookmarkletImportList._(
          createdAt: createdAt,
          createdBy: createdBy,
          id: id,
          url: url,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
