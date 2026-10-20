// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ServerSettings extends ServerSettings {
  @override
  final String? customSpaceTheme;
  @override
  final bool debug;
  @override
  final bool disableExternalConnectors;
  @override
  final int forceThemeFromSpace;
  @override
  final bool hosted;
  @override
  final String imprintUrl;
  @override
  final String? logoColor128;
  @override
  final String? logoColor144;
  @override
  final String? logoColor180;
  @override
  final String? logoColor192;
  @override
  final String? logoColor32;
  @override
  final String? logoColor512;
  @override
  final String? logoColorSvg;
  @override
  final String? navBgColor;
  @override
  final String? navLogo;
  @override
  final String privacyUrl;
  @override
  final String shoppingMinAutosyncInterval;
  @override
  final String termsUrl;
  @override
  final int unauthenticatedThemeFromSpace;
  @override
  final String version;

  factory _$ServerSettings([void Function(ServerSettingsBuilder)? updates]) =>
      (ServerSettingsBuilder()..update(updates))._build();

  _$ServerSettings._({
    this.customSpaceTheme,
    required this.debug,
    required this.disableExternalConnectors,
    required this.forceThemeFromSpace,
    required this.hosted,
    required this.imprintUrl,
    this.logoColor128,
    this.logoColor144,
    this.logoColor180,
    this.logoColor192,
    this.logoColor32,
    this.logoColor512,
    this.logoColorSvg,
    this.navBgColor,
    this.navLogo,
    required this.privacyUrl,
    required this.shoppingMinAutosyncInterval,
    required this.termsUrl,
    required this.unauthenticatedThemeFromSpace,
    required this.version,
  }) : super._();
  @override
  ServerSettings rebuild(void Function(ServerSettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ServerSettingsBuilder toBuilder() => ServerSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ServerSettings &&
        customSpaceTheme == other.customSpaceTheme &&
        debug == other.debug &&
        disableExternalConnectors == other.disableExternalConnectors &&
        forceThemeFromSpace == other.forceThemeFromSpace &&
        hosted == other.hosted &&
        imprintUrl == other.imprintUrl &&
        logoColor128 == other.logoColor128 &&
        logoColor144 == other.logoColor144 &&
        logoColor180 == other.logoColor180 &&
        logoColor192 == other.logoColor192 &&
        logoColor32 == other.logoColor32 &&
        logoColor512 == other.logoColor512 &&
        logoColorSvg == other.logoColorSvg &&
        navBgColor == other.navBgColor &&
        navLogo == other.navLogo &&
        privacyUrl == other.privacyUrl &&
        shoppingMinAutosyncInterval == other.shoppingMinAutosyncInterval &&
        termsUrl == other.termsUrl &&
        unauthenticatedThemeFromSpace == other.unauthenticatedThemeFromSpace &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, customSpaceTheme.hashCode);
    _$hash = $jc(_$hash, debug.hashCode);
    _$hash = $jc(_$hash, disableExternalConnectors.hashCode);
    _$hash = $jc(_$hash, forceThemeFromSpace.hashCode);
    _$hash = $jc(_$hash, hosted.hashCode);
    _$hash = $jc(_$hash, imprintUrl.hashCode);
    _$hash = $jc(_$hash, logoColor128.hashCode);
    _$hash = $jc(_$hash, logoColor144.hashCode);
    _$hash = $jc(_$hash, logoColor180.hashCode);
    _$hash = $jc(_$hash, logoColor192.hashCode);
    _$hash = $jc(_$hash, logoColor32.hashCode);
    _$hash = $jc(_$hash, logoColor512.hashCode);
    _$hash = $jc(_$hash, logoColorSvg.hashCode);
    _$hash = $jc(_$hash, navBgColor.hashCode);
    _$hash = $jc(_$hash, navLogo.hashCode);
    _$hash = $jc(_$hash, privacyUrl.hashCode);
    _$hash = $jc(_$hash, shoppingMinAutosyncInterval.hashCode);
    _$hash = $jc(_$hash, termsUrl.hashCode);
    _$hash = $jc(_$hash, unauthenticatedThemeFromSpace.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ServerSettings')
          ..add('customSpaceTheme', customSpaceTheme)
          ..add('debug', debug)
          ..add('disableExternalConnectors', disableExternalConnectors)
          ..add('forceThemeFromSpace', forceThemeFromSpace)
          ..add('hosted', hosted)
          ..add('imprintUrl', imprintUrl)
          ..add('logoColor128', logoColor128)
          ..add('logoColor144', logoColor144)
          ..add('logoColor180', logoColor180)
          ..add('logoColor192', logoColor192)
          ..add('logoColor32', logoColor32)
          ..add('logoColor512', logoColor512)
          ..add('logoColorSvg', logoColorSvg)
          ..add('navBgColor', navBgColor)
          ..add('navLogo', navLogo)
          ..add('privacyUrl', privacyUrl)
          ..add('shoppingMinAutosyncInterval', shoppingMinAutosyncInterval)
          ..add('termsUrl', termsUrl)
          ..add('unauthenticatedThemeFromSpace', unauthenticatedThemeFromSpace)
          ..add('version', version))
        .toString();
  }
}

