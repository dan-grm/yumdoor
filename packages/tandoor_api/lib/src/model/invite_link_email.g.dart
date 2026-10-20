// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_link_email.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InviteLinkEmail extends InviteLinkEmail {
  @override
  final OneOf oneOf;

  factory _$InviteLinkEmail([void Function(InviteLinkEmailBuilder)? updates]) =>
      (InviteLinkEmailBuilder()..update(updates))._build();

  _$InviteLinkEmail._({required this.oneOf}) : super._();
  @override
  InviteLinkEmail rebuild(void Function(InviteLinkEmailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InviteLinkEmailBuilder toBuilder() => InviteLinkEmailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InviteLinkEmail && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'InviteLinkEmail',
    )..add('oneOf', oneOf)).toString();
  }
}

class InviteLinkEmailBuilder
    implements Builder<InviteLinkEmail, InviteLinkEmailBuilder> {
  _$InviteLinkEmail? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  InviteLinkEmailBuilder() {
    InviteLinkEmail._defaults(this);
  }

  InviteLinkEmailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InviteLinkEmail other) {
    _$v = other as _$InviteLinkEmail;
  }

  @override
  void update(void Function(InviteLinkEmailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InviteLinkEmail build() => _build();

  _$InviteLinkEmail _build() {
    final _$result =
        _$v ??
        _$InviteLinkEmail._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
            oneOf,
            r'InviteLinkEmail',
            'oneOf',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
