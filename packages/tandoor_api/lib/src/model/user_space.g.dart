// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_space.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserSpace extends UserSpace {
  @override
  final bool? active;
  @override
  final DateTime? createdAt;
  @override
  final BuiltList<Group> groups;
  @override
  final Household? household;
  @override
  final int? id;
  @override
  final String? internalNote;
  @override
  final int? inviteLink;
  @override
  final int? space;
  @override
  final DateTime? updatedAt;
  @override
  final User? user;

  factory _$UserSpace([void Function(UserSpaceBuilder)? updates]) =>
      (UserSpaceBuilder()..update(updates))._build();

  _$UserSpace._({
    this.active,
    this.createdAt,
    required this.groups,
    this.household,
    this.id,
    this.internalNote,
    this.inviteLink,
    this.space,
    this.updatedAt,
    this.user,
  }) : super._();
  @override
  UserSpace rebuild(void Function(UserSpaceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserSpaceBuilder toBuilder() => UserSpaceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserSpace &&
        active == other.active &&
        createdAt == other.createdAt &&
        groups == other.groups &&
        household == other.household &&
        id == other.id &&
        internalNote == other.internalNote &&
        inviteLink == other.inviteLink &&
        space == other.space &&
        updatedAt == other.updatedAt &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, groups.hashCode);
    _$hash = $jc(_$hash, household.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, internalNote.hashCode);
    _$hash = $jc(_$hash, inviteLink.hashCode);
    _$hash = $jc(_$hash, space.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserSpace')
          ..add('active', active)
          ..add('createdAt', createdAt)
          ..add('groups', groups)
          ..add('household', household)
          ..add('id', id)
          ..add('internalNote', internalNote)
          ..add('inviteLink', inviteLink)
          ..add('space', space)
          ..add('updatedAt', updatedAt)
          ..add('user', user))
        .toString();
  }
}

class UserSpaceBuilder implements Builder<UserSpace, UserSpaceBuilder> {
  _$UserSpace? _$v;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<Group>? _groups;
  ListBuilder<Group> get groups => _$this._groups ??= ListBuilder<Group>();
  set groups(ListBuilder<Group>? groups) => _$this._groups = groups;

  HouseholdBuilder? _household;
  HouseholdBuilder get household => _$this._household ??= HouseholdBuilder();
  set household(HouseholdBuilder? household) => _$this._household = household;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _internalNote;
  String? get internalNote => _$this._internalNote;
  set internalNote(String? internalNote) => _$this._internalNote = internalNote;

  int? _inviteLink;
  int? get inviteLink => _$this._inviteLink;
  set inviteLink(int? inviteLink) => _$this._inviteLink = inviteLink;

  int? _space;
  int? get space => _$this._space;
  set space(int? space) => _$this._space = space;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  UserSpaceBuilder() {
    UserSpace._defaults(this);
  }

  UserSpaceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _active = $v.active;
      _createdAt = $v.createdAt;
      _groups = $v.groups.toBuilder();
      _household = $v.household?.toBuilder();
      _id = $v.id;
      _internalNote = $v.internalNote;
      _inviteLink = $v.inviteLink;
      _space = $v.space;
      _updatedAt = $v.updatedAt;
      _user = $v.user?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserSpace other) {
    _$v = other as _$UserSpace;
  }

  @override
  void update(void Function(UserSpaceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserSpace build() => _build();

  _$UserSpace _build() {
    _$UserSpace _$result;
    try {
      _$result =
          _$v ??
          _$UserSpace._(
            active: active,
            createdAt: createdAt,
            groups: groups.build(),
            household: _household?.build(),
            id: id,
            internalNote: internalNote,
            inviteLink: inviteLink,
            space: space,
            updatedAt: updatedAt,
            user: _user?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'groups';
        groups.build();
        _$failedField = 'household';
        _household?.build();

        _$failedField = 'user';
        _user?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UserSpace',
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
