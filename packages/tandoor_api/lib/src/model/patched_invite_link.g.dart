// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_invite_link.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PatchedInviteLink extends PatchedInviteLink {
  @override
  final DateTime? createdAt;
  @override
  final int? createdBy;
  @override
  final InviteLinkEmail? email;
  @override
  final bool? emailSent;
  @override
  final Group? group;
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

  factory _$PatchedInviteLink([
    void Function(PatchedInviteLinkBuilder)? updates,
  ]) => (PatchedInviteLinkBuilder()..update(updates))._build();

  _$PatchedInviteLink._({
    this.createdAt,
    this.createdBy,
    this.email,
    this.emailSent,
    this.group,
    this.household,
    this.id,
    this.internalNote,
    this.reusable,
    this.usedBy,
    this.uuid,
    this.validUntil,
  }) : super._();
  @override
  PatchedInviteLink rebuild(void Function(PatchedInviteLinkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PatchedInviteLinkBuilder toBuilder() =>
      PatchedInviteLinkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PatchedInviteLink &&
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
    return (newBuiltValueToStringHelper(r'PatchedInviteLink')
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

class PatchedInviteLinkBuilder
    implements Builder<PatchedInviteLink, PatchedInviteLinkBuilder> {
  _$PatchedInviteLink? _$v;

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

  PatchedInviteLinkBuilder() {
    PatchedInviteLink._defaults(this);
  }

  PatchedInviteLinkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _createdAt = $v.createdAt;
      _createdBy = $v.createdBy;
      _email = $v.email?.toBuilder();
      _emailSent = $v.emailSent;
      _group = $v.group?.toBuilder();
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
  void replace(PatchedInviteLink other) {
    _$v = other as _$PatchedInviteLink;
  }

  @override
  void update(void Function(PatchedInviteLinkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PatchedInviteLink build() => _build();

  _$PatchedInviteLink _build() {
    _$PatchedInviteLink _$result;
    try {
      _$result =
          _$v ??
          _$PatchedInviteLink._(
            createdAt: createdAt,
            createdBy: createdBy,
            email: _email?.build(),
            emailSent: emailSent,
            group: _group?.build(),
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
        _group?.build();
        _$failedField = 'household';
        _household?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'PatchedInviteLink',
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
