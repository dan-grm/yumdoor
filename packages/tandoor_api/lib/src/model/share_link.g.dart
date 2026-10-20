// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_link.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ShareLink extends ShareLink {
  @override
  final String link;
  @override
  final int pk;
  @override
  final String share;

  factory _$ShareLink([void Function(ShareLinkBuilder)? updates]) =>
      (ShareLinkBuilder()..update(updates))._build();

  _$ShareLink._({required this.link, required this.pk, required this.share})
    : super._();
  @override
  ShareLink rebuild(void Function(ShareLinkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShareLinkBuilder toBuilder() => ShareLinkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShareLink &&
        link == other.link &&
        pk == other.pk &&
        share == other.share;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, link.hashCode);
    _$hash = $jc(_$hash, pk.hashCode);
    _$hash = $jc(_$hash, share.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShareLink')
          ..add('link', link)
          ..add('pk', pk)
          ..add('share', share))
        .toString();
  }
}

class ShareLinkBuilder implements Builder<ShareLink, ShareLinkBuilder> {
  _$ShareLink? _$v;

  String? _link;
  String? get link => _$this._link;
  set link(String? link) => _$this._link = link;

  int? _pk;
  int? get pk => _$this._pk;
  set pk(int? pk) => _$this._pk = pk;

  String? _share;
  String? get share => _$this._share;
  set share(String? share) => _$this._share = share;

  ShareLinkBuilder() {
    ShareLink._defaults(this);
  }

  ShareLinkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _link = $v.link;
      _pk = $v.pk;
      _share = $v.share;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShareLink other) {
    _$v = other as _$ShareLink;
  }

  @override
  void update(void Function(ShareLinkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShareLink build() => _build();

  _$ShareLink _build() {
    final _$result =
        _$v ??
        _$ShareLink._(
          link: BuiltValueNullFieldError.checkNotNull(
            link,
            r'ShareLink',
            'link',
          ),
          pk: BuiltValueNullFieldError.checkNotNull(pk, r'ShareLink', 'pk'),
          share: BuiltValueNullFieldError.checkNotNull(
            share,
            r'ShareLink',
            'share',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
