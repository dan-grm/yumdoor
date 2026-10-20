// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_access_token.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedAccessToken extends PatchedAccessToken {
  @override
  final DateTime? created;
  @override
  final DateTime? expires;
  @override
  final int? id;
  @override
  final String? scope;
  @override
  final String? token;
  @override
  final DateTime? updated;

  factory _$PatchedAccessToken([
    void Function(PatchedAccessTokenBuilder)? updates,
  ]) => (PatchedAccessTokenBuilder()..update(updates))._build();

  _$PatchedAccessToken._({
    this.created,
    this.expires,
    this.id,
    this.scope,
    this.token,
    this.updated,
  }) : super._();
  @override
  PatchedAccessToken rebuild(
    void Function(PatchedAccessTokenBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  PatchedAccessTokenBuilder toBuilder() =>
      PatchedAccessTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedAccessToken &&
        created == other.created &&
        expires == other.expires &&
        id == other.id &&
        scope == other.scope &&
        token == other.token &&
        updated == other.updated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, expires.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, updated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PatchedAccessToken')
          ..add('created', created)
          ..add('expires', expires)
          ..add('id', id)
          ..add('scope', scope)
          ..add('token', token)
          ..add('updated', updated))
        .toString();
  }
}

class PatchedAccessTokenBuilder
    implements Builder<PatchedAccessToken, PatchedAccessTokenBuilder> {
  _$PatchedAccessToken? _$v;

  DateTime? _created;
  DateTime? get created => _$this._created;
  set created(DateTime? created) => _$this._created = created;

  DateTime? _expires;
  DateTime? get expires => _$this._expires;
  set expires(DateTime? expires) => _$this._expires = expires;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _scope;
  String? get scope => _$this._scope;
  set scope(String? scope) => _$this._scope = scope;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  DateTime? _updated;
  DateTime? get updated => _$this._updated;
  set updated(DateTime? updated) => _$this._updated = updated;

  PatchedAccessTokenBuilder() {
    PatchedAccessToken._defaults(this);
  }

  PatchedAccessTokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _created = $v.created;
      _expires = $v.expires;
      _id = $v.id;
      _scope = $v.scope;
      _token = $v.token;
      _updated = $v.updated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PatchedAccessToken other) {
    _$v = other as _$PatchedAccessToken;
  }

  @override
  void update(void Function(PatchedAccessTokenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedAccessToken build() => _build();

  _$PatchedAccessToken _build() {
    final _$result =
        _$v ??
        _$PatchedAccessToken._(
          created: created,
          expires: expires,
          id: id,
          scope: scope,
          token: token,
          updated: updated,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
