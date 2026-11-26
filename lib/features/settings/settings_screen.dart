import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_info.dart';
import '../../app/locale.dart';
import '../../app/platform_providers.dart';
import '../../app/session.dart';
import '../../app/theme_mode.dart';
import '../../design/components/buttons.dart';
import '../../design/components/filter_chips.dart';
import '../../design/design.dart';
import '../../l10n/l10n.dart';
import '../auth/logout.dart';
import '../common/up_scope.dart';
import 'seasonal_settings.dart';
import 'settings_providers.dart';

/// Where [SettingsScreen] is.
const settingsPath = '/settings';

/// Account, appearance and app information in one place (mockup
/// `14-einstellungen`, without the sections whose features don't exist yet).
///
/// Everything it shows is read-only data or a device setting, so it also
/// works offline; values that need the server show "nicht verfügbar" then.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    final session = ref.watch(sessionControllerProvider).value;
    final account = ref.watch(currentAccountProvider);
    final version = ref.watch(serverVersionProvider);
    final themeMode = ref.watch(themeModeSettingProvider);
    final locale = ref.watch(localeOverrideProvider);
    // Empty while loading, so "nicht verfügbar" only shows when it is.
    final unavailable = account.isLoading ? '' : l10n.settingsUnavailable;
    final versionUnavailable = version.isLoading
        ? ''
        : l10n.settingsUnavailable;
    final host = session == null
        ? null
        : '${session.serverUrl.authority}'
              '${session.serverUrl.path == '/' ? '' : session.serverUrl.path}';

    return UpScope(
      onUp: () => context.go('/'),
      child: Scaffold(
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: t.sizeWide),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  t.space5,
                  t.space3,
                  t.space5,
                  t.space6,
                ),
                children: [
                  Row(
                    children: [
                      RoundIconButton(
                        icon: Icons.arrow_back_rounded,
                        label: l10n.back,
                        onPressed: () => _leave(context),
                      ),
                      SizedBox(width: t.space3),
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.settingsTitle,
                            style: t.titleL.copyWith(color: t.ink),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _Section(
                    title: l10n.settingsAccount,
                    children: [
                      _ValueRow(
                        label: l10n.settingsName,
                        value: switch (account) {
                          AsyncData(:final value) when value != null =>
                            value.name.isEmpty ? unavailable : value.name,
                          _ => unavailable,
                        },
                      ),
                      _ValueRow(
                        label: l10n.settingsUsername,
                        value: switch (account) {
                          AsyncData(:final value)
                              when value != null && value.username.isNotEmpty =>
                            value.username,
                          _ => unavailable,
                        },
                      ),
                      _ValueRow(
                        label: l10n.settingsServer,
                        value: host ?? unavailable,
                      ),
                      _ValueRow(
                        label: l10n.settingsTandoorVersion,
                        value: version.value ?? versionUnavailable,
                      ),
                      SizedBox(height: t.space3),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PillButton(
                          label: l10n.logout,
                          kind: PillButtonKind.secondary,
                          icon: Icons.logout_rounded,
                          compact: true,
                          onPressed: () =>
                              unawaited(confirmAndLogout(context, ref)),
                        ),
                      ),
                    ],
                  ),
                  _Section(
                    title: l10n.settingsAppearance,
                    children: [
                      _ChoiceRow<ThemeMode>(
                        label: l10n.settingsTheme,
                        selected: themeMode,
                        onSelected: ref
                            .read(themeModeSettingProvider.notifier)
                            .set,
                        choices: [
                          (ThemeMode.light, l10n.settingsThemeLight),
                          (ThemeMode.dark, l10n.settingsThemeDark),
                          (ThemeMode.system, l10n.settingsSystem),
                        ],
                      ),
                      _ChoiceRow<String?>(
                        label: l10n.settingsLanguage,
                        selected: locale?.languageCode,
                        onSelected: (code) => ref
                            .read(localeOverrideProvider.notifier)
                            .set(code == null ? null : Locale(code)),
                        choices: [
                          ('de', l10n.settingsLanguageGerman),
                          ('en', l10n.settingsLanguageEnglish),
                          (null, l10n.settingsSystem),
                        ],
                      ),
                    ],
                  ),
                  _Section(
                    title: l10n.settingsSeasonal,
                    children: const [SeasonalSettings()],
                  ),
                  _Section(
                    title: l10n.settingsAbout,
                    children: [
                      _ValueRow(label: l10n.settingsVersion, value: appVersion),
                      _ValueRow(label: l10n.settingsLicense, value: 'AGPL-3.0'),
                      _SourceRow(),
                      SizedBox(height: t.space3),
                      Semantics(
                        header: true,
                        child: Text(
                          l10n.settingsAuthTitle,
                          style: t.label.copyWith(color: t.ink),
                        ),
                      ),
                      SizedBox(height: t.space1),
                      Text(
                        l10n.settingsAuthBody,
                        style: t.body.copyWith(color: t.inkMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Back to the screen below, or to the start if this was opened directly.
void _leave(BuildContext context) =>
    context.canPop() ? context.pop() : context.go('/');

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.only(top: t.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: t.titleS.copyWith(color: t.ink)),
          ),
          SizedBox(height: t.space2),
          ...children,
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: t.body.copyWith(color: t.inkMuted)),
          ),
          SizedBox(width: t.space3),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: t.body.copyWith(color: t.ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// The source code address, to open in the browser.
class _SourceRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l10n = context.l10n;
    return Semantics(
      link: true,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusS),
        onTap: () =>
            unawaited(ref.read(linkOpenerProvider).open(sourceCodeUrl)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: t.sizeTouch),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.settingsSource,
                  style: t.body.copyWith(color: t.inkMuted),
                ),
              ),
              SizedBox(width: t.space3),
              Flexible(
                child: Text(
                  sourceCodeUrl.host + sourceCodeUrl.path,
                  textAlign: TextAlign.end,
                  style: t.body.copyWith(
                    color: t.ink,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.choices,
  });

  final String label;
  final T selected;
  final ValueChanged<T> onSelected;
  final List<(T, String)> choices;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.body.copyWith(color: t.inkMuted)),
          SizedBox(height: t.space2),
          Wrap(
            spacing: t.space2,
            runSpacing: t.space2,
            children: [
              for (final (value, text) in choices)
                ChoiceFilterChip(
                  label: text,
                  selected: value == selected,
                  onSelected: () => onSelected(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