class ServerSettingsBuilder
    implements Builder<ServerSettings, ServerSettingsBuilder> {
  _$ServerSettings? _$v;

  String? _customSpaceTheme;
  String? get customSpaceTheme => _$this._customSpaceTheme;
  set customSpaceTheme(String? customSpaceTheme) =>
      _$this._customSpaceTheme = customSpaceTheme;

  bool? _debug;
  bool? get debug => _$this._debug;
  set debug(bool? debug) => _$this._debug = debug;

  bool? _disableExternalConnectors;
  bool? get disableExternalConnectors => _$this._disableExternalConnectors;
  set disableExternalConnectors(bool? disableExternalConnectors) =>
      _$this._disableExternalConnectors = disableExternalConnectors;

  int? _forceThemeFromSpace;
  int? get forceThemeFromSpace => _$this._forceThemeFromSpace;
  set forceThemeFromSpace(int? forceThemeFromSpace) =>
      _$this._forceThemeFromSpace = forceThemeFromSpace;

  bool? _hosted;
  bool? get hosted => _$this._hosted;
  set hosted(bool? hosted) => _$this._hosted = hosted;

  String? _imprintUrl;
  String? get imprintUrl => _$this._imprintUrl;
  set imprintUrl(String? imprintUrl) => _$this._imprintUrl = imprintUrl;

  String? _logoColor128;
  String? get logoColor128 => _$this._logoColor128;
  set logoColor128(String? logoColor128) => _$this._logoColor128 = logoColor128;

  String? _logoColor144;
  String? get logoColor144 => _$this._logoColor144;
  set logoColor144(String? logoColor144) => _$this._logoColor144 = logoColor144;

  String? _logoColor180;
  String? get logoColor180 => _$this._logoColor180;
  set logoColor180(String? logoColor180) => _$this._logoColor180 = logoColor180;

  String? _logoColor192;
  String? get logoColor192 => _$this._logoColor192;
  set logoColor192(String? logoColor192) => _$this._logoColor192 = logoColor192;

  String? _logoColor32;
  String? get logoColor32 => _$this._logoColor32;
  set logoColor32(String? logoColor32) => _$this._logoColor32 = logoColor32;

  String? _logoColor512;
  String? get logoColor512 => _$this._logoColor512;
  set logoColor512(String? logoColor512) => _$this._logoColor512 = logoColor512;

  String? _logoColorSvg;
  String? get logoColorSvg => _$this._logoColorSvg;
  set logoColorSvg(String? logoColorSvg) => _$this._logoColorSvg = logoColorSvg;

  String? _navBgColor;
  String? get navBgColor => _$this._navBgColor;
  set navBgColor(String? navBgColor) => _$this._navBgColor = navBgColor;

  String? _navLogo;
  String? get navLogo => _$this._navLogo;
  set navLogo(String? navLogo) => _$this._navLogo = navLogo;

  String? _privacyUrl;
  String? get privacyUrl => _$this._privacyUrl;
  set privacyUrl(String? privacyUrl) => _$this._privacyUrl = privacyUrl;

  String? _shoppingMinAutosyncInterval;
  String? get shoppingMinAutosyncInterval =>
      _$this._shoppingMinAutosyncInterval;
  set shoppingMinAutosyncInterval(String? shoppingMinAutosyncInterval) =>
      _$this._shoppingMinAutosyncInterval = shoppingMinAutosyncInterval;

  String? _termsUrl;
  String? get termsUrl => _$this._termsUrl;
  set termsUrl(String? termsUrl) => _$this._termsUrl = termsUrl;

  int? _unauthenticatedThemeFromSpace;
  int? get unauthenticatedThemeFromSpace =>
      _$this._unauthenticatedThemeFromSpace;
  set unauthenticatedThemeFromSpace(int? unauthenticatedThemeFromSpace) =>
      _$this._unauthenticatedThemeFromSpace = unauthenticatedThemeFromSpace;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  ServerSettingsBuilder() {
    ServerSettings._defaults(this);
  }

  ServerSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _customSpaceTheme = $v.customSpaceTheme;
      _debug = $v.debug;
      _disableExternalConnectors = $v.disableExternalConnectors;
      _forceThemeFromSpace = $v.forceThemeFromSpace;
      _hosted = $v.hosted;
      _imprintUrl = $v.imprintUrl;
      _logoColor128 = $v.logoColor128;
      _logoColor144 = $v.logoColor144;
      _logoColor180 = $v.logoColor180;
      _logoColor192 = $v.logoColor192;
      _logoColor32 = $v.logoColor32;
      _logoColor512 = $v.logoColor512;
      _logoColorSvg = $v.logoColorSvg;
      _navBgColor = $v.navBgColor;
      _navLogo = $v.navLogo;
      _privacyUrl = $v.privacyUrl;
      _shoppingMinAutosyncInterval = $v.shoppingMinAutosyncInterval;
      _termsUrl = $v.termsUrl;
      _unauthenticatedThemeFromSpace = $v.unauthenticatedThemeFromSpace;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ServerSettings other) {
    _$v = other as _$ServerSettings;
  }

  @override
  void update(void Function(ServerSettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ServerSettings build() => _build();

  _$ServerSettings _build() {
    final _$result =
        _$v ??
        _$ServerSettings._(
          customSpaceTheme: customSpaceTheme,
          debug: BuiltValueNullFieldError.checkNotNull(
            debug,
            r'ServerSettings',
            'debug',
          ),
          disableExternalConnectors: BuiltValueNullFieldError.checkNotNull(
            disableExternalConnectors,
            r'ServerSettings',
            'disableExternalConnectors',
          ),
          forceThemeFromSpace: BuiltValueNullFieldError.checkNotNull(
            forceThemeFromSpace,
            r'ServerSettings',
            'forceThemeFromSpace',
          ),
          hosted: BuiltValueNullFieldError.checkNotNull(
            hosted,
            r'ServerSettings',
            'hosted',
          ),
          imprintUrl: BuiltValueNullFieldError.checkNotNull(
            imprintUrl,
            r'ServerSettings',
            'imprintUrl',
          ),
          logoColor128: logoColor128,
          logoColor144: logoColor144,
          logoColor180: logoColor180,
          logoColor192: logoColor192,
          logoColor32: logoColor32,
          logoColor512: logoColor512,
          logoColorSvg: logoColorSvg,
          navBgColor: navBgColor,
          navLogo: navLogo,
          privacyUrl: BuiltValueNullFieldError.checkNotNull(
            privacyUrl,
            r'ServerSettings',
            'privacyUrl',
          ),
          shoppingMinAutosyncInterval: BuiltValueNullFieldError.checkNotNull(
            shoppingMinAutosyncInterval,
            r'ServerSettings',
            'shoppingMinAutosyncInterval',
          ),
          termsUrl: BuiltValueNullFieldError.checkNotNull(
            termsUrl,
            r'ServerSettings',
            'termsUrl',
          ),
          unauthenticatedThemeFromSpace: BuiltValueNullFieldError.checkNotNull(
            unauthenticatedThemeFromSpace,
            r'ServerSettings',
            'unauthenticatedThemeFromSpace',
          ),
          version: BuiltValueNullFieldError.checkNotNull(
            version,
            r'ServerSettings',
            'version',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
