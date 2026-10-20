// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final String? displayName;
  @override
  final String? firstName;
  @override
  final int? id;
  @override
  final bool? isActive;
  @override
  final bool? isStaff;
  @override
  final bool? isSuperuser;
  @override
  final String? lastName;
  @override
  final String? username;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (UserBuilder()..update(updates))._build();

  _$User._({
    this.displayName,
    this.firstName,
    this.id,
    this.isActive,
    this.isStaff,
    this.isSuperuser,
    this.lastName,
    this.username,
  }) : super._();
  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        displayName == other.displayName &&
        firstName == other.firstName &&
        id == other.id &&
        isActive == other.isActive &&
        isStaff == other.isStaff &&
        isSuperuser == other.isSuperuser &&
        lastName == other.lastName &&
        username == other.username;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, isStaff.hashCode);
    _$hash = $jc(_$hash, isSuperuser.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'User')
          ..add('displayName', displayName)
          ..add('firstName', firstName)
          ..add('id', id)
          ..add('isActive', isActive)
          ..add('isStaff', isStaff)
          ..add('isSuperuser', isSuperuser)
          ..add('lastName', lastName)
          ..add('username', username))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _isStaff;
  bool? get isStaff => _$this._isStaff;
  set isStaff(bool? isStaff) => _$this._isStaff = isStaff;

  bool? _isSuperuser;
  bool? get isSuperuser => _$this._isSuperuser;
  set isSuperuser(bool? isSuperuser) => _$this._isSuperuser = isSuperuser;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  UserBuilder() {
    User._defaults(this);
  }

  UserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _firstName = $v.firstName;
      _id = $v.id;
      _isActive = $v.isActive;
      _isStaff = $v.isStaff;
      _isSuperuser = $v.isSuperuser;
      _lastName = $v.lastName;
      _username = $v.username;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  User build() => _build();

  _$User _build() {
    final _$result =
        _$v ??
        _$User._(
          displayName: displayName,
          firstName: firstName,
          id: id,
          isActive: isActive,
          isStaff: isStaff,
          isSuperuser: isSuperuser,
          lastName: lastName,
          username: username,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
