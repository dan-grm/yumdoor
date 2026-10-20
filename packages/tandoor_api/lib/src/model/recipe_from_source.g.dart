// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_from_source.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RecipeFromSource extends RecipeFromSource {
  @override
  final int? bookmarklet;
  @override
  final String? data;
  @override
  final String? url;

  factory _$RecipeFromSource([
    void Function(RecipeFromSourceBuilder)? updates,
  ]) => (RecipeFromSourceBuilder()..update(updates))._build();

  _$RecipeFromSource._({this.bookmarklet, this.data, this.url}) : super._();
  @override
  RecipeFromSource rebuild(void Function(RecipeFromSourceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecipeFromSourceBuilder toBuilder() =>
      RecipeFromSourceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecipeFromSource &&
        bookmarklet == other.bookmarklet &&
        data == other.data &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookmarklet.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecipeFromSource')
          ..add('bookmarklet', bookmarklet)
          ..add('data', data)
          ..add('url', url))
        .toString();
  }
}

class RecipeFromSourceBuilder
    implements Builder<RecipeFromSource, RecipeFromSourceBuilder> {
  _$RecipeFromSource? _$v;

  int? _bookmarklet;
  int? get bookmarklet => _$this._bookmarklet;
  set bookmarklet(int? bookmarklet) => _$this._bookmarklet = bookmarklet;

  String? _data;
  String? get data => _$this._data;
  set data(String? data) => _$this._data = data;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  RecipeFromSourceBuilder() {
    RecipeFromSource._defaults(this);
  }

  RecipeFromSourceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookmarklet = $v.bookmarklet;
      _data = $v.data;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecipeFromSource other) {
    _$v = other as _$RecipeFromSource;
  }

  @override
  void update(void Function(RecipeFromSourceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecipeFromSource build() => _build();

  _$RecipeFromSource _build() {
    final _$result =
        _$v ??
        _$RecipeFromSource._(bookmarklet: bookmarklet, data: data, url: url);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
