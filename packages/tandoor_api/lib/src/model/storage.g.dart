// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Storage extends Storage {
  @override
  final int? createdBy;
  @override
  final int? id;
  @override
  final MethodEnum? method;
  @override
  final String name;
  @override
  final String? password;
  @override
  final String? path;
  @override
  final String? token;
  @override
  final ConnectorConfigUrl? url;
  @override
  final String? username;

  factory _$Storage([void Function(StorageBuilder)? updates]) =>
      (StorageBuilder()..update(updates))._build();

  _$Storage._({
    this.createdBy,
    this.id,
    this.method,
    required this.name,
    this.password,
    this.path,
    this.token,
    this.url,
    this.username,
  }) : super._();
  @override
  Storage rebuild(void Function(StorageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StorageBuilder toBuilder() => StorageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Storage &&
        createdBy == other.createdBy &&
        id == other.id &&
        method == other.method &&
        name == other.name &&
        password == other.password &&
        path == other.path &&
        token == other.token &&
        url == other.url &&
        username == other.username;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Storage')
          ..add('createdBy', createdBy)
          ..add('id', id)
          ..add('method', method)
          ..add('name', name)
          ..add('password', password)
          ..add('path', path)
          ..add('token', token)
          ..add('url', url)
          ..add('username', username))
        .toString();
  }
}

class StorageBuilder implements Builder<Storage, StorageBuilder> {
  _$Storage? _$v;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  MethodEnum? _method;
  MethodEnum? get method => _$this._method;
  set method(MethodEnum? method) => _$this._method = method;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  ConnectorConfigUrlBuilder? _url;
  ConnectorConfigUrlBuilder get url =>
      _$this._url ??= ConnectorConfigUrlBuilder();
  set url(ConnectorConfigUrlBuilder? url) => _$this._url = url;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  StorageBuilder() {
    Storage._defaults(this);
  }

  StorageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdBy = $v.createdBy;
      _id = $v.id;
      _method = $v.method;
      _name = $v.name;
      _password = $v.password;
      _path = $v.path;
      _token = $v.token;
      _url = $v.url?.toBuilder();
      _username = $v.username;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Storage other) {
    _$v = other as _$Storage;
  }

  @override
  void update(void Function(StorageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Storage build() => _build();

  _$Storage _build() {
    _$Storage _$result;
    try {
      _$result =
          _$v ??
          _$Storage._(
            createdBy: createdBy,
            id: id,
            method: method,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'Storage',
              'name',
            ),
            password: password,
            path: path,
            token: token,
            url: _url?.build(),
            username: username,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'url';
        _url?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Storage',
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
