// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_preference.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchPreference extends SearchPreference {
  @override
  final BuiltList<SearchFields>? fulltext;
  @override
  final BuiltList<SearchFields>? icontains;
  @override
  final BuiltList<SearchFields>? istartswith;
  @override
  final bool? lookup;
  @override
  final SearchEnum? search;
  @override
  final BuiltList<SearchFields>? trigram;
  @override
  final double? trigramThreshold;
  @override
  final BuiltList<SearchFields>? unaccent;
  @override
  final User? user;

  factory _$SearchPreference([
    void Function(SearchPreferenceBuilder)? updates,
  ]) => (SearchPreferenceBuilder()..update(updates))._build();

  _$SearchPreference._({
    this.fulltext,
    this.icontains,
    this.istartswith,
    this.lookup,
    this.search,
    this.trigram,
    this.trigramThreshold,
    this.unaccent,
    this.user,
  }) : super._();
  @override
  SearchPreference rebuild(void Function(SearchPreferenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchPreferenceBuilder toBuilder() =>
      SearchPreferenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchPreference &&
        fulltext == other.fulltext &&
        icontains == other.icontains &&
        istartswith == other.istartswith &&
        lookup == other.lookup &&
        search == other.search &&
        trigram == other.trigram &&
        trigramThreshold == other.trigramThreshold &&
        unaccent == other.unaccent &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fulltext.hashCode);
    _$hash = $jc(_$hash, icontains.hashCode);
    _$hash = $jc(_$hash, istartswith.hashCode);
    _$hash = $jc(_$hash, lookup.hashCode);
    _$hash = $jc(_$hash, search.hashCode);
    _$hash = $jc(_$hash, trigram.hashCode);
    _$hash = $jc(_$hash, trigramThreshold.hashCode);
    _$hash = $jc(_$hash, unaccent.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchPreference')
          ..add('fulltext', fulltext)
          ..add('icontains', icontains)
          ..add('istartswith', istartswith)
          ..add('lookup', lookup)
          ..add('search', search)
          ..add('trigram', trigram)
          ..add('trigramThreshold', trigramThreshold)
          ..add('unaccent', unaccent)
          ..add('user', user))
        .toString();
  }
}

class SearchPreferenceBuilder
    implements Builder<SearchPreference, SearchPreferenceBuilder> {
  _$SearchPreference? _$v;

  ListBuilder<SearchFields>? _fulltext;
  ListBuilder<SearchFields> get fulltext =>
      _$this._fulltext ??= ListBuilder<SearchFields>();
  set fulltext(ListBuilder<SearchFields>? fulltext) =>
      _$this._fulltext = fulltext;

  ListBuilder<SearchFields>? _icontains;
  ListBuilder<SearchFields> get icontains =>
      _$this._icontains ??= ListBuilder<SearchFields>();
  set icontains(ListBuilder<SearchFields>? icontains) =>
      _$this._icontains = icontains;

  ListBuilder<SearchFields>? _istartswith;
  ListBuilder<SearchFields> get istartswith =>
      _$this._istartswith ??= ListBuilder<SearchFields>();
  set istartswith(ListBuilder<SearchFields>? istartswith) =>
      _$this._istartswith = istartswith;

  bool? _lookup;
  bool? get lookup => _$this._lookup;
  set lookup(bool? lookup) => _$this._lookup = lookup;

  SearchEnum? _search;
  SearchEnum? get search => _$this._search;
  set search(SearchEnum? search) => _$this._search = search;

  ListBuilder<SearchFields>? _trigram;
  ListBuilder<SearchFields> get trigram =>
      _$this._trigram ??= ListBuilder<SearchFields>();
  set trigram(ListBuilder<SearchFields>? trigram) => _$this._trigram = trigram;

  double? _trigramThreshold;
  double? get trigramThreshold => _$this._trigramThreshold;
  set trigramThreshold(double? trigramThreshold) =>
      _$this._trigramThreshold = trigramThreshold;

  ListBuilder<SearchFields>? _unaccent;
  ListBuilder<SearchFields> get unaccent =>
      _$this._unaccent ??= ListBuilder<SearchFields>();
  set unaccent(ListBuilder<SearchFields>? unaccent) =>
      _$this._unaccent = unaccent;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  SearchPreferenceBuilder() {
    SearchPreference._defaults(this);
  }

  SearchPreferenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fulltext = $v.fulltext?.toBuilder();
      _icontains = $v.icontains?.toBuilder();
      _istartswith = $v.istartswith?.toBuilder();
      _lookup = $v.lookup;
      _search = $v.search;
      _trigram = $v.trigram?.toBuilder();
      _trigramThreshold = $v.trigramThreshold;
      _unaccent = $v.unaccent?.toBuilder();
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchPreference other) {
    _$v = other as _$SearchPreference;
  }

  @override
  void update(void Function(SearchPreferenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchPreference build() => _build();

  _$SearchPreference _build() {
    _$SearchPreference _$result;
    try {
      _$result =
          _$v ??
          _$SearchPreference._(
            fulltext: _fulltext?.build(),
            icontains: _icontains?.build(),
            istartswith: _istartswith?.build(),
            lookup: lookup,
            search: search,
            trigram: _trigram?.build(),
            trigramThreshold: trigramThreshold,
            unaccent: _unaccent?.build(),
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'fulltext';
        _fulltext?.build();
        _$failedField = 'icontains';
        _icontains?.build();
        _$failedField = 'istartswith';
        _istartswith?.build();

        _$failedField = 'trigram';
        _trigram?.build();

        _$failedField = 'unaccent';
        _unaccent?.build();
        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SearchPreference',
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
