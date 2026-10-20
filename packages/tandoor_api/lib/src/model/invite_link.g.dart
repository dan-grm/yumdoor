// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_link.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InviteLink extends InviteLink {
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final InviteLinkEmail? email;
  @override
  final bool? emailSent;
  @override
  final Group group;
  @override
  final Household? household;
  @override
  final int? id;
  @override
  final String? internalNote;
  @override
  final bool? reusable;
  @override
  final int? usedBy;
  @override
  final String? uuid;
  @override
  final Date? validUntil;

  factory _$InviteLink([void Function(InviteLinkBuilder)? updates]) =>
      (InviteLinkBuilder()..update(updates))._build();

  _$InviteLink._({
    this.createdAt,
    this.createdBy,
    this.email,
    this.emailSent,
    required this.group,
    this.household,
    this.id,
    this.internalNote,
    this.reusable,
    this.usedBy,
    this.uuid,
    this.validUntil,
  }) : super._();
  @override
  InviteLink rebuild(void Function(InviteLinkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InviteLinkBuilder toBuilder() => InviteLinkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InviteLink &&
        createdAt == other.createdAt &&
        createdBy == other.createdBy &&
        email == other.email &&
        emailSent == other.emailSent &&
        group == other.group &&
        household == other.household &&
        id == other.id &&
        internalNote == other.internalNote &&
        reusable == other.reusable &&
        usedBy == other.usedBy &&
        uuid == other.uuid &&
        validUntil == other.validUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, emailSent.hashCode);
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, household.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, internalNote.hashCode);
    _$hash = $jc(_$hash, reusable.hashCode);
    _$hash = $jc(_$hash, usedBy.hashCode);
    _$hash = $jc(_$hash, uuid.hashCode);
    _$hash = $jc(_$hash, validUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InviteLink')
          ..add('createdAt', createdAt)
          ..add('createdBy', createdBy)
          ..add('email', email)
          ..add('emailSent', emailSent)
          ..add('group', group)
          ..add('household', household)
          ..add('id', id)
          ..add('internalNote', internalNote)
          ..add('reusable', reusable)
          ..add('usedBy', usedBy)
          ..add('uuid', uuid)
          ..add('validUntil', validUntil))
        .toString();
  }
}

class InviteLinkBuilder implements Builder<InviteLink, InviteLinkBuilder> {
  _$InviteLink? _$v;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  int? _createdBy;
  int? get createdBy => _$this._createdBy;
  set createdBy(int? createdBy) => _$this._createdBy = createdBy;

  InviteLinkEmailBuilder? _email;
  InviteLinkEmailBuilder get email =>
      _$this._email ??= InviteLinkEmailBuilder();
  set email(InviteLinkEmailBuilder? email) => _$this._email = email;

  bool? _emailSent;
  bool? get emailSent => _$this._emailSent;
  set emailSent(bool? emailSent) => _$this._emailSent = emailSent;

  GroupBuilder? _group;
  GroupBuilder get group => _$this._group ??= GroupBuilder();
  set group(GroupBuilder? group) => _$this._group = group;

  HouseholdBuilder? _household;
  HouseholdBuilder get household => _$this._household ??= HouseholdBuilder();
  set household(HouseholdBuilder? household) => _$this._household = household;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _internalNote;
  String? get internalNote => _$this._internalNote;
  set internalNote(String? internalNote) => _$this._internalNote = internalNote;

  bool? _reusable;
  bool? get reusable => _$this._reusable;
  set reusable(bool? reusable) => _$this._reusable = reusable;

  int? _usedBy;
  int? get usedBy => _$this._usedBy;
  set usedBy(int? usedBy) => _$this._usedBy = usedBy;

  String? _uuid;
  String? get uuid => _$this._uuid;
  set uuid(String? uuid) => _$this._uuid = uuid;

  Date? _validUntil;
  Date? get validUntil => _$this._validUntil;
  set validUntil(Date? validUntil) => _$this._validUntil = validUntil;

  InviteLinkBuilder() {
    InviteLink._defaults(this);
  }

  InviteLinkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _email = $v.email?.toBuilder();
      _emailSent = $v.emailSent;
      _group = $v.group.toBuilder();
      _household = $v.household?.toBuilder();
      _id = $v.id;
      _internalNote = $v.internalNote;
      _reusable = $v.reusable;
      _usedBy = $v.usedBy;
      _uuid = $v.uuid;
      _validUntil = $v.validUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InviteLink other) {
    _$v = other as _$InviteLink;
  }

  @override
  void update(void Function(InviteLinkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InviteLink build() => _build();

  _$InviteLink _build() {
    _$InviteLink _$result;
    try {
      _$result =
          _$v ??
          _$InviteLink._(
            createdAt: createdAt,
            createdBy: createdBy,
            email: _email?.build(),
            emailSent: emailSent,
            group: group.build(),
            household: _household?.build(),
            id: id,
            internalNote: internalNote,
            reusable: reusable,
            usedBy: usedBy,
            uuid: uuid,
            validUntil: validUntil,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'email';
        _email?.build();

        _$failedField = 'group';
        group.build();
        _$failedField = 'household';
        _household?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'InviteLink',
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
