// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_space_batch_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserSpaceBatchUpdate extends UserSpaceBatchUpdate {
  @override
  final BuiltList<int> groupSet;
  @override
  final int? household;
  @override
  final BuiltList<int> userSpaces;

  factory _$UserSpaceBatchUpdate([
    void Function(UserSpaceBatchUpdateBuilder)? updates,
  ]) => (UserSpaceBatchUpdateBuilder()..update(updates))._build();

  _$UserSpaceBatchUpdate._({
    required this.groupSet,
    this.household,
    required this.userSpaces,
  }) : super._();
  @override
  UserSpaceBatchUpdate rebuild(
    void Function(UserSpaceBatchUpdateBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UserSpaceBatchUpdateBuilder toBuilder() =>
      UserSpaceBatchUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserSpaceBatchUpdate &&
        groupSet == other.groupSet &&
        household == other.household &&
        userSpaces == other.userSpaces;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, groupSet.hashCode);
    _$hash = $jc(_$hash, household.hashCode);
    _$hash = $jc(_$hash, userSpaces.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserSpaceBatchUpdate')
          ..add('groupSet', groupSet)
          ..add('household', household)
          ..add('userSpaces', userSpaces))
        .toString();
  }
}

class UserSpaceBatchUpdateBuilder
    implements Builder<UserSpaceBatchUpdate, UserSpaceBatchUpdateBuilder> {
  _$UserSpaceBatchUpdate? _$v;

  ListBuilder<int>? _groupSet;
  ListBuilder<int> get groupSet => _$this._groupSet ??= ListBuilder<int>();
  set groupSet(ListBuilder<int>? groupSet) => _$this._groupSet = groupSet;

  int? _household;
  int? get household => _$this._household;
  set household(int? household) => _$this._household = household;

  ListBuilder<int>? _userSpaces;
  ListBuilder<int> get userSpaces => _$this._userSpaces ??= ListBuilder<int>();
  set userSpaces(ListBuilder<int>? userSpaces) =>
      _$this._userSpaces = userSpaces;

  UserSpaceBatchUpdateBuilder() {
    UserSpaceBatchUpdate._defaults(this);
  }

  UserSpaceBatchUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupSet = $v.groupSet.toBuilder();
      _household = $v.household;
      _userSpaces = $v.userSpaces.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserSpaceBatchUpdate other) {
    _$v = other as _$UserSpaceBatchUpdate;
  }

  @override
  void update(void Function(UserSpaceBatchUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserSpaceBatchUpdate build() => _build();

  _$UserSpaceBatchUpdate _build() {
    _$UserSpaceBatchUpdate _$result;
    try {
      _$result =
          _$v ??
          _$UserSpaceBatchUpdate._(
            groupSet: groupSet.build(),
            household: household,
            userSpaces: userSpaces.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'groupSet';
        groupSet.build();

        _$failedField = 'userSpaces';
        userSpaces.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UserSpaceBatchUpdate',
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
